Return-Path: <linux-kernel-owner+w=401wt.eu-S935597AbXGTPSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935597AbXGTPSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762408AbXGTPR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:17:58 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:36490 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757862AbXGTPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:17:57 -0400
Date: Fri, 20 Jul 2007 11:17:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, jbeulich@novell.com,
       "S. P. Prasanna" <prasanna@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: new text patching for review
Message-ID: <20070720151748.GA511@Krystal>
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal> <200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal> <p73d4yow0ys.fsf@bingen.suse.de> <20070719234912.GB30383@Krystal> <46A00CC2.6010407@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46A00CC2.6010407@vmware.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:05:04 up 3 days,  9:39,  3 users,  load average: 0.57, 0.27, 0.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Zachary Amsden (zach@vmware.com) wrote:
> Mathieu Desnoyers wrote:
> >Yes, kprobes is case 1: atomic update. And we don't even have to bother
> >about Intel's erratum. This one is ok. That's mainly the
> >alternatives/paravirt code I worry about.
> >  
> 
> Paravirt and alternatives should all be ok because they are done before 
> SMP bringup and with NMIs disabled.  NMI watchdog is not setup until 
> smp_prepare_cpus/check_nmi_watchdog, which happens way later, not during 
> parse_args/setup_nmi_watchdog, which just decides which type of watchdog 
> to setup.
> 

I'm not so sure about this. You are right in that it has nothing to do
with parse_args, but I just went in detail through the source, and the
order seems to be:

1 - NMI is activated
2 - MCE is activated
3 - alternatives are applied

In detail:

start_kernel()
  ...
  include/asm-i386/smp.h:smp_prepare_boot_cpu()
    smp_ops.smp_prepare_boot_cpu()
       arch/i386/kernel/smpboot.c:native_smp_prepare_boot_cpu()
        arch/i386/kernel/smpboot.c:native_smp_prepare_cpus()
          arch/i386/kernel/smpboot.c:smp_boot_cpus()
            arch/i386/kernel/apic.c:setup_local_APIC()
              arch/i386/kernel/nmi.c:setup_apic_nmi_watchdog()
                arch/i386/kernel/cpu/perfctr-watchdog.c:lapic_watchdog_init()
                  wd_ops->setup() (e.g. setup_intel_arch_watchdog)
  ...
  arch/i386/kernel/cpu/bugs.c:check_bugs()
    arch/i386/kernel/cpu/common.c:identify_boot_cpu()
      identify_cpu()
        arch/i386/kernel/cpu/mcheck/mce.c:mcheck_init()
          arch/i386/kernel/cpu/mcheck/p4.c:intel_p4_mcheck_init()
    ...
    arch/i386/kernel/alternative_instructions()
  ...

Therefore, applying alternatives instructions seems to be done after NMI
and MCE init at boot time, or am I misunderstanding something ?


> I originally considered the NMI problem for paravirt-ops patching done 
> during module load, and found that I would need to modify 
> stop_machine_run to have an architecture specific callout to mask and 
> unmask NMIs.  I didn't imagine that would be very popular, and VMI was 
> the only paravirt-ops that were considering module load time patching, 
> so I flushed it.
> 
> You get some other nasty issues as well with run-time switching, like 
> missing early init calls (in particular, we would have to go to some 
> heroics to retake the land surrounding the APIC local timer interrupt).
> 
> Zach

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
