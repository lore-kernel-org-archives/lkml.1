Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYBYXUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYBYXUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYBYXUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:20:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700AbYBYXUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:20:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802251401.16413.phillips@phunq.net>
References: <200802251401.16413.phillips@phunq.net> <28196.1203605703@redhat.com> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk> <17916.1203636833@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 25 Feb 2008 23:19:22 +0000
Message-ID: <22888.1203981562@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Daniel Phillips <phillips@phunq.net> wrote:

> This factor of four (even worse on XFS, not quite as bad on Ext3) is
> worth ruminating upon.  Is all of the difference explained by avoiding
> seeks on the server, which has the files in memory?

Here are some more stats for you to consider:

 (1) Copy the data across the network to a fresh Ext3 fs on the same partition
     I was using for the cache:

	[root@andromeda ~]# time cp -a /warthog/aaa /var/fscache
	real    0m39.052s
	user    0m0.368s
	sys     0m15.229s

 (2) Reboot and read back the files just written into Ext3 on the local disk:

	[root@andromeda ~]# time tar cf - /var/fscache/aaa >/dev/zero
	real    0m40.574s
	user    0m0.164s
	sys     0m3.512s

 (3) Run through the cache population process, and then run a tar directly on
     cachefiles's cache directly after a reboot:

	[root@andromeda ~]# time tar cf - /var/fscache/cache >/dev/zero
	real    4m53.104s
	user    0m0.192s
	sys     0m4.240s

So I guess there's a problem in cachefiles's efficiency - possibly due to the
fact that it tries to be fully asynchronous.

In case (1) this is very similar to the time for a read through a completely
cold cache (37.497s).

In case (2) this is comparable to cachefiles with a cache warmed prior to a
reboot (1m54.350s); in this case, however, cachefiles is doing some extra work:

 (a) It's doing a lookup on the server for each file, in addition to the
     lookups on the disk.  However, just doing a tar from plain NFS, the
     command completes in 22.330s.

 (b) It's reading an xattr per object for cache coherency management.

 (c) As the cache knows nothing of directories, files, etc., it lays its
     directory subtree out in a way that suits it.  File lookup keys are
     turned into filenames.  This may result in a less efficient arrangement
     in the cache than the original data, especially as directories may become
     very large, so Ext3 may be doing some extra work.

In case (3), this perhaps suggests that cachefiles's directory layout may be
part of the problem.  Running the following:

	ls -ldSr `find . -type d`

in /var/fscache/cache shows that the directories are either 4096 bytes in size
(158 instances) or 12288 bytes in size (105 instances), for a total of 263
directories.  There are 19255 files.

Running that ls command in /warthog/aaa shows 1185 directories, all but three
of them 4096 bytes in size; two are 12288 bytes and one is 20480 bytes in size
(include/linux/ unsurprisingly).  There are 19258 files, three of which are
hardlinks to other files in the tree.

> This could be easily tested by running a test against a server that is the
> same as the client, and does not have the files in memory.  If local access
> is still slower than network then there is a real issue with cache
> efficiency.

My server is also my desktop machine.  The only way to guarantee that the
memory is scrubbed is to reboot it:-(  I'll look at setting up one of my other
machines as an NFS server.

David
