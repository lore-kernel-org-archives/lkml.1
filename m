Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbYDUNT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbYDUNT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbYDUNSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:18:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbYDUNSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:from:date:subject:cc;
        b=xKoaJTciMRGgnKUIqus4zuza0IWe2IHjD9poYXPrLb9z+EopWsCM9sGQI/SKPiBft41KJq3IsCWEugHUY8MekndsqCM9kfLze5bkT0h5qfCJtvkCDCjMHXwLFsQyWIIpc9/XLskpTDna73vs9iiJNS8BQgdXDJi4ZgLS//pGtVA=
Message-Id: <3797fec17193e05dee9666b990d6c84e16b188b3.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 2 Apr 2008 00:41:00 -0400
Subject: [PATCH 01/37] Input: remove private member from input_dev structure
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone should be using input_{get|set}_drvdata() by now.
Alias them to dev_{get|set}_drvdata() and remove ->private.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/input-polldev.c |    6 +++---
 include/linux/input.h         |    8 ++------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 490918a..0d3ce7a 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -73,7 +73,7 @@ static void input_polled_device_work(struct work_struct *work)
 
 static int input_open_polled_device(struct input_dev *input)
 {
-	struct input_polled_dev *dev = input->private;
+	struct input_polled_dev *dev = input_get_drvdata(input);
 	int error;
 
 	error = input_polldev_start_workqueue();
@@ -91,7 +91,7 @@ static int input_open_polled_device(struct input_dev *input)
 
 static void input_close_polled_device(struct input_dev *input)
 {
-	struct input_polled_dev *dev = input->private;
+	struct input_polled_dev *dev = input_get_drvdata(input);
 
 	cancel_delayed_work_sync(&dev->work);
 	input_polldev_stop_workqueue();
@@ -151,10 +151,10 @@ int input_register_polled_device(struct input_polled_dev *dev)
 {
 	struct input_dev *input = dev->input;
 
+	input_set_drvdata(input, dev);
 	INIT_DELAYED_WORK(&dev->work, input_polled_device_work);
 	if (!dev->poll_interval)
 		dev->poll_interval = 500;
-	input->private = dev;
 	input->open = input_open_polled_device;
 	input->close = input_close_polled_device;
 
diff --git a/include/linux/input.h b/include/linux/input.h
index cae2c35..28a094f 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1025,10 +1025,6 @@ struct ff_effect {
  * @node: used to place the device onto input_dev_list
  */
 struct input_dev {
-	/* private: */
-	void *private;	/* do not use */
-	/* public: */
-
 	const char *name;
 	const char *phys;
 	const char *uniq;
@@ -1238,12 +1234,12 @@ static inline void input_put_device(struct input_dev *dev)
 
 static inline void *input_get_drvdata(struct input_dev *dev)
 {
-	return dev->private;
+	return dev_get_drvdata(&dev->dev);
 }
 
 static inline void input_set_drvdata(struct input_dev *dev, void *data)
 {
-	dev->private = data;
+	dev_set_drvdata(&dev->dev, data);
 }
 
 int __must_check input_register_device(struct input_dev *);
-- 
1.5.5.rc2.6.gf58d


