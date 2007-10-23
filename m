Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbXJWMck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbXJWMck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 08:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXJWMcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 08:32:33 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:34504 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXJWMcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:32:32 -0400
Message-ID: <471DE9DE.7050104@tiscali.nl>
Date: Tue, 23 Oct 2007 14:32:30 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unlock 12c_mutex before return
References: <471D398E.8080209@tiscali.nl> <je3aw217on.fsf@sykes.suse.de>
In-Reply-To: <je3aw217on.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:

>> -	if (num > 2)
>> +	if (num > 2) {
>> +                mutex_unlock(&d->i2c_mutex);
>>  		return -EINVAL;
> 
> How about moving the check before the lock?

Good suggestion. Patch below covers both previous patches.
--
Move check before lock

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
index 18e0b16..f3ff813 100644
--- a/drivers/media/dvb/dvb-usb/au6610.c
+++ b/drivers/media/dvb/dvb-usb/au6610.c
@@ -79,12 +79,12 @@ static int au6610_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
-
 	if (num > 2)
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
 	for (i = 0; i < num; i++) {
 		/* write/read request */
 		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
diff --git a/drivers/media/dvb/dvb-usb/gl861.c b/drivers/media/dvb/dvb-usb/gl861.c
index f01d99c..6b99d9f 100644
--- a/drivers/media/dvb/dvb-usb/gl861.c
+++ b/drivers/media/dvb/dvb-usb/gl861.c
@@ -56,12 +56,12 @@ static int gl861_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
-
 	if (num > 2)
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
 	for (i = 0; i < num; i++) {
 		/* write/read request */
 		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {

