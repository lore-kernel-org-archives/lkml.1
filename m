Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbZBPKr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbZBPKr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZBPKrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:47:05 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:45190 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbZBPKrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:47:01 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	<sWhNs83kKPE.A.p4D.L20jJB@chimera>
	<878wognj00.fsf@burly.wgtn.ondioline.org>
	<200902142342.59186.rjw@sisk.pl>
	<87hc2u26m5.fsf@burly.wgtn.ondioline.org>
	<1234775410.26036.122.camel@pasglop>
Date: Mon, 16 Feb 2009 23:47:00 +1300
In-Reply-To: <1234775410.26036.122.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 16 Feb 2009 20:10:10 +1100")
Message-ID: <87d4di1wwr.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Mon, 2009-02-16 at 20:17 +1300, Paul Collins wrote:
>> It turns out I didn't test this properly.  The warning is only
>> triggered
>> when I close and open the lid, not when I run 'snooze' to suspend and
>> hit Return to resume, as I did for my so-called testing of 2.6.29-rc4.
>> 
>> Whatever is triggering the warning is still present in 2.6.29-rc5.
>
> Right, we probably need to stop sending input events from the PMU driver
> when it's "suspended".
>
> Ping me if I don't produce a patch tomorrow (ie, I forgot :-)

Just for laughs I slapped together the following, which seems to do the
job, although not especially tidily.


diff --git a/drivers/macintosh/via-pmu-event.c b/drivers/macintosh/via-pmu-event.c
index 25cd565..33c4b45 100644
--- a/drivers/macintosh/via-pmu-event.c
+++ b/drivers/macintosh/via-pmu-event.c
@@ -23,6 +23,7 @@
 #include <linux/input.h>
 #include <linux/adb.h>
 #include <linux/pmu.h>
+#include <linux/bug.h>
 #include "via-pmu-event.h"
 
 static struct input_dev *pmu_input_dev;
@@ -56,24 +57,62 @@ static int __init via_pmu_event_init(void)
 	return err;
 }
 
+static bool lid_event_pending;
+static int lid_event_pending_down;
+static bool power_button_event_pending;
+static int power_button_event_pending_down;
+
 void via_pmu_event(int key, int down)
 {
 
 	if (unlikely(!pmu_input_dev))
 		return;
 
-	switch (key) {
-	case PMU_EVT_POWER:
-		input_report_key(pmu_input_dev, KEY_POWER, down);
-		break;
-	case PMU_EVT_LID:
-		input_report_switch(pmu_input_dev, SW_LID, down);
-		break;
-	default:
-		/* no such key handled */
-		return;
-	}
+	if (!pmu_sys_suspended) {
+		switch (key) {
+		case PMU_EVT_POWER:
+			input_report_key(pmu_input_dev, KEY_POWER, down);
+			break;
+		case PMU_EVT_LID:
+			input_report_switch(pmu_input_dev, SW_LID, down);
+			break;
+		default:
+			/* no such key handled */
+			return;
+		}
+
+		input_sync(pmu_input_dev);
+	} else {
+		switch (key) {
+		case PMU_EVT_POWER:
+			power_button_event_pending = true;
+			power_button_event_pending_down = down;
+			break;
+		case PMU_EVT_LID:
+			lid_event_pending = true;
+			lid_event_pending_down = down;
+			break;
+		default:
+			/* no such key handled */
+			return;
+		}
+	}		
+}
 
+void via_pmu_event_resume(void)
+{
+	WARN_ON(pmu_sys_suspended);
+
+	if (power_button_event_pending) {
+		input_report_key(pmu_input_dev, KEY_POWER,
+				 power_button_event_pending_down);
+		power_button_event_pending = false;
+	}
+	if (lid_event_pending) {
+		input_report_switch(pmu_input_dev, SW_LID,
+				    lid_event_pending_down);
+		lid_event_pending = false;
+	}
 	input_sync(pmu_input_dev);
 }
 
diff --git a/drivers/macintosh/via-pmu-event.h b/drivers/macintosh/via-pmu-event.h
index 72c54de..2754adc 100644
--- a/drivers/macintosh/via-pmu-event.h
+++ b/drivers/macintosh/via-pmu-event.h
@@ -4,5 +4,6 @@
 #define PMU_EVT_POWER	0
 #define PMU_EVT_LID	1
 extern void via_pmu_event(int key, int down);
+extern void via_pmu_event_resume(void);
 
 #endif /* __VIA_PMU_EVENT_H */
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index b40fb9b..01b8689 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2479,6 +2479,8 @@ static int pmu_sys_resume(struct sys_device *sysdev)
 	pmu_resume();
 	pmu_sys_suspended = 0;
 
+	via_pmu_event_resume();
+
 	return 0;
 }
 


-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
