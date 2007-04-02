Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbXDBMZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbXDBMZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934007AbXDBMZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:25:25 -0400
Received: from www.osadl.org ([213.239.205.134]:56715 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934003AbXDBMZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:25:23 -0400
Subject: [PATCH] i386: fix file_read_actor() and pipe_read()  for original
	i386 systems
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stable Kernel Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org>
References: <1174810024.10840.477.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:25:31 +0200
Message-Id: <1175516731.28263.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __copy_to_user_inatomic() calls in file_read_actor() and pipe_read()
are broken on original i386 machines, where WP-works-ok == false, as
__copy_to_user_inatomic() on such systems calls functions which might
sleep and/or contain cond_resched() calls inside of a kmap_atomic()
region.

The original check for WP-works-ok was in access_ok(), but got moved
during the 2.5 series to fix a race vs. swap.

Return the number of bytes to copy in the case where we are in an atomic
region, so the non atomic code pathes in file_read_actor() and
pipe_read() are taken.

This could be optimized to avoid the kmap_atomicby moving the check for
WP-works-ok into fault_in_pages_writeable(), but this is more intrusive
and can be done later.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/i386/lib/usercopy.c b/arch/i386/lib/usercopy.c
index d22cfc9..1950277 100644
--- a/arch/i386/lib/usercopy.c
+++ b/arch/i386/lib/usercopy.c
@@ -10,6 +10,7 @@
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/backing-dev.h>
+#include <linux/interrupt.h>
 #include <asm/uaccess.h>
 #include <asm/mmx.h>
 
@@ -719,6 +720,14 @@ unsigned long __copy_to_user_ll(void __user *to, const void *from,
 #ifndef CONFIG_X86_WP_WORKS_OK
 	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
 			((unsigned long )to) < TASK_SIZE) {
+		/*
+		 * When we are in an atomic section (see
+		 * mm/filemap.c:file_read_actor), return the full
+		 * length to take the slow path.
+		 */
+		if (in_atomic())
+			return n;
+
 		/* 
 		 * CPU does not honor the WP bit when writing
 		 * from supervisory mode, and due to preemption or SMP,





