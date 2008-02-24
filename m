Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYBXRxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYBXRxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYBXRxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:53:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43655 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbYBXRxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:53:07 -0500
Date: Sun, 24 Feb 2008 18:52:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
Message-ID: <20080224175251.GA17441@elte.hu>
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se> <20080224135720.GA5323@elte.hu> <18369.35401.678391.183329@harpo.it.uu.se> <18369.43239.964660.62249@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18369.43239.964660.62249@harpo.it.uu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> 
> That turned out to be very illuminating:
> 
> --- dmesg-2.6.24-git7	2008-02-24 18:01:25.295851000 +0100
> +++ dmesg-2.6.24-git8	2008-02-24 18:01:25.530358000 +0100
> ...
>  CPU: After generic identify, caps: 00000003 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>  
>  CPU: After all inits, caps: 00000003 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> +CPU: After applying cleared_cpu_caps, caps: 00000013 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 
> Notice how the TSC cap bit goes from Off to On.
> 
> (The first two lines are printout loops from -git7 forward-ported
> to -git8, the third line is the same printout loop added just after
> the xor-with-cleared_cpu_caps[] loop.)
> 
> Here's how the breakage occurs:
> 1. arch/x86/kernel/tsc_32.c:tsc_init() sees !cpu_has_tsc,
>    so bails and calls setup_clear_cpu_cap(X86_FEATURE_TSC).
> 2. include/asm-x86/cpufeature.h:setup_clear_cpu_cap(bit) clears
>    the bit in boot_cpu_data and sets it in cleared_cpu_caps
> 3. arch/x86/kernel/cpu/common.c:identify_cpu() XORs all caps
>    in with cleared_cpu_caps
>    HOWEVER, at this point c->x86_capability correctly has TSC
>    Off, cleared_cpu_caps has TSC On, so the XOR incorrectly
>    sets TSC to On in c->x86_capability, with disastrous results.
> 
> The real bug is that clearing bits with XOR only works if the bits are 
> known to be 1 prior to the XOR, and that's not true here.
> 
> A simple fix is to convert the XOR to AND-NOT instead. The following 
> patch does that, and allows my 486 to boot 2.6.25-rc kernels again.

thanks for the fix, i've queued it up. The breakage was introduced via:

  commit 7d851c8d3db0f79b92c8b14361779ede8acd2488
  Author: Andi Kleen <ak@suse.de>
  Date:   Wed Jan 30 13:33:20 2008 +0100

    x86: add framework to disable CPUID bits on the command line

    There are already various options to disable specific cpuid bits
    on the command line. They all use their own variable. Add a generic
    mask to make this easier in the future.

    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

	Ingo
