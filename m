Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbXKPHJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbXKPHJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXKPHJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:09:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbXKPHJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:09:25 -0500
Date: Thu, 15 Nov 2007 23:08:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: disable preemption in delay_tsc()
Message-Id: <20071115230859.d9ccea20.akpm@linux-foundation.org>
In-Reply-To: <20071116061332.GF16273@elte.hu>
References: <200711150400.lAF40lIr020160@hera.kernel.org>
	<20071115194116.12c7a0f6@laptopd505.fenrus.org>
	<20071115195234.2dc8406d.akpm@linux-foundation.org>
	<20071116061332.GF16273@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 07:13:32 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > >     x86: disable preemption in delay_tsc()
> > > >     
> > > >     Marin Mitov points out that delay_tsc() can misbehave if it is 
> > > > preempted and rescheduled on a different CPU which has a skewed 
> > > > TSC. Fix it by disabling preemption.
> > > >  
> > > 
> > > this worries me.. this appears to effectively disable preemption 
> > > during udelay() and mdelay() loops... which are very obvious latency 
> > > inducers.
> > > 
> > > Now you can argue that if you're preemptible you should have used 
> > > msleep() and co, and I'll totally buy that.
> > > 
> > > 
> > > Maybe we should just check if we're still on the same cpu or 
> > > something, or have a cheap way to pin a process to a cpu.... but 
> > > both are longer term solutions.
> > 
> > Yes, we can do better.
> > 
> > But this bug can cause very rare failures in probably a large number 
> > of device drivers on a minorty of machines.  Ugly.  So I felt it best 
> > to plug it fast while people think about more sophisticated fixes.
> 
> how about using usleep() transparently if high-res timers are active and 
> we have !preempt_count()?

And CONFIG_PREEMPT, of course

> That would be a sufficient solution and would 
> avoid all the calibration and per-cpu-ness problems.

It sounds like it would work OK.  What is the setup cost for a usleep?  I'd
have thought that code which does something like

	while (i++ < 1000) {
		foo();
		udelay(1);
	}

would take qiute a bit longer with such a change?

