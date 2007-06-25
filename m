Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbXFYLcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbXFYLcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 07:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXFYLcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 07:32:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbXFYLcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 07:32:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Tuesday, 19 June 2007 16:35:29 -0400 <Pine.LNX.4.44L0.0706191517260.2672-200000@iolanthe.rowland.org>
X-Shopping-List: (1) Magnanimous sugar livers
   (2) Midget explosions
   (3) Irritating grief suction
   (4) Impious witches
   (5) Advantageous rails
Message-Id: <20070625113238.1AC4A4D05E7@magilla.localdomain>
Date: Mon, 25 Jun 2007 04:32:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I added this on top of your patch to make it compile (and look a little nicer).
With that, bptest worked nicely.

---
 arch/i386/kernel/kprobes.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: b/arch/i386/kernel/kprobes.c
===================================================================
--- a/arch/i386/kernel/kprobes.c
+++ b/arch/i386/kernel/kprobes.c
@@ -35,6 +35,7 @@
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
 #include <asm/uaccess.h>
+#include <asm/debugreg.h>
 
 void jprobe_return_end(void);
 
@@ -660,16 +661,16 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
-
-	/* The DR6 value is stored in args->err */
-#define DR6	(args->err)
-
-		if ((DR6 & DR_STEP) && post_kprobe_handler(args->regs)) {
-			if ((DR6 & ~DR_STEP) == 0)
-				ret = NOTIFY_STOP;
-		}
+		/*
+		 * The %db6 value is stored in args->err.
+		 * If DR_STEP is the only bit set and it's ours,
+		 * we should eat this exception.
+		 */
+		if ((args->err & DR_STEP) &&
+		    post_kprobe_handler(args->regs) &&
+		    (args->err & ~DR_STEP) == 0)
+			ret = NOTIFY_STOP;
 		break;
-#undef DR6
 
 	case DIE_GPF:
 	case DIE_PAGE_FAULT:
