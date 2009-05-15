Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZEOTVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZEOTVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZEOTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:21:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:36531 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZEOTVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:21:06 -0400
Message-ID: <4A0DC095.7050706@windriver.com>
Date: Fri, 15 May 2009 14:20:53 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 2/3] kgdb,i386: use address that SP register points to
 in the exception frame
References: <1242393479-19351-1-git-send-email-jason.wessel@windriver.com> <1242393479-19351-2-git-send-email-jason.wessel@windriver.com> <1242393479-19351-3-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.01.0905150814180.3343@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905150814180.3343@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------030303010503030205090903"
X-OriginalArrivalTime: 15 May 2009 19:20:54.0044 (UTC) FILETIME=[440D65C0:01C9D592]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030303010503030205090903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> Is this only ever used for kernel register state?
>
> Because in the _general_ case, the code should likely be something like
>
> 	if (user_mode_vm(regs)) {
> 		gdb_regs[GDB_SS] = regs->ss;
> 		gdb_regs[GDB_SP] = regs->sp;
> 	} else {
> 		gdb_regs[GDB_SS] = __KERNEL_DS;
> 		gdb_regs[GDB_SP] = (unsigned long)&regs->sp
> 	}
>   

You have discovered a long standing corner case.  The only way you can
end up with user_mode_vm() being true is the death by NMI watch dog or
from the IPI to bring the non master kgdb cpus into debugger. By default
the kgdb exception handler is not going to end up with that condition,
because there is a check against regs in the kgdb notify handler for the
non NMI/IPI events.

Thank you for the suggestion.   I went ahead and tested it out to
confirm the behavior, as well as to run the standard set of kgdb
regression tests.

The corner case is fixed in the attached patch, and I updated for_linus
branch with just this patch, if you would prefer to pull it.

 
git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
for_linus

Thanks,
Jason.

--------------030303010503030205090903
Content-Type: text/x-diff;
 name="0001-kgdb-i386-Fix-corner-case-access-to-sp-with-NMI-watc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-kgdb-i386-Fix-corner-case-access-to-sp-with-NMI-watc.pa";
 filename*1="tch"

>From 0fff698b7a60d8f534dcc0d1ef26efb579938d09 Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Fri, 15 May 2009 11:39:08 -0500
Subject: [PATCH 1/1] kgdb,i386: Fix corner case access to sp with NMI watch dog exception

It is possible for the user_mode_vm(regs) check to return true for a
non master kgdb cpu or when the master kgdb cpu handles the NMI watch
dog exception.

The solution is simply to select the correct stack pointer location
based on the check to user_mode_vm(regs).

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/x86/kernel/kgdb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -85,10 +85,15 @@ void pt_regs_to_gdb_regs(unsigned long *
 	gdb_regs[GDB_DS]	= regs->ds;
 	gdb_regs[GDB_ES]	= regs->es;
 	gdb_regs[GDB_CS]	= regs->cs;
-	gdb_regs[GDB_SS]	= __KERNEL_DS;
 	gdb_regs[GDB_FS]	= 0xFFFF;
 	gdb_regs[GDB_GS]	= 0xFFFF;
-	gdb_regs[GDB_SP]	= (int)&regs->sp;
+	if (user_mode_vm(regs)) {
+		gdb_regs[GDB_SS] = regs->ss;
+		gdb_regs[GDB_SP] = regs->sp;
+	} else {
+		gdb_regs[GDB_SS] = __KERNEL_DS;
+		gdb_regs[GDB_SP] = (unsigned long)&regs->sp;
+	}
 #else
 	gdb_regs[GDB_R8]	= regs->r8;
 	gdb_regs[GDB_R9]	= regs->r9;

--------------030303010503030205090903--
