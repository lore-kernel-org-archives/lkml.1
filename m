Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXLDUwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXLDUwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXLDUwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:52:25 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23049 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751695AbXLDUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:52:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bsP4FcnNDUFYZC4mjs2qX1C7UYgc111g3l+4AMDtrOkZnE76b6N/iyIHrpjHKgQiCI6ZUPDaraREZYkoIugSpTvMYkS188Zn6eeNmp+rE3FpPAo2mAk5r6YkXaJ/MktSNPHac+SSiOfXsG5f7dvxqtCyu4prWuFQGJ0qsipohfQ=  ;
X-YMail-OSG: GZDvUz0VM1nDFNSf070WyX5FJkgprXo5PjAqQsc7B0kpwpoUFXiM2sSo7PoQX6w56020u0NA8Q--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.24-rc4] ads7846 stops updating dev->power.power_state
Date: Tue, 4 Dec 2007 12:25:24 -0800
User-Agent: KMail/1.9.6
Cc: dmitry.torokhov@gmail.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041225.24316.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stops the ads7846 driver from using dev->power.power_state;
that field is deprecated (overdue for removal) and the only reason
to update it was to make the /sys/devices/.../power/state files
(now removed) work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- pstate.orig/drivers/input/touchscreen/ads7846.c	2007-12-04 09:19:00.000000000 -0800
+++ pstate/drivers/input/touchscreen/ads7846.c	2007-12-04 12:13:11.000000000 -0800
@@ -116,6 +116,7 @@ struct ads7846 {
 // FIXME remove "irq_disabled"
 	unsigned		irq_disabled:1;	/* P: lock */
 	unsigned		disabled:1;
+	unsigned		is_suspended:1;
 
 	int			(*filter)(void *data, int data_idx, int *val);
 	void			*filter_data;
@@ -203,7 +204,7 @@ static void ads7846_disable(struct ads78
 static int device_suspended(struct device *dev)
 {
 	struct ads7846 *ts = dev_get_drvdata(dev);
-	return dev->power.power_state.event != PM_EVENT_ON || ts->disabled;
+	return ts->is_suspended || ts->disabled;
 }
 
 static int ads7846_read12_ser(struct device *dev, unsigned command)
@@ -795,7 +796,7 @@ static int ads7846_suspend(struct spi_de
 
 	spin_lock_irq(&ts->lock);
 
-	spi->dev.power.power_state = message;
+	ts->is_suspended = 1;
 	ads7846_disable(ts);
 
 	spin_unlock_irq(&ts->lock);
@@ -810,7 +811,7 @@ static int ads7846_resume(struct spi_dev
 
 	spin_lock_irq(&ts->lock);
 
-	spi->dev.power.power_state = PMSG_ON;
+	ts->is_suspended = 0;
 	ads7846_enable(ts);
 
 	spin_unlock_irq(&ts->lock);
@@ -872,7 +873,6 @@ static int __devinit ads7846_probe(struc
 	}
 
 	dev_set_drvdata(&spi->dev, ts);
-	spi->dev.power.power_state = PMSG_ON;
 
 	ts->spi = spi;
 	ts->input = input_dev;
