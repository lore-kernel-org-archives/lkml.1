Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbXGPOIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbXGPOIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbXGPOIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:08:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:48679 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759813AbXGPOII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ODIj2BNmg0dHL/3CHL6dLxNmyusKXZrHZpd5P4NVDsshAcTxOKXMiNgbWLLZwuTjxjfUm7DfyNcaHQzQrXzglmUcmaqYeuyN/4Nv1YWutfQU3q5fiInD7hZtjwbbCLrVekAShEx1aK8tNwuY0oDEjnHuhMstIwGrtvG1Rg85/oM=
Date: Mon, 16 Jul 2007 22:58:04 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 7/10] msr: fix cpu hotplug error handling
Message-ID: <20070716135804.GG2040@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make msr_device_create() CPU_UP_PREPARE event handler
instead of CPU_ONLINE handler.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/i386/kernel/msr.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: 2.6-mm/arch/i386/kernel/msr.c
===================================================================
--- 2.6-mm.orig/arch/i386/kernel/msr.c
+++ 2.6-mm/arch/i386/kernel/msr.c
@@ -135,33 +135,39 @@ static const struct file_operations msr_
 	.open = msr_open,
 };
 
-static int msr_device_create(int i)
+static int msr_device_create(int cpu)
 {
-	int err = 0;
 	struct device *dev;
 
-	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, i), "msr%d",i);
-	if (IS_ERR(dev))
-		err = PTR_ERR(dev);
-	return err;
+	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu),
+			    "msr%d", cpu);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+static void msr_device_destroy(int cpu)
+{
+	device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
 }
 
 static int msr_class_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		msr_device_create(cpu);
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = msr_device_create(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
+		msr_device_destroy(cpu);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata msr_class_cpu_notifier =
@@ -198,7 +204,7 @@ static int __init msr_init(void)
 out_class:
 	i = 0;
 	for_each_online_cpu(i)
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, i));
+		msr_device_destroy(i);
 	class_destroy(msr_class);
 out_chrdev:
 	unregister_chrdev(MSR_MAJOR, "cpu/msr");
@@ -210,7 +216,7 @@ static void __exit msr_exit(void)
 {
 	int cpu = 0;
 	for_each_online_cpu(cpu)
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
+		msr_device_destroy(cpu);
 	class_destroy(msr_class);
 	unregister_chrdev(MSR_MAJOR, "cpu/msr");
 	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
