Return-Path: <linux-kernel-owner+w=401wt.eu-S1764980AbXFESoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764980AbXFESoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbXFESoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:44:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57515 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898AbXFESoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:44:10 -0400
Message-ID: <4665AEE5.7040904@zytor.com>
Date: Tue, 05 Jun 2007 11:43:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
References: <20070522223828.GV11115@waste.org> <20070605090714.22bfcfd4.akpm@linux-foundation.org> <46658C41.9090105@zytor.com> <200706051837.22847.ak@suse.de>
In-Reply-To: <200706051837.22847.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> I don't think it's a good idea for the TSC. There are various
> setups where it is unreliable and also often simulators don't 
> implement it correctly. And it's always a valuable workaround
> to be able to turn it off.
> 

I dug some more into the TSC code, and found some other annoying stuff:

/*
 * Make an educated guess if the TSC is trustworthy and synchronized
 * over all CPUs.
 */
__cpuinit int unsynchronized_tsc(void)
{
        if (!cpu_has_tsc || tsc_unstable)
                return 1;
        /*
         * Intel systems are normally all synchronized.
         * Exceptions must mark TSC as unstable:
         */
        if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
                /* assume multi socket systems are not synchronized: */
                if (num_possible_cpus() > 1)
                        tsc_unstable = 1;
        }
        return tsc_unstable;
}

That's a vendor check foul.  That should be a CPU feature flag.

Looks like there is some work to be done here.

	-hpa
