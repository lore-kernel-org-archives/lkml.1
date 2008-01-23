Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYAWLdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYAWLdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYAWLdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:33:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:40661 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYAWLc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:32:59 -0500
Date: Wed, 23 Jan 2008 12:33:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: Section Missmatch in current git
Message-ID: <20080123113308.GA20679@uranus.ravnborg.org>
References: <1201085533.12400.7.camel@Varda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1201085533.12400.7.camel@Varda>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 11:52:13AM +0100, Alejandro Riveira Fernández wrote:
> 
>  Just one more try
>  Ubuntu x86_64 gcc-4.2
> 
> WARNING: vmlinux.o(.text.head+0xe4): Section mismatch: reference to .init.data.2:trampoline_level4_pgt (between 'ident_complete' and 'secondary_startup_64')
> WARNING: vmlinux.o(.text.head+0xeb): Section mismatch: reference to .init.data.2:trampoline_level4_pgt (between 'ident_complete' and 'secondary_startup_64')
> 

I assume the following patch fixes it.
It is queued by Jeremy and akpm has it queued too.

	Sam

Subject: xen: fix section usage in xen-head.S and setup.c

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
