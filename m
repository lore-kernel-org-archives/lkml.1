Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZBDDBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZBDDBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZBDDB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:01:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbZBDDB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:01:26 -0500
Date: Tue, 3 Feb 2009 19:01:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090203190111.2ec31cef.akpm@linux-foundation.org>
In-Reply-To: <200902041314.32277.rusty@rustcorp.com.au>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200902022305.51344.rusty@rustcorp.com.au>
	<20090202200649.c1af2fd1.akpm@linux-foundation.org>
	<200902041314.32277.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 13:14:31 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 03 February 2009 14:36:49 Andrew Morton wrote:
> > But as you say, rdmsr_on_cpu() is easy to do, using
> > smp_call_function_single().  Then we can easily convert all other
> > work_on_cpu() callers to smp_call_function_single() and zap
> > work_on_cpu().  The best outcome, methinks.
> 
> grepping for set_cpus_allowed reveals the following users in the
> first third (when I got tired of it):
> 
> File                         Function            Context      Calls
> powerpc/kernel/smp.c         smp_cpus_done       kernel_init smp_ops->setup_cpu()
> x86/.../speedstep-ich.c      _speedstep_get      cpufreq     speedstep_get_processor_frequency()
> x86/.../powernow-k8.c        check_supported_cpu cpufreq     cpuid_*()
> x86/.../powernow-k8.c        powernowk8_target   cpufreq     mutex_lock, etc
> x86/.../powernow-k8.c        powernowk8_cpu_init boot/hotplg rdmsr,wrmsr
> x86/.../powernow-k8.c        powernowk8_get      cpufreq     rdmsr
> x86/.../speedstep-centrino.c get_cur_freq        cpufreq     rdmsr
> x86/.../speedstep-centrino.c centrino_target     cpufreq     rdmsr,wrmsr
> x86/kernel/reboot.c          nativ..._shutdown   sys_reboot  misc
> x86/.../microcode_core.c     do_microcode_update sys_write   microcode_ops->request_microcode_user
> x86/.../microcode_core.c     reload_store        sys_write   mutex_lock, etc
> 
> Some of these (reboot) we don't care what they do to cpumask.  Some are
> poor style, but not critical (boot time).  Some can use smp_call_function.
> 
> But there are some which should *not* be frobbing their cpus_allowed, and
> really do seem to want a user context.
> 
> I think you're right though: smp_call_function_single (or neat wrappers)
> where possible, work_on_cpu which can fail for the others, and we'll just
> have to plumb in the error returns.

I bet a lot of those can use plain old schedule_work_on().

Could it be that after converting things to
smp_call_function_single()/schedule_work_on(), we don't need
work_on_cpu()?

