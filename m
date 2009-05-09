Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZEIOoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZEIOoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZEIOm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:42:57 -0400
Received: from kroah.org ([198.145.64.141]:54177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbZEIOm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:56 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:33 2009
Message-Id: <20090509143633.076063420@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:06 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 05/13] Driver Core: x86: add nodename for cpuid and msr drivers.
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-x86-add-nodename-for-cpuid-and-msr-drivers.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the x86 cpuid and msr drivers to report the proper
device name to userspace for their devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpuid.c |    6 ++++++
 arch/x86/kernel/msr.c   |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -182,6 +182,11 @@ static struct notifier_block __refdata c
 	.notifier_call = cpuid_class_cpu_callback,
 };
 
+static char *cpuid_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "cpu/%u/cpuid", MINOR(dev->devt));
+}
+
 static int __init cpuid_init(void)
 {
 	int i, err = 0;
@@ -198,6 +203,7 @@ static int __init cpuid_init(void)
 		err = PTR_ERR(cpuid_class);
 		goto out_chrdev;
 	}
+	cpuid_class->nodename = cpuid_nodename;
 	for_each_online_cpu(i) {
 		err = cpuid_device_create(i);
 		if (err != 0)
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -196,6 +196,11 @@ static struct notifier_block __refdata m
 	.notifier_call = msr_class_cpu_callback,
 };
 
+static char *msr_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "cpu/%u/msr", MINOR(dev->devt));
+}
+
 static int __init msr_init(void)
 {
 	int i, err = 0;
@@ -212,6 +217,7 @@ static int __init msr_init(void)
 		err = PTR_ERR(msr_class);
 		goto out_chrdev;
 	}
+	msr_class->nodename = msr_nodename;
 	for_each_online_cpu(i) {
 		err = msr_device_create(i);
 		if (err != 0)


