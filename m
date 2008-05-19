Return-Path: <linux-kernel-owner+w=401wt.eu-S1763548AbYESV56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763548AbYESV56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbYESV52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:57:28 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42036 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763677AbYESV5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:57:25 -0400
Date: Tue, 20 May 2008 00:55:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: coda@cs.cmu.edu
Cc: codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] remove CODA_FS_OLD_API
Message-ID: <20080519215518.GL17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fixing CONFIG_ leakages to the userspace kernel headers I ran into 
CODA_FS_OLD_API.

After five years, are there still people using the old API left?
Especially considering that you have to choose at compile time which API 
to support in the kernel (and distributions tend to offer the new API 
for some time).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/Kconfig           |   14 --------------
 fs/coda/coda_linux.c |    6 ++----
 fs/coda/psdev.c      |    4 ----
 fs/coda/upcall.c     |   15 +--------------
 include/linux/coda.h |   43 -------------------------------------------
 5 files changed, 3 insertions(+), 79 deletions(-)

b4f57f48c803fe6d5373546ab477f39ef0fd75ee diff --git a/fs/Kconfig b/fs/Kconfig
index ab21a4c..86439a9 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -2048,20 +2048,6 @@ config CODA_FS
 	  To compile the coda client support as a module, choose M here: the
 	  module will be called coda.
 
-config CODA_FS_OLD_API
-	bool "Use 96-bit Coda file identifiers"
-	depends on CODA_FS
-	help
-	  A new kernel-userspace API had to be introduced for Coda v6.0
-	  to support larger 128-bit file identifiers as needed by the
-	  new realms implementation.
-
-	  However this new API is not backward compatible with older
-	  clients. If you really need to run the old Coda userspace
-	  cache manager then say Y.
-
-	  For most cases you probably want to say N.
-
 config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
diff --git a/fs/coda/coda_linux.c b/fs/coda/coda_linux.c
index e1c8548..bf4a3fd 100644
--- a/fs/coda/coda_linux.c
+++ b/fs/coda/coda_linux.c
@@ -28,11 +28,9 @@ int coda_fake_statfs;
 char * coda_f2s(struct CodaFid *f)
 {
 	static char s[60];
-#ifdef CONFIG_CODA_FS_OLD_API
- 	sprintf(s, "(%08x.%08x.%08x)", f->opaque[0], f->opaque[1], f->opaque[2]);
-#else
+
  	sprintf(s, "(%08x.%08x.%08x.%08x)", f->opaque[0], f->opaque[1], f->opaque[2], f->opaque[3]);
-#endif
+
 	return s;
 }
 
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index e3eb355..14474f5 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -377,11 +377,7 @@ MODULE_AUTHOR("Jan Harkes, Peter J. Braam");
 MODULE_DESCRIPTION("Coda Distributed File System VFS interface");
 MODULE_ALIAS_CHARDEV_MAJOR(CODA_PSDEV_MAJOR);
 MODULE_LICENSE("GPL");
-#ifdef CONFIG_CODA_FS_OLD_API
-MODULE_VERSION("5.3.21");
-#else
 MODULE_VERSION("6.6");
-#endif
 
 static int __init init_coda(void)
 {
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 359e531..ce432bc 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -52,12 +52,8 @@ static void *alloc_upcall(int opcode, int size)
         inp->ih.opcode = opcode;
 	inp->ih.pid = current->pid;
 	inp->ih.pgid = task_pgrp_nr(current);
-#ifdef CONFIG_CODA_FS_OLD_API
-	memset(&inp->ih.cred, 0, sizeof(struct coda_cred));
-	inp->ih.cred.cr_fsuid = current->fsuid;
-#else
 	inp->ih.uid = current->fsuid;
-#endif
+
 	return (void*)inp;
 }
 
@@ -166,20 +162,11 @@ int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
 	union inputArgs *inp;
 	union outputArgs *outp;
 	int insize, outsize, error;
