Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbXFSCl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbXFSCl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763486AbXFSCls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:41:48 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:64671 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763381AbXFSClr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:41:47 -0400
Subject: [PATCH RT] Don't call mcount from vsyscall_fn's
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Jun 2007 22:41:09 -0400
Message-Id: <1182220869.15228.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This bit me in the butt.

I couldn't understand why my init app was segfaulting, with a kernel
address, but a user RIP and RSP.  Well, the RIP I think was bogus, but
the kernel address was always the start of "mcount".  Looking deeper, I
printed out what was in the RSP (even though it was a user stack).  It
ended up showing me that the calling address was from the VDSO area.
Looking even further, I found the offending culprit, which was
vread_hpet.

Looking at the assembly dump, I saw the vread_hpet was calling mcount,
but I could not see it in the code. Nor could I see it in hpet.i (-E
option of compiling).

Well, I guess Ingo is a magician when it comes to compiler tricks, and
has the mcount being called by "every!!" function, unless you add the
"notrace" option.

This patch adds the notrace to vsyscall_fn, so that we don't have user
land apps calling mcount and crashing!

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-rt-test/include/asm-x86_64/vsyscall.h
===================================================================
--- linux-2.6-rt-test.orig/include/asm-x86_64/vsyscall.h
+++ linux-2.6-rt-test/include/asm-x86_64/vsyscall.h
@@ -22,7 +22,7 @@ enum vsyscall_num {
 /* Definitions for CONFIG_GENERIC_TIME definitions */
 #define __section_vsyscall_gtod_data __attribute__ \
 	((unused, __section__ (".vsyscall_gtod_data"),aligned(16)))
-#define __vsyscall_fn __attribute__ ((unused,__section__(".vsyscall_fn")))
+#define __vsyscall_fn __attribute__ ((unused,__section__(".vsyscall_fn"))) notrace
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2


