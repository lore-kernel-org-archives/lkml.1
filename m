Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbXJKLha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbXJKLha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXJKLhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:37:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:48410 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXJKLhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:37:21 -0400
X-IronPort-AV: i="4.21,259,1188792000"; 
   d="scan'208"; a="41542667:sNHT32610984"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH try #2] Blackfin BF54x Input Keypad controller driver
Date: Thu, 11 Oct 2007 12:37:15 +0100
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC0F100DA7@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH try #2] Blackfin BF54x Input Keypad controller driver
Thread-Index: AcgKrgj3u68rS7zqT0GCC9lfMA9cygBTJO1Q
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, <bryan.wu@analog.com>
Cc: "Michael Hennerich" <michael.hennerich@analog.com>,
       <linux-input@atrey.karlin.mff.cuni.cz>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       <uclinux-dist-devel@blackfin.uclinux.org>
X-OriginalArrivalTime: 11 Oct 2007 11:37:19.0455 (UTC) FILETIME=[14D96EF0:01C80BFB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Dmitry,

Thanks for your feedback.
See my comment below.
Bryan is going to send you an updated patch shortly.

Best regards,
Michael


>Hi Bryan,
>
>On 10/4/07, Bryan Wu <bryan.wu@analog.com> wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>> Blackfin BF54x Input Keypad controller driver:
>>
>> [try #2] Changelog:
>>  - Coding style issue fixes
>>  - using a temp variable for bf54x_kpad->input
>>  - Other updates according to Dmitry's review
>>
>
>I would like to ask you for a couple of additional changes:
>
>> +
>> +static u16 per_rows[] = {
>
>Change to "const" perhaps?
>
>> +       P_KEY_ROW7,
>> +       P_KEY_ROW6,
>> +       P_KEY_ROW5,
>> +       P_KEY_ROW4,
>> +       P_KEY_ROW3,
>> +       P_KEY_ROW2,
>> +       P_KEY_ROW1,
>> +       P_KEY_ROW0,
>> +       0
>> +};
>> +
>> +static u16 per_cols[] = {
>
>Same here.
>
>> +       P_KEY_COL7,
>> +       P_KEY_COL6,
>> +       P_KEY_COL5,
>> +       P_KEY_COL4,
>> +       P_KEY_COL3,
>> +       P_KEY_COL2,
>> +       P_KEY_COL1,
>> +       P_KEY_COL0,
>> +       0
>> +};
>> +
>> +
>> +       if (bfin_kpad_get_keypressed(bf54x_kpad)) {
>> +               disable_irq(bf54x_kpad->irq);
>> +               bf54x_kpad->lastkey = key;
>> +               bf54x_kpad->timer.expires = jiffies
>> +                                       +
bf54x_kpad->keyup_test_jiffies;
>> +               add_timer(&bf54x_kpad->timer);
>
>mod_timer()?
>
>> +
>> +       input->keycode = pdata->keymap;
>
>Please consider allocating memory for keycode so that platfrom data
>can be kept constant.

Typical use cases for this driver module would be in a single user
embedded system. - More likely going through reboot than through a
module unload/load cycle with different user setting. But you are right
cleaner is to copy the key codes.


>
>> +       input->keycodesize = sizeof(unsigned short);
>> +       input->keycodemax = pdata->keymapsize;
>> +
>> +       /* setup input device */
>> +       set_bit(EV_KEY, input->evbit);
>> +
>> +       if (pdata->repeat)
>> +               set_bit(EV_REP, input->evbit);
>> +
>
>__set_bit() should suffice here and above.
>
>> +       for (i = 0; i < pdata->keymapsize; i++)
>> +               __set_bit(pdata->keymap[i] & KEY_MAX, input->keybit);
>> +
>> +       __clear_bit(KEY_RESERVED, input->keybit);
>> +
>> +       error = input_register_device(input);
>> +
>> +       if (error) {
>> +               printk(KERN_ERR DRV_NAME
>> +                       ": Unable to register input device (%d)\n",
>error);
>> +               goto out4;
>> +       }
>> +
>> +       /* Init Keypad Key Up/Release test timer */
>> +
>> +       init_timer(&bf54x_kpad->timer);
>> +       bf54x_kpad->timer.function = bfin_kpad_timer;
>> +       bf54x_kpad->timer.data = (unsigned long) pdev;
>> +
>
>setup_timer()?
>
>> +
>> +       bfin_write_KPAD_PRESCALE(bfin_kpad_get_prescale(TIME_SCALE));
>> +
>> +       bfin_write_KPAD_CTL((((pdata->cols - 1) << 13) & KPAD_COLEN)
|
>> +                               (((pdata->rows - 1) << 10) &
KPAD_ROWEN)
>|
>> +                               (2 & KPAD_IRQMODE));
>> +
>> +
>> +       bfin_write_KPAD_CTL(bfin_read_KPAD_CTL() | KPAD_EN);
>> +
>> +       printk(KERN_ERR DRV_NAME
>> +               ": Blackfin BF54x Keypad registered IRQ %d\n",
>bf54x_kpad->irq);
>> +
>> +       return 0;
>> +
>> +
>> +out4:
>> +       input_free_device(input);
>> +out3:
>> +       free_irq(bf54x_kpad->irq, pdev);
>> +out2:
>> +       peripheral_free_list(&per_cols[MAX_RC - pdata->cols]);
>> +out1:
>> +       peripheral_free_list(&per_rows[MAX_RC - pdata->rows]);
>> +out:
>> +       kfree(bf54x_kpad);
>> +       platform_set_drvdata(pdev, NULL);
>> +
>> +       return error;
>> +}
>> +
>> +static int __devexit bfin_kpad_remove(struct platform_device *pdev)
>> +{
>> +       struct bfin_kpad_platform_data *pdata =
pdev->dev.platform_data;
>> +       struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
>> +
>> +
>> +       del_timer_sync(&bf54x_kpad->timer);
>> +       free_irq(bf54x_kpad->irq, pdev);
>> +
>> +       peripheral_free_list(&per_rows[MAX_RC - pdata->rows]);
>> +       peripheral_free_list(&per_cols[MAX_RC - pdata->cols]);
>> +
>> +       input_unregister_device(bf54x_kpad->input);
>> +
>> +       kfree(bf54x_kpad);
>> +       platform_set_drvdata(pdev, NULL);
>> +
>> +       return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int bfin_kpad_suspend(struct platform_device *pdev,
pm_message_t
>state)
>> +{
>
>Do you need these empty functions? At least stop timer here.

Currently not - I'm going to remove them.

>
>Thanks!
>
>Oh, one more thing - do not access input->private directly - it is
>going away - use input_set_drvdata() and input_get_drvdata().
>
>--
>Dmitry
