Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbZINUIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbZINUIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933526AbZINUIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54021 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084AbZINUIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 14/72] Blackfin: inline I-pipe bypass code in ret_from_exception
Date: Mon, 14 Sep 2009 16:07:18 -0400
Message-Id: <1252958896-25150-15-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ipipe.c      |    5 -----
 arch/blackfin/mach-common/entry.S |   14 +++++++-------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index be4f24e..5d73823 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -164,11 +164,6 @@ out:
 		__clear_bit(IPIPE_STALL_FLAG, &p->status);
 }
 
-int __ipipe_check_root(void)
-{
-	return ipipe_root_domain_p;
-}
-
 void __ipipe_enable_irqdesc(struct ipipe_domain *ipd, unsigned irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 2c58b60..cbc5b6d 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -840,13 +840,13 @@ ENDPROC(_resume)
 
 ENTRY(_ret_from_exception)
 #ifdef CONFIG_IPIPE
-	[--sp] = rets;
-	SP += -12;
-	call ___ipipe_check_root
-	SP += 12
-	rets = [sp++];
-	cc = r0 == 0;
-	if cc jump 4f;                /* not on behalf of Linux, get out */
+	p2.l = _per_cpu__ipipe_percpu_domain;
+	p2.h = _per_cpu__ipipe_percpu_domain;
+	r0.l = _ipipe_root;
+	r0.h = _ipipe_root;
+	r2 = [p2];
+	cc = r0 == r2;
+	if !cc jump 4f;  /* not on behalf of the root domain, get out */
 #endif /* CONFIG_IPIPE */
 	p2.l = lo(IPEND);
 	p2.h = hi(IPEND);
-- 
1.6.4.2

