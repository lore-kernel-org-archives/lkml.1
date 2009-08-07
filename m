Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbZHGUmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbZHGUmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZHGUmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:42:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33071 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZHGUmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:42:50 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 6/6] [ARM] Use atomic_spin_lock/atomic_spin_unlock for irqdesc lock
Date: Fri,  7 Aug 2009 22:42:41 +0200
Message-Id: <1249677761-19470-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090807203939.GA19374@pengutronix.de>
References: <20090807203939.GA19374@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was missed in commit

	fd2bde5 (genirq: Convert irqdesc lock to atomic_spinlock)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/include/asm/mach/irq.h |    4 ++--
 mm/highmem.c                    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/mach/irq.h b/arch/arm/include/asm/mach/irq.h
index acac530..3981cf2 100644
--- a/arch/arm/include/asm/mach/irq.h
+++ b/arch/arm/include/asm/mach/irq.h
@@ -26,9 +26,9 @@ extern int show_fiq_list(struct seq_file *, void *);
  */
 #define do_bad_IRQ(irq,desc)				\
 do {							\
-	spin_lock(&desc->lock);				\
+	atomic_spin_lock(&desc->lock);			\
 	handle_bad_irq(irq, desc);			\
-	spin_unlock(&desc->lock);			\
+	atomic_spin_unlock(&desc->lock);		\
 } while(0)
 
 #endif
diff --git a/mm/highmem.c b/mm/highmem.c
index 66e915a..214eefd 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -372,8 +372,8 @@ void *kmap_high_get(struct page *page)
 	lock_kmap_any(flags);
 	vaddr = (unsigned long)page_address(page);
 	if (vaddr) {
-		BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 1);
-		pkmap_count[PKMAP_NR(vaddr)]++;
+		BUG_ON(atomic_read(&pkmap_count[PKMAP_NR(vaddr)]) < 1);
+		atomic_add(1, pkmap_count[PKMAP_NR(vaddr)]);
 	}
 	unlock_kmap_any(flags);
 	return (void*) vaddr;
-- 
1.6.3.3

