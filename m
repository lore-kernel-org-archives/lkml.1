Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYHVGFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYHVGFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHVGFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:05:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57386 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbYHVGFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:05:39 -0400
Date: Fri, 22 Aug 2008 08:05:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU hotplug
Message-ID: <20080822060520.GG14110@elte.hu>
References: <48AD7F80.76E4.0078.0@novell.com> <20080821130259.GA22887@elte.hu> <20080821131652.GC13011@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821131652.GC13011@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 21.08.08 15:02:59, Ingo Molnar wrote:
> > 
> > * Jan Beulich <jbeulich@novell.com> wrote:
> > 
> > > Converting __cpuinit functions called out of init_amd() (and similar 
> > > others) to __init (and making them subject of xxx_initcall() handling 
> > > isn't valid, as they would no longer be called for hot plugged CPUs.
> > > 
> > > Further, since it's likely that in virtualized environments the MSR 
> > > write would at best be ignored, I'd also recommend using the 
> > > fault-safe accessors here *and* check that the bit actually got set 
> > > before setting PCI_HAS_IO_ECS (one would obviously have to BUG() when 
> > > hot-plugged CPUs fail to set the bit when those available at boot 
> > > successfully did so).
> > 
> > hm, which patch is this exactly, and in what tree? It's not upstream nor 
> > in -tip.
> 
> Probably this in the mainline kernel is meant:
> 
> commit 3a27dd1ce5de08e21e0266ddf00e6f1f843bfe8b
> Author: Robert Richter <robert.richter@amd.com>
> Date:   Thu Jun 12 20:19:23 2008 +0200
> 
>     x86: Move PCI IO ECS code to x86/pci
>     
>     "Form follows function". Code is now where it belongs to.
>     
>     Signed-off-by: Robert Richter <robert.richter@amd.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> The problem is code like this:
> 
> +static int __init enable_pci_io_ecs(void)
> +{
> +       /* assume all cpus from fam10h have IO ECS */
> +        if (boot_cpu_data.x86 < 0x10)
> +               return 0;
> +       on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1, 1);
> +       pci_probe |= PCI_HAS_IO_ECS;
> +       return 0;
> +}
> 
> It is only called during the setup and if the cpu is enabled. I intend 
> to rewrite the cpu setup code using cpu notifiers.

ok. Unfortunately the revert looks quite non-trivial for v2.6.27. Could 
we have some _really_ minimal fix for v2.6.27?

	Ingo
