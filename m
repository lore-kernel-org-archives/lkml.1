Return-Path: <linux-kernel-owner+w=401wt.eu-S1763177AbXGMScj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763177AbXGMScj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760181AbXGMScT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:32:19 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:32758 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755037AbXGMScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:32:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:User-Agent:Cc:MIME-Version:Content-Disposition:Date:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=ObjnTjsdm9dMDsSxlmngyLmn5YdzKysDTI+rjyUeE8g9M3uUaDbl5i6+LX4N09989ybRyU3IgdaRXqpZaYvU5cDXdWB4MOecFuDtVt6z1RL9h+vQoDL8aZKQRa8vDKWtDMz/7zBPxtTLA81ZwsF8EGZ5ANaNQLUxmqZXJ/IRcE0=  ;
X-YMail-OSG: fySNcVoVM1kfsfZnlVOZt_PFWKtU47k08IjBC8LNCoUiwXxvVDrql9EOxH_EZ_sDjChcqZ_mzA--
From: David Brownell <david-b@pacbell.net>
To: Dmitry Torokhov <dtor@mail.ru>, dtor@insightbb.com
Subject: [RESEND patch 2.6.22-rc4] ads7846 pendown status check
User-Agent: KMail/1.9.6
Cc: Semih Hazar <semih.hazar@indefia.com>, Imre Deak <imre.deak@solidboot.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 13 Jul 2007 11:29:40 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707131129.40930.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Semih Hazar <semih.hazar@indefia.com> 

Pendown status from the PENIRQ pin is currently read only at the beginning
of a sample set. If the pen is lifted just after sampling has began then
sampled values become wrong.

This patch adds an optional platform penirq_recheck_delay attribute.  If
non-zero, samples are only reported to the input subsystem if PENIRQ is
still active that long after the samples taken.

Signed-off-by: Semih Hazar <semih.hazar@indefia.com> 
Cc: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Still applies fine against 2.6.22-git ... this should be in 2.6.23

 drivers/input/touchscreen/ads7846.c |   15 +++++++++++++++
 include/linux/spi/ads7846.h         |    6 ++++++
 2 files changed, 21 insertions(+)

--- g26.orig/include/linux/spi/ads7846.h	2007-06-16 04:33:43.000000000 -0700
+++ g26/include/linux/spi/ads7846.h	2007-06-16 09:46:32.000000000 -0700
@@ -24,6 +24,12 @@ struct ads7846_platform_data {
 	 */
 	u16	settle_delay_usecs;
 
+	/* If set to non-zero, after samples are taken this delay is applied
+	 * and penirq is rechecked, to help avoid false events.  This value
+	 * is affected by the material used to build the touch layer.
+	 */
+	u16	penirq_recheck_delay_usecs;
+
 	u16	x_plate_ohms;
 	u16	y_plate_ohms;
 
--- g26.orig/drivers/input/touchscreen/ads7846.c	2007-06-16 09:46:22.000000000 -0700
+++ g26/drivers/input/touchscreen/ads7846.c	2007-06-16 09:46:32.000000000 -0700
@@ -107,6 +107,8 @@ struct ads7846 {
 	u16			debounce_tol;
 	u16			debounce_rep;
 
+	u16			penirq_recheck_delay_usecs;
+
 	spinlock_t		lock;
 	struct hrtimer		timer;
 	unsigned		pendown:1;	/* P: lock */
@@ -553,6 +555,15 @@ static void ads7846_rx(void *ads)
 		return;
 	}
 
+	/* Maybe check the pendown state before reporting. This discards
+	 * false readings when the pen is lifted.
+	 */
+	if (ts->penirq_recheck_delay_usecs) {
+		udelay(ts->penirq_recheck_delay_usecs);
+		if (!ts->get_pendown_state())
+			Rt = 0;
+	}
+
 	/* NOTE: We can't rely on the pressure to determine the pen down
 	 * state, even this controller has a pressure sensor.  The pressure
 	 * value can fluctuate for quite a while after lifting the pen and
@@ -896,6 +907,10 @@ static int __devinit ads7846_probe(struc
 		ts->filter = ads7846_no_filter;
 	ts->get_pendown_state = pdata->get_pendown_state;
 
+	if (pdata->penirq_recheck_delay_usecs)
+		ts->penirq_recheck_delay_usecs =
+				pdata->penirq_recheck_delay_usecs;
+
 	snprintf(ts->phys, sizeof(ts->phys), "%s/input0", spi->dev.bus_id);
 
 	input_dev->name = "ADS784x Touchscreen";
