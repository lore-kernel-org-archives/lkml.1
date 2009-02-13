Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbZBMDjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbZBMDjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 22:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZBMDjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 22:39:01 -0500
Received: from cmpxchg.org ([85.214.51.133]:58635 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176AbZBMDjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 22:39:01 -0500
Date: Fri, 13 Feb 2009 04:38:04 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can request_irq be called under spinlock?
Message-ID: <20090213033803.GA13631@cmpxchg.org>
References: <499481B9.4090202@goop.org> <alpine.LFD.2.00.0902122326100.16972@localhost.localdomain> <4994B23D.4040806@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4994B23D.4040806@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 03:35:25PM -0800, Jeremy Fitzhardinge wrote:
> Thomas Gleixner wrote:
> >I dont think that proc_mkdir conventions have changed
> >recently. According to git blame fs/proc/generic.c:
> >
> >^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700 580)     ent = 
> >kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
> >
> >  
> 
> I think its new that request_irq ends up calling proc_mkdir though.  But 
> its moot now anyway; I cleaned up that code, and don't call request_irq 
> under spinlock any more.

Still, the attached could be of use, no?

	Hannes

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: irq: use GFP_KERNEL for action allocation in request_irq()

request_irq() calls into proc code via __setup_irq() which is not safe
in an atomic context, so request_irq() can itself use the more
reliable GFP_KERNEL allocation for the action descriptor.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 291f036..0f2b3b6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -709,7 +709,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	if (!handler)
 		return -EINVAL;
 
-	action = kmalloc(sizeof(struct irqaction), GFP_ATOMIC);
+	action = kmalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
 
