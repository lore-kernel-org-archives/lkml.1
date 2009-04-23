Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZDWGtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZDWGtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZDWGtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:49:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:58137 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZDWGtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:49:12 -0400
Date: Thu, 23 Apr 2009 06:48:31 GMT
From: tip-bot for Luis Henriques <henrix@sapo.pt>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       henrix@sapo.pt, sfr@canb.auug.org.au, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       henrix@sapo.pt, tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20090401170635.GA4392@hades.domain.com>
References: <20090401170635.GA4392@hades.domain.com>
Subject: [tip:irq/genirq] genirq: do not execute DEBUG_SHIRQ when irq setup failed
Message-ID: <tip-6ce51c431019310ca03371355a4366c4649fa349@git.kernel.org>
Git-Commit-ID: 6ce51c431019310ca03371355a4366c4649fa349
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 06:48:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ce51c431019310ca03371355a4366c4649fa349
Gitweb:     http://git.kernel.org/tip/6ce51c431019310ca03371355a4366c4649fa349
Author:     Luis Henriques <henrix@sapo.pt>
AuthorDate: Wed, 1 Apr 2009 18:06:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 23 Apr 2009 08:45:48 +0200

genirq: do not execute DEBUG_SHIRQ when irq setup failed

When requesting an IRQ, the DEBUG_SHIRQ code executes a fake IRQ just to make
sure the driver is ready to receive an IRQ immediately.  The problem was that
this fake IRQ was being executed even if interrupt line failed to be allocated
by __setup_irq.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
LKML-Reference: <20090401170635.GA4392@hades.domain.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ fixed bug pointed out by a warning reported by Stephen Rothwell ]
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1516ab7..8c68d5b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -768,7 +768,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 		kfree(action);
 
 #ifdef CONFIG_DEBUG_SHIRQ
-	if (irqflags & IRQF_SHARED) {
+	if (!retval && (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
 		 * to happen immediately, so let's make sure....
