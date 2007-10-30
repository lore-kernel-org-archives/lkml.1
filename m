Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbXJ3LBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbXJ3LBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXJ3LBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:01:14 -0400
Received: from partizan.velesys.com ([213.184.230.195]:52112 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbXJ3LBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:01:12 -0400
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>
Subject: [PATCH 1/4] Unexport asm/page.h
Date: Tue, 30 Oct 2007 13:02:16 +0200
Message-Id: <1193742139-29738-2-git-send-email-k.shutemov@gmail.com>
X-Mailer: git-send-email 1.5.3.4.GIT
In-Reply-To: <1193742139-29738-1-git-send-email-k.shutemov@gmail.com>
References: <1193742139-29738-1-git-send-email-k.shutemov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not export asm/page.h during make headers_install.
This removes PAGE_SIZE from userspace headers.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
---
 include/asm-frv/Kbuild         |    1 -
 include/asm-generic/Kbuild.asm |    1 -
 include/asm-s390/kexec.h       |    2 ++
 include/asm-x86/Kbuild         |    2 --
 include/linux/Kbuild           |    2 +-
 include/linux/a.out.h          |    8 ++++++++
 include/linux/shm.h            |    8 ++++++++
 7 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/asm-frv/Kbuild b/include/asm-frv/Kbuild
index 966a983..bc3f12c 100644
--- a/include/asm-frv/Kbuild
+++ b/include/asm-frv/Kbuild
@@ -4,4 +4,3 @@ header-y += registers.h
 
 unifdef-y += termios.h
 unifdef-y += ptrace.h
-unifdef-y += page.h
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 8fd8171..a10583a 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -31,4 +31,3 @@ unifdef-y += user.h
 
 # These probably shouldn't be exported
 unifdef-y += elf.h
-unifdef-y += page.h
diff --git a/include/asm-s390/kexec.h b/include/asm-s390/kexec.h
index 7592af7..f219c64 100644
--- a/include/asm-s390/kexec.h
+++ b/include/asm-s390/kexec.h
@@ -10,7 +10,9 @@
 #ifndef _S390_KEXEC_H
 #define _S390_KEXEC_H
 
+#ifdef __KERNEL__
 #include <asm/page.h>
+#endif
 #include <asm/processor.h>
 /*
  * KEXEC_SOURCE_MEMORY_LIMIT maximum page get_free_page can return.
diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
index 12db5a1..828f9f8 100644
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -16,8 +16,6 @@ unifdef-y += ist.h
 unifdef-y += mce.h
 unifdef-y += msr.h
 unifdef-y += mtrr.h
-unifdef-y += page_32.h
-unifdef-y += page_64.h
 unifdef-y += posix_types_32.h
 unifdef-y += posix_types_64.h
 unifdef-y += ptrace.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 6a65231..e41809b 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -17,7 +17,6 @@ header-y += usb/
 
 header-y += affs_hardblocks.h
 header-y += aio_abi.h
-header-y += a.out.h
 header-y += arcfb.h
 header-y += atmapi.h
 header-y += atmbr2684.h
@@ -163,6 +162,7 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
+unifdef-y += a.out.h
 unifdef-y += apm_bios.h
 unifdef-y += atalk.h
 unifdef-y += atmarp.h
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index f913cc3..82cd918 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -128,12 +128,20 @@ enum machine_type {
 #endif
 
 #ifdef linux
+#ifdef __KERNEL__
 #include <asm/page.h>
+#else
+#include <unistd.h>
+#endif
 #if defined(__i386__) || defined(__mc68000__)
 #define SEGMENT_SIZE	1024
 #else
 #ifndef SEGMENT_SIZE
+#ifdef __KERNEL__
 #define SEGMENT_SIZE	PAGE_SIZE
+#else
+#define SEGMENT_SIZE   getpagesize()
+#endif
 #endif
 #endif
 #endif
diff --git a/include/linux/shm.h b/include/linux/shm.h
index eeaed92..eca6235 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -3,7 +3,11 @@
 
 #include <linux/ipc.h>
 #include <linux/errno.h>
+#ifdef __KERNEL__
 #include <asm/page.h>
+#else
+#include <unistd.h>
+#endif
 
 /*
  * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
@@ -13,7 +17,11 @@
 #define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
+#ifdef __KERNEL__
 #define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
+#else
+#define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
+#endif
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
 #ifdef __KERNEL__
-- 
1.5.3.4.GIT

