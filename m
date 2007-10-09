Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbXJITxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbXJITxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXJITxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:53:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:63546 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbXJITxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fs/CQA3mXwlRm8h974L+FP0j/YHoPWMzXr0vUcDQvXzS9vxmF8VPevfpgECS9SLEvcK7b/RWxcScWkOpjC6k7JYOwRei0dXFD8QHW63er4TXsdxPJzcqutBPgptz7zLLlItlsdzfOOAPJlsus4k8zLfYKzW4B8Chu/CtOIJNhBY=
Message-ID: <d120d5000710091253v3c862713n4f15e23618a30962@mail.gmail.com>
Date: Tue, 9 Oct 2007 15:53:13 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH try #2] Blackfin BF54x Input Keypad controller driver
Cc: "Michael Hennerich" <michael.hennerich@analog.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1191517394.6361.13.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191517394.6361.13.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 10/4/07, Bryan Wu <bryan.wu@analog.com> wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> Blackfin BF54x Input Keypad controller driver:
>
> [try #2] Changelog:
>  - Coding style issue fixes
>  - using a temp variable for bf54x_kpad->input
>  - Other updates according to Dmitry's review
>

I would like to ask you for a couple of additional changes:

> +
> +static u16 per_rows[] = {

Change to "const" perhaps?

> +       P_KEY_ROW7,
> +       P_KEY_ROW6,
> +       P_KEY_ROW5,
> +       P_KEY_ROW4,
> +       P_KEY_ROW3,
> +       P_KEY_ROW2,
> +       P_KEY_ROW1,
> +       P_KEY_ROW0,
> +       0
> +};
> +
> +static u16 per_cols[] = {

Same here.

> +       P_KEY_COL7,
> +       P_KEY_COL6,
> +       P_KEY_COL5,
> +       P_KEY_COL4,
> +       P_KEY_COL3,
> +       P_KEY_COL2,
> +       P_KEY_COL1,
> +       P_KEY_COL0,
> +       0
> +};
> +
> +
> +       if (bfin_kpad_get_keypressed(bf54x_kpad)) {
> +               disable_irq(bf54x_kpad->irq);
> +               bf54x_kpad->lastkey = key;
> +               bf54x_kpad->timer.expires = jiffies
> +                                       + bf54x_kpad->keyup_test_jiffies;
> +               add_timer(&bf54x_kpad->timer);

mod_timer()?

> +
> +       input->keycode = pdata->keymap;

Please consider allocating memory for keycode so that platfrom data
can be kept constant.

> +       input->keycodesize = sizeof(unsigned short);
> +       input->keycodemax = pdata->keymapsize;
> +
> +       /* setup input device */
> +       set_bit(EV_KEY, input->evbit);
> +
> +       if (pdata->repeat)
> +               set_bit(EV_REP, input->evbit);
> +

__set_bit() should suffice here and above.

> +       for (i = 0; i < pdata->keymapsize; i++)
> +               __set_bit(pdata->keymap[i] & KEY_MAX, input->keybit);
> +
> +       __clear_bit(KEY_RESERVED, input->keybit);
> +
> +       error = input_register_device(input);
> +
> +       if (error) {
> +               printk(KERN_ERR DRV_NAME
> +                       ": Unable to register input device (%d)\n", error);
> +               goto out4;
> +       }
> +
> +       /* Init Keypad Key Up/Release test timer */
> +
> +       init_timer(&bf54x_kpad->timer);
> +       bf54x_kpad->timer.function = bfin_kpad_timer;
> +       bf54x_kpad->timer.data = (unsigned long) pdev;
> +

setup_timer()?

> +
> +       bfin_write_KPAD_PRESCALE(bfin_kpad_get_prescale(TIME_SCALE));
> +
> +       bfin_write_KPAD_CTL((((pdata->cols - 1) << 13) & KPAD_COLEN) |
> +                               (((pdata->rows - 1) << 10) & KPAD_ROWEN) |
> +                               (2 & KPAD_IRQMODE));
> +
> +
> +       bfin_write_KPAD_CTL(bfin_read_KPAD_CTL() | KPAD_EN);
> +
> +       printk(KERN_ERR DRV_NAME
> +               ": Blackfin BF54x Keypad registered IRQ %d\n", bf54x_kpad->irq);
> +
> +       return 0;
> +
> +
> +out4:
> +       input_free_device(input);
> +out3:
> +       free_irq(bf54x_kpad->irq, pdev);
> +out2:
> +       peripheral_free_list(&per_cols[MAX_RC - pdata->cols]);
> +out1:
> +       peripheral_free_list(&per_rows[MAX_RC - pdata->rows]);
> +out:
> +       kfree(bf54x_kpad);
> +       platform_set_drvdata(pdev, NULL);
> +
> +       return error;
> +}
> +
> +static int __devexit bfin_kpad_remove(struct platform_device *pdev)
> +{
> +       struct bfin_kpad_platform_data *pdata = pdev->dev.platform_data;
> +       struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
> +
> +
> +       del_timer_sync(&bf54x_kpad->timer);
> +       free_irq(bf54x_kpad->irq, pdev);
> +
> +       peripheral_free_list(&per_rows[MAX_RC - pdata->rows]);
> +       peripheral_free_list(&per_cols[MAX_RC - pdata->cols]);
> +
> +       input_unregister_device(bf54x_kpad->input);
> +
> +       kfree(bf54x_kpad);
> +       platform_set_drvdata(pdev, NULL);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int bfin_kpad_suspend(struct platform_device *pdev, pm_message_t state)
> +{

Do you need these empty functions? At least stop timer here.

Thanks!

Oh, one more thing - do not access input->private directly - it is
going away - use input_set_drvdata() and input_get_drvdata().

-- 
Dmitry
