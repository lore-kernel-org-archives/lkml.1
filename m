Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXLFUC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXLFUC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbXLFUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:02:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbXLFUCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:02:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <26C82FDD-C778-4034-A3CF-CB1C83A0C90C@oracle.com>
References: <26C82FDD-C778-4034-A3CF-CB1C83A0C90C@oracle.com> <A0BB0F8C-9628-4B6C-A2F7-F3870B487D4E@oracle.com> <6306.1196874660@redhat.com> <25619.1196904168@redhat.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: dhowells@redhat.com, Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: How to manage shared persistent local caching (FS-Cache) with NFS?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 06 Dec 2007 20:00:51 +0000
Message-ID: <21053.1196971251@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever <chuck.lever@oracle.com> wrote:

> Why not use the fsid as well?  The NFS client already uses the fsid to detect
> when it is crossing a server-side mount point.

Why use the FSID at all?  The file handles are supposed to be unique per
server.

> I also note the inclusion of server IP address in the key.  For multi-
> homed servers, you have the same unavoidable cache aliasing issues if the
> client mounts the same server and export via different server  network
> interfaces.

I'm aware of this, but unless there's:

 (a) a way to specify a logical server group to the kernel, and

 (b) a guarantee that the file handles of each member of the logical group are
     common across the group

there's nothing I can do about it.

AFS deals with these by making servers second class citizens, and defining
"file handles" to be a set within the cell space.

Besides, I can use the IP address of the server as a key.  I just have to hope
that the IP address doesn't get transferred to a different server because, as
far as I know, there isn't any way to detect this in the NFS protocol.

> Is it a problem because, if there are multiple copies of the same remote file
> in its cache, then FS-cache doesn't know, upon  reconnection, which item to
> match against a particular remote file?

There are multiple copies of the same remote file that are described by the
same remote parameters.  Same IP address, same port, same NFS version, same
FSID, same FH.  The difference may be a local connection parameter.

> I think that's actually going to be a fairly typical situation -- 
> you'll have conditions where some cache items will become orphaned, for
> example, so you're going to have to deal with that ambiguity as a  part of
> normal operation.

Orphaned stuff in the cache is eventually culled by cachefilesd when there's
space pressure in the cache.

> For example, if the FS-caching client is disconnected or powered off when a
> remote rename occurs that replaces a file it has cached, the  client will have
> an orphaned item left over.  Maybe this use case is  only a garbage collection
> problem.

Rename isn't a problem provided the FH doesn't change.  NFS effectively caches
inodes, not files.  If the remote file is deleted, then either NFS will try
opening it, will fail and will tell the cache to evict it; or the remote file
will never be opened again and the garbage in the cache will be culled
eventually.  It may even hang around for ever, but if the FH it re-used, the
cache object will be evicted based on mtime + ctime + filesize being
different.

If someone tries hard enough, they can probably muck up the cache, but there's
not a lot I can do about that.

> >      Note that cache coherency management can't be entirely avoided: upon
> >      reconnection a cache object has to be checked against the server to see
> >      whether it's still valid.
> 
> How do you propose to do that?

For NFS, check mtime + ctime + filesize upon opening.  It's in the patch
already.

For AFS there's a data version number.

