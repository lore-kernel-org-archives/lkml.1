Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYFTVO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYFTVO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbYFTVOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:14:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYFTVOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:14:45 -0400
Date: Fri, 20 Jun 2008 17:14:41 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080620.102601.06998427.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806201707270.8990@engineering.redhat.com>
References: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
 <20080617.210159.141238856.davem@davemloft.net>
 <Pine.LNX.4.64.0806201143110.8789@engineering.redhat.com>
 <20080620.102601.06998427.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jun 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Fri, 20 Jun 2008 11:47:12 -0400 (EDT)
>
>> I took another few traces (to track the whole stack content) and there is
>> another problem: nested interrupts. Does Sparc64 limit them somehow?
>
> Two levels should be the deepest you will ever see, and this is
> equivalent to what you get on other platforms.

Are you sure? What about this:
ide-io.c:ide_intr
         if (drive->unmask)
                 local_irq_enable_in_hardirq();

or this:
kernel/irq/handle.c:handle_IRQ_event
         if (!(action->flags & IRQF_DISABLED))
                 local_irq_enable_in_hardirq();


--- how is number of nested interrupts here supposed to be limited?

If these things are not limited, you get at most as many nested handlers 
as there are hardware interrupts, which means crash.

Mikulas

> That path occurs when softirq processing re-enabled HW interrupts when
> returning from the top-level interrupt.
