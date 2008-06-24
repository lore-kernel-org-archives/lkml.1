Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYFXMZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYFXMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYFXMZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:25:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYFXMZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:25:17 -0400
Subject: Re: [PATCH 1/3] sched: enable interrupts and drop rq-lock
	duringnewidle balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       David Bahi <DBahi@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <4860BB14.BA47.005A.0@novell.com>
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
	 <20080623230440.31515.97377.stgit@lsg.lsg.lab.novell.com>
	 <1214302405.4351.21.camel@twins>  <4860BB14.BA47.005A.0@novell.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 14:24:59 +0200
Message-Id: <1214310299.4351.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 07:15 -0600, Gregory Haskins wrote:
> >>> On Tue, Jun 24, 2008 at  6:13 AM, in message <1214302405.4351.21.camel@twins>,
> Peter Zijlstra <peterz@infradead.org> wrote: 
> > On Mon, 2008-06-23 at 17:04 -0600, Gregory Haskins wrote:
> >> We do find_busiest_groups() et. al. without locks held for normal balancing,
> >> so lets do it for newidle as well.  It will allow other cpus to make
> >> forward progress (against our RQ) while we try to balance and allow 
> >> some interrupts to occur.
> > 
> > Is running f_b_g really that expensive? 
> 
> According to our oprofile data, yes.  I speculate that it works out that way because most newidle
> attempts result in "no imbalance".  But we were spending ~60%+ time in find_busiest_groups()
> because of all the heavy-context switching that goes on in PREEMPT_RT.  So while f_b_g() is
> probably cheaper than double-lock/move_tasks(), the ratio of occurrence is off the charts in
> comparison. Prior to this patch, those occurrences were preempt-disabled/irq-disabled/rq->lock critical
> sections.
> 
> So while it is not clear if f_b_g() is the actual cost, it is a convenient (and legal, afaict) place to
> deterministically reduce the rq->lock scope.  Additionally, doing so measurably helps
> performance, so I think its a win.  Without this patch you have to hope the double_lock releases
> this_rq, and even so were not checking for the NEEDS_RESCHED. 

See, having had this information in the changelog to begin with would
have helped ;-)



