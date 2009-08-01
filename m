Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZHATjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZHATjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 15:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZHATjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 15:39:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZHATjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 15:39:44 -0400
Message-ID: <4A7499BA.2000405@zytor.com>
Date: Sat, 01 Aug 2009 12:38:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2009 12:28 PM, Linus Torvalds wrote:
> 
> Hmm.
> 
> I just noticed another issue on x86 code generation, since I was looking 
> at assembly language generation due to the do_sigaltstack() kernel stack 
> info leak thing.
> 
> Our "get_current()" seriously sucks now that it's a per-cpu variable.
> 
> Look at the code generated for something like
> 
> 	current->sas_ss_sp = (unsigned long) ss_sp;
> 	current->sas_ss_size = ss_size;
> 
> and notice how the code really really sucks:
> 
>         movq %gs:per_cpu__current_task,%rcx
>         movq    %rdx, 1152(%rcx)
>         movq %gs:per_cpu__current_task,%rdx
>         movq    %rax, 1160(%rdx)
> 
> because it reloads that silly per-cpu variable every time, because the 
> assembler has a constraint of
> 
> 	"m" (per_cpu__current_task)
> 
> and so gcc is worried that the stores will invalidate the result of the 
> load from the per-cpu variable.
> 
> I don't know how to fix that _well_, but here's a not-so-very-pretty patch 
> that seems to shave off 4.5kB from my kernel, and gives gcc much better 
> scheduling for 'current' and 'thread_info' because now it can load them 
> early - and cache them - even in the presense of stores.
> 

This is clearly better... now the semi-obvious question becomes if there
is any way we can get compiler support to do better and migrate to that
as the compiler allows.  In particular, if I remember right the problem
with using __thread for percpu was exactly that the current cpuness can
change almost anywhere, unless preemption is disabled.

I'm wondering if we could use __thread or something like it for the
stable perthreads, perhaps with additional compiler hints.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

