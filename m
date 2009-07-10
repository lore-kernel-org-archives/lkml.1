Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZGJUN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZGJUN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZGJUNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:13:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZGJUNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:13:18 -0400
Date: Fri, 10 Jul 2009 16:13:08 -0400
From: Dave Jones <davej@redhat.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       cpufreq@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.31-rc2+: Interrupts enabled after cpufreq_suspend
Message-ID: <20090710201308.GA11075@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	cpufreq@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <4A561074.5080407@gmail.com> <20090710192511.GB6240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710192511.GB6240@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 03:25:11PM -0400, Dave Jones wrote:

 >     [PATCH] Add suspend method to cpufreq core
 >     
 >     In order to properly fix some issues with cpufreq vs. sleep on
 >     PowerBooks, I had to add a suspend callback to the pmac_cpufreq driver.
 >     I must force a switch to full speed before sleep and I switch back to
 >     previous speed on resume.
 > 
 > 
 > Ben, is there something better we can do here ?
 > 
 > I really don't want to add an #ifdef __powerpc__ to core code if we can help it.
 > I'd rather we didn't call into driver guts at all from the suspend path.

Marcin,
 Unless we get a better solution proposed, try running with this, which just
skips doing all that code entirely.

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
 
