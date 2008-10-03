Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYJCDSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYJCDSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYJCDR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:17:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44576 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYJCDR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:17:57 -0400
Date: Fri, 3 Oct 2008 05:23:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt handlers
Message-ID: <20081003032339.GE8318@one.firstfloor.org>
References: <20081001223213.078984344@linutronix.de> <873ajfoy1a.fsf@basil.nowhere.org> <20081002213146.GA9201@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002213146.GA9201@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 02:31:46PM -0700, Greg KH wrote:
> On Thu, Oct 02, 2008 at 04:46:09PM +0200, Andi Kleen wrote:
> > Thomas Gleixner <tglx@linutronix.de> writes:
> > >
> > >  - move long running handlers out of the hard interrupt context
> > 
> > I'm not sure I'm really looking forward to this brave new world
> > of very long running interrupt handlers. e.g. what do you
> > do for example when some handler blocks for a very long time?
> 
> We have this issue today with some irqs (USB is known for issue here...)
> 
> So I don't think this is a big issue, and in the end, a better idea as
> it might force us to confront some of the big abusers and fix them.

Not sure I follow? You're saying you want to first allow very long running
IRQ handlers and then after the fact somehow fix them?  Sounds like a weird
proposal to be honest.

The problem of course is that if you have such a very slow hardirq (let's
say one that runs for tens of ms) that what happens when another
interrupt comes in? How deep is your hardware queue?  Or will you 
just lose events in that case?

I suspect in the end you'll need another "fast interrupt" anyways
if the hardware queue is not deep enough to buffer at the software
side. Sounds a bit like the existing "interrupts" vs "softirq" 
doesn't it?

So I'm just not sure what the "slow interrupt handler" will give
you longer term. It just sounds like a redundant concept to me.

The other issue is that if you allow sleeping locks in the interrupt
handler what guarantee is that it won't block for even longer than
tens of milliseconds? And lose even more events.

-Andi

-- 
ak@linux.intel.com
