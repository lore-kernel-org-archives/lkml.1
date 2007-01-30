Return-Path: <linux-kernel-owner+w=401wt.eu-S1751465AbXA3V1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbXA3V1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXA3V1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:27:22 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:40758 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbXA3V1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:27:21 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 16:27:21 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding:Sender:Reply-To;
	b=uhv7SoKF1BONgSdk0qeNnXd0SrlPJ+jQC5hd/z8Pr77jX1aJfbUDrnRfjCnlPO8NMalgdMX+ai3RfYJWdsKGVli3XN41/5ctSgJE3TLnu77C6tJFXyqUpNmLu6S8+T/0;
Message-ID: <45BFB6F1.2070303@simon.arlott.org.uk>
Date: Tue, 30 Jan 2007 21:21:53 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] usbatm: Allow sub-drivers to handle calls to atm_proc_read.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Reply-To: Simon Arlott <601753fa5bab1585521hc0qm0003olph@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

usbatm only outputs basic information via the per-device /proc/net/atm/ file, this patch allows the device specific USB ATM drivers to replace the atm_proc_read function with their own.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

---
 drivers/usb/atm/usbatm.c |    3 +++
 drivers/usb/atm/usbatm.h |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index ec63b0e..d91ed11 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -761,6 +761,9 @@ static int usbatm_atm_proc_read(struct a
 		return -ENODEV;
 	}
 
+	if (instance->driver->proc_read != NULL)
+		return instance->driver->proc_read(instance, atm_dev, pos, page);
+
 	if (!left--)
 		return sprintf(page, "%s\n", instance->description);
 
diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index ff8551e..d3c0ee4 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -121,6 +121,9 @@ struct usbatm_driver {
 	/* cleanup ATM device ... can sleep, but can't fail */
 	void (*atm_stop) (struct usbatm_data *, struct atm_dev *);
 
+	/* called when the proc file is read */
+	int (*proc_read) (struct usbatm_data *, struct atm_dev *, loff_t * pos, char *page);
+
         int bulk_in;	/* bulk rx endpoint */
         int isoc_in;	/* isochronous rx endpoint */
         int bulk_out;	/* bulk tx endpoint */
-- 
1.4.3.1


-- 
Simon Arlott (subscribed to lkml, don't CC)
