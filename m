Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYELNhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYELNhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYELNhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:37:06 -0400
Received: from mail2.picochip.com ([82.111.145.34]:45611 "EHLO
	arun.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbYELNhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:37:05 -0400
X-Greylist: delayed 3350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 09:37:04 EDT
Message-ID: <48283AE5.7010704@jamieiles.com>
Date: Mon, 12 May 2008 13:41:09 +0100
From: Jamie Iles <lkml@jamieiles.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jamie Iles <jamie.iles@picochip.com>
Subject: Soft IRQs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (arun.picochip.com [172.17.0.30]); Mon, 12 May 2008 13:41:10 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to understand whether it is correct behaviour for soft IRQs 
to be executed when interrupts with disabled. In particular, if I have 
some code that does:

    spin_lock_t mylock = SPIN_LOCK_UNLOCKED;
    unsigned long flags;
    spin_lock_irqsave( &mylock, flags );
   
    ...
   
    spin_lock_irqrestore( &mylock, flags );

Can soft IRQs run in the critical section above? I have a problem where 
'local_bh_enable_ip()' is being called as a result of 'dev_kfree_skb()' 
and a NET_RX_SOFTIRQ is being raised when I expect interrupts to be 
disabled.

'local_bh_enable()' only uses the 'in_irq()' macro to check whether we 
should do 'do_softirq()' and it also only checks we do not have the 
softirq field of 'preempt_count' non-zero before enabling soft IRQs.

I can see that if I was to replace 'spin_lock_irqsave()' with 
'spin_lock_bh()' then the softirq field of 'preempt_count' would be 
incremented and prevent soft IRQs until the lock was released. Should 
'spin_lock_irqsave()' also disable soft interrupts?

Thanks,

Jamie
