Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZIXIth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZIXIth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZIXIt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:49:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56885 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZIXIt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:49:27 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Koskinen Aaro <aaro.koskinen@nokia.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH v5 2/2] ARM: Proper prefetch abort handling on ARMv6 and ARMv7
Date: Thu, 24 Sep 2009 11:49:20 +0300
Message-Id: <e9c1f398415c4a7a09d942cd1ef832d9d9dbb5e8.1253781660.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <b833952fedbf24c4a16e0d79fe78019357e9652b.1253781660.git.kirill@shutemov.name>
References: <b833952fedbf24c4a16e0d79fe78019357e9652b.1253781660.git.kirill@shutemov.name>
In-Reply-To: <b833952fedbf24c4a16e0d79fe78019357e9652b.1253781660.git.kirill@shutemov.name>
References: <b833952fedbf24c4a16e0d79fe78019357e9652b.1253781660.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, on ARMv6 and ARMv7, if an application tries to execute
code (or garbage) on non-executable page it hangs. It caused by
incorrect prefetch abort handling. Now every prefetch abort
processes as a translation fault.

To fix this we have to analyze instruction fault status register
to figure out reason why we've got the abort and process it
accordingly.

To make IFSR different from DFSR we set bit 31 which is reserved in
both IFSR and DFSR.

This patch also tries to protect from future hangs on unexpected
exceptions. An application will be killed if unexpected exception
type was received.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/arm/mm/fault.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index fd2375f..ae0e25f 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -519,9 +519,58 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	arm_notify_die("", regs, &info, fsr, 0);
 }
 
+
+static struct fsr_info ifsr_info[] = {
+	{ do_bad,		SIGBUS,  0,		"unknown 0"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 1"			   },
+	{ do_bad,		SIGBUS,  0,		"debug event"			   },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"section access flag fault"	   },
+	{ do_bad,		SIGBUS,  0,		"unknown 4"			   },
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"section translation fault"	   },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"page access flag fault"	   },
+	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"page translation fault"	   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on non-linefetch"  },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"section domain fault"		   },
+	{ do_bad,		SIGBUS,  0,		"unknown 10"			   },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"page domain fault"		   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
+	{ do_sect_fault,	SIGSEGV, SEGV_ACCERR,	"section permission fault"	   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
+	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"page permission fault"		   },
+	{ do_bad,		SIGBUS,  0,		"unknown 16"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 17"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 18"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 19"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 20"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 21"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 22"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 23"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 24"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 25"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 26"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 27"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 28"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 31"			   },
+};
+
 asmlinkage void __exception
 do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
 {
-	do_translation_fault(addr, FSR_LNX_PF, regs);
+	const struct fsr_info *inf = ifsr_info + fsr_fs(ifsr);
+	struct siginfo info;
+
+	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
+		return;
+
+	printk(KERN_ALERT "Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
+		inf->name, ifsr, addr);
+
+	info.si_signo = inf->sig;
+	info.si_errno = 0;
+	info.si_code  = inf->code;
+	info.si_addr  = (void __user *)addr;
+	arm_notify_die("", regs, &info, ifsr, 0);
 }
 
-- 
1.6.4.4

