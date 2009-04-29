Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbZD2LKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbZD2LKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZD2LJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:09:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZD2LJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:09:55 -0400
Date: Wed, 29 Apr 2009 13:09:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/29] x86/perfcounters: x86 and AMD cpu updates
Message-ID: <20090429110936.GI2373@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
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

> This patch series updates the perfcounters implementation mainly 
> for the x86 architecture.

Wow, very nice series! Still havent looked through all of them, but 
wanted to give some quick feedback that the splitup and direction 
looks all good.

> Also, it introduces a data structure (struct pmu) describing a 
> generic performance monitoring unit (pmu). This structure is a 
> replacement for struct hw_perf_counter_ops. Similiar, I introduced 
> struct x86_pmu for the x86 architecture (as a replacement for 
> struct pmc_x86_ops).

Looks sensible. There will eventually be PMU features that dont fit 
the hw-counter abstraction but which can still be expressed at the 
general counter level.

> There are patches for x86 with some fixes and cleanups, a change 
> in the model specific split and a complete rework of AMD pmu code. 
> The result is simplified model specific code and more generalized 
> and unified code. Features that are only supported by AMD or Intel 
> are now implemented in vendor specific functions.

Nice!

> The AMD pmu differs to Intel, especially there is no status 
> register and also there are no fixed counters. This makes a 
> separate interrupt handler for AMD cpus necessary. Also, a global 
> disable/enable of the performance counters (e.g. to avoid NMIs to 
> protect the modification of a list) is expensive on AMD cpus 
> leading to up to 4 msr reads/writes per counter. There is still 
> some more work to do here to avoid this.

Yeah. The previous code was really just a first-level approximation 
to show that it can be done.

> This patch series bases on the tip/percounters/core branch.
> 
> I developed this patches based on 03ced43 and later rebased to 
> 1b88991. The latest tip/percounters/core branch seems to be 
> broken, no nmis are delivered, only perfcounter interrupts with no 
> results on kerneltop. I am still debugging this. However, I could 
> test successfully the patch series based on 03ced43 and want to 
> release the patches anyway.

hm, it works all fine for me. This is "perf top" output from an 
AMD/Barcelona box:

------------------------------------------------------------------------------
 KernelTop:  139908 irqs/sec  kernel: 9.5% [NMI, 100000 CPU cycles],  (all, 16 CPUs)
------------------------------------------------------------------------------

             events    pcnt         RIP          kernel function
  ______     ______   _____   ________________   _______________

           11038.00 - 22.2% - ffffffff8037a090 : clear_page_c
            5842.00 - 11.7% - ffffffff804c6e02 : acpi_pm_read
            2235.00 -  4.5% - ffffffff80579530 : page_fault
            1518.00 -  3.0% - ffffffff8037a300 : copy_user_generic_string!
            1184.00 -  2.4% - ffffffff80291598 : get_page_from_freelist
             899.00 -  1.8% - ffffffff8057919a : _spin_lock
             824.00 -  1.7% - ffffffff802a0c0a : unmap_vmas
             739.00 -  1.5% - ffffffff8029d8a4 : __dec_zone_state
             696.00 -  1.4% - ffffffff8028aafe : perf_swcounter_event
             672.00 -  1.3% - ffffffff802a1b2e : handle_mm_fault

that's NMIs delivered to 16 cores. No lockups and no stuck IRQ 
handling.

Would be nice to fix this...

	Ingo
