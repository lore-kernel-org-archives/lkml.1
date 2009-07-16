Return-Path: <linux-kernel-owner+w=401wt.eu-S933542AbZGPW7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbZGPW7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933526AbZGPW7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:59:17 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54237 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933511AbZGPW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:59:16 -0400
Date: Thu, 16 Jul 2009 18:58:50 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Paul Mundt <lethal@linux-sh.org>, Sam Ravnborg <sam@ravnborg.org>
cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
In-Reply-To: <alpine.DEB.1.10.0907161636090.6798@vinegar-pot.mit.edu>
Message-ID: <alpine.DEB.1.10.0907161841210.6798@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu> <20090716203432.GB6096@merkur.ravnborg.org> <alpine.DEB.1.10.0907161636090.6798@vinegar-pot.mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Tim Abbott wrote:

> On Thu, 16 Jul 2009, Sam Ravnborg wrote:
> 
> > On Sun, Jul 12, 2009 at 06:23:33PM -0400, Tim Abbott wrote:
> > > I'd like acks from Sam and David on this one.  Also CCing Paul, since
> > > he has a patch from me which will need to be updated to use
> > > BSS_SECTION(0, PAGE_SIZE, 4) once this gets merged.
[...]
> > Could you please resend including the necessary fix for mn10300 so we do not
> > break bisecting.
> 
> I don't understand what you're asking here.  The original patch I sent 
> does include the necessary fix for mn10300 in the first hunk (reproduced 
> below).  I intentionally changed the mn10300 use at the same time as 
> changing the macros in order to avoid breaking bisecting.

I realized that you probably meant that I should resend the sh patch that 
I have currently in linux-next via Paul's tree that is broken by this 
change.

Paul -- the patch below differs from the version have in two ways:
(1) I updated it to use the fixed BSS linker script macros from this 
thread.
(2) I dropped the hunk that conflicted with a similar change in the percpu 
tree[2], as the version of that change in the percpu tree is better.

[1] http://www.spinics.net/lists/kernel/msg913238.html
[2] http://www.spinics.net/lists/kernel/msg913304.html

	-Tim Abbott

sh: Clean up linker script using new linker script macros.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/vmlinux.lds.S |   84 ++++-------------------------------------
 1 files changed, 9 insertions(+), 75 deletions(-)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index f53c76a..396d8ee 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -50,12 +50,7 @@ SECTIONS
 		_etext = .;		/* End of text section */
 	} = 0x0009
 
-	. = ALIGN(16);		/* Exception table */
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(16)
 
 	NOTES
 	RO_DATA(PAGE_SIZE)
@@ -71,69 +66,14 @@ SECTIONS
 		__uncached_end = .;
 	}
 
-	. = ALIGN(THREAD_SIZE);
-	.data : AT(ADDR(.data) - LOAD_OFFSET) {		/* Data */
-		*(.data.init_task)
-
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
-
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.read_mostly)
-
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
-
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-
-		DATA_DATA
-		CONSTRUCTORS
-	}
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
 
 	_edata = .;			/* End of data section */
 
 	. = ALIGN(PAGE_SIZE);		/* Init code and data */
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		__init_begin = .;
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
-
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { INIT_DATA }
-
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
-	}
-
-	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-
-	SECURITY_INIT
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
+	__init_begin = .;
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(16)
 
 	. = ALIGN(4);
 	.machvec.init : AT(ADDR(.machvec.init) - LOAD_OFFSET) {
@@ -152,16 +92,10 @@ SECTIONS
 	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { EXIT_DATA }
 
 	. = ALIGN(PAGE_SIZE);
-	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-		__init_end = .;
-		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
-		*(.bss)
-		*(COMMON)
-		. = ALIGN(4);
-		_ebss = .;			/* uClinux MTD sucks */
-		_end = . ;
-	}
+	__init_end = .;
+	BSS_SECTION(0, PAGE_SIZE, 4)
+	_ebss = .;			/* uClinux MTD sucks */
+	_end = . ;
 
 	/*
 	 * When something in the kernel is NOT compiled as a module, the
-- 
1.6.3.3

