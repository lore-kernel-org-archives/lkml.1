Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZFXHIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZFXHIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZFXHII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:08:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39986
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbZFXHIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:08:07 -0400
Date: Wed, 24 Jun 2009 00:08:11 -0700 (PDT)
Message-Id: <20090624.000811.118222188.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624070315.GH6760@one.firstfloor.org>
References: <20090622.022752.219499742.davem@davemloft.net>
	<20090623.171735.154729801.davem@davemloft.net>
	<20090624070315.GH6760@one.firstfloor.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 24 Jun 2009 09:03:15 +0200

>> I'm not exactly sure what to do about this.
> 
> Ack the timer interrupt earlier (and also give it a high priority?)

It has a higher priority, but all interrupts get re-enabled right
before we process software interrupts.  So the flood of qla2xxx
interrupts can come in before we can run the timer softirq and
thus schedule the next timer interrupt.

> That could be still problematic if you have non nestabled irq stacks
> (haven't checked if sparc has that or not), 
> potentially you might need to run the softirq on the process stack.

IRQ stacks on sparc64 work identically to how they do on x86.

I have some more theories about this, in that I always see the
NMI watchdog message with a PC right in the section of CPU idle
where NOHZ is enabled.

On these cpus there is no support yielding, so on them I just
touch the NMI watchdog in the loop waiting for need_resched()
to become true.

But if we get the qla2xxx interrupt storm during that loop, it's
pretty easy to not touch the NMI watchdog in time.
