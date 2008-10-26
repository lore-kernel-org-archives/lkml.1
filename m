Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbYJZUjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbYJZUjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 16:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYJZUjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 16:39:13 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:42277 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYJZUjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 16:39:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAKdxBElMQWro/2dsb2JhbACBdr07g08
Date: Sun, 26 Oct 2008 16:39:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC patch 05/15] get_cycles() : MIPS HAVE_GET_CYCLES_32
Message-ID: <20081026203908.GA15975@Krystal>
References: <20081016232729.699004293@polymtl.ca> <20081016234656.224625422@polymtl.ca> <20081026101826.GB24378@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081026101826.GB24378@linux-mips.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:32:29 up 144 days,  1:12,  9 users,  load average: 0.53, 0.59,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Baechle (ralf@linux-mips.org) wrote:
> On Thu, Oct 16, 2008 at 07:27:34PM -0400, Mathieu Desnoyers wrote:
> 
> > partly reverts commit efb9ca08b5a2374b29938cdcab417ce4feb14b54. Selects
> > HAVE_GET_CYCLES_32 only on CPUs where it is safe to use it.
> > 
> > Currently consider the "_WORKAROUND" cases for 4000 and 4400 to be unsafe, but
> > should probably add other sub-architecture to the blacklist.
> > 
> > Do not define HAVE_GET_CYCLES because MIPS does not provide 64-bit tsc (only
> > 32-bits).
> 
> [...]
> 
> > Index: linux-2.6-lttng/include/asm-mips/timex.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/asm-mips/timex.h	2008-10-16 12:25:47.000000000 -0400
> > +++ linux-2.6-lttng/include/asm-mips/timex.h	2008-10-16 12:34:18.000000000 -0400
> > @@ -29,14 +29,39 @@
> >   * which isn't an evil thing.
> >   *
> >   * We know that all SMP capable CPUs have cycle counters.
> > + *
> > + * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > + * HAVE_GET_CYCLES makes sure that this case is handled properly :
> > + *
> > + * Ralf Baechle <ralf@linux-mips.org> :
> > + * This avoids us executing an mfc0 c0_count instruction on processors which
> > + * don't have but also on certain R4000 and R4400 versions where reading from
> > + * the count register just in the very moment when its value equals c0_compare
> > + * will result in the timer interrupt getting lost.
> >   */
> 
> The usual workaround for this processor bug is to check if the value of
> the c0_count and c0_compare registers are close.  Clone, not identical to
> allow for the time skew in the pipeline.  If they are close, then
> execute the timer interrupt handler.  See also the R4000/R4400 errata.
> 
>   Ralf

Hrm, this sounds fragile. What happens if the instrumentation is added
in a irq-disabled code path ? We would be executing the timer interrupt
handler at this site synchronously when it should be deferred until the
irq off section is done. That would therefore behave like there is an
interrupt occuring in an irq off section.

OTOH, if we detect that get_cycles() is called with irqs off and decide
not to execute the irq handler, then the handler that would be expected
to be executed when the irq off section ends will simply be discarded
and a timer interrupt will be lost.

Or is there some way to raise the interrupt line from the CPU so it
behaves like a standard asynchronous interrupt ?

The other way around would be to add a check in local_irq_enable() to
verify that such work is pending, but it might have a significant
performance impact.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
