Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbXGMCNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbXGMCNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXGMCNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:13:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbXGMCNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:13:41 -0400
Date: Thu, 12 Jul 2007 19:13:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>
Subject: Re: [patch] x86_64: Avoid too many remote cpu references due to
 /proc/stat
Message-Id: <20070712191317.41217c7a.akpm@linux-foundation.org>
In-Reply-To: <20070713000615.GA11942@localdomain>
References: <20070713000615.GA11942@localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 17:06:16 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Too many remote cpu references due to /proc/stat.
> 
> On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
> On every call to kstat_irqs, the process brings in per-cpu data from all
> online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
> results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
> /proc/stat is parsed by common commands like top, who etc, causing
> lots of cacheline transfers

(256+32*63) * 63 = 143136

Do you have any actual numbers for how much this hurts?

> This statistic seems useless. Other 'big iron' arches disable this.
> Can we disable computing/reporting this statistic?  This piece of
> statistic is not human readable on x86_64 anymore,

Did you consider using percpu_counters (or such) at interrupt-time? 
(warning: percpu_counters aren't presently interrupt safe).

> If not, can we optimize computing this statistic so as to avoid
> too many remote references (patch to follow)

You other patch is a straightforward optimisation and should just be merged.

But afaict it will only provide a 2x speedup which I doubt is sufficient?



Another thought is: how many of the NR_IRQS counters are actually non-zero?
Because a pretty obvious optimisation would be to have a global
bitmap[NR_IRQS] and do

	if (!bitmap[irq])
		bitmap[irq] = 1;

at interrupt-time, then just print a "0" for the interrupts which have
never occurred within show_stats().

