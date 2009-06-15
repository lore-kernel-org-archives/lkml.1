Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZFOIVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZFOIVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZFOIVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:21:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45519 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZFOIVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:21:02 -0400
Message-ID: <4A360469.3040403@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:20:57 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/16] x86, mce: rename static variables around trigger
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"trigger" is not straight forward name for valiable that holds name
of user mode helper program which triggered by machine check events.

This patch renames this valiable and kins to more recognizable names.

	trigger		=> mce_helper
	trigger_argv	=> mce_helper_argv
	notify_user	=> mce_need_notify

No functional changes.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d66f9f1..e145229 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -88,9 +88,10 @@ int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
 
-static unsigned long		notify_user;
-static char			trigger[128];
-static char			*trigger_argv[2] = { trigger, NULL };
+/* User mode helper program triggered by machine check event */
+static unsigned long		mce_need_notify;
+static char			mce_helper[128];
+static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static unsigned long		dont_init_banks;
 
@@ -180,7 +181,7 @@ void mce_log(struct mce *mce)
 	wmb();
 
 	mce->finished = 1;
-	set_bit(0, &notify_user);
+	set_bit(0, &mce_need_notify);
 }
 
 static void print_mce(struct mce *m)
@@ -1115,7 +1116,7 @@ static void mcheck_timer(unsigned long data)
 
 static void mce_do_trigger(struct work_struct *work)
 {
-	call_usermodehelper(trigger, trigger_argv, NULL, UMH_NO_WAIT);
+	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
 }
 
 static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
@@ -1132,7 +1133,7 @@ int mce_notify_irq(void)
 
 	clear_thread_flag(TIF_MCE_NOTIFY);
 
-	if (test_and_clear_bit(0, &notify_user)) {
+	if (test_and_clear_bit(0, &mce_need_notify)) {
 		wake_up_interruptible(&mce_wait);
 
 		/*
@@ -1140,7 +1141,7 @@ int mce_notify_irq(void)
 		 * work_pending is always cleared before the function is
 		 * executed.
 		 */
-		if (trigger[0] && !work_pending(&mce_trigger_work))
+		if (mce_helper[0] && !work_pending(&mce_trigger_work))
 			schedule_work(&mce_trigger_work);
 
 		if (__ratelimit(&ratelimit))
@@ -1657,9 +1658,9 @@ static ssize_t set_bank(struct sys_device *s, struct sysdev_attribute *attr,
 static ssize_t
 show_trigger(struct sys_device *s, struct sysdev_attribute *attr, char *buf)
 {
-	strcpy(buf, trigger);
+	strcpy(buf, mce_helper);
 	strcat(buf, "\n");
-	return strlen(trigger) + 1;
+	return strlen(mce_helper) + 1;
 }
 
 static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
@@ -1668,10 +1669,10 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 	char *p;
 	int len;
 
-	strncpy(trigger, buf, sizeof(trigger));
-	trigger[sizeof(trigger)-1] = 0;
-	len = strlen(trigger);
-	p = strchr(trigger, '\n');
+	strncpy(mce_helper, buf, sizeof(mce_helper));
+	mce_helper[sizeof(mce_helper)-1] = 0;
+	len = strlen(mce_helper);
+	p = strchr(mce_helper, '\n');
 
 	if (*p)
 		*p = 0;
-- 
1.6.3


