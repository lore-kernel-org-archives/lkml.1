Return-Path: <linux-kernel-owner+w=401wt.eu-S935299AbYBVAJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935299AbYBVAJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYBVAJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:09:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYBVAJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:09:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802211444.04986.phillips@phunq.net>
References: <200802211444.04986.phillips@phunq.net> <200802201907.40406.phillips@phunq.net> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk> <28196.1203605703@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 22 Feb 2008 00:07:41 +0000
Message-ID: <18063.1203638861@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> wrote:

> When you say Ext3 cache vs NFS cache is the first on the server and the 
> second on the client?

The filesystem on the server is pretty much irrelevant as long as (a) it
doesn't change, and (b) all the data is in memory on the server anyway.

The way the client works is like this:

	+---------+
	|         |                   
	|   NFS   |--+                
	|         |  |                
	+---------+  |   +----------+ 
	             |   |          | 
	+---------+  +-->|          | 
	|         |      |          |
	|   AFS   |----->| FS-Cache |
	|         |      |          |--+
	+---------+  +-->|          |  |
	             |   |          |  |   +--------------+   +--------------+
	+---------+  |   +----------+  |   |              |   |              |
	|         |  |                 +-->|  CacheFiles  |-->|  Ext3        |
	|  ISOFS  |--+                     |  /var/cache  |   |  /dev/sda6   |
	|         |                        +--------------+   +--------------+
	+---------+


 (1) NFS, say, asks FS-Cache to store/retrieve data for it;

 (2) FS-Cache asks the cache backend, in this case CacheFiles to honour the
     operation;

 (3) CacheFiles 'opens' a file in a mounted filesystem, say Ext3, and does read
     and write operations of a sort on it;

 (4) Ext3 decides how the cache data is laid out on disk - CacheFiles just
     attempts to use one sparse file per netfs inode.

> I am trying to spot the numbers that show the sweet spot for this 
> optimization, without much success so far.

What are you trying to do exactly?  Are you actually playing with it, or just
looking at the numbers I've produced?

> Who is supposed to win big?  Is this mainly about reducing the load on 
> the server, or is the client supposed to win even with a lightly loaded 
> server?

These are difficult questions to answer.  The obvious answer to both is "it
depends", and the real answer to both is "it's a compromise".

Inserting a cache adds overhead: you have to look in the cache to see if your
objects are mirrored there, and then you have to look in the cache to see if
the data you want is stored there; and then you might have to go to the server
anyway and then schedule a copy to be stored in the cache.

The characteristics of this type of cache depend on a number of things: the
filesystem backing it being the most obvious variable, but also how fragmented
it is and the properties of the disk drive or drives it is on.

Whether it's worth having a cache depend on the characteristics of the network
versus the characteristics of the cache.  Latency of the cache vs latency of
the network, for example.  Network loading is another: having a cache on each
of several clients sharing a server can reduce network traffic by avoiding the
read requests to the server.  NFS has a characteristic that it keeps spamming
the server with file status requests, so even if you take the read requests out
of the load, an NFS client still generates quite a lot of network traffic to
the server - but the reduction is still useful.

The metadata problem is quite a tricky one since it increases with the number
of files you're dealing with.  As things stand in my patches, when NFS, for
example, wants to access a new inode, it first has to go to the server to
lookup the NFS file handle, and only then can it go to the cache to find out if
there's a matching object in the case.  Worse, the cache must then perform
several synchronous disk bound metadata operations before it can be possible to
read from the cache.  Worse still, this means that a read on the network file
cannot proceed until (a) we've been to the server *plus* (b) we've been to the
disk.

The reason my client going to my server is so quick is that the server has the
dcache and the pagecache preloaded, so that across-network lookup operations
are really, really quick, as compared to the synchronous slogging of the local
disk to find the cache object.

I can probably improve this a little by pre-loading the subindex directories
(hash tables) that I use to reduce the directory size in the cache, but I don't
know by how much.


Anyway, to answer your questions:

 (1) It may help with heavily loaded networks with lots of read-only traffic.

 (2) It may help with slow connections (like doing NFS between the UK and
     Australia).

 (3) It could be used to do offline/disconnected operation.

David
