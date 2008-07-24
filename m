Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYGXU1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYGXU1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYGXU1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:27:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35474 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYGXU1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:27:06 -0400
Date: Thu, 24 Jul 2008 22:26:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bad dereference in sched_mc_power_savings_store()
Message-ID: <20080724202634.GH20882@one.firstfloor.org>
References: <20080724120217.163a03f3@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724120217.163a03f3@mjolnir.drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 12:02:17PM +0200, Pierre Ossman wrote:
> I get the following with yesterdays kernel:

This patch should fix it.

-andi


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
 
