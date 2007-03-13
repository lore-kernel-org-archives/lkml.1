Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbXCMGLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbXCMGLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbXCMGLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:11:20 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:62020 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbXCMGLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:11:18 -0400
Message-ID: <45F63F8D.6000007@hitachi.com>
Date: Tue, 13 Mar 2007 15:07:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       mbligh@google.com, Satoshi Oshima <soshima@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       Hideo Aoki <haoki@redhat.com>
Subject: Re: Djprobes questions
References: <20070312223749.GA22280@Krystal>
In-Reply-To: <20070312223749.GA22280@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
> Hi Masami,
> 
> I recently had to add support for inline code patching on i386 to my
> marker infrastructure. Clearly, it looks like what is done in djprobes,
> with the main difference that I only patch the immediate value of a 2
> bytes "load immediate" instruction.

That's interesting.

> I think I found a solution to one of the main issues with djprobes : it
> currently has to wait for each CPU to hit the probe before being sure
> that it's safe to patch the code with something else than an int3. This
> is due to PIII errata 49, which says that a CPU much execute a
> serializing instruction before executing cross-modified code.

Hmm, djprobe already might not wait for each CPU to hit the probe
point. It just wait scheduler synchronization instead of that.
And after that, it issues cpuid for cache serialization before
executing cross-modified code.

The most difficult point of the djprobe is that it has to replace
"live" instructions. So we must check other processors not to run
those instructions carefully.

> Here is what I do : While I use a breakpoint to fall in a trap for the
> CPUs that hit the site currently being modified, I also send an IPI to
> all CPUs so they execute cpuid. Once it returns, I am sure that every
> CPU has executed a serializing instruction, which enables me to go on
> with the complete code modification, therefore removing the initial
> breakpoint.

I think its OK. That is the same way which I've done in djprobe.

> Here is my code :
> 
> http://ltt.polymtl.ca/cgi-bin/gitweb.cgi?p=linux-2.6-lttng.git;a=blob;f=arch/i386/kernel/marker.c;h=89b06f02f0966685be260d6364a0dd94c3d14456;hb=v2.6.20-lttng
> 
> (Comments are welcome)
> 
> On a second note, looking at the djprobes code triggered some question 
> in my mind about the safety of using a worker thread to "make sure"
> every interrupt context has returned (so there is no IP pointing into
> the modified code). The following scenario might be possible : an
> interrupt handler (or trap handler) reenables interrupts, does irq_exit()
> or nmi_exit() (which reenables preemption) but does not do iret yet. My
> understanding is that it could be scheduled and have a return IP
> pointing to the code that is being modified. Am I right ?

Same idea was already discussed. It might work on normal kernel,
but, unfortunately, it doesn't work on preemptive kernel. And actually,
that idea is same as synchronize_sched(). So, I've used it on normal
kernel. In the case of preemptive kernel, currently, I'm using
freeze_processes() suggested by Ingo.

Anyway, I and Satoshi are developing a static analysis tool to
check whether target instructions can be replaced by long jump.
I'd like to release djprobe patch against latest kernel after
developed it.

Best regards,

-- 
Masami HIRAMATSU
Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


