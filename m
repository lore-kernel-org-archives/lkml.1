Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXLFSa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXLFSa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXLFSat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:30:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43007 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXLFSas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:30:48 -0500
In-Reply-To: <25619.1196904168@redhat.com>
References: <A0BB0F8C-9628-4B6C-A2F7-F3870B487D4E@oracle.com> <6306.1196874660@redhat.com> <25619.1196904168@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <26C82FDD-C778-4034-A3CF-CB1C83A0C90C@oracle.com>
Cc: Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: How to manage shared persistent local caching (FS-Cache) with NFS?
Date: Thu, 6 Dec 2007 13:28:58 -0500
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David-

On Dec 5, 2007, at 8:22 PM, David Howells wrote:
> Chuck Lever <chuck.lever@oracle.com> wrote:
>
>> I don't see how persistent local caching means we can no longer  
>> ignore (a)
>> and (b) above.  Can you amplify this a bit?
>
> How about I put it like this.  There are two principal problems to  
> be dealt
> with:
>
>  (1) Reconnection.
>
>      Imagine that the administrator requests a mount that uses part  
> of a cache.
>      The client machine is at some time later rebooted and the  
> administrator
>      requests the same mount again.
>
>      Since the cache is meant to be persistent, the administrator  
> is at liberty
>      to expect that the second mount immediately begins to use the  
> data that
>      the first mount left in the cache.
>
>      For this to occur, the second mount has to be able to  
> determine which part
>      of the cache the first mount was using and request to use the  
> same piece
>      of cache.
>
>      To aid with this, FS-Cache has the concept of a 'key'.  Each  
> object in the
>      cache is addressed by a unique key.  NFS currently builds a  
> key to the
>      cache object for a file from: "NFS", the server IP address,  
> port and NFS
>      version and the file handle for that file.

