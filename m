Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYDRJXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYDRJXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 05:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYDRJXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 05:23:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbYDRJXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 05:23:43 -0400
Date: Fri, 18 Apr 2008 11:22:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-pm@lists.linux-foundation.org, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Jack Steiner <steiner@sgi.com>, Mike Travis <travis@sgi.com>,
       Alan Mayer <ajm@sgi.com>
Subject: Re: 2.6.25-mm1: not looking good
Message-ID: <20080418092254.GA20661@elte.hu>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <20080418005034.6e4dd9e7.akpm@linux-foundation.org> <20080418005323.7c015c42.akpm@linux-foundation.org> <20080418005733.aa3e8250.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418005733.aa3e8250.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x31/0x67()
>
> [<ffffffff803523e6>] ? debug_smp_processor_id+0x32/0xc4
> [<ffffffff8021ede5>] read_apic_id+0x31/0x67
> [<ffffffff8066f7f2>] verify_local_APIC+0xa7/0x163
> [<ffffffff8066e837>] native_smp_prepare_cpus+0x1ed/0x301
> [<ffffffff80669ab2>] kernel_init+0x5a/0x276

that came in via the UV-APIC patchset but the warning is entirely 
harmless. At that point we've got a single CPU running only so 
preemption of that code to another CPU is not possible.

native_smp_prepare_cpus() should probably just disable preemption, that 
way we could remove all those ugly preempt disable-enable calls from the 
called functions - per the patch below. (not boot tested yet - might 
provoke atomic-scheduling warnings if i forgot about some schedule point 
in this rather large codepath)

	Ingo

------------------->
Subject: x86: disable preemption in native_smp_prepare_cpus
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 18 11:07:10 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-x86.q/arch/x86/kernel/smpboot.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/smpboot.c
+++ linux-x86.q/arch/x86/kernel/smpboot.c
@@ -1181,6 +1181,7 @@ static void __init smp_cpu_index_default
  */
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
+	preempt_disable();
 	nmi_watchdog_default();
 	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
@@ -1237,6 +1238,7 @@ void __init native_smp_prepare_cpus(unsi
 	printk(KERN_INFO "CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
 	setup_boot_clock();
+	preempt_enable();
 }
 /*
  * Early setup to make printk work.
