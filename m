Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYBZOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYBZOea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYBZOeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:34:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYBZOeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:34:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802260226.26984.phillips@phunq.net>
References: <200802260226.26984.phillips@phunq.net> <200802251643.16631.phillips@phunq.net> <22888.1203981562@redhat.com> <24873.1203991250@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 26 Feb 2008 14:33:38 +0000
Message-ID: <27528.1204036418@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> wrote:

> I need to respond to this in pieces... first the bit that is bugging
> me:
> 
> > >   * two new page flags
> > 
> > I need to keep track of two bits of per-cached-page information:
> > 
> >  (1) This page is known by the cache, and that the cache must be informed if
> >      the page is going to go away.
> 
> I still do not understand the life cycle of this bit.  What does the
> cache do when it learns the page has gone away?

That's up to the cache.  CacheFS, for example, unpins some resources when all
the pages managed by a pointer block are taken away from it.  The cache may
also reserve a block on disk to back this page, and that reservation may then
be discarded by the netfs uncaching the page.

The cache may also speculatively take copies of the page if the machine is
idle.

Documentation/filesystems/caching/netfs-api.txt describes the caching API as a
process, including the presentation of netfs pages to the cache and their
uncaching.

> How is it informed?

[Documentation/filesystems/caching/netfs-api.txt]
==============
PAGE UNCACHING
==============

To uncache a page, this function should be called:

	void fscache_uncache_page(struct fscache_cookie *cookie,
				  struct page *page);

This function permits the cache to release any in-memory representation it
might be holding for this netfs page.  This function must be called once for
each page on which the read or write page functions above have been called to
make sure the cache's in-memory tracking information gets torn down.

Note that pages can't be explicitly deleted from the data file.  The whole
data file must be retired (see the relinquish cookie function below).

Furthermore, note that this does not cancel the asynchronous read or write
operation started by the read/alloc and write functions.
[/]

> Who owns the page cache in which such a page lives, the nfs client?
> Filesystem that hosts the page?  A third page cache owned by the
> cache itself?  (See my basic confusion about how many page cache
> levels you have, below.)

[Documentation/filesystems/caching/fscache.txt]
 (7) Data I/O is done direct to and from the netfs's pages.  The netfs
     indicates that page A is at index B of the data-file represented by cookie
     C, and that it should be read or written.  The cache backend may or may
     not start I/O on that page, but if it does, a netfs callback will be
     invoked to indicate completion.  The I/O may be either synchronous or
     asynchronous.
[/]

I should perhaps make the documentation more explicit: the pages passed to the
routines defined in include/linux/fscache.h are netfs pages, normally belonging
the pagecache of the appropriate netfs inode.  This is, however, mentioned in
the function banner comments in fscache.h.

> Suppose one were to take a mundane approach to the persistent cache
> problem instead of layering filesystems.  What you would do then is
> change NFS's ->write_page and variants to fiddle the persistent
> cache

It is a requirement laid down by the Linux NFS fs maintainers that the writes
to the cache be asynchronous, even if the writes to NFS aren't.

Note further that NFS's write_page() != writing to the cache.  Writing to the
cache is typically done by NFS's readpages().

Besides, at the moment, caching is suppressed for any NFS file opened for
writing due to coherency issues.  This is something to be revisited later.

> as well as the network, instead of just the network as now.

Not as now.  See above.

> This fiddling could even consist of ->write calls to another
> filesystem, though working directly with the bio interface would
> yield the fastest, and therefore to my mind, best result.

You can't necessarily access the BIO interface, and even if you can, the cache
is still a filesystem.

Essentially, what cachefiles does is to do what you say: to perform ->write
calls on another filesystem.

FS-Cache also protects the netfs against (a) there being no cache, (b) the
cache suffering a fatal I/O error and (c) the cache being removed; and protects
the cache against (d) the netfs uncaching pages that the cache is using and (e)
conflicting operations from the netfs, some of which may be queued for
asynchronous processing.

FS-Cache also groups asynchronous netfs store requests together, which
hopefully, one day, I'll be able to pass on to the backing fs.

> In any case, you find out how to write the page to backing store by
> asking the filesystem, which in the naive approach would be nfs
> augmented with caching library calls.

NFS and AFS and CIFS and ISOFS, but yes, that's what fscache is, if you like, a
caching library.

> The filesystem keeps its own metadata around to know how to map the page to
> disk.  So again naively, this metadata could tell the nfs client that the
> page is not mapped to disk at all.

The netfs should _not_ know about the metadata of a backing fs.  Firstly, there
are many different potential backing filesystems, and secondly if the netfs
knows about the metadata of the backing fs, then the backing fs has to ask the
netfs's permission if it wants to change it (background defragmentation, for
instance).

The only bit of metadata Cachefiles asks for is whether a block is represented
on disk or not.  This indicates whether the page held in that block is in the
cache or whether it has to be retrieved from the server.  The answer to that
shouldn't change if the backing fs shuffles its (meta)data around on disk.

> So I do not see what your per-page bit is for, obviously because I do not
> fully understand your caching scheme.

It's an indication to the netfs that the cache has an interest in this page,
where an interest may be a pointer to it, resources allocated or reserverd for
it, or I/O in progress upon it.

> Which I could eventually find out by reading all the patches but asking you
> is so much more fun :-)

And a waste of my time.  I've provided documentation in the main FS-Cache
patch, both as text files and in comments in header files that answer your
questions.  Please read them first.

> By the way, how many levels of page caching for the same data are
> there, is it:
> 
>   1) nfs client
>   2) cache layer's own page cache
>   3) filesystem hosting the cache
> 
> or just:
> 
>   1) nfs client page cache
>   2) filesystem hosting the cache
> 
> I think it is the second, but that is already double caching, which
> has got to hurt.

Actually, it is ideally:

    1) NFS client page cache.

But, because I can't do in-kernel O_DIRECT at the moment, with _CacheFiles_, it
is:

    1) NFS client page cache.
    2) Backing fs page cache.

With CacheFS it really is:

    1) NFS client page cache.

and it really does BIOs directly to/from the pages in the netfs.

David
