Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZB0HTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZB0HTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZB0HTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:19:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbZB0HTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:19:08 -0500
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, jonathan@jonmasters.org
In-Reply-To: <20090226214514.f8a58731.akpm@linux-foundation.org>
References: <20090226131336.423054348@linutronix.de>
	 <20090226131719.760899560@linutronix.de>
	 <20090226153216.5db66bc3.akpm@linux-foundation.org>
	 <20090226212752.332ba546@infradead.org>
	 <20090226214514.f8a58731.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 08:18:33 +0100
Message-Id: <1235719113.4948.1252.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 21:45 -0800, Andrew Morton wrote:
> On Thu, 26 Feb 2009 21:27:52 -0800 Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > > 
> > > Bearing in mind that the driver might choose to split the IRQ handling
> > > between hard-irq context fastpath and process-context slowpath (I
> > > hope), and that each path might want to take the same lock.
> > > 
> > 
> > 
> > Realistically, for the "we go threaded interrupts" case (which is
> > opt-in), I think the only sane option is
> > * the quickhandler runs with irqs off
> > * the "slow" threaded handler runs with irqs on
> > And we guarantee both of these conditions from the core, to the point
> > that I think we should not allow any other combination.
> > 
> > This also should be fine for basically all cases; the quick handler
> > really needs to be quick so irq off makes sense, and the slow handler
> > can, worst case, turn off interrupts by itself, but normally is
> > preemptable etc etc.
> 
> I was actually kinda surprised by the patch - it needs moderate changes
> to each driver.  I'd have thought that it would be possible to arrange for
> _all_ drivers to have their interrupt handlers automagically called from
> process context with no driver changes.
> 
> Did anyone ever try that?  I think they did...

Yes, current preempt-rt does exactly that, as mentioned in the
changelog. That same changelog also mentions why this isn't such a hot
idea:


"The implementation provides an opt-in mechanism to convert drivers to
the threaded interrupt handler model contrary to the preempt-rt patch
where the threaded handlers are enabled by a brute force switch. The
brute force switch is suboptimal as it does not change the interrupt
handler -> tasklet/softirq interaction problems, but was the only way
which was possible for the limited man power of the preempt-rt
developers."


So the idea is that we want people to re-think and change their
interrupt routines to take advantage of the benefits of threaded
interrupts and avoid the endless context switching between threaded
interrupts handler, softirq/tasklet/workqueue contexts, which preempt-rt
now has.

The only way to avoid that is by pushing all softirq/tasklet/worklet
code into the threaded handler, and the only way to do that is by
reworking the drivers.

Since there are too many drivers to count on our few hands, we need an
opt-in, so that we can gradually migrate towards this scheme.