Why not use the fsid as well?  The NFS client already uses the fsid  
to detect when it is crossing a server-side mount point.  Fsids are  
supposed to be stable over server reboots (although sometimes they  
aren't, it could be made a condition of supporting FS-cache on clients).

I also note the inclusion of server IP address in the key.  For multi- 
homed servers, you have the same unavoidable cache aliasing issues if  
the client mounts the same server and export via different server  
network interfaces.

>  (2) Cache coherency.
>
>      Imagine that the administrator requests a mount that uses part  
> of a
>      cache.  The administrator then makes a second mount that  
> overlaps the
>      first, maybe because it's a different part of the same server  
> export or
>      maybe it uses the same part, but with different parameters.
>
>      Imagine further that a particular server file is accessible  
> through both
>      mountpoints.  This means that the kernel, and therefore the  
> user, has two
>      views of the one file.
>
>      If the kernel maintains these two views of the files as  
> totally separate
>      copies, then coherency is mostly not a kernel problem, it's an  
> application
>      problem - as it is now.
>
>      However, if these two views are shared at any level - such as  
> if they
>      share an FS-Cache cache object - then coherency can be a problem.

Is it a problem because, if there are multiple copies of the same  
remote file in its cache, then FS-cache doesn't know, upon  
reconnection, which item to match against a particular remote file?

I think that's actually going to be a fairly typical situation --  
you'll have conditions where some cache items will become orphaned,  
for example, so you're going to have to deal with that ambiguity as a  
part of normal operation.

For example, if the FS-caching client is disconnected or powered off  
when a remote rename occurs that replaces a file it has cached, the  
client will have an orphaned item left over.  Maybe this use case is  
only a garbage collection problem.

>      The two simplest solutions to the coherency problem are (a) to  
> enforce
>      sharing at all levels (superblocks, inodes, cache objects),  
> (b) to enforce
>      non-sharing.  In-between states are possible, but are much  
> trickier and
>      more complex.
>
>      Note that cache coherency management can't be entirely  
> avoided: upon
>      reconnection a cache object has to be checked against the  
> server to see
>      whether it's still valid.

How do you propose to do that?

First, clearly, FS-cache has to know that it's the same object, so  
fsid and filehandle have to be the same (you refer to that as the  
"reconnection problem", but it may generally be a "cache aliasing  
problem").

I assume FS-cache has a record of the state of the remote file when  
it was last connected -- mtime, ctime, size, change attribute (I'll  
refer to this as the "reconciliation problem")?  Does it, for  
instance, checksum both the cache item and the remote file to detect  
data differences?

You have the same problem here as we have with file system search  
tools such as Beagle.  Reconciling file contents after a reconnection  
event may be too expensive to consider for NFS, especially if a file  
is terabytes in size.

> Note that both these problems only really exist because the cache is
> persistent between mounts.  If it were volatile between mounts,  
> then (1) would not exist, and (2) can be ignored as it is now.

Do you allow administrators to select whether the FS-cache is  
persistent?  Or is it always unconditionally persistent?

An adequate first pass at FS-cache can be done without guaranteeing  
persistence.  There are a host of other issues that need exposure --  
steady-state performance; cache garbage collection and reclamation;  
cache item aliasing; whether all files on a mount point should be  
cached on disk, or some in memory and some on disk; and so on -- that  
can be examined without even beginning to worry about reboot recovery.

And what would it harm if FS-cache decides that certain items in its  
cache have become ambiguous or otherwise unusable after a  
reconnection event, thus it reclaims them instead of re-using them?

> There are three obvious ways of dealing with the problems (ignoring  
> the fact
> that all cases have on-reconnection coherency to deal with whatever):
>
>  (a) No sharing at all.
>
>      Cache coherency is what it is now with NFS, but reconnection  
> must be
>      managed.  A key must be generated to each mount to distinguish  
> that mount
>      from an overlapping mount that might contain the same files.
>
>      These keys must be unique (and uniqueness must be enforced)  
> unless two
>      superblocks are guaranteed disjoint (eg: on different  
> servers), or are
>      guaranteed to share anyway (eg: exact same parameter sets and  
> nosharecache
>      not specified).
>
>  (b) Fully shared.
>
>      Cache coherency is a non-issue.  Reconnection is a non-issue.   
> Any
>      particular server inode is guaranteed to be represented by a  
> single inode
>      on the client, both in the superblock and the pagecache, and  
> by a single
>      FS-Cache cache object.
>
>      The downside of this is that sharing must take priority over  
> different
>      connection parameters.  R/O vs R/W can be dealt relatively  
> easily as I
>      believe it's a local phenomenon, and is dealt with before the  
> filesystem
>      is consulted.  There are patches to do this.
>
>  (c) Implicit full sharing between cached mountpoints; uncached  
> mountpoints
>      need not be shared.
>
>      Cached mountpoints have the properties of (b), uncached  
> mountpoints are
>      left to themselves.
>
> Note that redundant disk usage is undesirable, but unlikely to  
> cause a real
> problem, such as an oops.  Non-unique keys, on the other hand, are  
> a problem.
>
> Having non-shared local inodes sharing cache objects causes even  
> more problems,
> and I don't want to go there.
>
>> Nothing you say in the rest of your proposal convinces me that having
>> multiple caches for the same export is really more than a  
>> theoretical issue.
>
> Okay.  So how do you do reconnection?
>
> The simplest way from what I see is to require that the  
> administrator specify
> everything, but this is probably not what you want if you're  
> distributing NFS
> mounts by NIS, say.

Automatic configuration is preferred.  For example, NFS with Kerberos  
has an administrative scaling problem because some local  
administration (creating a keytab and registering the client with  
KDC) is required for every client that joins a realm.

> The next simplest way is to bind all the differentiation parameters  
> (see
> nfs_compare_mount_options()) into a key and use that, plus a  
> uniquifier from
> the administrator if NFS_MOUNT_UNSHARED is set.

It gives us the proper legacy behavior, but as soon as the  
administrator changes a mount option, all previously cached items for  
that mount point become orphans.

>> As useful as the feature is, one can also argue that mounting the  
>> same export
>> multiple times is infrequent in most normal use cases.    
>> Practically speaking,
>> why do we really need to worry about it?
>
> Because it's possible.  Because it has to be considered.  Because,  
> as you said,
> people do it.  Because if I don't deal with it, the kernel will  
> oops when NFS
> asks FS-Cache to do something it doesn't support.
>
> I can't just say: "Well, it'll oops if you configure your NFS  
> shares like that,
> so don't.  It's not worth me implementing round it.".

What causes that instability?  Why can't you insulate against the  
instability but allow cache incoherence and aliased cache items?

Local file systems are fraught with cases where they protect their  
internal metadata aggressively at the cost of not keeping the disk up  
to date with the memory version of the file system.

Similar compromises might benefit FS-cache.  In other words, FS-cache  
for NFS file systems may be less functional than for, say, AFS, to  
allow the cache to operate reliably.

>> The real problem here is that the NFS protocol itself does not  
>> support strong
>> cache coherence.  I don't see why the Linux kernel  must fix that  
>> problem.
>
> So you're arguing there shouldn't be local caching for NFS?  Or  
> that there
> shouldn't be persistent local caching for NFS?

I'm arguing that cache coherence isn't supported by the NFS protocol,  
so how can FS-cache *require* a facility to support persistent local  
caching that the protocol doesn't have in the first place?

NFS client implementations do the best they can; there are always  
scenarios where coherence issues cause behavior no-one expects.   
Usually NFS clients handle ambiguous cases by invalidating their  
caches.  Invalidating is cheap for in-memory caches.  Frequent  
invalidation is going to be expensive for FS-cache, since it requires  
some disk I/O (and perhaps even file truncation).  One reason why  
chunk caching is better than whole-file caching is that it bounds the  
time and effort to recycle a cache item.

AFS assigns universally unique identities to servers, volumes, and  
files.  NFS doesn't guarantee unique identities to servers or  
exports, and file handles are supposed to be unique only on a given  
server [*].  And unfortunately file handles can be re-used by the  
server without any indication to the client that the file handle it  
has cached is no longer the same file (see the "out_fileid" label in  
fs/nfs/inode.c:nfs_update_inode).  AFS provides client-visible  
generation IDs in its inode numbers for this case.

Thus NFS itself does not provide any good way to help you sort FS- 
cache cache items outside of a single export.  A proper FS-cache  
implementation thus cannot depend on server/export identity to  
guarantee the singularity of cache items.

So FS-cache will have a hard time guaranteeing that there is only one  
item in its cache that maps to a given NFS server file.  It may also  
be difficult to guarantee that multiple NFS server files do not map  
onto the same local cache item (file handle re-use).

This suggests to me that the cache aliasing problem is unsolvable for  
NFS, so you should find a way to make FS-cache work in a world where  
cache aliasing is a fact of life.

>> Lastly, there's already a mount option that allows admins to  
>> control whether
>> the page and attribute caches are shared -- "sharecache".  Is   
>> this mount
>> option not adequate for persistent caching?
>
> Adequate in what way?  It doesn't currently automatically guarantee  
> sharing of
> overlapping superblocks.  It merely disables nonsharecache which  
> explicitly
> disables cache sharing.

The current problem with "sharecache" is that the mount options on  
subsequent mounts of the same export are silently ignored.  You are  
proposing the same behavior for FS-cache-managed mount points, which  
means we're spreading bad UI behavior further.

At least there should be a warning that explains why a file system  
that was mounted with "rw,noac,tcp" is behaving like it's "ro,ac,udp".

Ideally, if we must have cache sharing, the behavior should be: if  
the mount options, the server, and the fsid are the same, then the  
cache should be shared.  If any of that tuple are different, then a  
unique cache is used for that mount point (within the limits of being  
able to determine the unique identity of a server and export).

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com

[*] Section 4 of RFC 3530 states:

The filehandle in the NFS protocol is a per server unique identifier  
for a filesystem object.  The contents of the filehandle are opaque  
to the client.  Therefore, the server is responsible for translating  
the filehandle to an internal representation of the filesystem object.
