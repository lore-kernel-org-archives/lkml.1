Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYG1W22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYG1W22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYG1W2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:28:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:30329 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYG1W2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=LJJBSKWvYwL80BbfmxQTM7p0RnS971WOr3Wydj1tEaqnniWOobm4BsHY4hiL85vJAA
         QD7WVfQ9RxzxPyqEgT/zMXCxyAEOQEib/osT1ZhB1154Fp6Wdv7u3ovOQv0Dypz1TEYV
         PIm8o5svrBXUCJ9OCRX7/xz/zoYhWpTBVyDXI=
Date: Tue, 29 Jul 2008 00:26:43 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000002
Message-ID: <20080728222643.GA6339@slug>
References: <20080725095317.GA12636@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725095317.GA12636@skywalker>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello  Aneesh,

On Fri, Jul 25, 2008 at 03:23:17PM +0530, Aneesh Kumar K.V wrote:
> [  163.378265] BUG: unable to handle kernel NULL pointer dereference at 00000002
> [  163.378276] IP: [<c0124933>] sched_power_savings_store+0x13/0x70

Does the attached patch solve the problem?

Regards,
Frederik

diff --git a/kernel/sched.c b/kernel/sched.c
index 0047bd9..090b397 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7643,34 +7643,30 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_mc_power_savings_show(struct sysdev_class *cls, char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
-					    struct sysdev_attribute *attr,
+static ssize_t sched_mc_power_savings_store(struct sysdev_class *cls,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
 		   sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_smt_power_savings_show(struct sysdev_class *cls, char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
-					     struct sysdev_attribute *attr,
+static ssize_t sched_smt_power_savings_store(struct sysdev_class *cls,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
 		   sched_smt_power_savings_store);
 #endif
 
@@ -7680,13 +7676,13 @@ int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 
 #ifdef CONFIG_SCHED_SMT
 	if (smt_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_smt_power_savings.attr);
+		err = sysdev_class_create_file(cls,
+					       &attr_sched_smt_power_savings);
 #endif
 #ifdef CONFIG_SCHED_MC
 	if (!err && mc_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_mc_power_savings.attr);
+		err = sysdev_class_create_file(cls,
+					       &attr_sched_mc_power_savings);
 #endif
 	return err;
 }
