Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZASCrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZASCrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbZASCrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:47:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:56132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305AbZASCq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:46:58 -0500
Message-ID: <4973E99B.4070103@kernel.org>
Date: Mon, 19 Jan 2009 11:46:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] linker script: kill PERCPU_VADDR_PREALLOC()
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com> <1232326345-3534-1-git-send-email-brgerst@gmail.com> <1232326345-3534-2-git-send-email-brgerst@gmail.com> <1232326345-3534-3-git-send-email-brgerst@gmail.com> <1232326345-3534-4-git-send-email-brgerst@gmail.com> <1232326345-3534-5-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232326345-3534-5-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Jan 2009 02:46:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With .data.percpu.first in place, PERCPU_VADDR_PREALLOC() is no longer
necessary.  Kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |   45 ++++++--------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

Index: work/include/asm-generic/vmlinux.lds.h
===================================================================
--- work.orig/include/asm-generic/vmlinux.lds.h
+++ work/include/asm-generic/vmlinux.lds.h
@@ -430,22 +430,10 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
-#define PERCPU_PROLOG(vaddr)						\
-	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
-	.data.percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
-				- LOAD_OFFSET) {			\
-		VMLINUX_SYMBOL(__per_cpu_start) = .;
-
-#define PERCPU_EPILOG(phdr)						\
-		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
-	} phdr								\
-	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data.percpu);
-
 /**
- * PERCPU_VADDR_PREALLOC - define output section for percpu area with prealloc
+ * PERCPU_VADDR - define output section for percpu area
  * @vaddr: explicit base address (optional)
  * @phdr: destination PHDR (optional)
- * @prealloc: the size of prealloc area
  *
  * Macro which expands to output section for percpu area.  If @vaddr
  * is not blank, it specifies explicit base address and all percpu
@@ -457,40 +445,23 @@
  * section in the linker script will go there too.  @phdr should have
  * a leading colon.
  *
- * If @prealloc is non-zero, the specified number of bytes will be
- * reserved at the start of percpu area.  As the prealloc area is
- * likely to break alignment, this macro puts areas in increasing
- * alignment order.
- *
  * This macro defines three symbols, __per_cpu_load, __per_cpu_start
  * and __per_cpu_end.  The first one is the vaddr of loaded percpu
  * init data.  __per_cpu_start equals @vaddr and __per_cpu_end is the
  * end offset.
  */
-#define PERCPU_VADDR_PREALLOC(vaddr, segment, prealloc)			\
-	PERCPU_PROLOG(vaddr)						\
-		. += prealloc;						\
-		*(.data.percpu)						\
-		*(.data.percpu.shared_aligned)				\
-		*(.data.percpu.page_aligned)				\
-	PERCPU_EPILOG(segment)
-
-/**
- * PERCPU_VADDR - define output section for percpu area
- * @vaddr: explicit base address (optional)
- * @phdr: destination PHDR (optional)
- *
- * Macro which expands to output section for percpu area.  Mostly
- * identical to PERCPU_VADDR_PREALLOC(@vaddr, @phdr, 0) other than
- * using slighly different layout.
- */
 #define PERCPU_VADDR(vaddr, phdr)					\
-	PERCPU_PROLOG(vaddr)						\
+	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
+	.data.percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
+				- LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
 		*(.data.percpu.first)					\
 		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
-	PERCPU_EPILOG(phdr)
+		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+	} phdr								\
+	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data.percpu);
 
 /**
  * PERCPU - define output section for percpu area, simple version
