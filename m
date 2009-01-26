Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZAZNoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZAZNoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZAZNoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:44:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:13202 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZAZNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:44:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YYs5u140qVopR6z/akhx7/5Ni14le5sq6LUQ+3eQnIaVkNYnMRlkRORSuwGw17U86t
         GScH0rhArUJFPrO2za8TatNj2p3VPaSV9qo06sx0wr42Rgv3dMv3aP8Eal+FSuKS4dAp
         cD1pGcNZ2DF0VUjsBqkdHzD3J4UXGWOt5DaxA=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86-32: Fix __per_cpu_load relocation
Date: Mon, 26 Jan 2009 08:44:05 -0500
Message-Id: <1232977445-11815-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090126103243.GA31307@elte.hu>
References: <20090126103243.GA31307@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes this error:
WARNING: Absolute relocations present
Offset     Info     Type     Sym.Value Sym.Name
c0a4e07d 00e78001   R_386_32 c0ab0000  __per_cpu_load

Now, __per_cpu_load is a section-relative symbol:
c0aa4000 D __per_cpu_load
c0aa4000 A __per_cpu_load_abs

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 include/asm-generic/vmlinux.lds.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 53e21f3..f3180a8 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -451,17 +451,18 @@
  * end offset.
  */
 #define PERCPU_VADDR(vaddr, phdr)					\
-	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
-	.data.percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
+	VMLINUX_SYMBOL(__per_cpu_load_abs) = .;				\
+	.data.percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load_abs)	\
 				- LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
+		VMLINUX_SYMBOL(__per_cpu_load) = LOADADDR(.data.percpu) + LOAD_OFFSET;\
 		*(.data.percpu.first)					\
 		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	} phdr								\
-	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data.percpu);
+	. = VMLINUX_SYMBOL(__per_cpu_load_abs) + SIZEOF(.data.percpu);
 
 /**
  * PERCPU - define output section for percpu area, simple version
-- 
1.6.1

