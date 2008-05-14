Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbYENHM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbYENHM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYENHL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:11:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:50290 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYENHL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:11:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sWGf3Oh3vm2oZJAUwewXgbuuMfNfxSIFPMez3QS+FJGx3VyJ8Ok3lHoVPEmo90fdgOxHtGiHvefpTJsSbLnL/wo/oXAroTyCaGAvSp34I1Sm7jNYWWcMsHp36TuBulwm6eSHc/Duzq9Pf9J9/gtJ22LUQAlxfo7R9iKTy/txP48=
Message-ID: <19f34abd0805140011ybee42c7mf78d1ae97b234460@mail.gmail.com>
Date: Wed, 14 May 2008 09:11:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Cc: "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "=?UTF-8?Q?S.=C3=87a=C4=9Flar_Onur?=" <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, "Matt Mackall" <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080514065605.GB21369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513204206.GA17781@damson.getinternet.no>
	 <20080514065605.GB21369@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 14, 2008 at 8:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
>  > Hi,
>  >
>  > Recap: powertop shows between 200-400 wakeups/second with the
>  > description "<kernel IPI>: Rescheduling interrupts" when all
>  > processors have load (e.g. I need to run two busy-loops on my 2-CPU
>  > system for this to show up).
>
>  ok, could you try the fix below? It was a mistake to make mwait use
>  dependent on power considerations - on a desktop CPU it is unlikely to
>  use more power than a simple HLT - and the IPIs are extra scheduling
>  latency and extra power used.

This fixes it for the desktop machine at least. I guess I should try
on the laptop as well, but that will have to wait. Time for school :-)

Thanks.

Vegard

>  -------------->
>  Subject: x86: remove mwait C-state capability
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Wed May 14 08:47:40 CEST 2008
>
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  ---
>   arch/x86/kernel/process.c |   11 +----------
>   1 file changed, 1 insertion(+), 10 deletions(-)
>
>  Index: linux/arch/x86/kernel/process.c
>  ===================================================================
>  --- linux.orig/arch/x86/kernel/process.c
>  +++ linux/arch/x86/kernel/process.c
>  @@ -99,15 +99,6 @@ static void mwait_idle(void)
>                 local_irq_enable();
>   }
>
>  -
>  -static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
>  -{
>  -       if (force_mwait)
>  -               return 1;
>  -       /* Any C1 states supported? */
>  -       return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
>  -}
>  -
>   /*
>   * On SMP it's slightly faster (but much more power-consuming!)
>   * to poll the ->work.need_resched flag instead of waiting for the
>  @@ -131,7 +122,7 @@ void __cpuinit select_idle_routine(const
>                         " performance may degrade.\n");
>         }
>   #endif
>  -       if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
>  +       if (cpu_has(c, X86_FEATURE_MWAIT)) {
>                 /*
>                  * Skip, if setup has overridden idle.
>                  * One CPU supports mwait => All CPUs supports mwait
>



-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
