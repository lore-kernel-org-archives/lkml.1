Return-Path: <linux-kernel-owner+w=401wt.eu-S934533AbXFFQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533AbXFFQRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbXFFQRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:17:42 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38571 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXFFQRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:17:41 -0400
Subject: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
From: Badari Pulavarty <pbadari@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 09:07:24 -0700
Message-Id: <1181146045.9503.67.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Your recent cleanup to shm code, namely

[PATCH] shm: make sysv ipc shared memory use stacked files

took away one of the debugging feature for shm segments.
Originally, shmid were forced to be the inode numbers and
they show up in /proc/pid/maps for the process which mapped
this shared memory segments (vma listing). That way, its easy
to find out who all mapped this shared memory segment. Your
patchset, took away the inode# setting. So, we can't easily
match the shmem segments to /proc/pid/maps easily. (It was
really useful in tracking down a customer problem recently). 
Is this done deliberately ? Anything wrong in setting this back ?

Comments ?

Thanks,
Badari

Without patch:
--------------

# ipcs -m

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status
0x00000000 884737     db2inst1  767        33554432   13

# grep 884737 /proc/*/maps
#

With patch:
-----------

# ipcs -m

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status
0x00000000 884737     db2inst1  767        33554432   13

# grep 884737 /proc/*/maps
/proc/11110/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11111/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11112/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11113/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11114/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11115/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11116/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11117/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11118/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11121/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11122/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11124/maps:4000389c000-4000589c000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)
/proc/11575/maps:40006724000-40008724000 rw-s 00000000 00:08 884737 /SYSV00000000 (deleted)



Here is the patch.

"ino#" in /proc/pid/maps used to match "ipcs -m" output for shared 
memory (shmid). It was useful in debugging, but its changed recently. 
This patch sets inode number to shared memory id to match /proc/pid/maps.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

Index: linux-2.6.22-rc4/ipc/shm.c
===================================================================
--- linux-2.6.22-rc4.orig/ipc/shm.c	2007-06-04 17:57:25.000000000 -0700
+++ linux-2.6.22-rc4/ipc/shm.c	2007-06-06 08:23:57.000000000 -0700
@@ -397,6 +397,7 @@ static int newseg (struct ipc_namespace 
 	shp->shm_nattch = 0;
 	shp->id = shm_buildid(ns, id, shp->shm_perm.seq);
 	shp->shm_file = file;
+	file->f_dentry->d_inode->i_ino = shp->id;
 
 	ns->shm_tot += numpages;
 	shm_unlock(shp);


