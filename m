Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZITS2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZITS2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbZITS2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:28:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60487 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbZITS2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:28:20 -0400
Date: Sun, 20 Sep 2009 14:28:03 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: David Howells <dhowells@redhat.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH] mn10300 linker script cleanup
Message-ID: <alpine.DEB.1.10.0909201414380.3101@dr-wily.mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I noticed that you already converted to mn10300 architecture to use some 
of the new macros in vmlinux.lds.h.  It seems to me that one could clean 
things up further by using some of the higher-level macros 
(RW_DATA_SECTION, INIT_TEXT_SECTION, INIT_DATA_SECTION).  Patch below.

	Best regards,
	-Tim Abbott

mn10300: Clean up linker script using higher-level macros.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/mn10300/kernel/vmlinux.lds.S |   40 +++---------------------------------
 1 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 76f41bd..10549dc 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -44,24 +44,8 @@ SECTIONS
   RO_DATA(PAGE_SIZE)
 
   /* writeable */
-  .data : {			/* Data */
-	DATA_DATA
-	CONSTRUCTORS
-	}
-
-  .data_nosave : { NOSAVE_DATA; }
-
-  .data.page_aligned : { PAGE_ALIGNED_DATA(PAGE_SIZE); }
-  .data.cacheline_aligned : { CACHELINE_ALIGNED_DATA(32); }
-
-  /* rarely changed data like cpu maps */
-  . = ALIGN(32);
-  .data.read_mostly : AT(ADDR(.data.read_mostly)) {
-	READ_MOSTLY_DATA(32);
-	_edata = .;		/* End of data section */
-  }
-
-  .data.init_task : { INIT_TASK_DATA(THREAD_SIZE); }
+  RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
+  _edata = .;
 
   /* might get freed after init */
   . = ALIGN(PAGE_SIZE);
@@ -74,22 +58,8 @@ SECTIONS
   /* will be freed after init */
   . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
-  .init.text : {
-	_sinittext = .;
-	INIT_TEXT;
-	_einittext = .;
-  }
-  .init.data : { INIT_DATA; }
-  .setup.init : { INIT_SETUP(16); }
-
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
-  }
-  __initcall_end = .;
-  .con_initcall.init : { CON_INITCALL; }
-
-  SECURITY_INIT
+  INIT_TEXT_SECTION(PAGE_SIZE)
+  INIT_DATA_SECTION(16)
   . = ALIGN(4);
   __alt_instructions = .;
   .altinstructions : { *(.altinstructions) }
@@ -100,8 +70,6 @@ SECTIONS
 	.exit.text : { EXIT_TEXT; }
 	.exit.data : { EXIT_DATA; }
 
-  .init.ramfs : { INIT_RAM_FS; }
-
   PERCPU(32)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
-- 
1.6.3.3

