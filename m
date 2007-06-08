Return-Path: <linux-kernel-owner+w=401wt.eu-S971325AbXFHWbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971325AbXFHWbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032333AbXFHWaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:30:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57131 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032318AbXFHWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:30:12 -0400
Subject: [PATCH] Restore shmid as inode# to fix /proc/pid/maps ABI breakage
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Cahalan <acahalan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       torvalds@linux-foundation.org
In-Reply-To: <787b0d920706072351s6917ad77oe0bf381a5d5817d0@mail.gmail.com>
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
	 <20070606204432.b670a7b1.akpm@linux-foundation.org>
	 <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com>
	 <20070607162004.GA27802@vino.hallyn.com>
	 <m1ir9zrtwe.fsf@ebiederm.dsl.xmission.com>
	 <787b0d920706072141s5a34ecb3n97007ad857ba4dc9@mail.gmail.com>
	 <m1ejknrnva.fsf@ebiederm.dsl.xmission.com>
	 <787b0d920706072351s6917ad77oe0bf381a5d5817d0@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 15:31:14 -0700
Message-Id: <1181341874.14441.3.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Can you include this in -mm ?

Thanks,
Badari

shmid used to be stored as inode# for shared memory segments. Some of
the proc-ps tools use this from /proc/pid/maps.  Recent cleanups
to newseg() changed it.  This patch sets inode number back to shared 
memory id to fix breakage.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

Index: linux-2.6.22-rc4/ipc/shm.c
===================================================================
--- linux-2.6.22-rc4.orig/ipc/shm.c	2007-06-08 15:17:20.000000000 -0700
+++ linux-2.6.22-rc4/ipc/shm.c	2007-06-08 15:19:38.000000000 -0700
@@ -397,6 +397,11 @@ static int newseg (struct ipc_namespace 
 	shp->shm_nattch = 0;
 	shp->id = shm_buildid(ns, id, shp->shm_perm.seq);
 	shp->shm_file = file;
+	/*
+	 * shmid gets reported as "inode#" in /proc/pid/maps.
+	 * proc-ps tools use this. Changing this will break them.
+	 */
+	file->f_dentry->d_inode->i_ino = shp->id;
 
 	ns->shm_tot += numpages;
 	shm_unlock(shp);


