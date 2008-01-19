Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYASVUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYASVUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYASVUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:20:14 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49339 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYASVUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:20:12 -0500
Date: Sat, 19 Jan 2008 22:20:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: [updated PATCH] xen: fix section usage in xen-head.S and setup.c
Message-ID: <20080119212019.GB29070@uranus.ravnborg.org>
References: <200801181318.30009.toralf.foerster@gmx.de> <20080118122917.GH2559@hacking> <20080118124627.GA17918@uranus.ravnborg.org> <20080118125144.GI2559@hacking> <20080118132242.GA18183@uranus.ravnborg.org> <20080118161452.GJ2559@hacking> <20080119131743.GA26615@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080119131743.GA26615@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failing to specify "ax" in the pushsection caused ld to generate
an additional section for .init.text appending a number.

A side effect of this was a section mismatch warning because modpost
did not recognize a .init.text section named .init.text.1:
WARNING: vmlinux.o(.text.head+0x247): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')

Fix this by hardcoding the "ax" in the pushsection.
Thanks to Torlaf for reporting this.

Alan Modra provided the hint that made me able to
locate the root cause of this warning.
And Mike Frysinger told me how to properly fix it
using __INIT/__FINIT.

Fix following Section mismatch warning in addition:
WARNING: vmlinux.o(.text+0x14c8): Section mismatch: reference to .init.data:vsyscall_int80_start (between 'fiddle_vdso' and 'xen_setup_features')

fiddle_vdso was only used from a __init function - so declare it __init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Toralf Förster <toralf.foerster@gmx.de>
---

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index f84e772..5e24f67 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -59,7 +59,7 @@ static void xen_idle(void)
 /*
  * Set the bit indicating "nosegneg" library variants should be used.
  */
-static void fiddle_vdso(void)
+static void __init fiddle_vdso(void)
 {
 	extern u32 VDSO_NOTE_MASK; /* See ../kernel/vsyscall-note.S.  */
 	extern char vsyscall_int80_start;
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index f8d6937..288d587 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -4,16 +4,18 @@
 #ifdef CONFIG_XEN
 
 #include <linux/elfnote.h>
+#include <linux/init.h>
 #include <asm/boot.h>
 #include <xen/interface/elfnote.h>
 
-.pushsection .init.text
+	__INIT
 ENTRY(startup_xen)
 	movl %esi,xen_start_info
 	cld
 	movl $(init_thread_union+THREAD_SIZE),%esp
 	jmp xen_start_kernel
-.popsection
+
+	__FINIT
 
 .pushsection .bss.page_aligned
 	.align PAGE_SIZE_asm
