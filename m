Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbZFVOcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbZFVOcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZFVOci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:32:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53453 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbZFVOch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:32:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MN10300: Fix the vmlinux ldscript
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Mon, 22 Jun 2009 15:32:36 +0100
Message-ID: <20090622143236.3927.29414.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090622143231.3927.1495.stgit@warthog.procyon.org.uk>
References: <20090622143231.3927.1495.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the MN10300 vmlinux ldscript.  It needs to use various macros from
asm-generic/vmlinux.lds.h to correctly include all that it needs to.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/vmlinux.lds.S |   60 ++++++++++---------------------------
 1 files changed, 16 insertions(+), 44 deletions(-)


diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 24de6b9..bcebcef 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -38,14 +38,10 @@ SECTIONS
 
   _etext = .;			/* End of text section */
 
-  . = ALIGN(16);		/* Exception table */
-  __start___ex_table = .;
-  __ex_table : { *(__ex_table) }
-  __stop___ex_table = .;
-
+  EXCEPTION_TABLE(16)
   BUG_TABLE
 
-  RODATA
+  RO_DATA(PAGE_SIZE)
 
   /* writeable */
   .data : {			/* Data */
@@ -53,27 +49,19 @@ SECTIONS
 	CONSTRUCTORS
 	}
 
-  . = ALIGN(PAGE_SIZE);
-  __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
-  . = ALIGN(PAGE_SIZE);
-  __nosave_end = .;
-
-  . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : { *(.data.idt) }
+  .data_nosave : { NOSAVE_DATA; }
 
-  . = ALIGN(32);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .data.page_aligned : { PAGE_ALIGNED_DATA(PAGE_SIZE); }
+  .data.cacheline_aligned : { CACHELINE_ALIGNED_DATA(32); }
 
   /* rarely changed data like cpu maps */
   . = ALIGN(32);
   .data.read_mostly : AT(ADDR(.data.read_mostly)) {
-	*(.data.read_mostly)
+	READ_MOSTLY_DATA(32);
 	_edata = .;		/* End of data section */
   }
 
-  . = ALIGN(THREAD_SIZE);	/* init_task */
-  .data.init_task : { *(.data.init_task) }
+  .data.init_task : { INIT_TASK(THREAD_SIZE); }
 
   /* might get freed after init */
   . = ALIGN(PAGE_SIZE);
@@ -88,23 +76,18 @@ SECTIONS
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
-	*(.init.text)
+	INIT_TEXT;
 	_einittext = .;
   }
-  .init.data : { *(.init.data) }
-  . = ALIGN(16);
-  __setup_start = .;
-  .setup.init : { KEEP(*(.init.setup)) }
-  __setup_end = .;
+  .init.data : { INIT_DATA; }
+  .setup.init : { INIT_SETUP(16); }
 
   __initcall_start = .;
   .initcall.init : {
 	INITCALLS
   }
   __initcall_end = .;
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
+  .con_initcall.init : { CON_INITCALL; }
 
   SECURITY_INIT
   . = ALIGN(4);
@@ -114,28 +97,17 @@ SECTIONS
  .altinstr_replacement : { *(.altinstr_replacement) }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
-  .exit.text : { *(.exit.text) }
-  .exit.data : { *(.exit.data) }
+	.exit.text : { EXIT_TEXT; }
+	.exit.data : { EXIT_DATA; }
 
-#ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(PAGE_SIZE);
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
-#endif
+  .init.ramfs : { INIT_RAM_FS; }
 
   PERCPU(32)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
 
-  __bss_start = .;		/* BSS */
-  .bss : {
-	*(.bss.page_aligned)
-	*(.bss)
-  }
-  . = ALIGN(4);
-  __bss_stop = .;
+  BSS(4)
 
   _end = . ;
 
@@ -145,7 +117,7 @@ SECTIONS
 
   /* Sections to be discarded */
   /DISCARD/ : {
-	*(.exitcall.exit)
+	EXIT_CALL
 	}
 
   STABS_DEBUG

