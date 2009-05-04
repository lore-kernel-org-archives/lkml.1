Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZEDO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZEDO2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZEDO2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:28:23 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59820 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZEDO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:28:22 -0400
Date: Mon, 4 May 2009 16:30:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>
Subject: [PATCH/RFC] Sample conversion of powerpc
Message-ID: <20090504143032.GB8237@uranus.ravnborg.org>
References: <1241121253-32341-1-git-send-email-tabbott@mit.edu> <20090501213118.GA28126@uranus.ravnborg.org> <alpine.DEB.1.10.0905011916530.10966@vinegar-pot.mit.edu> <20090502220132.GA4130@uranus.ravnborg.org> <20090504142732.GA8237@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504142732.GA8237@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch to convert powerpc to the
new linker script setup.

Note that powerpc does not take benefit of all the consolidations.

	Sam

 arch/powerpc/kernel/vmlinux.lds.S |   53 +++++--------------------------------
 1 files changed, 7 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index a047a6c..e0fef43 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -75,14 +75,8 @@ SECTIONS
 	PROVIDE32 (etext = .);
 
 	/* Read-only data */
-	RODATA
-
-	/* Exception & bug tables */
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	RO_DATA_SECTION(PAGE_SIZE)
+	EXCEPTION_TABLE(1)
 
 	NOTES :kernel :notes
 
@@ -100,11 +94,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__init_begin = .;
 
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	} :kernel
+	INIT_TEXT_SECTION(PAGE_SIZE) :kernel
 
 	/* .exit.text is discarded at runtime, not link time,
 	 * to deal with references from __bug_table
@@ -113,8 +103,10 @@ SECTIONS
 		EXIT_TEXT
 	}
 
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-		INIT_DATA
+	INIT_DATA_SECTION(16)
+	PERCPU(PAGE_SIZE)
+
+	.init.data :  {
 		__vtop_table_begin = .;
 		*(.vtop_fixup);
 		__vtop_table_end = .;
@@ -128,27 +120,6 @@ SECTIONS
 #endif
 	}
 
-	. = ALIGN(16);
-	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-
-	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-		}
-
-	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-
-	SECURITY_INIT
-
 	. = ALIGN(8);
 	__ftr_fixup : AT(ADDR(__ftr_fixup) - LOAD_OFFSET) {
 		__start___ftr_fixup = .;
@@ -175,15 +146,6 @@ SECTIONS
 		__stop___fw_ftr_fixup = .;
 	}
 #endif
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
-	PERCPU(PAGE_SIZE)
 
 	. = ALIGN(8);
 	.machine.desc : AT(ADDR(.machine.desc) - LOAD_OFFSET) {
@@ -247,7 +209,6 @@ SECTIONS
 
 	. = ALIGN(PAGE_SIZE);
 	_edata  =  .;
-	PROVIDE32 (edata = .);
 
 	/* The initial task and kernel stack */
 #ifdef CONFIG_PPC32
