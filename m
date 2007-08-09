Return-Path: <linux-kernel-owner+w=401wt.eu-S937297AbXHIQtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937297AbXHIQtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763581AbXHIQth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:49:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbXHIQtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:49:36 -0400
Message-ID: <46BB4599.2020900@redhat.com>
Date: Thu, 09 Aug 2007 12:49:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>
Subject: i386 doublefault handler is broken with CONFIG_DEBUG_SPINLOCK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The new percpu code has apparently broken the doublefault handler
when CONFIG_DEBUG_SPINLOCK is set. Doublefault is handled by
a hardware task, making the check

        SPIN_BUG_ON(lock->owner == current, lock, "recursion");

fault because it uses the FS register to access the percpu data
for current, and that register is zero in the new TSS. (The trace
I saw was on 2.6.20 where it was GS, but it looks like this will
still happen with FS on 2.6.22.)

Initializing FS in the doublefault_tss should fix it.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---

 NOTE: not even compile tested.

 arch/i386/kernel/doublefault.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.22.noarch.orig/arch/i386/kernel/doublefault.c
+++ linux-2.6.22.noarch/arch/i386/kernel/doublefault.c
@@ -63,6 +63,7 @@ struct tss_struct doublefault_tss __cach
 		.cs		= __KERNEL_CS,
 		.ss		= __KERNEL_DS,
 		.ds		= __USER_DS,
+		.fs		= __KERNEL_PERCPU,
 
 		.__cr3		= __pa(swapper_pg_dir)
 	}
