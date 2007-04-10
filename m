Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXDJDI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXDJDI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbXDJDI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:08:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798AbXDJDI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:08:28 -0400
Date: Mon, 9 Apr 2007 23:08:23 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Preemption Broken:  centrino_target busted under SMP on 2.6.20.4
Message-ID: <20070410030823.GA16229@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
	Linux kernel <linux-kernel@vger.kernel.org>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <46155CFF.70701@wolfmountaingroup.com> <20070405205034.GB3605@redhat.com> <20070409172651.9bc619d6.akpm@linux-foundation.org> <20070410023108.GA14081@redhat.com> <20070409194142.88f0a5e5.akpm@linux-foundation.org> <20070410030500.GA15509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410030500.GA15509@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 11:05:00PM -0400, Dave Jones wrote:

 > This whole file is going away in .22, and we have a viable alternative in
 > .21 (acpi-cpufreq), so I'm not overly worried about fixing this up
 > given it only shows up in debug kernels, especially at this stage in -rc.
 > 
 > (Yeah, it's a cop-out, but unless someone with more interest in this problem
 >  steps up, I've bigger fishes to fry).

One last try...
(I didn't think too long about this, so this might be equally busted,
 but if so, see comment above).

	Dave

diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
index f43b987..38e31ce 100644
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -720,11 +720,13 @@ static int centrino_target (struct cpufreq_policy *policy,
 			cpu_set(j, set_mask);
 
 		set_cpus_allowed(current, set_mask);
+		preempt_disable();
 		if (unlikely(!cpu_isset(smp_processor_id(), set_mask))) {
 			dprintk("couldn't limit to CPUs in this domain\n");
 			retval = -EAGAIN;
 			if (first_cpu) {
 				/* We haven't started the transition yet. */
+				preempt_enable();
 				goto migrate_end;
 			}
 			break;
@@ -765,6 +767,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			break;
 
 		cpu_set(j, covered_cpus);
+		preempt_enable();
 	}
 
 	for_each_cpu_mask(k, online_policy_cpus) {

-- 
http://www.codemonkey.org.uk