> First, clearly, FS-cache has to know that it's the same object, so fsid and
> filehandle have to be the same (you refer to that as the  "reconnection
> problem", but it may generally be a "cache aliasing  problem").

FSID is not required.  FH has to be unique per server according to Trond.

> I assume FS-cache has a record of the state of the remote file when it was
> last connected -- mtime, ctime, size, change attribute (I'll  refer to this as
> the "reconciliation problem")?

mtime + ctime + size, yes.  I should add the change attribute if it's present,
I suppose, but that ought to be simple enough.

> Does it, for instance, checksum both the cache item and the remote file to
> detect data differences?

No.  That would be horrendously inefficient.  Besides, if we're going to
checksum the remote file each time, what's the point in having a persistent
cache?

> You have the same problem here as we have with file system search tools such
> as Beagle.  Reconciling file contents after a reconnection  event may be too
> expensive to consider for NFS, especially if a file  is terabytes in size.

Because NFS v2 and v3 don't support proper coherency, there's a limited amount
we can do without being silly about it.  You just have to hope someone doesn't
wind back the clock on the server in order to fudge the ctime to give your
cache conniptions.  But if someone's willing to go to such lengths, you're
stuffed anyway.

I have to make some assumptions about what I can do.  They're probably
reasonable, but there's no guarantee it won't malfunction due to the speed of
today's networks vs the granularity of the time stamps.

If you don't want to take the risk, don't use persistent caching or don't use
NFS2 or 3.

> Do you allow administrators to select whether the FS-cache is persistent?  Or
> is it always unconditionally persistent?

The cache is persistent.  If you don't want it to be persistent, you can have
init delete it during boot.  It would be very easy to have NFS tell the cache
to discard each object as it ditches the inode that's using it.  It already
has to do this anyway, but it could be configured, for example, through the
NFS mount options.

> An adequate first pass at FS-cache can be done without guaranteeing
> persistence.

True.  But it's not particularly interesting to me in such a case.

> There are a host of other issues that need exposure -- steady-state
> performance;

Meaning what?

I have been measuring the performance improvement and degradation numbers, and
I can say that if you've one client and one server, the server has all the
files in memory, and there's gigabit ethernet between them, an on-disk cache
really doesn't help.

Basically, the consideration of whether to use a cache is a compromise between
a host of factors.

> cache garbage collection

Done.

> and reclamation;

Done.

> cache item aliasing;

Partly done.

> whether all files on a mount point should be cached on disk, or some in
> memory and some on disk;

I've thought about that, but no-one seems particularly interested in
discussing it.

> and so on -- that can be examined without even beginning to worry about
> reboot recovery.

Yet persistence, if we're going to have it, needs to be considered up front,
lest you have to go and completely rewrite everything later.

Persistence requires one thing: a unique key for each object.

> And what would it harm if FS-cache decides that certain items in its cache
> have become ambiguous or otherwise unusable after a  reconnection event, thus
> it reclaims them instead of re-using them?

It depends.

At some point I'd like to make disconnected operation possible, and that means
storing data to be written back in the cache.  You can't necessarily just
chuck that away.

But apart from that, that's precisely what the current caching code does.
It's at liberty to discard any clean part of the cache.

> Automatic configuration is preferred.

Indeed.  Furthermore, I'd rather not have the fscache parameters in the NFS
mount options at all, but specified separately.  This would permit
per-directory controls, say.

> > The next simplest way is to bind all the differentiation parameters (see
> > nfs_compare_mount_options()) into a key and use that, plus a uniquifier from
> > the administrator if NFS_MOUNT_UNSHARED is set.
> 
> It gives us the proper legacy behavior, but as soon as the administrator
> changes a mount option, all previously cached items for  that mount point
> become orphans.

That would be unavoidable.

> > I can't just say: "Well, it'll oops if you configure your NFS shares like
> > that,
> > so don't.  It's not worth me implementing round it.".
> 
> What causes that instability?  Why can't you insulate against the instability
> but allow cache incoherence and aliased cache items?

Insulate how?  The only way to do that is to add something to the cache key
that says that these two otherwise identical items are actually diffent
things.

> Local file systems are fraught with cases where they protect their internal
> metadata aggressively at the cost of not keeping the disk up  to date with the
> memory version of the file system.

I don't see that this is applicable.

> Similar compromises might benefit FS-cache.  In other words, FS-cache for NFS
> file systems may be less functional than for, say, AFS, to  allow the cache to
> operate reliably.

Firstly, I'd rather not start adding special exceptions unless I absolutely
have to.  Secondly, you haven't actually shown any compromises that might be
useful.

> I'm arguing that cache coherence isn't supported by the NFS protocol, so how
> can FS-cache *require* a facility to support persistent local  caching that
> the protocol doesn't have in the first place?

NFS has just enough to just about support a persistent local cache for
unmodified files.  It has unique file keys per server, and it has a (limited)
amount of coherency data per file.  That's not really the problem.

The problem is that the client can create loads of different views of a remote
export and the kernel treats them as if they're views of different remote
exports.  These views do not necessarily have *anything* to distinguish them
at all (nosharecache option).  This is a local phenomenon, and not really
anything to do with the server.

Now, for the case of cached clients, we can enforce a reduction of incoherency
by requiring one remote inode maps to a single client inode if that inode is
going to be placed in the persistent cache.

> NFS client implementations do the best they can;

This is no different.  I'm trying to do the best I can, even though it's not
fully supported.

> Usually NFS clients handle ambiguous cases by invalidating their caches.

This is no different.

> Invalidating is cheap for in-memory caches.  Frequent invalidation is going
> to be expensive for FS-cache, since it requires some disk I/O (and perhaps
> even file truncation).

So what?  That's one of the compromises you have to make if you want an
on-disk cache.  The invalidation is asynchronous anyway.  The cachefiles
kernel module renames the dead item into the graveyard directory, and
cachefilesd wakes up sometime later and deletes it.

> One reason why chunk caching is better than whole-file caching is that it
> bounds the time and effort to recycle a cache item.

That's a whole different kettle of miscellaneous swimming things, and also
besides the point.  Yes, I realise chunk caching is more efficient under some
circumstances, but not all.  However, I think that's something that NFS has to
handle, not FS-Cache as NFS is the one that can spam the server.

> AFS assigns universally unique identities to servers, volumes, and files.  NFS
> doesn't guarantee unique identities to servers or  exports, and file handles
> are supposed to be unique only on a given  server [*].  And unfortunately file
> handles can be re-used by the  server without any indication to the client
> that the file handle it  has cached is no longer the same file (see the
> "out_fileid" label in  fs/nfs/inode.c:nfs_update_inode).  AFS provides
> client-visible  generation IDs in its inode numbers for this case.

Yes.  That's one of the compromises you have to make just by using NFS at all.
It's not limited to NFS + FS-Cache.

> Thus NFS itself does not provide any good way to help you sort FS-cache
> cache items outside of a single export.  A proper FS-cache implementation
> thus cannot depend on server/export identity to guarantee the singularity of
> cache items.

What do you mean by server/export identity?  I'm under the impression that
FH's are unique per-server, and that exports don't have anything to do with
it.

> So FS-cache will have a hard time guaranteeing that there is only one item in
> its cache that maps to a given NFS server file.  It may also  be difficult to
> guarantee that multiple NFS server files do not map  onto the same local cache
> item (file handle re-use).

Anything that applies to NFS + FS-Cache here *also* applies to NFS itself.

Yes, I realise that the assumptions may get violated, but that's one of those
compromises you have to make if you want to use NFS.

> This suggests to me that the cache aliasing problem is unsolvable for NFS, so
> you should find a way to make FS-cache work in a world where  cache aliasing
> is a fact of life.

So you shouldn't use NFS at all is what you're saying?

Cache aliasing is a pain and has to be dealt with one way or another.  My
preferred solution is to *reduce* the amount of aliasing that occurs on the
client.  It is possible.  The code is already in the vanilla kernel to do
this.

The other extreme is to manually tag cache objects to distinguish otherwise
undistinguishable unshareable views of a remote file.

Note that there are just three aspects that need to be considered with regard
to managing coherence with the server:

 (1) Server identification.

     How do you detect that the server you were talking to before is still the
     same server?  As far as I know, with NFS, you can't.  You just have to
     hope.

 (2) Remote file identification.

     How do you detect that the file on that server you were accessing before
     is still the same file?

 (3) Remote file data version identification.

     How do you detect that the data in that file on that server you were
     using before is still the same data?

I currently combine points (2) and (3) by checking that the combination of FH,
mtime, ctime and file size is the same.  If it is not, the cache object is not
found or is discarded and a new one is made.  This could be improved for NFS
by using the change attribute if available.

These determine whether persistent caching is possible at all.

The views set up by the sysadmin are artificial non-coherency problems.  Still
valid, obviously, judging by the cries of anguish when they're ignored
preemptively in all cases.

> The current problem with "sharecache" is that the mount options on subsequent
> mounts of the same export are silently ignored.  You are  proposing the same
> behavior for FS-cache-managed mount points, which  means we're spreading bad
> UI behavior further.

The whole point of "sharecache" is to make FS-Cache support easier by reducing
the coherency issues to something that's manageable by simple methods.  That's
why I wrote the patches for it.

However, given that no sysadmins use local caching on Linux until these
patches come along, why is it a problem to impose the added restriction that
fscached superblocks must also be shared?

> At least there should be a warning that explains why a file system that was
> mounted with "rw,noac,tcp" is behaving like it's "ro,ac,udp".

Perhaps.

Note again that R/O and R/W should be handled elsewhere.  Unless they're
reflected on the network at all?

> Ideally, if we must have cache sharing, the behavior should be: if the mount
> options, the server, and the fsid are the same, then the cache should be
> shared.  If any of that tuple are different, then a unique cache is used for
> that mount point (within the limits of being able to determine the unique
> identity of a server and export).

Yes.  This is more or less what I proposed and you've been objecting to.  At
least, I think you have.

I'm not sure that FSID is really relevant.  It doesn't add any useful
information, and can be changed by the server relatively easily - at least it
can on Linux under some circumstances.

Would you say that specifying "nosharecache" verboten if "fsc" is also
requested?  Otherwise, admin intervention is absolutely required in the
following case:

	mount warthog:/a /a -o nosharecache,fsc
	mount warthog:/a /b -o nosharecache,fsc

as there's no way to distinguish between the two mounts.

David
