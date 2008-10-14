Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbYJNTCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbYJNTCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYJNTCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:02:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36472
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbYJNTCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:02:39 -0400
Date: Tue, 14 Oct 2008 12:02:15 -0700 (PDT)
Message-Id: <20081014.120215.101891203.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: sparc64: Optimized immediate value implementation build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081014160848.GA20740@Krystal>
References: <20081014044758.GA20420@Krystal>
	<20081014.021506.18668456.davem@davemloft.net>
	<20081014160848.GA20740@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9EJ2qdq024512

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Tue, 14 Oct 2008 12:08:48 -0400

> * David Miller (davem@davemloft.net) wrote:
> > On the other hand, CONFIG_PSRWLOCK_LATENCY_TEST fails to build:
> > 
> >   CC      lib/psrwlock-latency-trace.o
> > lib/psrwlock-latency-trace.c: In function â€˜calibrate_get_cyclesâ€™:
> > lib/psrwlock-latency-trace.c:60: error: implicit declaration of function â€˜rdtsc_barrierâ€™
> > 
> > You could use sched_clock() or similar, we do have portable
> > interfaces by which to do these things.  And if we don't
> > have something fitting exactly what is needed here, add it :-)
> > 
> 
> I think the %tick register we get with get_cycles() on sparc64 is what
> is needed. Hopefully it's synchronized across CPUs on SMP systems ?

Yes, it is synchronized.

> On x86_64, rdtsc_barrier() issues a synchronizing instruction (cpuid)
> which serializes the instructions executed on the CPU so we do not
> execute rdtsc speculatively. Is reading %tick synchronized on sparc64 or
> not ?

It is synchronized on sparc64.

> Is there a similar %tick register on sparc32 ? I've read somewhere it's
> new to sparc v8. (http://cr.yp.to/hardware/sparc.html) So I guess we
> should simply disable this psrwlock latency tracer on SPARC32 ?

Not really.  There is only the time keeping device out in I/O space
which is very expensive to access.

This is why we don't have a sched_clock() implementation on sparc32.

> Probably that the best way to deal with this is to create a 
> 
> (generic code)
> HAVE_GET_CYCLES
>   def_bool n
> 
> (sparc, x86, powerpc... Kconfig)
> config SPARC64/X86/POWERPC
>   select HAVE_GET_CYCLES
> 
> And we can make CONFIG_PSRWLOCK_LATENCY_TEST depend on HAVE_GET_CYCLES.

Yes, something like that.

> > Also:
> > 
> > <stdin>:1421:2: warning: #warning syscall marker not implemented
> > <stdin>:1425:2: warning: #warning syscall trace not implemented
> > 
> > which should be fixed by the following patch:
> > 
> > sparc: Add sys_trace() and sys_marker() syscall table entries.
> > 
> 
> Thanks, I'll merge it :) I don't expect the userspace tracing to be in
> its final form, but it's good to add such support.

I think so too :)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
