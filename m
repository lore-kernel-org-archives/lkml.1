Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYCRLYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYCRLYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYCRLYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:24:00 -0400
Received: from saeurebad.de ([85.214.36.134]:35243 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYCRLYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:24:00 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vfree with spin_lock_bh
References: <Pine.LNX.4.64.0803180019470.18817@fbirervta.pbzchgretzou.qr>
Date: Tue, 18 Mar 2008 12:21:39 +0100
In-Reply-To: <Pine.LNX.4.64.0803180019470.18817@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Tue, 18 Mar 2008 00:30:35 +0100 (CET)")
Message-ID: <87wso0wa4c.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Jan Engelhardt <jengelh@computergmbh.de> writes:

> while transforming some code with big allocations (like 120 KB) from 
> kmalloc to vmalloc — virtual contiguity is sufficient — I hit a
> BUG_ON in mm/vmalloc.c a number of times:
>
> 	void vfree(const void *addr)
> 	{
> 	        BUG_ON(in_interrupt());
> 	        __vunmap(addr, 1);
> 	}
>
> First I was thinking “how could iptables -F run in interrupt context?”,
> but apparently, it does seem to make a difference:
>
> 	...
> 	spin_lock_bh(&a_local_spinlock);
> 	list_del_rcu(&node->list);
> 	printk(KERN_INFO "Interrupt? %lu\n", in_interrupt());
> 	/* vfree not worky here */
> 	spin_unlock_bh(&a_local_spinlock);
> 	printk(KERN_INFO "Interrupt? %lu\n", in_interrupt());
> 	/* now possible */
> 	vfree(node);
> 	...
>
> and this gives (x86_32)
>
> 	Interrupt? 256
> 	Interrupt? 0
>
> So this may be a "property" of spinlocks, but it is a bit strange to me.
> Why should not I be able to call vfree() when I am, in fact, in
> user context (but with a bh spinlock held...).

in_interrupt() checks for both, hard- and softirqs.  Since
spin_lock_bh() disables softirq's you have to be as fast as possible to
avoid softirq latency.

> Do I perhaps need a non-bh spinlock? There's RCU going on on that 
> linked list so I am not sure whether I could just call the normal 
> spin_lock() function.

Perhaps a call_rcu() which vfree()s the node?  But I am just guessing
wildly here.

> Looking at the code of _spin_lock_bh in kernel/spinlock.c reveals that 
> it is actually disabling preempt instead of being in an interrupt. 
> Making an uneducated guess, would
>
> 	BUG_ON(in_interrupt() != 0 && in_interrupt() != 256)

That's basically a lacky in_irq().  The 256 you see here is
1<<SOFTIRQ_SHIFT but softirq disabling can be nested and you can not
check for 256 directly.

> in vfree() be safe?

Can not judge that.

	Hannes
