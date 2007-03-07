Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbXCGMgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbXCGMgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965042AbXCGMgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:36:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXCGMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:36:12 -0500
Subject: Re: Wanted: simple, safe x86 stack overflow detection
From: Arjan van de Ven <arjan@infradead.org>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070307064423.GH18774@holomorphy.com>
References: <45E5913D.3080505@redhat.com>
	 <20070228204144.GA32316@one.firstfloor.org>
	 <20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com>
	 <Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com>
	 <20070306203432.GD18774@holomorphy.com>
	 <1173241715.3236.16.camel@laptopd505.fenrus.org>
	 <20070307064423.GH18774@holomorphy.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 07 Mar 2007 04:34:52 -0800
Message-Id: <1173270892.3176.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 22:44 -0800, Bill Irwin wrote:
> At some point in the past, I wrote:
> >> I'm certainly in favor of the move; IRQ stacks could be made
> >> rather deep and cheaply at that. I may get around to writing it this
> >> week if no one else does it first.
> 
> On Tue, Mar 06, 2007 at 08:28:35PM -0800, Arjan van de Ven wrote:
> > the irq stacks aren't the problem; RH at some point accidentally shipped
> > a kernel with 4k *shared* irq/user context stack and even that gave
> > almost no issues.
> > irq's really shouldn't actually nest; it's bad for just about everything
> > to do that (but that's another story, I would *love* to get rid of the
> > "enable irqs" thing in the x86 irq path, it hurts just about anything in
> > reality)
> 
> What do you see as the obstacle to eliminating nested IRQ's?

political will, or maybe just the lack of convincing people so far

>  It doesn't
> seem so far out to test for being on the interrupt stack and defer the
> call to do_IRQ() until after the currently-running instance of do_IRQ()
> has returned, or to move to per-irq stacks modulo special arrangements
> for the per-cpu IRQ's. Or did you have other methods in mind?

it's simpler...

irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
{ 
        irqreturn_t ret, retval = IRQ_NONE;
        unsigned int status = 0;

        handle_dynamic_tick(action);
   
        if (!(action->flags & IRQF_DISABLED))
                local_irq_enable_in_hardirq();


just removing the if() and the explicit IRQ enabling already makes irqs no longer nest...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

