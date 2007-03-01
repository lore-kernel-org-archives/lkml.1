Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXCAJMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXCAJMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933181AbXCAJMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:12:05 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:43301 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbXCAJME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:12:04 -0500
Message-ID: <45E698DF.4010006@simon.arlott.org.uk>
Date: Thu, 01 Mar 2007 09:11:59 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: round_jiffies and load average
References: <45E0577C.9020409@simon.arlott.org.uk>
In-Reply-To: <45E0577C.9020409@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/07 15:19, Simon Arlott wrote:
> I've modified the driver of an USB device (cxacru) to schedule the next poll
> for status every 1s using round_jiffies_relative instead of just waiting 1s
> since the last poll was completed. This process takes on average 11ms to
> complete and while it is waiting for a response it's considered running.
> The load average is calculated every 5 seconds equivalent to round_jiffies,
> so I have a problem with the load average always tending towards 1.00.
> Perhaps the load average count could be run just before or in the middle of
> a second instead?

I've added some printks to show exactly what happens (see below).

Since calc_load() appears to be run as often as possible, would it be ok to 
move it to run half a second out of step from rounded jiffies? Its count 
value is initialised to LOAD_FREQ so it would be easy to add HZ/2.

Otherwise every process using round_jiffies to 1s (1.00), 2s (0.50), 
3s (0.33), 4s (0.25), 5s (0.00 or 1.00) could affect the load average in a 
constant way. (Beyond 10s the effect is unlikely to be noticed).


After a while of this (~3min):
[  192.147049] cxacru_poll_status(..), jiffies=4294832000
[  192.151319] cxacru_poll_status(..), jiffies=4294832004, next=996
[  192.463459] calc_load(27), count=-20, jiffies=4294832316
[  192.463472] calc_load(27), count=4980, jiffies=4294832316

Jiffies wraps:
[  327.121469] cxacru_poll_status(..), jiffies=4294967000
[  327.139428] cxacru_poll_status(..), jiffies=4294967018, next=1000
[  327.437739] calc_load(27), count=-20, jiffies=20
[  327.437750] calc_load(27), count=4980, jiffies=20

The next run occurs during cxacru_poll_status:
[  332.416288] cxacru_poll_status(..), jiffies=5000
[  332.417312] calc_load(1), count=-1, jiffies=5001
[  332.417322] calc_load(1), count=4999, jiffies=5001
[  332.423382] cxacru_poll_status(..), jiffies=5007, next=993

This happens without fail until I reboot:
[  672.350970] cxacru_poll_status(..), jiffies=345000
[  672.351913] calc_load(1), count=-1, jiffies=345001
[  672.351926] calc_load(1), count=4999, jiffies=345001
[  672.367737] cxacru_poll_status(..), jiffies=345016, next=984


It's interesting that calc_load() is run most of the time 19ms later (count=-20) than usual until jiffies wraps, then it runs on time or 1ms late (count=-2). Full log available on request (75K), HZ=1000 with NO_HZ.


(diff below of cxacru.c based on http://lkml.org/lkml/2007/2/23/328)
---
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index c8b69bf..4717fa4 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -535,6 +535,7 @@ static void cxacru_poll_status(struct work_struct *work)
 	struct atm_dev *atm_dev = usbatm->atm_dev;
 	int ret;
 
+	printk(KERN_DEBUG "cxacru_poll_status(..), jiffies=%lu\n", jiffies);
 	ret = cxacru_cm_get_array(instance, CM_REQUEST_CARD_INFO_GET, buf, CXINF_MAX);
 	if (ret < 0) {
 		atm_warn(usbatm, "poll status: error %d\n", ret);
@@ -599,6 +600,8 @@ static void cxacru_poll_status(struct work_struct *work)
 reschedule:
 	schedule_delayed_work(&instance->poll_work,
 			round_jiffies_relative(msecs_to_jiffies(POLL_INTERVAL*1000)));
+	printk(KERN_DEBUG "cxacru_poll_status(..), jiffies=%lu, next=%lu\n", jiffies, 
+		round_jiffies_relative(msecs_to_jiffies(POLL_INTERVAL*1000)));
 }
 
 static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
diff --git a/kernel/timer.c b/kernel/timer.c
index cb1b86a..9c2b816 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1230,12 +1230,14 @@ static inline void calc_load(unsigned long ticks)
 	count -= ticks;
 	if (unlikely(count < 0)) {
 		active_tasks = count_active_tasks();
+		printk(KERN_DEBUG "calc_load(%lu), count=%d, jiffies=%lu\n", ticks, count, jiffies);
 		do {
 			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
 			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
 			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
 			count += LOAD_FREQ;
 		} while (count < 0);
+		printk(KERN_DEBUG "calc_load(%lu), count=%d, jiffies=%lu\n", ticks, count, jiffies);
 	}
 }

 

-- 
Simon Arlott
