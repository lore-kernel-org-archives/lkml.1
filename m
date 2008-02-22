Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbYBVQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbYBVQQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbYBVQQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:16:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbYBVQQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:16:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <17916.1203636833@redhat.com>
References: <17916.1203636833@redhat.com> <28196.1203605703@redhat.com> <200802201907.40406.phillips@phunq.net> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Daniel Phillips <phillips@phunq.net>,
       Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 22 Feb 2008 16:14:35 +0000
Message-ID: <19020.1203696875@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > > Have you got before/after benchmark results?
> > 
> > See attached.
> 
> Attached here are results using BTRFS (patched so that it'll work at all)
> rather than Ext3 on the client on the partition backing the cache.

And here are XFS results.

Tuning XFS makes a *really* big difference for the lots of small/medium files
being tarred case.  However, in general BTRFS is much better.

David
---


=========================
FEW BIG FILES TEST ON XFS
=========================

Completely cold caches:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m2.286s
	user    0m0.000s
	sys     0m1.828s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m4.228s
	user    0m0.000s
	sys     0m1.360s

Warm NFS pagecache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m0.058s
	user    0m0.000s
	sys     0m0.060s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m0.122s
	user    0m0.000s
	sys     0m0.120s

Warm XFS pagecache, cold NFS pagecache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m0.181s
	user    0m0.000s
	sys     0m0.180s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m1.034s
	user    0m0.000s
	sys     0m0.404s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m1.540s
	user    0m0.000s
	sys     0m0.256s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m3.003s
	user    0m0.000s
	sys     0m0.532s


==========================================
MANY SMALL/MEDIUM FILE READING TEST ON XFS
==========================================

Completely cold caches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    4m56.827s
	user    0m0.180s
	sys     0m6.668s

Warm NFS pagecache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m15.084s
	user    0m0.212s
	sys     0m5.008s

Warm XFS pagecache, cold NFS pagecache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m13.547s
	user    0m0.220s
	sys     0m5.652s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    4m36.316s
	user    0m0.148s
	sys     0m4.440s


=======================================================
MANY SMALL/MEDIUM FILE READING TEST ON AN OPTIMISED XFS
=======================================================

mkfs.xfs -d agcount=4 -l size=128m,version=2 /dev/sda6


Completely cold caches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    3m44.033s
	user    0m0.248s
	sys     0m6.632s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    3m8.582s
	user    0m0.108s
	sys     0m3.420s
