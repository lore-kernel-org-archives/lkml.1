Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbXHVNeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbXHVNeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXHVNeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:34:10 -0400
Received: from mx10.go2.pl ([193.17.41.74]:46453 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbXHVNeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:34:09 -0400
Date: Wed, 22 Aug 2007 15:35:11 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, netdev@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.23-rc3-mm1] request_irq fix DEBUG_SHIRQ handling Re: 2.6.23-rc2-mm1: rtl8139 inconsistent lock state
Message-ID: <20070822133511.GH1684@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708100149.14446.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-08-2007 01:49, Mariusz Kozlowski wrote:
> Hello,
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.23-rc2-mm1 #7
> ---------------------------------
> inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> ifconfig/5492 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&tp->lock){+...}, at: [<de8706e0>] rtl8139_interrupt+0x27/0x46b [8139too]
> {in-hardirq-W} state was registered at:
>   [<c0138eeb>] __lock_acquire+0x949/0x11ac
>   [<c01397e7>] lock_acquire+0x99/0xb2
>   [<c0452ff3>] _spin_lock+0x35/0x42
>   [<de8706e0>] rtl8139_interrupt+0x27/0x46b [8139too]
>   [<c0147a5d>] handle_IRQ_event+0x28/0x59
>   [<c01493ca>] handle_level_irq+0xad/0x10b
>   [<c0105a13>] do_IRQ+0x93/0xd0
>   [<c010441e>] common_interrupt+0x2e/0x34
...
> other info that might help us debug this:
> 1 lock held by ifconfig/5492:
>  #0:  (rtnl_mutex){--..}, at: [<c0451778>] mutex_lock+0x1c/0x1f
> 
> stack backtrace:
...
>  [<c0452ff3>] _spin_lock+0x35/0x42
>  [<de8706e0>] rtl8139_interrupt+0x27/0x46b [8139too]
>  [<c01480fd>] free_irq+0x11b/0x146
>  [<de871d59>] rtl8139_close+0x8a/0x14a [8139too]
>  [<c03bde63>] dev_close+0x57/0x74
...

It looks like this was possible after David's fix, which really
enabled running of the handler in free_irq, but before Andrew's patch
disabling local irqs for this time.

So, this bug should be fixed, but IMHO similar problem is possible in
request_irq. And, I think, this is not only about lockdep complaining,
but real lockup possibility, because any locks in such a handler are
taken in another, not expected for them context, and could be
vulnerable (especially with softirqs, but probably hardirqs as well).

Reported-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.23-rc3-mm1-/kernel/irq/manage.c 2.6.23-rc3-mm1/kernel/irq/manage.c
--- 2.6.23-rc3-mm1-/kernel/irq/manage.c	2007-08-22 13:58:58.000000000 +0200
+++ 2.6.23-rc3-mm1/kernel/irq/manage.c	2007-08-22 14:12:21.000000000 +0200
@@ -546,14 +546,11 @@ int request_irq(unsigned int irq, irq_ha
 		 * We do this before actually registering it, to make sure that
 		 * a 'real' IRQ doesn't run in parallel with our fake
 		 */
-		if (irqflags & IRQF_DISABLED) {
-			unsigned long flags;
+		unsigned long flags;
 
-			local_irq_save(flags);
-			handler(irq, dev_id);
-			local_irq_restore(flags);
-		} else
-			handler(irq, dev_id);
+		local_irq_save(flags);
+		handler(irq, dev_id);
+		local_irq_restore(flags);
 	}
 #endif
 
