Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZJFFHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZJFFHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbZJFFHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:07:11 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:64745 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbZJFFHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ttjMDIfxe7/YDCL1rZIuAWEDr0ehx6K/sW7C1tX4oz0NguTylPkbhYcjms6avBRpgm
         SxEbiUjK/36sBe6o1tSYKM8Kd8DCmYz0dxdXwWvqk/8xpNDTEmGVx14iKdH9wdAf40lM
         f+yMMRqsYqkH611WNaYp6Zo8k0Rt1AHP2AG1s=
Date: Mon, 5 Oct 2009 22:06:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, linux-input@vger.kernel.org
Subject: Re: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
	matrix-keypad related?
Message-ID: <20091006050649.GH27881@core.coreip.homeip.net>
References: <20090930200746.GA1384@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930200746.GA1384@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, Sep 30, 2009 at 10:07:46PM +0200, Pavel Machek wrote:
> Hi!
> 
> It complains about unbalanced irq 113 wake disable. That one belongs
> to matrix-keypad...

I guess some of enable_irq_wake()s fail on your box. Do you see it if
you apply the patch below?

Thanks.

-- 
Dmitry


Input: matrix-keypad - report errors from enable_irq_wake()

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/matrix_keypad.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)


diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 91cfe51..488171c 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -218,14 +218,29 @@ static int matrix_keypad_suspend(struct platform_device *pdev, pm_message_t stat
 	struct matrix_keypad *keypad = platform_get_drvdata(pdev);
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
+	int err;
 
 	matrix_keypad_stop(keypad->input_dev);
 
-	if (device_may_wakeup(&pdev->dev))
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			enable_irq_wake(gpio_to_irq(pdata->row_gpios[i]));
+	if (device_may_wakeup(&pdev->dev)) {
+		for (i = 0; i < pdata->num_row_gpios; i++) {
+			err = enable_irq_wake(gpio_to_irq(pdata->row_gpios[i]));
+			if (err) {
+				dev_err(&pdev->dev,
+					"Failed to setup GPIO %d as "
+					"wakeup source, err: %d\n",
+					pdata->row_gpios[i], err);
+				goto err_out;
+			}
+		}
+	}
 
 	return 0;
+
+ err_out:
+	while (--i >= 0)
+		disable_irq_wake(gpio_to_irq(pdata->row_gpios[i]));
+	return err;
 }
 
 static int matrix_keypad_resume(struct platform_device *pdev)
