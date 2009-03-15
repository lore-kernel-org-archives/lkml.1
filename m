Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZCOC44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZCOC44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 22:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZCOC4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 22:56:46 -0400
Received: from ozlabs.org ([203.10.76.45]:45978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZCOC4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 22:56:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Sun, 15 Mar 2009 13:26:33 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903132342.42813.rusty@rustcorp.com.au> <20090313152742.GA11800@elte.hu>
In-Reply-To: <20090313152742.GA11800@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151326.34114.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009 01:57:42 Ingo Molnar wrote:
> Note, it might have crashed in a cpu hotplug test i'm conducting 
> during bootup:
> 
> echo 0 > /sys/devices/system/cpu/cpu1/online

Indeed, thanks!

Subject: cpumask: fix crash when offlining cpus

Impact: Fix cpu offline when CONFIG_MAXSMP=y

Changeset bc9b83dd1f66402b870301c3c7117b9c1484abb4 "cpumask: convert c1e_mask
in arch/x86/kernel/process.c to cpumask_var_t" contained a bug: c1e_mask is
manipulated even if C1E isn't detected (and hence not allocated).  This is
simply fixed by checking for NULL (which gcc optimizes out anyway of
CONFIG_CPUMASK_OFFSTACK=n, since it knows ce1_mask can never be NULL).

In addition, fix a leak where select_idle_routine re-allocates (and re-clears)
c1e_mask on every cpu init.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cad5431..91a8c26 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -479,7 +479,8 @@ static int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
 {
-	cpumask_clear_cpu(cpu, c1e_mask);
+	if (c1e_mask != NULL)
+		cpumask_clear_cpu(cpu, c1e_mask);
 }
 
 /*
@@ -556,8 +557,11 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		pm_idle = mwait_idle;
 	} else if (check_c1e_idle(c)) {
 		printk(KERN_INFO "using C1E aware idle routine\n");
-		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
-		cpumask_clear(c1e_mask);
+		/* c1e_mask can only be NULL during boot of first cpu. */
+		if (c1e_mask == NULL) {
+			alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
+			cpumask_clear(c1e_mask);
+		}
 		pm_idle = c1e_idle;
 	} else
 		pm_idle = default_idle;
