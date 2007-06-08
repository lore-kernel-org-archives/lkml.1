Return-Path: <linux-kernel-owner+w=401wt.eu-S939500AbXFHXzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939500AbXFHXzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 19:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXFHXza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 19:55:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbXFHXz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 19:55:29 -0400
Date: Fri, 8 Jun 2007 16:55:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Albert Cahalan <acahalan@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH] shm: Fix the filename of hugetlb sysv shared memory
Message-Id: <20070608165505.aa15fcdb.akpm@linux-foundation.org>
In-Reply-To: <m1vedyqaft.fsf_-_@ebiederm.dsl.xmission.com>
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
	<20070606204432.b670a7b1.akpm@linux-foundation.org>
	<787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com>
	<20070607162004.GA27802@vino.hallyn.com>
	<m1ir9zrtwe.fsf@ebiederm.dsl.xmission.com>
	<46697EDA.9000209@us.ibm.com>
	<m1vedyqaft.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 17:43:34 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Some user space tools need to identify SYSV shared memory when
> examining /proc/<pid>/maps.  To do so they look for a block device
> with major zero, a dentry named SYSV<sysv key>, and having the minor of
> the internal sysv shared memory kernel mount.
> 
> To help these tools and to make it easier for people just browsing
> /proc/<pid>/maps this patch modifies hugetlb sysv shared memory to
> use the SYSV<key> dentry naming convention.
> 
> User space tools will still have to be aware that hugetlb sysv
> shared memory lives on a different internal kernel mount and so
> has a different block device minor number from the rest of sysv
> shared memory.

I assume this fix is preferred over Badari's?  If so, why?



From: Badari Pulavarty <pbadari@us.ibm.com>

shmid used to be stored as inode# for shared memory segments. Some of
the proc-ps tools use this from /proc/pid/maps.  Recent cleanups
to newseg() changed it.  This patch sets inode number back to shared
memory id to fix breakage.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: "Albert Cahalan" <acahalan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN ipc/shm.c~restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage ipc/shm.c
--- a/ipc/shm.c~restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage
+++ a/ipc/shm.c
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
_

