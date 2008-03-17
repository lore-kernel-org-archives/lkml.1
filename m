Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYCQXao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYCQXao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYCQXah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:30:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYCQXah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:30:37 -0400
Date: Tue, 18 Mar 2008 00:30:35 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: vfree with spin_lock_bh
Message-ID: <Pine.LNX.4.64.0803180019470.18817@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


while transforming some code with big allocations (like 120 KB) from 
kmalloc to vmalloc — virtual contiguity is sufficient — I hit a
BUG_ON in mm/vmalloc.c a number of times:

	void vfree(const void *addr)
	{
	        BUG_ON(in_interrupt());
	        __vunmap(addr, 1);
	}

First I was thinking “how could iptables -F run in interrupt context?”,
but apparently, it does seem to make a difference:

	...
	spin_lock_bh(&a_local_spinlock);
	list_del_rcu(&node->list);
	printk(KERN_INFO "Interrupt? %lu\n", in_interrupt());
	/* vfree not worky here */
	spin_unlock_bh(&a_local_spinlock);
	printk(KERN_INFO "Interrupt? %lu\n", in_interrupt());
	/* now possible */
	vfree(node);
	...

and this gives (x86_32)

	Interrupt? 256
	Interrupt? 0

So this may be a "property" of spinlocks, but it is a bit strange to me.
Why should not I be able to call vfree() when I am, in fact, in
user context (but with a bh spinlock held...).

Do I perhaps need a non-bh spinlock? There's RCU going on on that 
linked list so I am not sure whether I could just call the normal 
spin_lock() function.

Looking at the code of _spin_lock_bh in kernel/spinlock.c reveals that 
it is actually disabling preempt instead of being in an interrupt. 
Making an uneducated guess, would

	BUG_ON(in_interrupt() != 0 && in_interrupt() != 256)

in vfree() be safe?


thanks,
Jan
