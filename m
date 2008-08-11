Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYHKVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYHKVYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbYHKVX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:23:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33518
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbYHKVX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:23:58 -0400
Date: Mon, 11 Aug 2008 14:23:59 -0700 (PDT)
Message-Id: <20080811.142359.145735170.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: jkacur@gmail.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org
Subject: Re: [PATCH] BUG: using smp_processor_id() in preemptible
 [00000000] code: caller is __qdisc_run
From: David Miller <davem@davemloft.net>
In-Reply-To: <1218488979.15798.39.camel@lappy.programming.kicks-ass.net>
References: <520f0cf10808110611y62f6a4e2v94a0d0cde1d5d79d@mail.gmail.com>
	<20080811.140014.94581847.davem@davemloft.net>
	<1218488979.15798.39.camel@lappy.programming.kicks-ass.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 11 Aug 2008 23:09:38 +0200

> On Mon, 2008-08-11 at 14:00 -0700, David Miller wrote:
> > From: "John Kacur" <jkacur@gmail.com>
> > Date: Mon, 11 Aug 2008 15:11:46 +0200
> > 
> > > __qdisc_run() calls qdisc_restart() which calls
> > > handle_dev_cpu_collision(skb, dev, q); and then the problem shows up
> > > here:
> > > __get_cpu_var(netdev_rx_stat).cpu_collision++;
> > > 
> > > The solution is to disable interrupts around the above increment. Here
> > > is an attached patch to do so. (Thank's to Peter Zijlstra for help in
> > > the analysis and dropping the answer in my lap, so if I got it right
> > > it is due to his help, but if I messed it up, then I did that part all
> > > by myself.)
> > 
> > __qdisc_run() always runs in software interrupt context,
> > so I guess this is some problem with the -rt stuff running
> > software interrupts in threads?
> 
> Hmm, good point - and those threads should be cpu affine on -rt if I'm
> not mistaken. Steven, do you happen to remember details?

The key issue is whether those threads run software interrupts
in a compatible environment.  And such a proper environment allows
plain smp_processor_id() without any special preparations.