-#ifdef CONFIG_CODA_FS_OLD_API
-	struct coda_cred cred = { 0, };
-	cred.cr_fsuid = uid;
-#endif
 	
 	insize = SIZE(release);
 	UPARG(CODA_CLOSE);
 	
-#ifdef CONFIG_CODA_FS_OLD_API
-	memcpy(&(inp->ih.cred), &cred, sizeof(cred));
-#else
 	inp->ih.uid = uid;
-#endif
-	
         inp->coda_close.VFid = *fid;
         inp->coda_close.flags = flags;
 
diff --git a/include/linux/coda.h b/include/linux/coda.h
index b5cf078..96c8769 100644
--- a/include/linux/coda.h
+++ b/include/linux/coda.h
@@ -199,28 +199,6 @@ typedef u_int32_t vuid_t;
 typedef u_int32_t vgid_t;
 #endif /*_VUID_T_ */
 
-#ifdef CONFIG_CODA_FS_OLD_API
-struct CodaFid {
-	u_int32_t opaque[3];
-};
-
-static __inline__ ino_t  coda_f2i(struct CodaFid *fid)
-{
-	if ( ! fid ) 
-		return 0; 
-	if (fid->opaque[1] == 0xfffffffe || fid->opaque[1] == 0xffffffff)
-		return ((fid->opaque[0] << 20) | (fid->opaque[2] & 0xfffff));
-	else
-		return (fid->opaque[2] + (fid->opaque[1]<<10) + (fid->opaque[0]<<20));
-}
-
-struct coda_cred {
-    vuid_t cr_uid, cr_euid, cr_suid, cr_fsuid; /* Real, efftve, set, fs uid*/
-    vgid_t cr_groupid, cr_egid, cr_sgid, cr_fsgid; /* same for groups */
-};
-
-#else /* not defined(CONFIG_CODA_FS_OLD_API) */
-
 struct CodaFid {
 	u_int32_t opaque[4];
 };
@@ -228,8 +206,6 @@ struct CodaFid {
 #define coda_f2i(fid)\
 	(fid ? (fid->opaque[3] ^ (fid->opaque[2]<<10) ^ (fid->opaque[1]<<20) ^ fid->opaque[0]) : 0)
 
-#endif
-
 #ifndef _VENUS_VATTR_T_
 #define _VENUS_VATTR_T_
 /*
@@ -313,15 +289,7 @@ struct coda_statfs {
 
 #define CIOC_KERNEL_VERSION _IOWR('c', 10, size_t)
 
-#if 0
-#define CODA_KERNEL_VERSION 0 /* don't care about kernel version number */
-#define CODA_KERNEL_VERSION 1 /* The old venus 4.6 compatible interface */
-#endif
-#ifdef CONFIG_CODA_FS_OLD_API
-#define CODA_KERNEL_VERSION 2 /* venus_lookup got an extra parameter */
-#else
 #define CODA_KERNEL_VERSION 3 /* 128-bit file identifiers */
-#endif
 
 /*
  *        Venus <-> Coda  RPC arguments
@@ -329,16 +297,9 @@ struct coda_statfs {
 struct coda_in_hdr {
     u_int32_t opcode;
     u_int32_t unique;	    /* Keep multiple outstanding msgs distinct */
-#ifdef CONFIG_CODA_FS_OLD_API
-    u_int16_t pid;	    /* Common to all */
-    u_int16_t pgid;	    /* Common to all */
-    u_int16_t sid;          /* Common to all */
-    struct coda_cred cred;  /* Common to all */
-#else
     pid_t pid;
     pid_t pgid;
     vuid_t uid;
-#endif
 };
 
 /* Really important that opcode and unique are 1st two fields! */
@@ -613,11 +574,7 @@ struct coda_vget_out {
 /* CODA_PURGEUSER is a venus->kernel call */
 struct coda_purgeuser_out {
     struct coda_out_hdr oh;
-#ifdef CONFIG_CODA_FS_OLD_API
-    struct coda_cred cred;
-#else
     vuid_t uid;
-#endif
 };
 
 /* coda_zapfile: */

