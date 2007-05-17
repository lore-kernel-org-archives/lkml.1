Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbXEQGWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbXEQGWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbXEQGWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:22:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41074 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754124AbXEQGWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:22:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@sgi.com>
To: Bernardo Innocenti <bernie@codewiz.org>
cc: Jordan Crouse <jordan.crouse@amd.com>, kdb@oss.sgi.com,
       linux-kernel@vger.kernel.org, devel@laptop.org
Subject: Re: kdb: add rdmsr and wrmsr commands for i386 
In-reply-to: Your message of "Tue, 15 May 2007 23:03:55 -0400."
             <464A749B.4010906@codewiz.org> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 17 May 2007 16:22:33 +1000
Message-ID: <6778.1179382953@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernardo Innocenti (on Tue, 15 May 2007 23:03:55 -0400) wrote:
>Jordan Crouse wrote:
>
>> Can you break this up with a : between the high dword and the low dword?
>> That makes it easier to parse when debugging.
>
>Good idea, but I used "_" instead because it's what AMD uses in their
>documentation and it looks better with a "0x" prefix.
>
>> Also, would it make sense to coordinate the order of the high and low
>> dwords with the order they are specified with 'wrmsr'?  
>
>Yeah, I did it as suggested by Mitch.  Here's a thrid
>revision of the patch with everything included:
>
>From 1850ca76585306e2484cf5e709434049f1df3c1f Mon Sep 17 00:00:00 2001
>From: Bernardo Innocenti <bernie@codewiz.org>
>Date: Tue, 15 May 2007 15:29:48 -0400
>Subject: [PATCH] kdb: add rdmsr and wrmsr commands for i386 (take 3)
>
>The syntax is:
>  rdmsr <addr>
>  wrmsr <addr> <h> <l>
>
>Signed-off-by: Bernardo Innocenti <bernie@codewiz.org>
>---
> arch/i386/kdb/kdbasupport.c |   47 +++++++++++++++++++++++++++++++++++++++---
> kdb/kdbmain.c               |    3 +-

Thanks for the patch, but ...

Before using MSR, you must first check that the cpu supports the
instruction, rd/wrmsr cause an oops on 486 or earlier.  Also using an
invalid msr number causes an oops, so use rd/wrmsr_safe().  Finally, kdb
on x86_64 needs the commands as well, so move it to kdb/modules/kdbm_x86.c
(common i386/x86_64 code).  Cleaned up patch + changelogs.

---

 arch/i386/kdb/ChangeLog       |    6 ++++
 arch/i386/kdb/kdbasupport.c   |    7 ++--
 arch/x86_64/kdb/ChangeLog     |    6 ++++
 arch/x86_64/kdb/kdbasupport.c |    7 ++--
 kdb/ChangeLog                 |    7 ++++
 kdb/kdbmain.c                 |    3 --
 kdb/modules/kdbm_x86.c        |   59 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 85 insertions(+), 10 deletions(-)

diff -u linux/arch/i386/kdb/ChangeLog linux/arch/i386/kdb/ChangeLog
--- linux/arch/i386/kdb/ChangeLog
+++ linux/arch/i386/kdb/ChangeLog
@@ -1,3 +1,9 @@
+2007-05-17 Keith Owens  <kaos@sgi.com>
+
+	* Update dumpregs comments for rdmsr and wrmsr commands.
+	  Bernardo Innocenti.
+	* kdb v4.4-2.6.21-i386-3.
+
 2007-05-15 Keith Owens  <kaos@sgi.com>
 
 	* Change kdba_late_init to kdba_arch_init so KDB_ENTER() can be used
diff -u linux/arch/i386/kdb/kdbasupport.c linux/arch/i386/kdb/kdbasupport.c
--- linux/arch/i386/kdb/kdbasupport.c
+++ linux/arch/i386/kdb/kdbasupport.c
@@ -474,13 +474,14 @@
  *	argument is NULL (struct pt_regs).   The alternate register
  *	set types supported by this function:
  *
- *	d 		Debug registers
+ *	d		Debug registers
  *	c		Control registers
  *	u		User registers at most recent entry to kernel
  *			for the process currently selected with "pid" command.
  * Following not yet implemented:
- *	m		Model Specific Registers (extra defines register #)
  *	r		Memory Type Range Registers (extra defines register)
+ *
+ * MSR on i386/x86_64 are handled by rdmsr/wrmsr commands.
  */
 
 int
@@ -546,8 +547,6 @@
 			   cr[0], cr[1], cr[2], cr[3], cr[4]);
 		return 0;
 	}
-	case 'm':
-		break;
 	case 'r':
 		break;
 	default:
diff -u linux/arch/x86_64/kdb/ChangeLog linux/arch/x86_64/kdb/ChangeLog
--- linux/arch/x86_64/kdb/ChangeLog
+++ linux/arch/x86_64/kdb/ChangeLog
@@ -1,3 +1,9 @@
+2007-05-17 Keith Owens  <kaos@sgi.com>
+
+	* Update dumpregs comments for rdmsr and wrmsr commands.
+	  Bernardo Innocenti.
+	* kdb v4.4-2.6.21-x86_64-3.
+
 2007-05-15 Keith Owens  <kaos@sgi.com>
 
 	* Change kdba_late_init to kdba_arch_init so KDB_ENTER() can be used
