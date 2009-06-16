Return-Path: <linux-kernel-owner+w=401wt.eu-S936624AbZFPF6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936624AbZFPF6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbZFPFvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:21 -0400
Received: from kroah.org ([198.145.64.141]:48378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934880AbZFPFvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/64] Driver Core: x86: add nodename for cpuid and msr drivers.
Date: Mon, 15 Jun 2009 22:46:18 -0700
Message-Id: <1245131213-24168-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
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
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 2ac1f0c..b07af88 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -182,6 +182,11 @@ static struct notifier_block __refdata cpuid_class_cpu_notifier =
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
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 3cf3413..98fd6cd 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -196,6 +196,11 @@ static struct notifier_block __refdata msr_class_cpu_notifier = {
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
-- 
1.6.3.2

