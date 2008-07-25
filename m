Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYGYSPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYGYSPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYGYSPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:15:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34407 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYGYSPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:15:43 -0400
Date: Fri, 25 Jul 2008 20:15:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: Kernel BUG in 2.6.26-git series
Message-ID: <20080725181514.GL20882@one.firstfloor.org>
References: <4889E538.5010007@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4889E538.5010007@lwfinger.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 09:37:44AM -0500, Larry Finger wrote:
> In the current git pulls from Linus's tree, I get a kernel BUG if 
> CONFIG_SCHED_SMT is defined. It does not always appear, but when it does, 
> it is late in the bootup sequence. Perhaps there is a timing issue. This is 
> an x86_64 system on an HP dv2815nr notebook with and AMD Turion X2 CPU. My 
> distro is openSUSE 11.0.

A couple of people ran into that. It was a latent bug triggered by
some changes of mine. Here's the patch.

-Andi


commit a2ab909933f8c8623282979dfa64f3e358bdb9fc
Author: Andi Kleen <ak@gargoyle.(none)>
Date:   Thu Jul 24 21:57:40 2008 +0200

    Make scheduler sysfs attributes sysdev class devices
    
    They are really class devices, but were incorrectly declared. This leads
    to crashes with the recent changes that makes non normal sysdevs
    use a different prototype.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index 6acf749..24358ca 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7641,34 +7641,34 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
+					   char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
-					    struct sysdev_attribute *attr,
+static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-		   sched_mc_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644, 
+			 sched_mc_power_savings_show,
+		         sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
+					    char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
-					     struct sysdev_attribute *attr,
+static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644, 
+		   sched_smt_power_savings_show,
 		   sched_smt_power_savings_store);
 #endif
 
