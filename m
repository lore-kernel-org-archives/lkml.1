Return-Path: <linux-kernel-owner+w=401wt.eu-S1765138AbXEUTYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765138AbXEUTYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbXEUTVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:23 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46321 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765294AbXEUTVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:19 -0400
Message-Id: <20070521191700.064658000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Simon Arlott <simon@fire.lp0.eu>
Subject: [patch 05/69] cxacru: Fix infinite loop when trying to cancel polling task
Content-Disposition: inline; filename=cxacru-fix-infinite-loop-when-trying-to-cancel-polling-task.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Simon Arlott <simon@fire.lp0.eu>

As part of the device initialisation cxacru_atm_start starts 
a rearming status polling task, which is cancelled in 
cxacru_unbind. Failure to ever start the task means an 
infinite loop occurs trying to cancel it.

Possible reasons for not starting the polling task:
* Firmware files missing
* Device initialisation fails
* User unplugs device or unloads module

Effect:
* Infinite loop in khubd trying to add/remove the device (or rmmod if timed right)

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Fixed for 2.6.22 by 6a02c996bce297a782432e29c69268356e97fadd.

 drivers/usb/atm/cxacru.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

--- linux-2.6.21.1.orig/drivers/usb/atm/cxacru.c
+++ linux-2.6.21.1/drivers/usb/atm/cxacru.c
@@ -146,6 +146,12 @@ enum cxacru_info_idx {
 	CXINF_MAX = 0x1c,
 };
 
+enum poll_state {
+	CX_INIT,
+	CX_POLLING,
+	CX_ABORT
+};
+
 struct cxacru_modem_type {
 	u32 pll_f_clk;
 	u32 pll_b_clk;
@@ -159,6 +165,8 @@ struct cxacru_data {
 
 	int line_status;
 	struct delayed_work poll_work;
+	struct mutex poll_state_serialize;
+	enum poll_state poll_state;
 
 	/* contol handles */
 	struct mutex cm_serialize;
@@ -356,7 +364,7 @@ static int cxacru_atm_start(struct usbat
 	/*
 	struct atm_dev *atm_dev = usbatm_instance->atm_dev;
 	*/
-	int ret;
+	int ret, start_polling = 1;
 
 	dbg("cxacru_atm_start");
 
@@ -376,7 +384,15 @@ static int cxacru_atm_start(struct usbat
 	}
 
 	/* Start status polling */
-	cxacru_poll_status(&instance->poll_work.work);
+	mutex_lock(&instance->poll_state_serialize);
+	if (instance->poll_state == CX_INIT)
+		instance->poll_state = CX_POLLING;
+	else /* poll_state == CX_ABORT */
+		start_polling = 0;
+	mutex_unlock(&instance->poll_state_serialize);
+
+	if (start_polling)
+		cxacru_poll_status(&instance->poll_work.work);
 	return 0;
 }
 
@@ -685,6 +701,9 @@ static int cxacru_bind(struct usbatm_dat
 	instance->usbatm = usbatm_instance;
 	instance->modem_type = (struct cxacru_modem_type *) id->driver_info;
 
+	mutex_init(&instance->poll_state_serialize);
+	instance->poll_state = CX_INIT;
+
 	instance->rcv_buf = (u8 *) __get_free_page(GFP_KERNEL);
 	if (!instance->rcv_buf) {
 		dbg("cxacru_bind: no memory for rcv_buf");
@@ -744,6 +763,7 @@ static void cxacru_unbind(struct usbatm_
 		struct usb_interface *intf)
 {
 	struct cxacru_data *instance = usbatm_instance->driver_data;
+	int stop_polling = 1;
 
 	dbg("cxacru_unbind entered");
 
@@ -752,8 +772,20 @@ static void cxacru_unbind(struct usbatm_
 		return;
 	}
 
-	while (!cancel_delayed_work(&instance->poll_work))
-	       flush_scheduled_work();
+	mutex_lock(&instance->poll_state_serialize);
+	if (instance->poll_state != CX_POLLING) {
+		/* Polling hasn't started yet and with
+		 * the mutex locked it can be prevented
+		 * from starting.
+		 */
+		instance->poll_state = CX_ABORT;
+		stop_polling = 0;
+	}
+	mutex_unlock(&instance->poll_state_serialize);
+
+	if (stop_polling)
+		while (!cancel_delayed_work(&instance->poll_work))
+			flush_scheduled_work();
 
 	usb_kill_urb(instance->snd_urb);
 	usb_kill_urb(instance->rcv_urb);

-- 
