Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbXEPDL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbXEPDL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXEPDLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:11:22 -0400
Received: from 81-174-33-43.f5.ngi.it ([81.174.33.43]:42033 "EHLO develer.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755101AbXEPDLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:11:21 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 23:11:21 EDT
Message-ID: <464A749B.4010906@codewiz.org>
Date: Tue, 15 May 2007 23:03:55 -0400
From: Bernardo Innocenti <bernie@codewiz.org>
Organization: http://www.codewiz.org/
User-Agent: Thunderbird 2.0.0.0 (X11/20070504)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: kdb@oss.sgi.com, linux-kernel@vger.kernel.org, devel@laptop.org
Subject: Re: kdb: add rdmsr and wrmsr commands for i386
References: <46494B99.2030502@codewiz.org> <20070515145133.GE27984@cosmic.amd.com>
In-Reply-To: <20070515145133.GE27984@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:

> Can you break this up with a : between the high dword and the low dword?
> That makes it easier to parse when debugging.

Good idea, but I used "_" instead because it's what AMD uses in their
documentation and it looks better with a "0x" prefix.

> Also, would it make sense to coordinate the order of the high and low
> dwords with the order they are specified with 'wrmsr'?  

Yeah, I did it as suggested by Mitch.  Here's a thrid
revision of the patch with everything included:

>From 1850ca76585306e2484cf5e709434049f1df3c1f Mon Sep 17 00:00:00 2001
From: Bernardo Innocenti <bernie@codewiz.org>
Date: Tue, 15 May 2007 15:29:48 -0400
Subject: [PATCH] kdb: add rdmsr and wrmsr commands for i386 (take 3)

The syntax is:
  rdmsr <addr>
  wrmsr <addr> <h> <l>

Signed-off-by: Bernardo Innocenti <bernie@codewiz.org>
---
 arch/i386/kdb/kdbasupport.c |   47 +++++++++++++++++++++++++++++++++++++++---
 kdb/kdbmain.c               |    3 +-
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/arch/i386/kdb/kdbasupport.c b/arch/i386/kdb/kdbasupport.c
index 482b319..7038dfb 100644
--- a/arch/i386/kdb/kdbasupport.c
+++ b/arch/i386/kdb/kdbasupport.c
@@ -223,6 +223,46 @@ kdba_removedbreg(kdb_bp_t *bp)
 	kdba_putdr7(dr7);
 }
 
+static int
+kdba_rdmsr(int argc, const char **argv)
+{
+	unsigned long addr;
+	uint32_t l, h;
+	int diag;
+
+	if (argc != 1)
+		return KDB_ARGCOUNT;
+
+	if ((diag = kdbgetularg(argv[1], &addr)))
+		return diag;
+
+	kdb_printf("msr(0x%lx) = ", addr);
+	rdmsr(addr, l, h);
+	kdb_printf("0x%08lx_%08lx\n", h, l);
+
+	return 0;
+}
+
+static int
+kdba_wrmsr(int argc, const char **argv)
+{
+	unsigned long addr;
+	unsigned long l, h;
+	int diag;
+
+	if (argc != 3)
+		return KDB_ARGCOUNT;
+
+	if ((diag = kdbgetularg(argv[1], &addr))
+			|| (diag = kdbgetularg(argv[2], &h))
+			|| (diag = kdbgetularg(argv[3], &l)))
+		return diag;
+
+	wrmsr(addr, l, h);
+
+	return 0;
+}
+
 
 /*
  * kdba_getregcontents
@@ -474,12 +514,11 @@ kdba_setregcontents(const char *regname,
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
  */
 
@@ -546,8 +585,6 @@ kdba_dumpregs(struct pt_regs *regs,
 			   cr[0], cr[1], cr[2], cr[3], cr[4]);
 		return 0;
 	}
-	case 'm':
-		break;
 	case 'r':
 		break;
 	default:
@@ -899,6 +936,8 @@ kdba_init(void)
 {
 	kdb_register("pt_regs", kdba_pt_regs, "address", "Format struct pt_regs", 0);
 	kdb_register("stackdepth", kdba_stackdepth, "[percentage]", "Print processes using >= stack percentage", 0);
+	kdb_register("rdmsr", kdba_rdmsr, "<maddr>", "Display Model Specific Register", 0);
+	kdb_register("wrmsr", kdba_wrmsr, "<maddr> <h> <l>", "Modify Model Specific Register", 0);
 
 	return;
 }
diff --git a/kdb/kdbmain.c b/kdb/kdbmain.c
index 0b2cb91..88bf14f 100644
--- a/kdb/kdbmain.c
+++ b/kdb/kdbmain.c
@@ -2596,8 +2596,7 @@ kdb_rd(int argc, const char **argv)
  *	none.
  * Remarks:
  *	Currently doesn't allow modification of control or
- *	debug registers, nor does it allow modification
- *	of model-specific registers (MSR).
+ *	debug registers.
  */
 
 static int
-- 
1.5.0.2

-- 
   // Bernardo Innocenti
 \X/  http://www.codewiz.org/
