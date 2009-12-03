Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbZLCDRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbZLCDRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZLCDRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:17:10 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49793 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbZLCDRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kwkaq1dZlnNofUL1xAnIky6GqfttST9Kr0csH+EaAn3EHICuWJckuRit1llP4hhpC5
         Va2p4gvNPUushVb0NbucoOw4saNeV0hRzLpbLlIRBtYjCSQU3LkJPr1xbogzQxk2riCH
         YuA/FQBdTB24VOv8tgcpHElNH7GTvXFvLfCFM=
Date: Wed, 2 Dec 2009 19:17:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       linux-input@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
	matrix-keypad related?
Message-ID: <20091203031709.GE9121@core.coreip.homeip.net>
References: <20090930200746.GA1384@ucw.cz> <20091006050649.GH27881@core.coreip.homeip.net> <20091006075816.GA1362@ucw.cz> <20091007043603.GC10204@core.coreip.homeip.net> <f17812d70910070742y5e27f9c3u38e3299b94f33613@mail.gmail.com> <20091007163327.GA12053@core.coreip.homeip.net> <20091007211225.GB17805@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007211225.GB17805@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 11:12:26PM +0200, Pavel Machek wrote:
> 
> > > > OK, so it looks like your box refuses to set up one of the GPIOs as a
> > > > wakeup source... Hmm, either your box is wrong ;) or matrix_keypad
> > > > driver needs to maintain a separate list of wakeup GPIOs.
> > > >
> > > 
> > > This is due to the nature of PXA processor, where not every GPIO can
> > > be configured as a wakeup source. Mmm.... we can either return a
> > > pseudo value indicating setting wakeup on that GPIO is OK (which
> > > doesn't sound like a good idea), or we can just ignore the failure of
> > > enable_irq_wake() in matrix_keypad?
> > 
> > We ignore the failure right now in the mainline but that causes stack
> > traces on resume as we trying to disable not enabled wakeup GPIOs. That
> > was original Pavel's complaint.
> 
> Yep...
> 
> I'd say that BUG() simply should not trigger if wakeup can not be
> enabled/disabled for particular source...?

Pavel,

Could you please try the patch below and let me know if it fixes the
problem for you?

Thanks.

-- 
Dmitry

Input: matrix-keypad - handle cases when GPIOs can't be wakeup sources

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/matrix_keypad.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)


diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 91cfe51..a1152ba 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -29,11 +29,13 @@ struct matrix_keypad {
 	unsigned short *keycodes;
 	unsigned int row_shift;
 
+	DECLARE_BITMAP(disabled_gpios, MATRIX_MAX_ROWS);
+
 	uint32_t last_key_state[MATRIX_MAX_COLS];
 	struct delayed_work work;
+	spinlock_t lock;
 	bool scan_pending;
 	bool stopped;
-	spinlock_t lock;
 };
 
 /*
@@ -221,9 +223,16 @@ static int matrix_keypad_suspend(struct platform_device *pdev, pm_message_t stat
 
 	matrix_keypad_stop(keypad->input_dev);
 
-	if (device_may_wakeup(&pdev->dev))
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			enable_irq_wake(gpio_to_irq(pdata->row_gpios[i]));
+	if (device_may_wakeup(&pdev->dev)) {
+		for (i = 0; i < pdata->num_row_gpios; i++) {
+			if (!test_bit(i, keypad->disabled_gpios)) {
+				unsigned int gpio = pdata->row_gpios[i];
+
+				if (enable_irq_wake(gpio_to_irq(gpio)) == 0)
+					__set_bit(i, keypad->disabled_gpios);
+			}
+		}
+	}
 
 	return 0;
 }
@@ -234,9 +243,15 @@ static int matrix_keypad_resume(struct platform_device *pdev)
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
 
-	if (device_may_wakeup(&pdev->dev))
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			disable_irq_wake(gpio_to_irq(pdata->row_gpios[i]));
+	if (device_may_wakeup(&pdev->dev)) {
+		for (i = 0; i < pdata->num_row_gpios; i++) {
+			if (test_and_clear_bit(i, keypad->disabled_gpios)) {
+				unsigned int gpio = pdata->row_gpios[i];
+
+				disable_irq_wake(gpio_to_irq(gpio));
+			}
+		}
+	}
 
 	matrix_keypad_start(keypad->input_dev);
 
