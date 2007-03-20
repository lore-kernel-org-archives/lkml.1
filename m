Return-Path: <linux-kernel-owner+w=401wt.eu-S965349AbXCTQcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbXCTQcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965338AbXCTQcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:32:05 -0400
Received: from gw.goop.org ([64.81.55.164]:53981 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965320AbXCTQcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:32:01 -0400
Message-ID: <46000C7E.4070001@goop.org>
Date: Tue, 20 Mar 2007 09:31:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@muc.de>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, anthony@codemonkey.ws, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org> <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net> <20070318120814.GA45869@muc.de> <1174272469.11680.23.camel@localhost.localdomain> <m1648xxf93.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org> <1174348905.11680.54.camel@localhost.localdomain> <45FF4043.4000805@vmware.com> <45FF770C.7050301@goop.org> <Pine.LNX.4.64.0703200805450.6730@woody.linux-foundation.org> <m1mz27sy82.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703200903500.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703200903500.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 20 Mar 2007, Eric W. Biederman wrote:
>   
>> If that is the case.  In the normal kernel what would
>> the "the oops, we got an interrupt code do?"
>> I assume it would leave interrupts disabled when it returns?
>> Like we currently do with the delayed disable of normal interrupts?
>>     
>
> Yeah, disable interrupts, and set a flag that the fake "sti" can test, and 
> just return without doing anything.
>
> (You may or may not also need to do extra work to Ack the hardware 
> interrupt etc, which may be irq-controller specific. Once the CPU has 
> accepted the interrupt, you may not be able to just leave it dangling)
>   

So it would be something like:

    pda.intr_mask = 1;		/* disable interrupts */
    ...
    pda.intr_mask = 0;		/* enable interrupts */
    if (xchg(&pda.intr_pending, 0))	/* check pending */
    	asm("sti");		/* was pending; isr left cpu interrupts masked */
      

and in the interrupt handler:

    if (pda.intr_mask) {
    	pda.intr_pending = 1;
    	regs->eflags &= ~IF;
    	maybe_ack_interrupt_controller();
    	iret
      

    }

?

    J

