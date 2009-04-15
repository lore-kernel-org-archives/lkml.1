Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbZDOFoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbZDOFoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZDOFop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:44:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbZDOFoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:44:44 -0400
Date: Wed, 15 Apr 2009 07:44:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415054417.GA5272@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414020544.GA3738@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > Gitweb:     http://git.kernel.org/linus/1c98aa7424ff163637d8321674ec58dee28152d4
> > Commit:     1c98aa7424ff163637d8321674ec58dee28152d4
> > Parent:     2e1c63b7ed36532b68f0eddd6a184d7ba1013b89
> > Author:     Linus Torvalds <torvalds@linux-foundation.org>
> > AuthorDate: Mon Apr 13 18:09:20 2009 -0700
> > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> > CommitDate: Mon Apr 13 18:09:20 2009 -0700
> > 
> >     Fix quilt merge error in acpi-cpufreq.c
> >     
> >     We ended up incorrectly using '&cur' instead of '&readin' in the
> >     work_on_cpu() -> smp_call_function_single() transformation in commit
> >     01599fca6758d2cd133e78f87426fc851c9ea725 ("cpufreq: use
> >     smp_call_function_[single|many]() in acpi-cpufreq.c").
> >     
> >     Andrew explains:
> >      "OK, the acpi tree went and had conflicting changes merged into it after
> >       I'd written the patch and it appears that I incorrectly reverted part
> >       of 18b2646fe3babeb40b34a0c1751e0bf5adfdc64c while fixing the resulting
> >       rejects.
> >     
> >       Switching it to `readin' looks correct."
> >     
> >     Acked-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > index 3e3cd3d..837c2c4 100644
> > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > @@ -277,7 +277,7 @@ static unsigned int get_measured_perf(struct cpufreq_policy *policy,
> >  	unsigned int perf_percent;
> >  	unsigned int retval;
> >  
> > -	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &cur, 1))
> > +	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &readin, 1))
> >  		return 0;
> 
> Ah, this might explain a few weird smp_processor_id() runtime 
> warnings i got a few hours ago in that area of code (but didnt 
> track it down at that time) when i updated to at around ~80a04d3.
> 
> (Never noticed the build warning - there's still too many of 
> them.)

No, that warning is back and triggered in overnight testing:

[   54.888193] BUG: using smp_processor_id() in preemptible [00000000] code: S99local/7753
[   54.888267] caller is smp_call_function_many+0x29/0x210
[   54.888309] Pid: 7753, comm: S99local Not tainted 2.6.30-rc1-tip #1750
[   54.888352] Call Trace:
[   54.888389]  [<c054d06d>] debug_smp_processor_id+0xcd/0xd0
[   54.888432]  [<c016e989>] smp_call_function_many+0x29/0x210
[   54.888477]  [<c0115860>] ? do_drv_write+0x0/0x70
[   54.888519]  [<c0115851>] drv_write+0x21/0x30
[   54.888559]  [<c0115e06>] acpi_cpufreq_target+0x146/0x310

fuller log below. I think this is because smp_call_function_many() 
was essentially unused before - an IPI function should not trigger 
this warning, it will naturally be called in preemptible context. 

Rusty?

	Ingo

----------------->
[   40.227336] Adding 4096564k swap on /dev/sda2.  Priority:-1 extents:1 across:4096564k 
[   43.958724] eth0: no IPv6 routers present
[   54.827389] CPUFREQ: ondemand sampling_rate_max sysfs file is deprecated - used by: cat
[   54.888193] BUG: using smp_processor_id() in preemptible [00000000] code: S99local/7753
[   54.888267] caller is smp_call_function_many+0x29/0x210
[   54.888309] Pid: 7753, comm: S99local Not tainted 2.6.30-rc1-tip #1750
[   54.888352] Call Trace:
[   54.888389]  [<c054d06d>] debug_smp_processor_id+0xcd/0xd0
[   54.888432]  [<c016e989>] smp_call_function_many+0x29/0x210
[   54.888477]  [<c0115860>] ? do_drv_write+0x0/0x70
[   54.888519]  [<c0115851>] drv_write+0x21/0x30
[   54.888559]  [<c0115e06>] acpi_cpufreq_target+0x146/0x310
[   54.888603]  [<c0166aab>] ? trace_hardirqs_on_caller+0x1b/0x1b0
[   54.888647]  [<c0166c4b>] ? trace_hardirqs_on+0xb/0x10
[   54.888690]  [<c022fd78>] ? sysfs_remove_group+0x68/0xd0
[   54.888735]  [<c0f17e02>] ? __mutex_unlock_slowpath+0x172/0x180
[   54.888781]  [<c0115cc0>] ? acpi_cpufreq_target+0x0/0x310
[   54.888828]  [<c0c8141e>] __cpufreq_driver_target+0x5e/0xa0
[   54.888873]  [<c0c827a3>] cpufreq_governor_performance+0x23/0x30
[   54.888918]  [<c0c804cb>] __cpufreq_governor+0x2b/0x60
[   54.888961]  [<c015af6f>] ? blocking_notifier_call_chain+0x1f/0x30
[   54.889006]  [<c0c8076a>] __cpufreq_set_policy+0xfa/0x140
[   54.889048]  [<c0c80f9a>] store_scaling_governor+0x8a/0xb0
[   54.889091]  [<c0c81880>] ? handle_update+0x0/0x20
[   54.889133]  [<c0c80ea4>] ? cpufreq_cpu_get+0x74/0x90
[   54.889174]  [<c0c80f10>] ? store_scaling_governor+0x0/0xb0
[   54.889217]  [<c0c8195d>] store+0x4d/0x70
[   54.889257]  [<c022cc50>] flush_write_buffer+0x50/0x70
[   54.889298]  [<c022cd4c>] sysfs_write_file+0x4c/0x80
[   54.889340]  [<c01df6df>] vfs_write+0x8f/0xd0
[   54.889379]  [<c022cd00>] ? sysfs_write_file+0x0/0x80
[   54.889421]  [<c01df762>] sys_write+0x42/0x70
[   54.889461]  [<c0102fab>] sysenter_do_call+0x12/0x36
[   54.889823] BUG: using smp_processor_id() in preemptible [00000000] code: S99local/7753
[   54.889890] caller is smp_call_function_many+0x29/0x210
[   54.889931] Pid: 7753, comm: S99local Not tainted 2.6.30-rc1-tip #1750
[   54.889974] Call Trace:
[   54.890008]  [<c054d06d>] debug_smp_processor_id+0xcd/0xd0
[   54.890051]  [<c016e989>] smp_call_function_many+0x29/0x210
[   54.890093]  [<c0115860>] ? do_drv_write+0x0/0x70
[   54.890133]  [<c0115851>] drv_write+0x21/0x30
[   54.890172]  [<c0115e06>] acpi_cpufreq_target+0x146/0x310
[   54.890216]  [<c0166aab>] ? trace_hardirqs_on_caller+0x1b/0x1b0
[   54.890261]  [<c0166c4b>] ? trace_hardirqs_on+0xb/0x10
[   54.890304]  [<c022fd78>] ? sysfs_remove_group+0x68/0xd0
[   54.890349]  [<c0f17e02>] ? __mutex_unlock_slowpath+0x172/0x180
[   54.890393]  [<c0115cc0>] ? acpi_cpufreq_target+0x0/0x310
[   54.890437]  [<c0c8141e>] __cpufreq_driver_target+0x5e/0xa0
[   54.890480]  [<c0c827a3>] cpufreq_governor_performance+0x23/0x30
[   54.890526]  [<c0c804cb>] __cpufreq_governor+0x2b/0x60
[   54.890569]  [<c015af6f>] ? blocking_notifier_call_chain+0x1f/0x30
[   54.890614]  [<c0c8076a>] __cpufreq_set_policy+0xfa/0x140
[   54.890658]  [<c0c80f9a>] store_scaling_governor+0x8a/0xb0
[   54.890701]  [<c0c81880>] ? handle_update+0x0/0x20
[   54.890743]  [<c0c80ea4>] ? cpufreq_cpu_get+0x74/0x90
[   54.890783]  [<c0c80f10>] ? store_scaling_governor+0x0/0xb0
[   54.890826]  [<c0c8195d>] store+0x4d/0x70
[   54.890864]  [<c022cc50>] flush_write_buffer+0x50/0x70
[   54.890994]  [<c022cd4c>] sysfs_write_file+0x4c/0x80
[   54.891035]  [<c01df6df>] vfs_write+0x8f/0xd0
[   54.891075]  [<c022cd00>] ? sysfs_write_file+0x0/0x80
[   54.891115]  [<c01df762>] sys_write+0x42/0x70
[   54.891154]  [<c0102fab>] sysenter_do_call+0x12/0x36
[   56.475977] device: 'vcs4': device_add

