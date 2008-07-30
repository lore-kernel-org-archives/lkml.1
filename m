Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbYG3Si1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbYG3Si1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYG3SiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:38:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46720 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753478AbYG3SiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:38:04 -0400
Message-ID: <4890B500.7040100@sgi.com>
Date: Wed, 30 Jul 2008 11:37:52 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use	cpumask_of_cpu_map
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com> <20080730165539.GA10079@codemonkey.org.uk> <4890A0A8.4000502@sgi.com>
In-Reply-To: <4890A0A8.4000502@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Dave Jones wrote:
>> On Wed, Jul 23, 2008 at 10:18:42AM -0700, Mike Travis wrote:
>>  >   * The previous "lvalue replacement for cpumask_of_cpu()" was not usable
>>  >     in certain situations and generally added unneeded complexity.  So
>>  >     this patch replaces the cpumask_of_cpu_ptr* macros with a generic
>>  >     cpumask_of_cpu_map[].  The only config option is whether this is a
>>  >     static map, or allocated at boot up time:
>>
>> I've lost the plot on what's going on with these cpumask patches.
>> But I just saw this on -rc1.
>>
>> arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:206:33: error: not addressable
>> arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:274:32: error: not addressable
>> arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:352:34: error: not addressable
>>
>> 	Dave
>>
> 
> It looks like some old code is still there (patch dropped?).  I'll send a fix asap.
> 
> Thanks,
> Mike

After I recreated linux-next the changes all appear to be there now.
One problem though, is !SMP config does not build (something about
DECLARE_BITMAP with NR_CPUS=1.)  I wasn't sure how to create a constant
"(cpumask_t)1" that worked as an lvalue, so the following patch is
somewhat a kluge, but fulfills the requirements.

If anyone has a better suggestion, please let me know.

Subject: [PATCH] cpmask: add cpumask_of_cpu(0) for non-SMP

  * Fix cpumask_of_cpu(0) when CONFIG_SMP is not set by providing a
    pointer to a cpumask_t with cpu 0 bit set.

Signed-of-by: Mike Travis <travis@sgi.com
---
 include/linux/cpumask.h |    6 ++++++
 kernel/cpu.c            |    7 +++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- linux-2.6.tip.orig/include/linux/cpumask.h
+++ linux-2.6.tip/include/linux/cpumask.h
@@ -265,6 +265,7 @@ static inline void __cpus_shift_left(cpu
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
 
+#ifdef CONFIG_SMP
 /*
  * Special-case data structure for "single bit set only" constant CPU masks.
  *
@@ -288,6 +289,11 @@ static inline const cpumask_t *get_cpu_m
  * variable created:
  */
 #define cpumask_of_cpu(cpu)	(*get_cpu_mask(cpu))
+#else
+
+extern const cpumask_t cpu_bit_bitmap_of_one;
+#define cpumask_of_cpu(cpu)	cpu_bit_bitmap_of_one
+#endif
 
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
--- linux-2.6.tip.orig/kernel/cpu.c
+++ linux-2.6.tip/kernel/cpu.c
@@ -35,6 +35,8 @@ EXPORT_SYMBOL(cpu_online_map);
 cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
 EXPORT_SYMBOL(cpu_possible_map);
 
+const cpumask_t cpu_bit_bitmap_of_one = { { [0] = 1 } };
+
 #else /* CONFIG_SMP */
 
 /* Serializes the updates to cpu_online_map, cpu_present_map */
@@ -454,8 +456,6 @@ out:
 }
 #endif /* CONFIG_PM_SLEEP_SMP */
 
-#endif /* CONFIG_SMP */
-
 /*
  * cpu_bit_bitmap[] is a special, "compressed" data structure that
  * represents all NR_CPUS bits binary values of 1<<nr.
@@ -480,3 +480,6 @@ const unsigned long cpu_bit_bitmap[BITS_
 #endif
 };
 EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
+
+#endif /* CONFIG_SMP */
+

