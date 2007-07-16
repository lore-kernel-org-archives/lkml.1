Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXGPOKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXGPOKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXGPOKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:10:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:51791 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbXGPOKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FWhvgtd41midzS3f8Bg5/UEI2YtE1vLroyh1XWcCiG2kjh9SMrq0g6LEmzq26rSXxZr/4wqUcUSebXIA5lgR3TXe2vonxW/jYDLsNSBI0p5JLVmuvXqtCtjqFvYt1WV9JimUQglmSbNSlk3Da5P+iQ5pmZmRqvniYb710HUSZnM=
Date: Mon, 16 Jul 2007 23:00:08 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 9/10] mce: fix cpu hotplug error handling
Message-ID: <20070716140008.GA2092@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix error handling in mce_create_device()

  Error handling should not do sysdev_remove_file() with not yet added
  attributes.

- Change mce_create_device() from CPU_ONLINE event handler
  to CPU_UP_PREPARE event handler.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/x86_64/kernel/mce.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

Index: 2.6-mm/arch/x86_64/kernel/mce.c
===================================================================
--- 2.6-mm.orig/arch/x86_64/kernel/mce.c
+++ 2.6-mm/arch/x86_64/kernel/mce.c
@@ -803,19 +803,30 @@ static __cpuinit int mce_create_device(u
 {
 	int err;
 	int i;
-	if (!mce_available(&cpu_data[cpu]))
-		return -EIO;
 
+	memset(&per_cpu(device_mce, cpu).kobj, 0, sizeof(struct kobject));
 	per_cpu(device_mce,cpu).id = cpu;
 	per_cpu(device_mce,cpu).cls = &mce_sysclass;
 
 	err = sysdev_register(&per_cpu(device_mce,cpu));
+	if (err)
+		return err;
+
+	for (i = 0; mce_attributes[i]; i++) {
+		err = sysdev_create_file(&per_cpu(device_mce,cpu),
+					 mce_attributes[i]);
+		if (err)
+			goto error;
+	}
 
-	if (!err) {
-		for (i = 0; mce_attributes[i]; i++)
-			sysdev_create_file(&per_cpu(device_mce,cpu),
-				mce_attributes[i]);
+	return 0;
+error:
+	while (i--) {
+		sysdev_remove_file(&per_cpu(device_mce,cpu),
+				   mce_attributes[i]);
 	}
+	sysdev_unregister(&per_cpu(device_mce,cpu));
+
 	return err;
 }
 
@@ -827,7 +838,6 @@ static void mce_remove_device(unsigned i
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
 			mce_attributes[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
-	memset(&per_cpu(device_mce, cpu).kobj, 0, sizeof(struct kobject));
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
@@ -835,18 +845,21 @@ static int
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		mce_create_device(cpu);
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = mce_create_device(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mce_remove_device(cpu);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block mce_cpu_notifier = {
