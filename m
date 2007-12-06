Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbXLFBYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbXLFBYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 20:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXLFBYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 20:24:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXLFBYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 20:24:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <A0BB0F8C-9628-4B6C-A2F7-F3870B487D4E@oracle.com>
References: <A0BB0F8C-9628-4B6C-A2F7-F3870B487D4E@oracle.com> <6306.1196874660@redhat.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: dhowells@redhat.com, Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: How to manage shared persistent local caching (FS-Cache) with NFS?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 06 Dec 2007 01:22:48 +0000
Message-ID: <25619.1196904168@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chuck Lever <chuck.lever@oracle.com> wrote:

> I don't see how persistent local caching means we can no longer ignore (a)
> and (b) above.  Can you amplify this a bit?

How about I put it like this.  There are two principal problems to be dealt
with:

 (1) Reconnection.

     Imagine that the administrator requests a mount that uses part of a cache.
     The client machine is at some time later rebooted and the administrator
     requests the same mount again.

     Since the cache is meant to be persistent, the administrator is at liberty
     to expect that the second mount immediately begins to use the data that
     the first mount left in the cache.

     For this to occur, the second mount has to be able to determine which part
     of the cache the first mount was using and request to use the same piece
     of cache.

     To aid with this, FS-Cache has the concept of a 'key'.  Each object in the
     cache is addressed by a unique key.  NFS currently builds a key to the
     cache object for a file from: "NFS", the server IP address, port and NFS
     version and the file handle for that file.

 (2) Cache coherency.

     Imagine that the administrator requests a mount that uses part of a
     cache.  The administrator then makes a second mount that overlaps the
     first, maybe because it's a different part of the same server export or
     maybe it uses the same part, but with different parameters.

     Imagine further that a particular server file is accessible through both
     mountpoints.  This means that the kernel, and therefore the user, has two
     views of the one file.

     If the kernel maintains these two views of the files as totally separate
     copies, then coherency is mostly not a kernel problem, it's an application
     problem - as it is now.

     However, if these two views are shared at any level - such as if they
     share an FS-Cache cache object - then coherency can be a problem.

     The two simplest solutions to the coherency problem are (a) to enforce
     sharing at all levels (superblocks, inodes, cache objects), (b) to enforce
     non-sharing.  In-between states are possible, but are much trickier and
     more complex.

     Note that cache coherency management can't be entirely avoided: upon
     reconnection a cache object has to be checked against the server to see
     whether it's still valid.

Note that both these problems only really exist because the cache is
persistent between mounts.  If it were volatile between mounts, then (1) would
not exist, and (2) can be ignored as it is now.

There are three obvious ways of dealing with the problems (ignoring the fact
that all cases have on-reconnection coherency to deal with whatever):

 (a) No sharing at all.
     
     Cache coherency is what it is now with NFS, but reconnection must be
     managed.  A key must be generated to each mount to distinguish that mount
     from an overlapping mount that might contain the same files.

     These keys must be unique (and uniqueness must be enforced) unless two
     superblocks are guaranteed disjoint (eg: on different servers), or are
     guaranteed to share anyway (eg: exact same parameter sets and nosharecache
     not specified).

 (b) Fully shared.

     Cache coherency is a non-issue.  Reconnection is a non-issue.  Any
     particular server inode is guaranteed to be represented by a single inode
     on the client, both in the superblock and the pagecache, and by a single
     FS-Cache cache object.

     The downside of this is that sharing must take priority over different
     connection parameters.  R/O vs R/W can be dealt relatively easily as I
     believe it's a local phenomenon, and is dealt with before the filesystem
     is consulted.  There are patches to do this.

 (c) Implicit full sharing between cached mountpoints; uncached mountpoints
     need not be shared.

     Cached mountpoints have the properties of (b), uncached mountpoints are
     left to themselves.

Note that redundant disk usage is undesirable, but unlikely to cause a real
problem, such as an oops.  Non-unique keys, on the other hand, are a problem.

Having non-shared local inodes sharing cache objects causes even more problems,
and I don't want to go there.

> Nothing you say in the rest of your proposal convinces me that having
> multiple caches for the same export is really more than a theoretical issue.

Okay.  So how do you do reconnection?

The simplest way from what I see is to require that the administrator specify
everything, but this is probably not what you want if you're distributing NFS
mounts by NIS, say.

The next simplest way is to bind all the differentiation parameters (see
nfs_compare_mount_options()) into a key and use that, plus a uniquifier from
the administrator if NFS_MOUNT_UNSHARED is set.

> Frankly, the reason why admins mount exports multiple times is precisely
> because they want different applications to access the  files in different
> ways.

So I've gathered.

> This is actually a feature of NFS.  It's used as a standard part of production
> environments, for example, when running Oracle databases  on NFS.  One mount
> point is rw and is used by the database engine.   Another mount point is ro
> and is used for back-up utilities, like RMAN.

R/O vs R/W is a special case.  There are patches out there to deal with it by
moving the R/O flag off into vfsmount.

> As useful as the feature is, one can also argue that mounting the same export
> multiple times is infrequent in most normal use cases.   Practically speaking,
> why do we really need to worry about it?

Because it's possible.  Because it has to be considered.  Because, as you said,
people do it.  Because if I don't deal with it, the kernel will oops when NFS
asks FS-Cache to do something it doesn't support.

I can't just say: "Well, it'll oops if you configure your NFS shares like that,
so don't.  It's not worth me implementing round it.".

> The real problem here is that the NFS protocol itself does not support strong
> cache coherence.  I don't see why the Linux kernel  must fix that problem.

So you're arguing there shouldn't be local caching for NFS?  Or that there
shouldn't be persistent local caching for NFS?

> The problems you ascribe to your second and third caching scenarios
> (deadlocking and reconnection)

The second only.  Neither occur with the third scenario.

> are, however, real and substantial.  You don't have these issues when caching
> each mount point separately, right?

Not right.  Deadlocking, no; reconnection, YES.  As I said:

	There's a further problem that is less obvious: the cache is persistent
	- and so the links from the client inodes into the cache must be
	reformed for subsequent mounts.

Reconnection is straightforward only in the third scenario because it
eliminates all possibility of alternative possibilities.

> It seems to me that implementing the first scenario is (a) straightforward,
> (b) has fewer runtime risks (ie deadlocks), (c)  doesn't take away features
> that some people still use, and (d) solves  more than 80% of the issues here
> (80/20 rule of thumb).

It seems straightforward at first glance, but you still have to deal with
reconnection.

As for (b), the third scenario has fewest risks and deadlock possibilities by
virtue of making sure they don't arise in the first place.

(c) is a valid point.

(d) isn't true.  Reconnection.

> Lastly, there's already a mount option that allows admins to control whether
> the page and attribute caches are shared -- "sharecache".  Is  this mount
> option not adequate for persistent caching?

Adequate in what way?  It doesn't currently automatically guarantee sharing of
overlapping superblocks.  It merely disables nonsharecache which explicitly
disables cache sharing.

David
