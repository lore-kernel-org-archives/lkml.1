Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbYBUO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbYBUO4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 09:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYBUO4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 09:56:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYBUOz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:55:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802201907.40406.phillips@phunq.net>
References: <200802201907.40406.phillips@phunq.net> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 21 Feb 2008 14:55:03 +0000
Message-ID: <28196.1203605703@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> wrote:

> Have you got before/after benchmark results?

See attached.

These show a couple of things:

 (1) Dealing with lots of metadata slows things down a lot.  Note the result of
     looking and reading lots of small files with tar (the last result).  The
     NFS client has to both consult the NFS server *and* the cache.  Not only
     that, but any asynchronicity the cache may like to do is rendered
     ineffective by the fact tar wants to do a read on a file pretty much
     directly after opening it.

 (2) Getting metadata from the local disk fs is slower than pulling it across
     an unshared gigabit ethernet from a server that already has it in memory.

These points don't mean that fscache is no use, just that you have to consider
carefully whether it's of use to *you* given your particular situation, and
that depends on various factors.

Note that currently FS-Caching is disabled for individual NFS files opened for
writing as there's no way to handle the coherency problems thereby introduced.

David
---

			  ===========================
			  FS-CACHE FOR NFS BENCHMARKS
			  ===========================

 (*) The NFS client has a 1.86GHz Core2 Duo CPU and 1GB of RAM.

 (*) The NFS client has a Seagate ST380211AS 80GB 7200rpm SATA disk on an
     interface running in AHCI mode.  The chipset is an Intel G965.

 (*) A partition of approx 4.5GB is committed to caching, and is formatted as
     Ext3 with a blocksize of 4096 and directory indices.

 (*) The NFS client is using SELinux.

 (*) The NFS server is running an in-kernel NFSd, and has a 2.66GHz Core2 Duo
     CPU and 6GB of RAM.  The chipset is an Intel P965.

 (*) The NFS client is connected to the NFS server by Gigabit Ethernet.

 (*) The NFS mount is made with defaults for all options not relating to the
     cache:

	warthog:/warthog /warthog nfs
		rw,vers=3,rsize=1048576,wsize=1048576,hard,proto=tcp,timeo=600,
		retrans=2,sec=sys,fsc,addr=w.x.y.z 0 0


==================
FEW BIG FILES TEST
==================

Where:

 (*) The NFS server has two files:

	[root@andromeda ~]# ls -l /warthog/bigfile
	-rw-rw-r-- 1 4043 4043 104857600 2006-11-30 09:39 /warthog/bigfile
	[root@andromeda ~]# ls -l /warthog/biggerfile 
	-rw-rw-r-- 1 4043 4041 209715200 2006-03-21 13:56 /warthog/biggerfile

     Both of which are in memory on the server in all cases.


No patches, cold NFS cache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m1.909s
	user    0m0.000s
	sys     0m0.520s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m3.750s
	user    0m0.000s
	sys     0m0.904s

CONFIG_FSCACHE=n, cold NFS cache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m2.003s
	user    0m0.000s
	sys     0m0.124s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m4.100s
	user    0m0.004s
	sys     0m0.488s

Cold NFS cache, no disk cache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m2.084s
	user    0m0.000s
	sys     0m0.136s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m4.020s
	user    0m0.000s
	sys     0m0.720s

Completely cold caches:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m2.412s
	user    0m0.000s
	sys     0m0.892s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m4.449s
	user    0m0.000s
	sys     0m2.300s

Warm NFS pagecache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m0.067s
	user    0m0.000s
	sys     0m0.064s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m0.133s
	user    0m0.000s
	sys     0m0.136s

Warm Ext3 pagecache, cold NFS pagecache:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m0.173s
	user    0m0.000s
	sys     0m0.172s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m0.316s
	user    0m0.000s
	sys     0m0.316s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time cat /warthog/bigfile >/dev/null
	real    0m1.955s
	user    0m0.000s
	sys     0m0.244s
	[root@andromeda ~]# time cat /warthog/biggerfile >/dev/null
	real    0m3.596s
	user    0m0.000s
	sys     0m0.460s


===================================
MANY SMALL/MEDIUM FILE READING TEST
===================================

Where:

 (*) The NFS server has an old kernel tree:

	[root@andromeda ~]# du -s /warthog/aaa
	347340  /warthog/aaa
	[root@andromeda ~]# find /warthog/aaa | wc -l
	20443

     All of which is in memory on the server in all cases.


No patches, cold NFS cache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m21.698s
	user    0m0.156s
	sys     0m5.284s

CONFIG_FSCACHE=n, cold NFS cache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m22.337s
	user    0m0.152s
	sys     0m5.476s

Cold NFS cache, no disk cache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m22.734s
	user    0m0.124s
	sys     0m5.796s

Completely cold caches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m37.497s
	user    0m0.248s
	sys     0m6.648s

Warm NFS pagecache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    0m15.167s
	user    0m0.168s
	sys     0m4.856s

Warm Ext3 pagecache, cold NFS pagecache:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	tar: Removing leading `/' from member names
	tar: Removing leading `/' from hard link targets

	real    0m13.818s
	user    0m0.200s
	sys     0m5.492s

Warm on-disk cache, cold pagecaches:

	[root@andromeda ~]# time tar cf - /warthog/aaa >/dev/zero
	real    1m54.350s
	user    0m0.044s
	sys     0m1.256s
