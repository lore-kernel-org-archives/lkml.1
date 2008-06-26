Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYFZPst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYFZPst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYFZPsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:48:41 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41324 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYFZPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:48:40 -0400
Date: Thu, 26 Jun 2008 08:48:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, josh@freedesktop.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: invoke RCU readers from irq handlers (timers)
Message-ID: <20080626154833.GB10859@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com> <20080622200638.GA25328@linux.vnet.ibm.com> <20080625192452.GA12754@linux.vnet.ibm.com> <20080626072239.GB3160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626072239.GB3160@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 09:22:39AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This patch allows torturing RCU from irq handlers (timers, in this 
> > case). A new module parameter irqreader enables such additional 
> > torturing, and is enabled by default.  Variants of RCU that do not 
> > tolerate readers being called from irq handlers (e.g., SRCU) ignore 
> > irqreader.
> > 
> > (No failures observed, but only short tests thus far.  And no failures 
> > observed thus far from about 10 hours of running stock rcutorture in 
> > parallel with 170 kernel builds on a two-CPU machine.)
> 
> applied to tip/core/rcu - thanks Paul.
> 
> > +static int irqreader = 1;	/* RCU readers from irq (timers). */
> 
> Good - this means that in bzImage type of tests (built-in rcutorture, no 
> modules) this new test variant will be activated by default, right?

Ah, I knew I was forgetting to test something...

OK, checked it out by booting with rcutorture.stat_interval=100 so that
I can see the statistics.  I enabled rcutorture after the machine booted
with "echo 1 > /proc/sys/kernel/rcutorture_runnable".  Then I saw the
following in dmesg:

rcu-torture: rtc: ffffffff8098b9a0 ver: 16961 tfle: 0 rta: 16961 rtaf: 0 rtf: 16922 rtmbe: 0 nt: 121139
rcu-torture: Reader Pipe:  93315610 6300 0 0 0 0 0 0 0 0 0
rcu-torture: Reader Batch:  93315670 6240 0 0 0 0 0 0 0 0 0
rcu-torture: Free-Block Circulation:  16960 16960 16960 16960 16959 16951 16943 16936 16928 16922 0

The "nt: 121139" is the count of the number of times that an RCU read-side
critical section has been invoked from an rcutorture timer handler.

So yes, it does work.  ;-)

							Thanx, Paul
