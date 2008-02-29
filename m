Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYB2Afc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYB2Afc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYB2AfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:35:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:61782 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYB2AfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:35:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=jFq//pw+VupblWyis5s8zfXe64ByBg03Af03no7I/x5KPe5/KmHxX22/jUPxLr32iKgy9gJqkfbDmbp/cz5ytm4eHQE3eZUhl18mDOYy0A2p2M6+H8uVUC26t8j/MhNrzcLTD41MvPlWNpC2UoznxJ8ASYe8vRnE3Zr1m/YiADw=
Date: Fri, 29 Feb 2008 02:32:24 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index
	calculation
Message-ID: <20080229003224.GA18821@ubuntu>
References: <20080224155515.GA24831@ubuntu> <20080224161814.GA29556@elte.hu> <20080224162653.GA30364@ubuntu> <20080225001816.GA2933@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225001816.GA2933@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo/x86-folks,

On Mon, Feb 25, 2008 at 02:18:16AM +0200, Ahmed S. Darwish wrote:
...
> 
> This thread's main bug no longer appears. There's a new bug though,
> but it looks nicer than the original ugly bug!. 
> 
> The new bug does *not* appear in mainline with the same patch. It's
> a panic, but this time on the _guest_ side (which is the same host's
> kernel).
>
> [    0.023996] CPU: Intel(R) Pentium(R) M processor 1500MHz stepping 05
> [    0.023996] Kernel panic - not syncing: Kernel compiled for Pentium+, requires TSC feature!
> [    0.023996] Pid: 0, comm: swapper Not tainted 2.6.25-rc2-00815-g3db3a05 #64
> 

The bug appeared in mainline due to the latest x86 merge. The commit
that caused the bug is not faulty though:

commit 12c247a6719987aad65f83158d2bb3e73c75c1f5
    x86: fix boot failure on 486 due to TSC breakage

    1. arch/x86/kernel/tsc_32.c:tsc_init() sees !cpu_has_tsc,
       so bails and calls setup_clear_cpu_cap(X86_FEATURE_TSC).
    2. include/asm-x86/cpufeature.h:setup_clear_cpu_cap(bit) clears
       the bit in boot_cpu_data and sets it in cleared_cpu_caps
    3. arch/x86/kernel/cpu/common.c:identify_cpu() XORs all caps
       in with cleared_cpu_caps
       HOWEVER, at this point c->x86_capability correctly has TSC
       Off, cleared_cpu_caps has TSC On, so the XOR incorrectly
       sets TSC to On in c->x86_capability, with disastrous results.

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f86a3c4..a38aafa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -504,7 +504,7 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 	/* Clear all flags overriden by options */
 	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] ^= cleared_cpu_caps[i];
+		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 

Now the commit fixed everything, and x86_capability shows the right
thing (TSC = off). 

On the lguest _guest_ side, 'cpu_has_tsc' is _always_ false (due to 
lguest using his own clocksource ?), thus a guest with a pentium+ 
cpu always panics with:

#ifdef CONFIG_X86_TSC
	if (!cpu_has_tsc)
		panic("Kernel compiled for Pentium+, requires TSC feature!");
#endif


In older kernels (2.6.23), the problem was also hidden using 'tsc_disable':

tsc.c:
	if (!cpu_has_tsc || tsc_disable)
		tsc_disable = 1;

bug.c:
#ifdef CONFIG_X86_TSC
	if (!cpu_has_tsc && !tsc_disable)
		panic("Kernel compiled for Pentium+, requires TSC feature!");
#endif


I've tried solving the problem with several tweaks including something like:

	/* If we're running on a pentium+, fake an enabled TSC to bypass
	 * kernel checks for processor bugs (see x86/cpu/bugs.c) */
	if (boot_cpu_data.x86 >= 5)
		setup_force_cpu_cap(X86_FEATURE_TSC);

with no luck at all. 

Any idea how to solve this problem in a right/mergeable way ?

Thank you,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

