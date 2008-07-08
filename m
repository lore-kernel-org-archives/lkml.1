Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbYGHMQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbYGHMQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759260AbYGHMNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:13:38 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27340 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759237AbYGHMNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:13:36 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 16/58] microblaze_v5: head.S + linker script
Date: Tue,  8 Jul 2008 13:59:16 +0200
Message-Id: <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/head.S        |   38 +++++++++
 arch/microblaze/kernel/vmlinux.lds.S |  142 ++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/head.S
 create mode 100644 arch/microblaze/kernel/vmlinux.lds.S

diff --git a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/head.S
new file mode 100644
index 0000000..8f87626
--- /dev/null
+++ b/arch/microblaze/kernel/head.S
@@ -0,0 +1,38 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+
+	.text
+ENTRY(_start)
+	mfs	r1, rmsr
+	andi	r1, r1, ~2
+	mts	rmsr, r1
+
+	/* Initialize small data anchors */
+	la	r13, r0, _KERNEL_SDA_BASE_
+	la	r2, r0, _KERNEL_SDA2_BASE_
+
+	/* Initialize stack pointer */
+	la	r1, r0, init_thread_union + THREAD_SIZE - 4
+
+	/* Initialize r31 with current task address */
+	la	r31, r0, init_task
+
+	/* Call platform dependent initialize function.
+	 * Please see $(ARCH)/mach-$(SUBARCH)/setup.c for
+	 * the function. */
+	la	r8, r0, machine_early_init
+	brald	r15, r8
+	nop
+
+	la	r15, r0, machine_halt
+	braid	start_kernel
+	nop
diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..5abd468
--- /dev/null
+++ b/arch/microblaze/kernel/vmlinux.lds.S
@@ -0,0 +1,142 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+OUTPUT_FORMAT("elf32-microblaze", "elf32-microblaze", "elf32-microblaze")
+OUTPUT_ARCH(microblaze)
+ENTRY(_start)
+
+#include <asm-generic/vmlinux.lds.h>
+
+jiffies = jiffies_64 + 4;
+
+SECTIONS {
+	. = CONFIG_KERNEL_BASE_ADDR;
+
+	.text : {
+		_text = . ;
+		_stext = . ;
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		. = ALIGN (4) ;
+		_etext = . ;
+	}
+
+	. = ALIGN(16);
+	RODATA
+
+	/* sdata2 section can go anywhere, but must be word aligned
+	 and SDA2_BASE must point to the middle of it */
+	.sdata2 : {
+		_ssrw = .;
+		. = ALIGN(0x8);
+		*(.sdata2)
+	. = ALIGN(8);
+	_essrw = .;
+	_ssrw_size = _essrw - _ssrw;
+	_KERNEL_SDA2_BASE_ = _ssrw + (_ssrw_size / 2);
+	}
+
+	_sdata = . ;
+	.data ALIGN (0x4) : {
+		DATA_DATA
+	}
+	. = ALIGN(32);
+	.data.cacheline_aligned : { *(.data.cacheline_aligned) }
+	_edata = . ;
+
+	/* The initial task */
+	. = ALIGN(8192);
+	.data.init_task : { *(.data.init_task) }
+
+	/* Under the microblaze ABI, .sdata and .sbss must be contiguous */
+	. = ALIGN(8);
+	.sdata : {
+		_ssro = .;
+		*(.sdata)
+	}
+
+	.sbss :	{
+		_ssbss = .;
+		*(.sbss)
+		_esbss = .;
+		_essro = .;
+		_ssro_size = _essro - _ssro ;
+		_KERNEL_SDA_BASE_ = _ssro + (_ssro_size / 2) ;
+	}
+
+	. = ALIGN(16);
+	__start___ex_table = .;
+	__ex_table : { *(__ex_table) }
+	__stop___ex_table = .;
+
+	__init_begin = .;
+
+	. = ALIGN(4096);
+	.init.text : {
+		_sinittext = . ;
+		*(.init.text)
+		*(.exit.text)
+		*(.exit.data)
+		_einittext = .;
+	}
+
+	.init.data : { *(.init.data) }
+
+	. = ALIGN(4);
+	.init.ivt : {
+		__ivt_start = .;
+		*(.init.ivt)
+		__ivt_end = .;
+	}
+
+	.init.setup : {
+		__setup_start = .;
+		*(.init.setup)
+		__setup_end = .;
+	}
+
+	.initcall.init : {
+		__initcall_start = .;
+		INITCALLS
+		__initcall_end = .;
+	}
+
+	.con_initcall.init : {
+		__con_initcall_start = .;
+		*(.con_initcall.init)
+		__con_initcall_end = .;
+	}
+
+	__init_end_before_initramfs = .;
+
+	.init.ramfs ALIGN(4096) : {
+		__initramfs_start = .;
+		*(.init.ramfs)
+		__initramfs_end = .;
+		. = ALIGN(4);
+		LONG(0);
+		. = ALIGN(4096);/* Pad init.ramfs up to page boundary, so
+				that __init_end == __bss_start. This will
+				make image.elf consistent with the image.bin */
+	}
+
+	__init_end = .;
+
+	.bss ALIGN (4096) : {
+		__bss_start = . ;
+			*(.bss*)
+			*(COMMON)
+		. = ALIGN (4) ;
+		__bss_stop = . ;
+		_ebss = . ;
+	}
+	. = ALIGN(4096);
+	_end = .;
+}
+
-- 
1.5.4.GIT

