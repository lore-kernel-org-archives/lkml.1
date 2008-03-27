Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYC0Afl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYC0Afl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 20:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYC0Afb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 20:35:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60108
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbYC0Afa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 20:35:30 -0400
Date: Wed, 26 Mar 2008 17:35:27 -0700 (PDT)
Message-Id: <20080326.173527.193701097.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: Linux 2.6.25-rc7 sparc64 loops forever on cat
 /proc/<pid>/pagemap
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803261302.46313.m.kozlowski@tuxland.pl>
References: <alpine.LFD.1.00.0803251856450.2775@woody.linux-foundation.org>
	<200803261302.46313.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Wed, 26 Mar 2008 13:02:45 +0100

> cat /proc/<pid>/pagemap 
> 
> and 
> 
> cat /proc/<pid>/task/<pid>/pagemap
> 
> eats up to 100% of CPU while looping forever somewhere. On the other
> hand on my old x86 the same commands take well below 1s so I
> guess that is the expected behaviour.

The patch below will speed this up for 32-bit processes but for 64-bit
ones it's still going to take a long time.

Cat'ing this file writes a 64-bit value for every possible page in the
task's address space, which for 64-bit is an enormous number of
entries.

This is not how this file is supposed to be used.  Programs are
supposed to inspect /proc/${PID}/maps, and use those ranges to lseek()
around the pagemap file and fish out the values they need.

This expensive operation is quite harmless, the process can still be
killed, it is not unstoppable.

commit c101b088ba0ed16d7109b2f3c2d16798d162a535
Author: David S. Miller <davem@davemloft.net>
Date:   Wed Mar 26 17:32:33 2008 -0700

    [SPARC64]: Define TASK_SIZE_OF()
    
    This make "cat /proc/${PID}/pagemap" more efficient for
    32-bit tasks.
    
    Based upon a report by Mariusz Kozlowski.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/asm-sparc64/processor.h b/include/asm-sparc64/processor.h
index 8da484c..885b6a1 100644
--- a/include/asm-sparc64/processor.h
+++ b/include/asm-sparc64/processor.h
@@ -37,6 +37,9 @@
 #endif
 
 #define TASK_SIZE	((unsigned long)-VPTE_SIZE)
+#define TASK_SIZE_OF(tsk) \
+	(test_tsk_thread_flag(tsk,TIF_32BIT) ? \
+	 (1UL << 32UL) : TASK_SIZE)
 #ifdef __KERNEL__
 
 #define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