diff -u linux/arch/x86_64/kdb/kdbasupport.c linux/arch/x86_64/kdb/kdbasupport.c
--- linux/arch/x86_64/kdb/kdbasupport.c
+++ linux/arch/x86_64/kdb/kdbasupport.c
@@ -470,12 +470,13 @@
  *	argument is NULL (struct pt_regs).   The alternate register
  *	set types supported by this function:
  *
- *	d 		Debug registers
+ *	d		Debug registers
  *	c		Control registers
  *	u		User registers at most recent entry to kernel
  * Following not yet implemented:
- *	m		Model Specific Registers (extra defines register #)
  *	r		Memory Type Range Registers (extra defines register)
+ *
+ * MSR on i386/x86_64 are handled by rdmsr/wrmsr commands.
  */
 
 int
@@ -536,8 +537,6 @@
 			   cr[0], cr[1], cr[2], cr[3], cr[4]);
 		return 0;
 	}
-	case 'm':
-		break;
 	case 'r':
 		break;
 	default:
diff -u linux/kdb/ChangeLog linux/kdb/ChangeLog
--- linux/kdb/ChangeLog
+++ linux/kdb/ChangeLog
@@ -1,3 +1,10 @@
+2007-05-17 Keith Owens  <kaos@sgi.com>
+
+	* Add rdmsr and wrmsr commands for i386 and x86_64.  Original patch by
+	  Bernardo Innocenti for i386, reworked by Keith Owens to make it safe
+	  on all cpu models and to handle both i386 and x86_64.
+	* kdb v4.4-2.6.21-common-3.
+
 2007-05-15 Keith Owens  <kaos@sgi.com>
 
 	* Correct alignment of debug_alloc_header.
diff -u linux/kdb/kdbmain.c linux/kdb/kdbmain.c
--- linux/kdb/kdbmain.c
+++ linux/kdb/kdbmain.c
@@ -2596,8 +2596,7 @@
  *	none.
  * Remarks:
  *	Currently doesn't allow modification of control or
- *	debug registers, nor does it allow modification
- *	of model-specific registers (MSR).
+ *	debug registers.
  */
 
 static int
diff -u linux/kdb/modules/kdbm_x86.c linux/kdb/modules/kdbm_x86.c
--- linux/kdb/modules/kdbm_x86.c
+++ linux/kdb/modules/kdbm_x86.c
@@ -1012,6 +1012,61 @@
 	return 0;
 }
 
+static int
+kdb_rdmsr(int argc, const char **argv)
+{
+	unsigned long addr;
+	uint32_t l, h;
+	int diag;
+	struct cpuinfo_x86 *c = cpu_data + smp_processor_id();
+
+	if (argc != 1)
+		return KDB_ARGCOUNT;
+
+	if ((diag = kdbgetularg(argv[1], &addr)))
+		return diag;
+
+	if (!cpu_has(c, X86_FEATURE_MSR))
+		return KDB_NOTIMP;
+
+	kdb_printf("msr(0x%lx) = ", addr);
+	if ((diag = rdmsr_safe(addr, &l, &h))) {
+		kdb_printf("error %d\n", diag);
+		return KDB_BADINT;
+	} else {
+		kdb_printf("0x%08x_%08x\n", h, l);
+	}
+
+	return 0;
+}
+
+static int
+kdb_wrmsr(int argc, const char **argv)
+{
+	unsigned long addr;
+	unsigned long l, h;
+	int diag;
+	struct cpuinfo_x86 *c = cpu_data + smp_processor_id();
+
+	if (argc != 3)
+		return KDB_ARGCOUNT;
+
+	if ((diag = kdbgetularg(argv[1], &addr))
+			|| (diag = kdbgetularg(argv[2], &h))
+			|| (diag = kdbgetularg(argv[3], &l)))
+		return diag;
+
+	if (!cpu_has(c, X86_FEATURE_MSR))
+		return KDB_NOTIMP;
+
+	if ((diag = wrmsr_safe(addr, l, h))) {
+		kdb_printf("error %d\n", diag);
+		return KDB_BADINT;
+	}
+
+	return 0;
+}
+
 static int __init kdbm_x86_init(void)
 {
 	kdb_register("rdv", kdb_rdv, NULL, "Display registers in verbose mode", 0);
@@ -1020,6 +1075,8 @@
 	kdb_register_repeat("ldt", kdb_ldt, "<sel> [<count>]", "Display LDT", 0, KDB_REPEAT_NO_ARGS);
 	kdb_register_repeat("ptex", kdb_pte, "<addr> [<count>]", "Display pagetables", 0, KDB_REPEAT_NO_ARGS);
 	kdb_register_repeat("ldtp", kdb_ldt, "<sel> [<count>]", "Display Process LDT", 0, KDB_REPEAT_NO_ARGS);
+	kdb_register("rdmsr", kdb_rdmsr, "<maddr>", "Display Model Specific Register", 0);
+	kdb_register("wrmsr", kdb_wrmsr, "<maddr> <h> <l>", "Modify Model Specific Register", 0);
 	return 0;
 }
 
@@ -1031,6 +1088,8 @@
 	kdb_unregister("idt");
 	kdb_unregister("ptex");
 	kdb_unregister("ldtp");
+	kdb_unregister("rdmsr");
+	kdb_unregister("wrmsr");
 }
 
 module_init(kdbm_x86_init)

