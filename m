Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXGPOHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXGPOHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762227AbXGPOHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:07:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:44353 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759784AbXGPOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=a4I+55SMQPYHfc7kYEYFkGITB6+P5wvkEucsJvrOSEhPhBPhKVqN+/8AQYdHv/YyEq41+tGnL0IbYFJMpxMxmjG2DzcsJgGrzfu8PeVm+WynOm3jeziBdA06VGx9MVXPlWzkRBvGSlxPWuQPlW6nzE062Y4KuGuP3kyRCoINTqc=
Date: Mon, 16 Jul 2007 22:57:04 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Dmitriy Zavin <dmitriyz@google.com>
Subject: [PATCH 6/10] thermal_throttle: fix cpu hotplug error handling
Message-ID: <20070716135704.GF2040@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Dmitriy Zavin <dmitriyz@google.com>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make thermal_throttle_add_dev() CPU_UP_PREPARE event handler
instead of CPU_ONLINE event handler.

Cc: Dmitriy Zavin <dmitriyz@google.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/i386/kernel/cpu/mcheck/therm_throt.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: 2.6-mm/arch/i386/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- 2.6-mm.orig/arch/i386/kernel/cpu/mcheck/therm_throt.c
+++ 2.6-mm/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -131,23 +131,24 @@ static __cpuinit int thermal_throttle_cp
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct sys_device *sys_dev;
-	int err;
+	int err = 0;
 
 	sys_dev = get_cpu_sysdev(cpu);
 	mutex_lock(&therm_cpu_lock);
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		err = thermal_throttle_add_dev(sys_dev);
-		WARN_ON(err);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		thermal_throttle_remove_dev(sys_dev);
 		break;
 	}
 	mutex_unlock(&therm_cpu_lock);
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block thermal_throttle_cpu_notifier =
