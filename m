Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZADOpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZADOpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 09:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZADOpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 09:45:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZADOpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 09:45:41 -0500
Date: Sun, 4 Jan 2009 15:44:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86: cpumask: some more cpumask cleanups
Message-ID: <20090104144454.GA1132@elte.hu>
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104131759.865331000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Here's some more cpumask cleanups.
> 
>     ia64: cpumask fix for is_affinity_mask_valid()
>     cpumask: update local_cpus_show to use new cpumask API
>     cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
>     x86: cleanup remaining cpumask_t ops in smpboot code
>     x86: clean up speedstep-centrino and reduce cpumask_t usage
>     cpumask: Replace CPUMASK_ALLOC etc with cpumask_var_t.
>     cpumask: convert struct cpufreq_policy to cpumask_var_t.
>     cpumask: use work_on_cpu in acpi/cstate.c
>     cpumask: use cpumask_var_t in acpi-cpufreq.c
>     cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
>     cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
> 
> This version basically splits out the changes to make it more 
> bisectable, and has been patch-wise compile/boot tested.  Updated stats 
> are below.

ok, i've picked them up into tip/cpus4096:

1d1a70e: cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
4d30e6b: cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
0771cd4: cpumask: use cpumask_var_t in acpi-cpufreq.c
9fa9864: cpumask: use work_on_cpu in acpi/cstate.c
a2a8809: cpumask: convert struct cpufreq_policy to cpumask_var_t
ee557bd: cpumask: replace CPUMASK_ALLOC etc with cpumask_var_t
3744123: x86: clean up speedstep-centrino and reduce cpumask_t usage
c2d1cec: x86: cleanup remaining cpumask_t ops in smpboot code
588235b: cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
3be8305: cpumask: update local_cpus_show to use new cpumask API
d3b66bf: ia64: cpumask fix for is_affinity_mask_valid()

( Sidenote, your mail scripts have a bug that do this to the Subject line:

    Subject: [PATCH 05/11] x86: clean up speedstep-centrino and reduce 
    cpumask_t usage From: Rusty Russell <rusty@rustcorp.com.au>

  i've fixed them up manually so that Rusty is in the Author field. )


> The number of stack hogs have been significantly reduced:
> 
> ====== Stack (-l 500)
>     1 - allyesconfig-128
>     2 - allyesconfig-4k
> 
>   .1.    .2.    ..final..
>     0  +1032   1032      .  flush_tlb_page
>     0  +1024   1024      .  kvm_reload_remote_mmus
>     0  +1024   1024      .  kvm_flush_remote_tlbs
>     0  +1024   1024      .  flush_tlb_mm
>     0  +1024   1024      .  flush_tlb_current_task

Quite good! Can we fix those TLB flush cpumask uses too?

> And the overall memory usage is becoming quite less affected by changing
> NR_CPUS from 128 to 4096:
[...]
>         .1.       .2.    ..final..
>    11436936  +4167424    15604360   +36%  .bss

.bss seems to account for ~80% of the increase. Are these static cpumasks, 
or do we still have NR_CPUS arrays around?

	Ingo
