Return-Path: <linux-kernel-owner+w=401wt.eu-S1762704AbXGMScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762704AbXGMScZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXGMScR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:32:17 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:32747 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752472AbXGMScQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:32:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:User-Agent:Cc:MIME-Version:Content-Disposition:Date:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=gAQVcqTuxLV/wmtZrf0Sn0DquaywMVoQTdIL+Spm9/AgHyrn2uP8rOZJ+DBttHxOAVrejMvDklCmEd3Z5ZpoRAAazWK6i1dyaOT3NIVqlNgfZ9KxXElJC8DHtp9gXZxjADvW3MI6YKP/nbhf2Dr8wG9w+7YurEV/N8FKsOTHsUc=  ;
X-YMail-OSG: L6172sQVM1m.3.4Pzsi5ylvMaimHdAx_vhgqW0d6eVZpy_awH8SYET1MTvs_wQroPwzSWsuNPw--
From: David Brownell <david-b@pacbell.net>
To: Dmitry Torokhov <dtor@mail.ru>, dtor@insightbb.com
Subject: [RESEND patch 2.6.22-rc4 1/2] ads7846 sample settling
User-Agent: KMail/1.9.6
Cc: Semih Hazar <semih.hazar@indefia.com>, Imre Deak <imre.deak@solidboot.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 13 Jul 2007 11:29:10 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707131129.10885.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Semih Hazar <semih.hazar@indefia.com> 

The ads7846 driver has support for filtering, but when the chip gets
deselected between samples this causes noise. This patch adds support
for an optional settling delay time, so that two consecutive samples
will be taken with the specified delay time apart.  This ensures that
the chip won't be deselected, so the noise won't appear.

Filtering can still be done, but will have less work to do since each
time a new sample is taken the same delay applies.

Signed-off-by: Semih Hazar <semih.hazar@indefia.com>
Cc: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Still applies fine against 2.6.22-git ... this should be in 2.6.23

 drivers/input/touchscreen/ads7846.c |   65 +++++++++++++++++++++++++++++++++++-
 include/linux/spi/ads7846.h         |    8 ++++
 2 files changed, 72 insertions(+), 1 deletion(-)

--- g26.orig/include/linux/spi/ads7846.h	2007-02-12 00:31:26.000000000 -0800
+++ g26/include/linux/spi/ads7846.h	2007-06-16 04:33:43.000000000 -0700
@@ -16,6 +16,14 @@ struct ads7846_platform_data {
 	u16	vref_delay_usecs;	/* 0 for external vref; etc */
 	int	keep_vref_on:1;		/* set to keep vref on for differential
 					 * measurements as well */
+
+	/* Settling time of the analog signals; a function of Vcc and the
+	 * capacitance on the X/Y drivers.  If set to non-zero, two samples
+	 * are taken with settle_delay us apart, and the second one is used.
+	 * ~150 uSec with 0.01uF caps.
+	 */
+	u16	settle_delay_usecs;
+
 	u16	x_plate_ohms;
 	u16	y_plate_ohms;
 
--- g26.orig/drivers/input/touchscreen/ads7846.c	2007-05-24 12:04:45.000000000 -0700
+++ g26/drivers/input/touchscreen/ads7846.c	2007-06-16 09:46:22.000000000 -0700
@@ -95,7 +95,7 @@ struct ads7846 {
 	u16			dummy;		/* for the pwrdown read */
 	struct ts_event		tc;
 
-	struct spi_transfer	xfer[10];
+	struct spi_transfer	xfer[18];
 	struct spi_message	msg[5];
 	struct spi_message	*last_msg;
 	int			msg_idx;
@@ -936,6 +936,24 @@ static int __devinit ads7846_probe(struc
 	x->len = 2;
 	spi_message_add_tail(x, m);
 
+	/* the first sample after switching drivers can be low quality;
+	 * optionally discard it, using a second one after the signals
+	 * have had enough time to stabilize.
+	 */
+	if (pdata->settle_delay_usecs) {
+		x->delay_usecs = pdata->settle_delay_usecs;
+
+		x++;
+		x->tx_buf = &ts->read_y;
+		x->len = 1;
+		spi_message_add_tail(x, m);
+
+		x++;
+		x->rx_buf = &ts->tc.y;
+		x->len = 2;
+		spi_message_add_tail(x, m);
+	}
+
 	m->complete = ads7846_rx_val;
 	m->context = ts;
 
@@ -954,6 +972,21 @@ static int __devinit ads7846_probe(struc
 	x->len = 2;
 	spi_message_add_tail(x, m);
 
+	/* ... maybe discard first sample ... */
+	if (pdata->settle_delay_usecs) {
+		x->delay_usecs = pdata->settle_delay_usecs;
+
+		x++;
+		x->tx_buf = &ts->read_x;
+		x->len = 1;
+		spi_message_add_tail(x, m);
+
+		x++;
+		x->rx_buf = &ts->tc.x;
+		x->len = 2;
+		spi_message_add_tail(x, m);
+	}
+
 	m->complete = ads7846_rx_val;
 	m->context = ts;
 
@@ -973,6 +1006,21 @@ static int __devinit ads7846_probe(struc
 		x->len = 2;
 		spi_message_add_tail(x, m);
 
+		/* ... maybe discard first sample ... */
+		if (pdata->settle_delay_usecs) {
+			x->delay_usecs = pdata->settle_delay_usecs;
+
+			x++;
+			x->tx_buf = &ts->read_z1;
+			x->len = 1;
+			spi_message_add_tail(x, m);
+
+			x++;
+			x->rx_buf = &ts->tc.z1;
+			x->len = 2;
+			spi_message_add_tail(x, m);
+		}
+
 		m->complete = ads7846_rx_val;
 		m->context = ts;
 
@@ -990,6 +1038,21 @@ static int __devinit ads7846_probe(struc
 		x->len = 2;
 		spi_message_add_tail(x, m);
 
+		/* ... maybe discard first sample ... */
+		if (pdata->settle_delay_usecs) {
+			x->delay_usecs = pdata->settle_delay_usecs;
+
+			x++;
+			x->tx_buf = &ts->read_z2;
+			x->len = 1;
+			spi_message_add_tail(x, m);
+
+			x++;
+			x->rx_buf = &ts->tc.z2;
+			x->len = 2;
+			spi_message_add_tail(x, m);
+		}
+
 		m->complete = ads7846_rx_val;
 		m->context = ts;
 	}
