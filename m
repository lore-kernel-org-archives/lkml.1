Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYGXJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYGXJmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYGXJmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:42:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYGXJmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:42:06 -0400
Date: Thu, 24 Jul 2008 11:41:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: petkovbb@gmail.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [lockdep warning] INFO: inconsistent lock state,
	serial8250_interrupt(), &port_lock_key
Message-ID: <20080724094154.GA20128@elte.hu>
References: <20080723093332.GA22109@elte.hu> <20080723093604.GA29817@elte.hu> <20080724065329.GE17724@gollum.tnic> <20080724071210.GA2738@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724071210.GA2738@gollum.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> On Thu, Jul 24, 2008 at 08:53:29AM +0200, Borislav Petkov wrote:
> > On Wed, Jul 23, 2008 at 11:36:04AM +0200, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > =================================
> > > > [ INFO: inconsistent lock state ]
> > > > 2.6.26-tip-06509-gb4ebc67-dirty #13600
> > > > ---------------------------------
> > > 
> > > the upstream component of that is: v2.6.26-6077-gc010b2f
> > > 
> > > i.e. my suspicion is that this got introduced via the recent tty 
> > > changes.
> > 
> > Hi,
> > 
> > i hit the same warning here. How about the following fix (this is at least what
> > i think happens):
> > --
> > 
> > serial8250_startup() might unconditionally enable irqs after releasing
> > &up->port.lock while we're still servicing an interrupt.
> 
> Actually, this explanation is not correct - it should be more like:
> 
> serial8250_startup() doesn't disable interrupts while taking the 
> &up->port.lock which might race against the interrupt handler 
> serial8250_interrupt(), which when entered, will deadlock waiting for 
> the lock to be released.

thanks Borislav, your patch seems to have done the trick.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
