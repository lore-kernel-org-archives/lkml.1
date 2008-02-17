Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYBQM0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYBQM0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbYBQMXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:10 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38353 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: [PATCH 14/27] hwmon: fix section mismatch in coretemp
Date: Sun, 17 Feb 2008 13:22:51 +0100
Message-Id: <1203250984-11285-14-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0xebfd04): Section mismatch in reference from the function coretemp_cpu_callback() to the function .cpuinit.text:coretemp_device_add()

coretemp_cpu_callback() are only used inside a
HOTPLUG_CPU block so annotate it __cpuinit.
The notifier referencing the function are annotated
__refdata to silence warning from the exit function.
The unregister function do not use the embedded pointer
but clears the variable so the annotation is OK.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
---
 drivers/hwmon/coretemp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 3ee60d2..1439432 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -330,7 +330,7 @@ static void coretemp_device_remove(unsigned int cpu)
 	mutex_unlock(&pdev_list_mutex);
 }
 
-static int coretemp_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit coretemp_cpu_callback(struct notifier_block *nfb,
 				 unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long) hcpu;
@@ -347,7 +347,7 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block coretemp_cpu_notifier = {
+static struct notifier_block coretemp_cpu_notifier __refdata = {
 	.notifier_call = coretemp_cpu_callback,
 };
 #endif				/* !CONFIG_HOTPLUG_CPU */
-- 
1.5.4.rc3.14.g44397

