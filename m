Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbYBUXgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbYBUXgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbYBUXgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:36:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbYBUXgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:36:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <28196.1203605703@redhat.com>
References: <28196.1203605703@redhat.com> <200802201907.40406.phillips@phunq.net> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Daniel Phillips <phillips@phunq.net>,
       Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 21 Feb 2008 23:33:53 +0000
Message-ID: <17916.1203636833@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > Have you got before/after benchmark results?
> 
> See attached.

Attached here are results using BTRFS (patched so that it'll work at all)
rather than Ext3 on the client on the partition backing the cache.

Note that I didn't bother redoing the tests that didn't involve a cache as the
choice of filesystem backing the cache should have no bearing on the result.

Generally, completely cold caches shouldn't show much variation as all the
writing can be done completely asynchronously, provided the client doesn't
fill its RAM.

The interesting case is where the disk cache is warm, but the pagecache is
cold (ie: just after a reboot after filling the caches).  Here, for the two
big files case, BTRFS appears quite a bit better than Ext3, showing a 21%
reduction in time for the smaller case and a 13% reduction for the larger
case.

For the many small/medium files case, BTRFS performed significantly better
(15% reduction in time) in the case where the caches were completely cold.
I'm not sure why, though - perhaps because it doesn't execute a write_begin()
stage during the write_one_page() call and thus doesn't go allocating disk
blocks to back the data, but instead allocates them later.

More surprising is that BTRFS performed significantly worse (15% increase in
time) in the case where the cache on disk was fully populated and then the
machine had been rebooted to clear the pagecaches.

It's important to note that I've only run each test once apiece, so the
numbers should be taken with a modicum of salt (bad statistics and all that).

David
---
===========================
FEW BIG FILES TEST ON BTRFS
===========================

Completely cold caches:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m2.124s
	user    0m0.000s
	sys     0m1.260s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m4.538s
	user    0m0.000s
	sys     0m2.624s

Warm NFS pagecache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m0.061s
	user    0m0.000s
	sys     0m0.064s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m0.118s
	user    0m0.000s
	sys     0m0.116s

Warm BTRFS pagecache, cold NFS pagecache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m0.189s
	user    0m0.000s
	sys     0m0.188s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m0.369s
	user    0m0.000s
	sys     0m0.368s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m1.540s
	user    0m0.000s
	sys     0m1.440s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m3.132s
	user    0m0.000s
	sys     0m1.724s


============================================
MANY SMALL/MEDIUM FILE READING TEST ON BTRFS
============================================

Completely cold caches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m31.838s
	user    0m0.192s
	sys     0m6.076s

Warm NFS pagecache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m14.841s
	user    0m0.148s
	sys     0m4.988s

Warm BTRFS pagecache, cold NFS pagecache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m16.773s
	user    0m0.148s
	sys     0m5.512s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    2m12.527s
	user    0m0.080s
	sys     0m2.908s

