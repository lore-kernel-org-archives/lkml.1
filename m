Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZBDCoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZBDCoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZBDCoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:44:37 -0500
Received: from ozlabs.org ([203.10.76.45]:40509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZBDCog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:44:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Wed, 4 Feb 2009 13:14:31 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200902022305.51344.rusty@rustcorp.com.au> <20090202200649.c1af2fd1.akpm@linux-foundation.org>
In-Reply-To: <20090202200649.c1af2fd1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041314.32277.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 14:36:49 Andrew Morton wrote:
> But as you say, rdmsr_on_cpu() is easy to do, using
> smp_call_function_single().  Then we can easily convert all other
> work_on_cpu() callers to smp_call_function_single() and zap
> work_on_cpu().  The best outcome, methinks.

grepping for set_cpus_allowed reveals the following users in the
first third (when I got tired of it):

File                         Function            Context      Calls
powerpc/kernel/smp.c         smp_cpus_done       kernel_init smp_ops->setup_cpu()
x86/.../speedstep-ich.c      _speedstep_get      cpufreq     speedstep_get_processor_frequency()
x86/.../powernow-k8.c        check_supported_cpu cpufreq     cpuid_*()
x86/.../powernow-k8.c        powernowk8_target   cpufreq     mutex_lock, etc
x86/.../powernow-k8.c        powernowk8_cpu_init boot/hotplg rdmsr,wrmsr
x86/.../powernow-k8.c        powernowk8_get      cpufreq     rdmsr
x86/.../speedstep-centrino.c get_cur_freq        cpufreq     rdmsr
x86/.../speedstep-centrino.c centrino_target     cpufreq     rdmsr,wrmsr
x86/kernel/reboot.c          nativ..._shutdown   sys_reboot  misc
x86/.../microcode_core.c     do_microcode_update sys_write   microcode_ops->request_microcode_user
x86/.../microcode_core.c     reload_store        sys_write   mutex_lock, etc

Some of these (reboot) we don't care what they do to cpumask.  Some are
poor style, but not critical (boot time).  Some can use smp_call_function.

But there are some which should *not* be frobbing their cpus_allowed, and
really do seem to want a user context.

I think you're right though: smp_call_function_single (or neat wrappers)
where possible, work_on_cpu which can fail for the others, and we'll just
have to plumb in the error returns.

I'll start the patchstream for 2.6.30.

Thanks,
Rusty.
