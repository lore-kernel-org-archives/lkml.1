Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbXLHAwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbXLHAwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXLHAwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:52:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbXLHAwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:52:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <DD7C0279-50CF-443B-B61B-D3DD78EE22C5@oracle.com>
References: <DD7C0279-50CF-443B-B61B-D3DD78EE22C5@oracle.com> <26C82FDD-C778-4034-A3CF-CB1C83A0C90C@oracle.com> <A0BB0F8C-9628-4B6C-A2F7-F3870B487D4E@oracle.com> <6306.1196874660@redhat.com> <25619.1196904168@redhat.com> <21053.1196971251@redhat.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: dhowells@redhat.com, Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: How to manage shared persistent local caching (FS-Cache) with NFS?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sat, 08 Dec 2007 00:52:15 +0000
Message-ID: <16896.1197075135@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever <chuck.lever@oracle.com> wrote:

> Why not encode the local mounted-on directory in the key?

Can't.  Namespaces.  chroot.

> Meaning your cache is at quota all the time, and to continue operation it must
> eject items constantly.

I've thought about that, thank you.  Go and read the documentation.  There's
configurable hysteresis in the culling algorithm.

> This is a scenario where it pays to cache the read-mostly items on disk, and
> leave the frequently changing items in memory.

Currently any file which is opened for writing is automatically ejected from
the cache.

> The economics of disk caches is different than memory caches.  Disk caches are
> much larger and cheaper, but their performance tanks when  they have to track
> frequently changing files.  Memory caches are  smaller, but tracking
> frequently changing data is only a little more  expensive than tracking data
> that doesn't change often.

I'm aware of all that.  My OLS slides and paper can be found here:

	http://people.redhat.com/~dhowells/fscache/fscache-ols2006.odp
	http://people.redhat.com/~dhowells/fscache/FS-Cache.pdf

Lots of small files also hurt worse than fewer big files in some ways.  Lots
more metadata in the cache.  On the other hand, fragmentation is less of a
problem.

Anyway, this is straying off the main topic.

> I think it's key to preventing FS-cache from making performance worse in many
> common scenarios.

Perhaps.  The problem is that NFS doesn't know what the access pattern on a
file is expected to be.  I've been asked to provide fine-grained cache
controls (perhaps directory level), but Al Viro was, erm, luke warm in his
reception to that idea.

Gathering statistical data dynamically has performance penalties of its own:-/

> Disconnected operation for NFS is fraught with challenges.  Access to data on
> servers is traditionally gated by the client's IP address,  for example.  The
> client may disconnect from the network, then  reconnect using a different
> address where suddenly all of its  accesses are rebuffed.

Agreed, but isn't that one of the design goals for NFS4?

It's also something of interest to other netfs's that might want to use
FS-Cache.  This isn't an NFS-only facility.

> NFS servers, not clients, traditionally determine the file's mtime and ctime,
> and its file handle.  So file updates and file creation  become problematic.
> The client has to reconcile the server's file  handle, for files created
> offline, with its own when reconnecting.

Yes.  Basically it's a major can of major worms.  Doesn't stop people wanting
it, though.

> And, for disconnected operation, the cache is required to contain every item
> from the remote.  You can't just drop items from the cache  because they are
> inconvenient.

Yes.  That's what pinning and reservations are for.

Currently, support for disconnected operations is an idea I'd like to have,
but is otherwise mostly non-existent.

> That something might be the pathname of the mounted-on directory or of the
> file itself.

See above.

> Yes, they do.  The combination of mount options and mounted-on directory (or
> local pathname to the file) gives you a unique identity  for that view.

See above.

> So an item is cached in memory until space becomes available in the disk
> cache?

The item isn't considered for caching until space becomes available in the
disk cache.  It's put on a queue for potential caching, but won't actually be
cached if it gets discarded from the icache or pagecache before being cached.

It's unfortunate, but with a fast network you can download data faster than
you can make space in the cache.  unlink() and rmdir() are (a) slow and (b)
synchronous.  Each unlink() or rmdir() operation requires a task to perform
it, and that task is committed until the op finishes.

I could actually improve cachefilesd (the userspace cache culler) by giving it
multiple threads.

However, having cachefilesd doing lots of parallel synchronous, journalled
disk ops hurts performance in other ways I've noticed:-/

Again, hysteresis is available.  We stop writing stuff into the cache beyond
a limit until the free space drops sufficiently below that limit that we've
got a good go at writing a load new stuff, rather than just a block here and a
block there.

It's all very icky, and depends as much on the filesystem underlying the cache
(ext3 for example) and *its* configuration, as the characteristics of the
netfs and the network link.  It's all about compromise.

David
