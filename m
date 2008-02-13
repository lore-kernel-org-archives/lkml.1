Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYBMIiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYBMIiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYBMIhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:37:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbYBMIhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:37:54 -0500
Date: Wed, 13 Feb 2008 00:35:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rajat Jain" <rajat.noida.india@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Kernel Bug? Use of IRQF_SHARED + IRQF_DISABLED
Message-Id: <20080213003547.e8113b9a.akpm@linux-foundation.org>
In-Reply-To: <b115cb5f0802112149t574347e3of13a081937ec0ca0@mail.gmail.com>
References: <b115cb5f0802112149t574347e3of13a081937ec0ca0@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 11:19:03 +0530 "Rajat Jain" <rajat.noida.india@gmail.com> wrote:

> Hi,
> 
> Based on suggestion from Thomas Petazzoni, I'm moving this to LKML.
> 
> This is regarding the following code in kernel/irq/handle.c. Consider
> the case of a shared IRQ line, where two handlers are registered such
> that first handler does not specify IRQF_DISABLED, but the second one
> does. But it seems both the handlers will be called with IRQs ENABLED
> (which is certainly not what the second handler expects).
> 
> I also checked but could not find anything that stops me from
> registering two shared ISRs - one with IRQF_DISABLED & another without
> this flag. Am I missing something here?
> 
> irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> {
>    irqreturn_t ret, retval = IRQ_NONE;
>    unsigned int status = 0;
> 
>    handle_dynamic_tick(action);
> 
>    if (!(action->flags & IRQF_DISABLED))
>        local_irq_enable_in_hardirq();
> 
>    do {
>        ret = action->handler(irq, action->dev_id);
>        if (ret == IRQ_HANDLED)
>            status |= action->flags;
>        retval |= ret;
>        action = action->next;
>    } while (action);
> 
>    if (status & IRQF_SAMPLE_RANDOM)
>        add_interrupt_randomness(irq);
>    local_irq_disable();
> 
>    return retval;
> }
> 
> I'd like to submit a patch but was wondering which of the following is
> the correct startegy to deal with above situation (I personally think
> (1) below is more appropriate):
> 
> 1) IN the above code while calling shared ISRs, check for each ISR
> whether it specified IRQF_DISABLED or not. Enable IRQs only for ISR
> that did not specify IRQF_DISABLED.
> 
> 2) While installing ISR, check that all the ISRs for that IRQ should
> have consistent use of IRQF_DISABLED. Don't allow insonsistent use of
> IRQF_DISABLED on a shared IRQ.

Well.. the question is "what are the semantics of IRQF_DISABLED?".

If it is "interrupts should be disabled while calling the ->action then
fine, 1) is good.

But that sounds fairly pointless - the handler can do local_irq_disable()
if it wants.  I guess IRQF_DISABLED was deswigned to hold off interrupts
for the entire duration of the hard IRQ - I don't really recall.  Alan
might though?

I'm pretty sure this came up within the last year, and it looks like we
decided to leave the code in the state which you see there.  I wonder why. 
How god is your googling?

