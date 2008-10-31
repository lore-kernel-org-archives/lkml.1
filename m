Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYJaRkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYJaRkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYJaRju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:39:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:39400 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJaRjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DkhZ+FpZVRWsud+9Ti94/9kggHK3oGgEv30Q5irqZF2IUI6YJ7xNVTq5sCUm/Zw+nh
         FyWMVs4JOFisgNgD7/WdIHyqumVLWKBXWO4Wl2OJsInUWrVeZh+Gy1jF8lfKOQcx6bXw
         8K1+QmVp1mQ0HbON/YvkWgHgf+8B0DTtnTUD4=
Date: Fri, 31 Oct 2008 17:39:21 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: [Patch] ipc: clean up ipc/shm.c
Message-ID: <20081031173920.GF3235@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the macro shm_ids().

Remove useless check for a userspace pointer, because copy_to_user()
will check it.

Some style cleanups.

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/ipc/shm.c b/ipc/shm.c
index 867e5d6..612249d 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -75,7 +75,7 @@ void shm_init_ns(struct ipc_namespace *ns)
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
 	ns->shm_tot = 0;
-	ipc_init_ids(&ns->ids[IPC_SHM_IDS]);
+	ipc_init_ids(&shm_ids(ns));
 }
 
 /*
@@ -644,7 +644,7 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 		if (err)
 			return err;
 
-		memset(&shminfo,0,sizeof(shminfo));
+		memset(&shminfo, 0, sizeof(shminfo));
 		shminfo.shmmni = shminfo.shmseg = ns->shm_ctlmni;
 		shminfo.shmmax = ns->shm_ctlmax;
 		shminfo.shmall = ns->shm_ctlall;
@@ -669,7 +669,7 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 		if (err)
 			return err;
 
-		memset(&shm_info,0,sizeof(shm_info));
+		memset(&shm_info, 0, sizeof(shm_info));
 		down_read(&shm_ids(ns).rw_mutex);
 		shm_info.used_ids = shm_ids(ns).in_use;
 		shm_get_stat (ns, &shm_info.shm_rss, &shm_info.shm_swp);
@@ -678,7 +678,7 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 		shm_info.swap_successes = 0;
 		err = ipc_get_maxid(&shm_ids(ns));
 		up_read(&shm_ids(ns).rw_mutex);
-		if(copy_to_user (buf, &shm_info, sizeof(shm_info))) {
+		if (copy_to_user(buf, &shm_info, sizeof(shm_info))) {
 			err = -EFAULT;
 			goto out;
 		}
@@ -692,11 +692,6 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 		struct shmid64_ds tbuf;
 		int result;
 
-		if (!buf) {
-			err = -EFAULT;
-			goto out;
-		}
-
 		if (cmd == SHM_STAT) {
 			shp = shm_lock(ns, shmid);
 			if (IS_ERR(shp)) {
@@ -712,7 +707,7 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 			}
 			result = 0;
 		}
-		err=-EACCES;
+		err = -EACCES;
 		if (ipcperms (&shp->shm_perm, S_IRUGO))
 			goto out_unlock;
 		err = security_shm_shmctl(shp, cmd);

