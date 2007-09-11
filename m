Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXIKHH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXIKHH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761012AbXIKHHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:07:17 -0400
Received: from ozlabs.org ([203.10.76.45]:57348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760981AbXIKHHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:07:16 -0400
Subject: [PATCH] lguest: Fix guest crash when CONFIG_X86_USE_3DNOW=y
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michael Rasenberger <michael.rasenberger@googlemail.com>
Cc: lguest@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46E1A7BB.70203@googlemail.com>
References: <46E18381.9020206@googlemail.com>
	 <1189179936.10802.321.camel@localhost.localdomain>
	 <46E1A7BB.70203@googlemail.com>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 17:06:37 +1000
Message-Id: <1189494397.20631.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One of the very first things lguest_init() does is a memcpy.  On
Athlon/Duron/K7 or CyrixIII/VIA-C3 or Geode GX/LX, this tries to use
MMX.

memcpy -> _mmx_memcpy -> kernel_fpu_begin -> clts -> paravirt_ops.clts

But we haven't set paravirt_ops.clts yet, so we do the native version
and crash.  The simplest solution is to use __memcpy.

Thanks to Michael Rasenberger for the bug report.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 1b28730fea64 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Tue Sep 11 13:53:31 2007 +1000
+++ b/drivers/lguest/lguest.c	Tue Sep 11 16:28:49 2007 +1000
@@ -964,11 +964,12 @@ __init void lguest_init(void *boot)
 {
 	/* Copy boot parameters first: the Launcher put the physical location
 	 * in %esi, and head.S converted that to a virtual address and handed
-	 * it to us. */
-	memcpy(&boot_params, boot, PARAM_SIZE);
+	 * it to us.  We use "__memcpy" because "memcpy" sometimes tries to do
+	 * tricky things to go faster, and we're not ready for that. */
+	__memcpy(&boot_params, boot, PARAM_SIZE);
 	/* The boot parameters also tell us where the command-line is: save
 	 * that, too. */
-	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
+	__memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
 	       COMMAND_LINE_SIZE);
 
 	/* We're under lguest, paravirt is enabled, and we're running at


