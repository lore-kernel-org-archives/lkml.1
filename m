Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYDVVgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYDVVgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYDVVgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:36:39 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:3589 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbYDVVgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=onac6/iW9Wiy94OcFuqHlU9+gQ6rCbF4PJnwoVCg3wKB0+OU1NJUoKz1/zr35Hwx7tMKkgTGEdGfYBzL7oDRA55BKGfc/g/QhIxCma2f6rzakl8voJWdMlD7q022FNVEPSckJSPwa3VOl3R333e5AEcjQWDRjk6974QSvzvux2E=
Date: Wed, 23 Apr 2008 02:31:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SHM: tweak /proc/sysvipc/shm banner
Message-ID: <20080422223149.GA4845@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"size" field and everything after in banner isn't aligned properly on 64-bit archs.

Before:
       key      shmid perms       size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime
         0          0     0               4194304  4749     0      0  1000  1000  1000  1000          0          0 1208902917

After:
       key      shmid perms                  size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime
         0          0     0               4194304  4745     0      0  1000  1000  1000  1000          0          0 1208902637

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 ipc/shm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -106,9 +106,14 @@ void shm_exit_ns(struct ipc_namespace *ns)
 
 void __init shm_init (void)
 {
+	char *banner;
+
 	shm_init_ns(&init_ipc_ns);
-	ipc_init_proc_interface("sysvipc/shm",
-				"       key      shmid perms       size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime\n",
+	if (sizeof(size_t) <= sizeof(int))
+		banner = "       key      shmid perms       size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime\n";
+	else
+		banner = "       key      shmid perms                  size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime\n";
+	ipc_init_proc_interface("sysvipc/shm", banner,
 				IPC_SHM_IDS, sysvipc_shm_proc_show);
 }
 

