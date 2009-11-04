Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZKDNUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZKDNUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZKDNUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:20:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:56649 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZKDNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:20:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SNodcHR7Nd278dZ2Idc2IQeYWPh3ocU1UxoMP4ctiragD1htTq6GmsRVRdHjQHYFbl
         W9SDKMZBYRxf3Qo7VGEJNEf867bS9s4KHvecJKMiw9Ic3Yxs9RMY9qGiT+LuA+JdE6Vj
         fBff43UChnB8Rx+LT2gZ9sgJBDQTKxmseRFf0=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] genirq: set irq thread affinity when doing __setup_irq
Date: Wed,  4 Nov 2009 21:20:40 +0800
Message-Id: <1257340841-3739-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257340841-3739-1-git-send-email-yong.zhang0@gmail.com>
References: <1257340841-3739-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_affinity() should be paired with irq_set_thread_affinity()
even in the setup stage of an irq. Because irq_default_affinity
could be initialized by arch code in which case affinity between
irq and thead will be inconsistent.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0b5e5ed..5c5c114 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -748,7 +748,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			desc->status |= IRQ_NO_BALANCING;
 
 		/* Set default affinity mask once everything is setup */
-		setup_affinity(irq, desc);
+		ret = setup_affinity(irq, desc);
+		if (!ret)
+			irq_set_thread_affinity(desc);
 
 	} else if ((new->flags & IRQF_TRIGGER_MASK)
 			&& (new->flags & IRQF_TRIGGER_MASK)
-- 
1.6.3.3

