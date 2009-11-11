Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZKKCrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZKKCrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbZKKCrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:47:19 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46323 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZKKCrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:47:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=I7ieCs6YAVBZE4IXWnOfWD4i2pZEGbtAXc1UjRc45HNiS64PBfHEiUxpkgvq6RPyFY
         JVXPAvNQMMwmrvm59FxbRdIFWnb1mu3g0NndttIw2HdSI310J31a8uwXEcBE7SkM3yL/
         gj1dmRA2kbRNz3K9iGIDGodaKXDOy12DteLc0=
Subject: Re: [PATCH v7 03/17] tracing: add MIPS specific trace_clock_local()
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       zhangfx@lemote.com, zhouqg@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <4AF9A77E.6020908@caviumnetworks.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
	 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
	 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
	 <4AF9A77E.6020908@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 11 Nov 2009 10:47:16 +0800
Message-ID: <1257907636.2922.48.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2009-11-10 at 09:48 -0800, David Daney wrote:
> Wu Zhangjin wrote:
> [...]
> > + * trace_clock_local(): the simplest and least coherent tracing clock.
> > + *
> > + * Useful for tracing that does not cross to other CPUs nor
> > + * does it go through idle events.
> > + */
> > +u64 trace_clock_local(void)
> > +{
> > +	unsigned long flags;
> > +	u64 clock;
> > +
> > +	raw_local_irq_save(flags);
> > +
> > +	clock = mips_timecounter_read();
> > +
> > +	raw_local_irq_restore(flags);
> > +
> > +	return clock;
> > +}
> 
> Why disable interrupts?
> 

I got it from kernel/trace/trace_clock.c:

/*
 * trace_clock_local(): the simplest and least coherent tracing clock.
 *
 * Useful for tracing that does not cross to other CPUs nor
 * does it go through idle events.
 */
u64 notrace trace_clock_local(void)
{
        unsigned long flags;
        u64 clock;

        /*
         * sched_clock() is an architecture implemented, fast, scalable,
         * lockless clock. It is not guaranteed to be coherent across
         * CPUs, nor across CPU idle events.
         */
        raw_local_irq_save(flags);
        clock = sched_clock();
        raw_local_irq_restore(flags);

        return clock;
}

> Also you call the new function mips_timecounter_read().  Since 
> sched_clock() is a weak function, you can override the definition with a 
> more accurate version when possible.  Then you could just directly call 
> it here, instead of adding the new mips_timecounter_read() that the 
> '[PATCH v7 02/17] tracing: add mips_timecounter_read() for MIPS' adds.
> 

Yes, I have tried to override the sched_clock(), but failed on
booting(just hang there). and also, as you know, this version of
mips_timecounter_read() will bring us some overhead, I think it's not a
good idea to enable it for the whole system, so, I only enable it for
ftrace.

Regards,
	Wu Zhangjin

