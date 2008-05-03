Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbYECK6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbYECK6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYECK5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:57:51 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:41593 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733AbYECK5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:57:50 -0400
Message-ID: <481C452B.10403@superbug.co.uk>
Date: Sat, 03 May 2008 11:57:47 +0100
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: hadi@cyberus.ca
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost>
In-Reply-To: <1209810775.6972.37.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jamal wrote:
> Peoplez,
>
> Ive narrowed down a problem i am having with an old P2 to commit
> 61c4628b538608c1a85211ed8438136adfeb9a95 with subject "x86, fpu: split
> FPU state from task struct - v5" (Authored by Suresh and committed by
> Ingo on Apr/19).
>
> In the process i learnt how painfully time consuming and boring a blind
> git bisect feast could be (the last time a kernel worked on the P2 was
> back in 2.6.23). I literally spent no less than 10 hours tracking this
> (Ok, I was chewing tobbaco in between running git bisect bad/good,
> compile, copy over kernel, spit here, reboot, test).
> Also this patch is so huge that given my lack of knowledge in the area,
> i couldnt do better bisecting to be more exact on what is causing this.
> i.e the patch is not bisect-friendly. 
> So the best i can do is have other people take it from here.
>
> I am able to reproduce the issue consistently on my laptop using qemu
> (which helped speed debugging a bit). I have also narrowed it down to
> include/asm-x86/i387.h::__save_init_fpu in (32 bit version) - it dies
> somewhere in calling the following line:
>
> ----
>         alternative_input(
>                 "fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
>                 "fxsave %[fx]\n"
>                 "bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
>                 X86_FEATURE_FXSR,
>                 [fx] "m" (tsk->thread.xstate->fxsave),
>                 [fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
> ----------
>
> The only thing that has changed there compared to good version is the
> last two lines. But that looks sane to me given the struct naming has
> changed. So i am suspecting the calling path perhaps not setting
> something or other.
>
>   
My guess would be that the jnc 1f is now wrong.

