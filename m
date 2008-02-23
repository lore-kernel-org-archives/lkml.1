Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYBWBXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYBWBXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYBWBXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:23:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYBWBXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:23:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802221425.48535.phillips@phunq.net>
References: <200802221425.48535.phillips@phunq.net> <200802211657.01704.phillips@phunq.net> <18063.1203638861@redhat.com> <20089.1203684531@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sat, 23 Feb 2008 01:22:38 +0000
Message-ID: <25049.1203729758@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> wrote:

> I am eventually going to suggest cutting the backing filesystem entirely out
> of the picture,

You still need a database to manage the cache.  A filesystem such as Ext3
makes a very handy database for four reasons:

 (1) It exists and works.

 (2) It has a well defined interface within the kernel.

 (3) I can place my cache on, say, my root partition on my laptop.  I don't
     have to dedicate a partition to the cache.

 (4) Userspace cache management tools (such as cachefilesd) have an already
     existing interface to use: rmdir, unlink, open, getdents, etc..

I do have a cache-on-blockdev thing, but it's basically a wandering tree
filesystem inside.  It is, or was, much faster than ext3 on a clean cache, but
it degrades horribly over time because my free space reclamation sucks - it
gradually randomises the block allocation sequence over time.

So, what would you suggest instead of a backing filesystem?

> I really do not like idea of force fitting this cache into a generic
> vfs model.  Sun was collectively smoking some serious crack when they
> cooked that one up.  But there is also the ageless principle "isness is
> more important than niceness".

What do you mean?  I'm not doing it like Sun.  The cache is a side path from
the netfs.  It should be transparent to the user, the VFS and the server.

The only place it might not be transparent is that you might to have to
instruct the netfs mount to use the cache.  I'd prefer to do it some other way
than passing parameters to mount, though, as (1) this causes fun with NIS
distributed automounter maps, and (2) people are asking for a finer grain of
control than per-mountpoint.  Unfortunately, I can't seem to find a way to do
it that's acceptable to Al.

> Which would require a change to NFS, not an option because you hope to
> work with standard servers?  Of course with years to think about this,
> the required protocol changes were put into v4.  Not.

I don't think there's much I can do about NFS.  It requires the filesystem
from which the NFS server is dealing to have inode uniquifiers, which are then
incorporated into the file handle.  I don't think the NFS protocol itself
needs to change to support this.

> Have you completely exhausted optimization ideas for the file handle
> lookup?

No, but there aren't many.  CacheFiles doesn't actually do very much, and it's
hard to reduce that not very much.  The most obvious thing is to prepopulate
the dcache, but that's at the expense of memory usage.

Actually, if I cache the name => FH mapping I used last time, I can make a
start on looking up in the cache whilst simultaneously accessing the server.
If what's on the server has changed, I can ditch the speculative cache lookup
I was making and start a new cache lookup.

However, storing directory entries has penalties of its own, though it'll be
necesary if we want to do disconnected operation.

> > Where "lookup table" == "dcache".  That would be good yes.  cachefilesd
> > prescans all the files in the cache, which ought to do just that, but it
> > doesn't seem to be very effective.  I'm not sure why.
> 
> RCU?  Anyway, it is something to be tracked down and put right.

cachefilesd runs in userspace.  It's possible it isn't doing enough to preload
all the metadata.

> What I tried to say.  So still... got any ideas?  That extra synchronous
> network round trip is a killer.  Can it be made streaming/async to keep
> throughput healthy?

That's a per-netfs thing.  With the test rig I've got, it's going to the
on-disk cache that's the killer.  Going over the network is much faster.

See the results I posted.  For the tarball load, and using Ext3 to back the
cache:

	Cold NFS cache, no disk cache:		0m22.734s
	Warm on-disk cache, cold pagecaches:	1m54.350s

The problem is reading using tar is a worst case workload for this.  Everything
it does is pretty much completely synchronous.

One thing that might help is if things like tar and find can be made to use
fadvise() on directories to hint to the filesystem (NFS, AFS, whatever) that
it's going to access every file in those directories.

Certainly AFS could make use of that: the directory is read as a file, and the
netfs then parses the file to get a list of vnode IDs that that directory
points to.  It could then do bulk status fetch operations to instantiate the
inodes 50 at a time.

I don't know whether NFS could use it.  Someone like Trond or SteveD or Chuck
would have to answer that.

David
