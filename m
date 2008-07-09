Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYGILRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYGILRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbYGILRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:17:30 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:35090 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757172AbYGILR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:17:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rqJG5JplRq7ZbM0QujE1D44Ra+e3pYesNLMePXMSGrM0rlKRr2byqeVazpaBHsTdyMoLl8+4/VfIUUoQVEVr7inKkdqO+pKSsale55lWVdy1ln5ubnWn4bGWHUDkI8AbKAHUFCrEtkav/YayWhcXMCsZ8x/2YUSloKQ3XV9gi/g=  ;
X-YMail-OSG: rbD3I0AVM1kv9SFOhglwJbMCLdrSZHV3.tpH1wkDbCF39PcMI4DSDlHrNb8C0l3qZoxiOXB63NuHJyoBDbkjxkOwfDA3PyM51MdlZTBdFHcPSCG3fDhWoIUp6t5bT4_0dXc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH 2/3] sched: terminate newidle balancing once at least one task has moved over
Date: Wed, 9 Jul 2008 21:17:01 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, rostedt@goodmis.org, peterz@infradead.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com> <200807091809.52293.nickpiggin@yahoo.com.au> <48746084.BA47.005A.0@novell.com>
In-Reply-To: <48746084.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092117.01669.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2008 20:53, Gregory Haskins wrote:
> >>> On Wed, Jul 9, 2008 at  4:09 AM, in message
>
> <200807091809.52293.nickpiggin@yahoo.com.au>, Nick Piggin
>
> <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 08 July 2008 22:37, Gregory Haskins wrote:
> >> >>> On Tue, Jul 8, 2008 at  1:00 AM, in message
> >>
> >> <200807081500.18245.nickpiggin@yahoo.com.au>, Nick Piggin
> >>
> >> <nickpiggin@yahoo.com.au> wrote:
> >> > On Saturday 28 June 2008 06:29, Gregory Haskins wrote:
> >> >> Inspired by Peter Zijlstra.
> >> >>
> >> >> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> >> >
> >> > What happened to the feedback I sent about this?
> >> >
> >> > It is still nack from me.
> >>
> >> Ah yes.  Slipped through the cracks...sorry about that.
> >>
> >> What if we did "if (idle == CPU_NEWLY_IDLE && need_resched())" instead?
> >
> > Isn't that exactly the same thing
>
> Not quite.  The former version would break on *any* succesful enqueue (as a
> result of a local move_task as well as a remote wake-up/migration).  The
> latter version will only break on the the remote variety.  You were
> concerned about stopping a move_task operation early because it would
> reduce efficiency, and I do not entirely disagree. However, this really
> only concerns the local type (which have now been removed).
>
> Remote preemptions should (IMO) always break immediately because it would
> have been likely to invalidate the f_b_g() calculation anyway, and
> low-latency requirements dictate its the right thing to do.

I thought this was about newidle balancing? Tasks are always going to
be coming from remote runqueues, aren't they?


> > because any task will preempt the idle thread?
>
> During NEWIDLE this is a preempt-disabled section because we are still in
> the middle of a schedule(). Therefore there will be no involuntary
> preemption and that is why we are concerned with making sure we check for
> voluntary preemption.  The move_tasks() will run to completion without this
> patch.  With this patch it will break the operation if someone tries to
> preempt us.

Firstly, won't the act of pulling tasks set the need_resched condition?

Secondly, even if it does what you say, what exactly would be the difference
between blocking a newly moved task from running and blocking a newly woken
task from running? Either way you introduce the same worst case latency
condition.


> I'll keep an open mind but I am pretty sure this is something we should be
> doing. As far as I can tell, there should be no downside with this second
> version. 

I don't think it has really been thought through that well. So I'm still
against it.

> As a compromise we could put an #ifdef CONFIG_PREEMPT around this 
> new logic, but I don't think it is strictly necessary.

That's not very nice. It's reasonable to run with CONFIG_PREEMPT but not
blindly want to trade latency for throughput.
