Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYGXUIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYGXUIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYGXUII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:08:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39019 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYGXUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:08:07 -0400
Date: Thu, 24 Jul 2008 22:07:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Oops in sched_mc_power_savings_store
Message-ID: <20080724200730.GF20882@one.firstfloor.org>
References: <20080724115121.GA28269@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724115121.GA28269@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 05:51:22AM -0600, Matthew Wilcox wrote:
> 
> I have no idea how you guys intended this to work, but here's the
> debugging work I've done so far.
> 
> [   89.210171] Call Trace:
> [   89.210182]  [<c011c0b3>] ? sched_mc_power_savings_store+0x0/0x4a
> [   89.210198]  [<c02908c0>] ? sysdev_class_store+0x38/0x40
> [   89.210213]  [<c01a0b51>] ? sysfs_write_file+0xb9/0xe4
> 
> sched_mc_power_savings_store isn't a class attribute, it's a plain
> attribute.  So the prototypes are different.  This is why we try to load
> from address 2 -- it's actually the length parameter.
> 
> I don't know how our typing system let this one through.  I don't know if
> you want to fix this by adding an extra argument to the class_attribute
> show and store methods.  I don't know if sched_mc_power_savings_store
> was intended to be a class attribute or not.

Seems like a latent problem. The attributes were just declared wrong.
Longer term we should probably add the sysdev attributes to the class
too, but right now here's a minimal fix. Does it solve your problem?
Thanks,

-Andi
---


commit a2ab909933f8c8623282979dfa64f3e358bdb9fc
Author: Andi Kleen <ak@linux.intel.com>
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
 
