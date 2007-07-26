Return-Path: <linux-kernel-owner+w=401wt.eu-S936829AbXGZUlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936829AbXGZUlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbXGZUlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:41:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764788AbXGZUlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:41:44 -0400
Date: Thu, 26 Jul 2007 13:41:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: IRQF_DISABLED problem
In-Reply-To: <20070726201355.GP19275@parisc-linux.org>
Message-ID: <alpine.LFD.0.999.0707261323180.3442@woody.linux-foundation.org>
References: <20070726201355.GP19275@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, Matthew Wilcox wrote:
> 
> I noticed that we only look at the first action in the chain when
> determining whether to re-enable local interrupts during handle_IRQ_event.

You can't really share an interrupt handler that wants to run with 
interrupts on with one that wants to run with them off.

That said, I think the whole IRQF_DISABLED thing should go away. It is 
total legacy crud, methinks - it used to be SA_INTERRUPT, and it's always 
worked the way IRQF_DISABLED works now: it only looks at the first one in 
the chain.

> But we don't try to exclude sharing interrupts with mixtures of
> IRQF_DISABLED set and clear.

I think you should just consider it to be a "if you mix them, you get 
randomr results".

> I just tried to do that locally, and one
> of my USB ports disappears, because it shares an interrupt with qla2xxx
> which sets IRQF_DISABLED, and UHCI doesn't.

There really is no excuse for using IRQF_DISABLED unless you're something 
like a system device (like the timer interrupt or similar) and you have an 
exclusive irq handler. A SCSI driver almost certainly has no business 
doing it.

Generally, I would say that "IRQF_DISABLED | IRQF_SHARED" is an insane 
combination, but a quick grep shows that it's distressingly common.

The real fix is to just leave it as it is. It's always worked that way. 
IRQF_DISABLED basically cannot have any sane behaviour in the presense of 
mixing.

		Linus
