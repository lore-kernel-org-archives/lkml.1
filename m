Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbZG3Qqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbZG3Qqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZG3Qqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:46:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47980 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZG3Qqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:46:35 -0400
Date: Thu, 30 Jul 2009 12:46:29 -0400
From: Dave Jones <davej@redhat.com>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: Warning during suspend with MS-7310 mainboard
Message-ID: <20090730164629.GC2593@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Langsdorf, Mark" <mark.langsdorf@amd.com>,
	Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	rusty@rustcorp.com.au
References: <1248936650.3313.6.camel@queen> <1248949671.3313.10.camel@queen> <20090730154734.GB2593@redhat.com> <6453C3CB8E2B3646B0D020C11261327303620A01@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C11261327303620A01@sausexmb4.amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 11:38:22AM -0500, Langsdorf, Mark wrote:
 > I'll look into it.
 > 
 > First time I've had this bug reported, though.
 > 

It's happening because the suspend code runs with interrupts disabled,
and the powerpc workaround we do in the cpufreq suspend hook
calls the drivers ->get method.

powernow-k8's ->get does an smp_call_function_single
which needs interrupts enabled

If we just make the suspend code conditional on ppc, this whole problem
goes away.

Something like the patch below..

	Dave

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5cc77fb..8d3b3d1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1288,6 +1288,14 @@ static int cpufreq_suspend(struct sys_device *sysdev, pm_message_t pmsg)
 
 	dprintk("suspending cpu %u\n", cpu);
 
+	/*
+	 * This whole bogosity is here because Powerbooks are made of fail.
+	 * No sane platform should need any of the code below to be run.
+	 * (it's entirely the wrong thing to do, as driver->get may
+	 *  reenable interrupts on some architectures).
+	 */
+
+#ifdef __powerpc__
 	if (!cpu_online(cpu))
 		return 0;
 
@@ -1346,6 +1354,7 @@ static int cpufreq_suspend(struct sys_device *sysdev, pm_message_t pmsg)
 
 out:
 	cpufreq_cpu_put(cpu_policy);
+#endif	/* __powerpc__ */
 	return ret;
 }
 
@@ -1365,6 +1374,11 @@ static int cpufreq_resume(struct sys_device *sysdev)
 
 	dprintk("resuming cpu %u\n", cpu);
 
+	/* As with the ->suspend method, all the code below is
+	 * only necessary because Powerbooks suck.
+	 * See commit 42d4dc3f4e1e for jokes. */
+#ifdef __powerpc__
+
 	if (!cpu_online(cpu))
 		return 0;
 
@@ -1428,6 +1442,7 @@ out:
 	schedule_work(&cpu_policy->update);
 fail:
 	cpufreq_cpu_put(cpu_policy);
+#endif	/* __powerpc__ */
 	return ret;
 }
 
