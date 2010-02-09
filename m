Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0BIKVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:21:10 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:35798 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0BIKVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:21:08 -0500
Date: Tue, 9 Feb 2010 11:21:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 4/6] tracing: add tracing support for compat syscalls
Message-ID: <20100209102100.GA23838@osiris.boeblingen.de.ibm.com>
References: <cover.1265142153.git.jbaron@redhat.com>
 <bec426992cb9ab8f8abe07efb2baa785577a3855.1265142153.git.jbaron@redhat.com>
 <20100203125251.GA30003@osiris.boeblingen.de.ibm.com>
 <20100208154325.GB2688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208154325.GB2688@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 10:43:25AM -0500, Jason Baron wrote:
> On Wed, Feb 03, 2010 at 01:52:51PM +0100, Heiko Carstens wrote:
> > In order to avoid the whole ifdef mess some s390 files do include
> > asm/compat.h instead of linux/compat.h. This will get messy :)
> 
> is there a way for s390 to use the common include/linux/compat.h file?
> what other arch defs are required? 

The patch below is the smallest solution so that s390 still compiles
and probably even works:

Subject: [PATCH] compat: have generic is_compat_task for !CONFIG_COMPAT

From: Heiko Carstens <heiko.carstens@de.ibm.com>

..instead of an arch specific one.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/compat.h  |    7 -------
 arch/s390/kernel/ptrace.c       |    2 +-
 arch/s390/kernel/setup.c        |    2 +-
 arch/s390/mm/mmap.c             |    2 +-
 drivers/s390/block/dasd_eckd.c  |    2 +-
 drivers/s390/block/dasd_ioctl.c |    1 +
 drivers/s390/char/fs3270.c      |    1 +
 drivers/s390/char/vmcp.c        |    1 +
 drivers/s390/cio/chsc_sch.c     |    1 +
 drivers/s390/scsi/zfcp_cfdc.c   |    1 +
 include/linux/compat.h          |    7 +++++++
 11 files changed, 16 insertions(+), 11 deletions(-)

--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -171,13 +171,6 @@ static inline int is_compat_task(void)
 	return test_thread_flag(TIF_31BIT);
 }
 
-#else
-
-static inline int is_compat_task(void)
-{
-	return 0;
-}
-
 #endif
 
 static inline void __user *compat_alloc_user_space(long len)
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -36,8 +36,8 @@
 #include <linux/regset.h>
 #include <linux/tracehook.h>
 #include <linux/seccomp.h>
+#include <linux/compat.h>
 #include <trace/syscall.h>
-#include <asm/compat.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -43,7 +43,7 @@
 #include <linux/reboot.h>
 #include <linux/topology.h>
 #include <linux/ftrace.h>
-
+#include <linux/compat.h>
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,8 +27,8 @@
 #include <linux/personality.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 #include <asm/pgalloc.h>
-#include <asm/compat.h>
 
 /*
  * Top of mmap area (just below the process stack).
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -14,6 +14,7 @@
 
 #include <linux/stddef.h>
 #include <linux/kernel.h>
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <linux/hdreg.h>	/* HDIO_GETGEO			    */
 #include <linux/bio.h>
@@ -23,7 +24,6 @@
 #include <asm/debug.h>
 #include <asm/idals.h>
 #include <asm/ebcdic.h>
-#include <asm/compat.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/cio.h>
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/blkpg.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
 #include <asm/cmb.h>
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 #include <asm/compat.h>
 #include <asm/cpcmd.h>
 #include <asm/debug.h>
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/miscdevice.h>
+#include <linux/compat.h>
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
 #include "zfcp_def.h"
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -353,5 +353,12 @@ asmlinkage long compat_sys_newfstatat(un
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 
+#else /* CONFIG_COMPAT */
+
+static inline int is_compat_task(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
