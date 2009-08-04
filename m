Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbZHDMMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbZHDMMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbZHDMMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:12:39 -0400
Received: from av8-1-sn3.vrr.skanova.net ([81.228.9.183]:58218 "EHLO
	av8-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbZHDMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:12:38 -0400
Message-ID: <4A7825B3.1010806@mocean-labs.com>
Date: Tue, 04 Aug 2009 14:12:35 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>
Subject: Re: [PATCH 2/2] tsc2007: reduced number of I2C transfers
References: <4A69DDED.50402@mocean-labs.com> <20090724180022.GA6477@dtor-d630.eng.vmware.com> <4A6A0D77.6000600@mocean-labs.com> <20090726080212.GA24365@dtor-d630.eng.vmware.com>
In-Reply-To: <20090726080212.GA24365@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> 
> I modified the patch a bit before applying. In fact there were a few
> changes to all the patces so it would be nice if you could take a look
> at the 'next' branch of my tree:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git next
> 
> Also, I di dnot quite like the logic of the patch making
> get_pendown_state callback optional; could you please try the patch
> below and let me know of it works for you?

I like your changes, there is just a small miss while checking the 
platform data. You forgot to remove the check for get_pen_down_state in 
the probe function, see the patch below (to be applied on top of yours):

I also would like a check if the power down failed or not during probe.

--Richard

Input: tsc2007 - Check if I2C communication works during probe

Check the result when sending the power down command to the controller.

Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
---
Index: linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c
===================================================================
--- linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c	(revision 1071)
+++ linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c	(revision 1073)
@@ -269,7 +269,7 @@
  	struct input_dev *input_dev;
  	int err;

-	if (!pdata || !pdata->get_pendown_state) {
+	if (!pdata) {
  		dev_err(&client->dev, "platform data is required!\n");
  		return -EINVAL;
  	}
@@ -326,10 +326,14 @@
  	i2c_set_clientdata(client, ts);

  	/* Prepare for touch readings - power down ADC and enable PENIRQ */
-	tsc2007_xfer(ts, PWRDOWN);
+	err = tsc2007_xfer(ts, PWRDOWN);
+	if (err < 0)
+		goto err_unreg_dev;

  	return 0;

+ err_unreg_dev:
+	input_unregister_device(ts->input);
   err_free_irq:
  	tsc2007_free_irq(ts);
  	if (pdata->exit_platform_hw)
