Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbYISOUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbYISOUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYISOU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:20:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYISOU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:20:26 -0400
Subject: Re: How how latent should non-preemptive scheduling be?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <48D39312.9000400@yahoo.com>
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no>
	 <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no>
	 <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no>
	 <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no>
	 <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no>
	 <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no>  <48D39312.9000400@yahoo.com>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 16:20:05 +0200
Message-Id: <1221834006.5537.3.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-19 at 12:54 +0100, Sitsofe Wheeler wrote:
> Ingo Molnar wrote:
> > here's two quick howtos:
> > 
> >   http://redhat.com/~mingo/sched-devel.git/readme-tracer.txt
> >   http://redhat.com/~mingo/sched-devel.git/howto-trace-latencies.txt
> 
> These two files appear to be identical. Is this intentional?
> 
> Anyway after following your instructions a putting together a small 
> script to dice the output, I collated the 10 switches which took the 
> longest:
> 
> # Top ten longest switches
> # Rel TS Process   Abs TS
> 0.122161 hald-3423 1867.821170 ***
> 0.039438 <idle>-0  1867.379054
> 0.036318 hald-3423 1867.669009
> 0.031362 <idle>-0  1868.002762
> 0.030000 hald-3423 1867.699009
> 0.028933 <idle>-0  1867.529238
> 0.028539 <idle>-0  1867.228861
> 0.028196 <idle>-0  1867.128731
> 0.027763 <idle>-0  1868.101449
> 0.027513 <idle>-0  1867.028606
> 
> # tracer: sched_switch from around longest switch
> #
> #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> #              | |      |          |         |
>            <idle>-0     [00]  1867.608017:      0:140:R   +     3:115:S
>            <idle>-0     [00]  1867.608038:      0:140:R   +  3423:120:D
>            <idle>-0     [00]  1867.608045:      0:140:R ==>     3:115:R
>       ksoftirqd/0-3     [00]  1867.608048:      3:115:S ==>  3423:120:R
>              hald-3423  [00]  1867.629350:   3423:120:R   +  6096:120:S
>              hald-3423  [00]  1867.632691:   3423:120:R   +  3827:120:S
>              hald-3423  [00]  1867.669009:   3423:120:R   +  3998:120:S
>              hald-3423  [00]  1867.699009:   3423:120:R   +  6097:120:S
>           ***hald-3423  [00]  1867.821170:   3423:120:R ==>  6096:120:R
>         rhythmbox-6096  [00]  1867.821219:   6096:120:S ==>  6097:120:R
>         rhythmbox-6097  [00]  1867.821262:   6097:120:R   +  3826:120:S
>         rhythmbox-6097  [00]  1867.821289:   6097:120:S ==>  3826:120:R
>        pulseaudio-3826  [00]  1867.821332:   3826:120:R   +  6097:120:S
>        pulseaudio-3826  [00]  1867.821374:   3826:120:S ==>  6097:120:R
>         rhythmbox-6097  [00]  1867.821380:   6097:120:S ==>  3998:120:R
>         rhythmbox-3998  [00]  1867.821709:   3998:120:S ==>  3827:120:R
>        pulseaudio-3827  [00]  1867.824041:   3827:120:R   +  3826:120:S
> 

Its actually function tracer output I'm interested in.. that shows what
all its doing to make it take 120+ms.

I thought we had a wakeup latency tracer exacty like we have preempt and
irq off latency tracers, Steve, where'd that go?

> > sounds like potential SMM triggered latencies.
> 
> I have just gone away and read about the SMM ( 
> http://blogs.msdn.com/carmencr/archive/2005/08/31/458609.aspx ). If 
> you're right there is pretty much nothing that can be done about the 
> problem : (

Yeah, SMM/SMI is nasty stuff :-(

