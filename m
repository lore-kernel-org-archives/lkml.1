Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYGaQdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYGaQdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYGaQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:33:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38435 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751177AbYGaQdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:33:00 -0400
Message-ID: <4891E938.40708@sgi.com>
Date: Thu, 31 Jul 2008 09:32:56 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 0/3] dyn_array support #2
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807300311.48510.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com> <200807302109.21519.yhlu.kernel@gmail.com>
In-Reply-To: <200807302109.21519.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> please check the patches adding dyn_array and nr_irqs #2
> 
> Thanks
> 
> YH


It appears that the primary difference between your patch and Eric's
is that you estimate the number of IRQ's required based on the number
of cpus present, while Eric's patch grows the list based on the IRQ's
being requested.  For soon to be "power" desktop systems (say dual 8 core
Nahalem's w/HT), you're reserving IRQ's for 32 cpus on a system which
probably has one I/O bus (or maybe two).  A dual socket Larabbee system
will have 256 cpus.  An SGI UV system has more of a "building block"
approach, where you can grow all three (cpus, memory, I/O) independently.

One other very nice feature of Eric's approach is that the new "IRQ"
struct being requested can be created in "node local" memory, cutting
down significantly the number of "cross node" accesses.

Plus, I still like Ingo's suggestion to not change NR_IRQS ==> nr_irqs.
CONFIG_ARCH_HAS_DYNAMIC_IRQS spells out exactly what NR_IRQS means.
(Even more accurate would be CONFIG_ARCH_HAS_DYNAMIC_NR_IRQS.)

The DEFINE_DYN_ARRAY could be the following.  (Changing general purpose
DYN_ARRAY to specifically purposed IRQ_ARRAY.)

#ifdef CONFIG_ARCH_HAS_DYNAMIC_IRQS
#define DEFINE_IRQ_ARRAY <new variable irq array [or list] definition>
#else
#define DEFINE_IRQ_ARRAY <old static irq array>
#endif

For the immediate problem, unraveling the code merge back to IRQ's based
on NR_IOAPICS would seem to be the least intrusive.

Thanks,
Mike
