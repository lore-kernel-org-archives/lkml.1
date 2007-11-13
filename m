Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbXKMCN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbXKMCN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXKMCNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:13:46 -0500
Received: from cobra.newdream.net ([66.33.216.30]:59711 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbXKMCNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:13:45 -0500
X-Greylist: delayed 1359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 21:13:45 EST
Date: Mon, 12 Nov 2007 17:51:06 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ceph-devel@lists.sourceforge.net
Subject: [ANNOUNCE] Ceph distributed file system
Message-ID: <Pine.LNX.4.64.0711121736580.13192@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Ceph is a distributed network file system designed to provide excellent 
performance, reliability, and scalability with POSIX semantics.  I 
periodically see frustration on this list with the lack of a scalable GPL 
distributed file system with sufficiently robust replication and failure 
recovery to run on commodity hardware, and would like to think that--with 
a little love--Ceph could fill that gap.  Basic features include:

 * POSIX semantics.
 * Seamless scaling from a few nodes to many thousands.
 * Gigabytes to petabytes.
 * High availability and reliability.  No single points of failure.
 * N-way replication of all data across multiple nodes.
 * Automatic rebalancing of data on node addition/removal to efficiently 
   utilize device resources.
 * Easy deployment; most FS components are userspace daemons.
 * Fuse-based client.
 - Lightweight kernel client (in progress).

 - Flexible snapshots on arbitrary subdirectories (soon)
 - Quotas (soon)
 - Strong security (planned)

(* = current features, - = coming soon)

In contrast to cluster filesystems like GFS, OCFS2, and GPFS that rely on 
symmetric access by all clients to shared block devices, Ceph separates 
data and metadata management into independent server clusters, similar to 
Lustre.  Unlike Lustre, however, metadata and storage nodes run entirely 
in userspace and require no special kernel support.  Storage nodes utilize 
either a raw block device or large image file to store data objects, or 
can utilize an existing file system (XFS, etc.) for local object storage 
(currently with weakened safety semantics).  File data is striped across 
storage nodes in large chunks to distribute workload and facilitate high 
throughputs.  When storage nodes fail, data is re-replicated in a 
distributed fashion by the storage nodes themselves (with some 
coordination from a cluster monitor), making the system extremely 
efficient and scalable.  Currently only n-way replication is supported, 
although initial groundwork has been laid for parity-based data 
redundancy.

Metadata servers effectively form a large, consistent, distributed 
in-memory cache above the storage cluster that is extremely scalable, 
dynamically redistributes metadata in response to workload changes, and 
can tolerate arbitrary (well, non-Byzantine) node failures.  The metadata 
server takes a somewhat unconventional approach to metadata storage to 
significantly improve performance for common workloads.  In particular, 
inodes with only a single link are embedded in directories, allowing 
entire directories of dentries and inodes to be loaded into its cache with 
a single I/O operation.  The contents of extremely large directories can 
be fragmented and managed by independent metadata servers, allowing 
scalable concurrent access.

Most importantly (in my mind, at least), the system offers automatic data 
rebalancing/migration when scaling from a small cluster of just a few 
nodes to many hundreds, without requiring an administrator carve the data 
set into static volumes or go through the tedious process of migrating 
data between servers.  When the file system approaches full, new nodes can 
be easily added and things will "just work."  Moreover, there is an 
unfortunate scarcity of 'enterprise-grade' features among open source 
Linux file systems when it comes to scalability, failure recovery, load 
balancing, and snapshots.  Snapshot support is a particularly sore point 
for me as block device-based approaches tend to be slow, inefficient, 
tedious to use, and unusable by the cluster file systems.

The following paper provides a good overview of the architecture:  

 http://www.usenix.org/events/osdi06/tech/weil.html


Although I have been working on this project for some time (it was the 
subject of my PhD thesis), I am announcing it to linux-fsdevel and lkml 
now because we are just (finally) getting started with the implementation 
of an in-kernel client.  There is a prototype client based on FUSE, but it 
is limited both in terms of correctness (due to limited control over cache 
consistency) and performance.  I am hoping to generate interest among file 
system developers with more kernel experience than I to help guide 
development as we move forward with porting the client to the kernel.

The kernel-side client code is in its infancy, but the rest of the system 
is relatively mature.  We have already been able to demonstrate excellent 
performance and scalability (see the above referenced paper), and the 
storage and metadata clusters can both tolerate and recover from 
arbitrary/multiple node failures.  I would describe the code base 
(weighing in at around 40,000 semicolon-lines) as early alpha quality: 
there is a healthy amount of debugging work to be done, but the basic 
features of the system system are complete and can be tested and 
benchmarked.

If you have any questions, I would be happy to discuss the architecture 
in more detail.  The paper mentioned above is probably the best overview.  
The source and more are available at the project web site,

 http://ceph.sourceforge.net/

Please let me know what you think.

sage
