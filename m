Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbZEIB7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbZEIB7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 21:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZEIB7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 21:59:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:54307 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZEIB7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 21:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gJyqUSTpKMK2Ji8UsTsl6750RckB7wo3dYyOGEJxehoI4Nm1oRycwJACsgEX1fkSce
         HNoTYi8Xc7x3JQcQ6HCdYZFitiRPk//Wy3NWPiuNvNgtvQNdkNbLBDLdtwvv6BhqpOmn
         zn5bHvP6QCKIaL2KLBB7Fv4+7PrjUiYLs92fo=
MIME-Version: 1.0
In-Reply-To: <20090508031859.GE30616@dtor-d630.eng.vmware.com>
References: <4A012C64.1020101@samsung.com> <20090508031859.GE30616@dtor-d630.eng.vmware.com>
From: Kim Kyuwon <chammoru@gmail.com>
Date: Sat, 9 May 2009 10:58:45 +0900
Message-ID: <4d34a0a70905081858y56dacf34of004301f93daf3e3@mail.gmail.com>
Subject: Re: Input: add MAX7359 key switch controller driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thank you for good comments. I fixed all as you recommended. More
detailed answers are below your comments.
In addition, I also added wakeup related statements
(device_init_wakeup, device_may_wakeup, [enable|disable]_irq_wake).

I'm sending this revised patch right now.

By the way, can I ask the same question which I ask to Trilok.
Even though I guard suspend/resume with #ifdef CONFIG_PM in the new
patch, Could I know the good reason for this protection? Because
'/Documentation/SubmittingPatches' says "ifdefs are ugly"

Thank you Dmitry again for your comments and time.
Kyuwon

On Fri, May 8, 2009 at 12:19 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Kim,
>
> On Wed, May 06, 2009 at 03:21:24PM +0900, Kim Kyuwon wrote:
>> @@ -332,4 +332,12 @@ config KEYBOARD_SH_KEYSC
>>
>>         To compile this driver as a module, choose M here: the
>>         module will be called sh_keysc.
>> +
>> +config KEYBOARD_MAX7359
>> +     tristate "Maxim MAX7359 Key Switch Controller"
>> +     depends on I2C
>> +     help
>> +       If you say yes here you get support for the Maxim MAX7359 Key
>> +       Switch Controller chip. This providers microprocessors with
>> +       management of up to 64 key switches
>
> "To compile this driver as a module..."

I added this sentence.

>> +
>> +#include <linux/module.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/input.h>
>> +#include <linux/max7359_keypad.h>
>> +
>> +#define MAX_KEY_NUM                  (8 * 8)
>
> Please do:
>
> #define MAX_KEY_NUM     (MAX_MATRIX_KEY_ROWS * MAX_MATRIX_KEY_COLS)

I did
#define MAX7359_MAX_KEY_NUM	(MAX7359_MAX_KEY_ROWS * MAX7359_MAX_KEY_COLS)
Thanks.

>> +static int max7359_write_reg(struct i2c_client *client, u8 reg, u8 val)
>> +{
>> +     int ret = i2c_smbus_write_byte_data(client, reg, val);
>
> Empty line after declarations please.

Fixed.

>> +static irqreturn_t max7359_interrupt(int irq, void *dev_id)
>> +{
>> +     struct max7359_keypad *keypad = (struct max7359_keypad *) dev_id;
>> +
>> +     if (!work_pending(&keypad->work)) {
>> +             disable_irq_nosync(keypad->irq);
>> +             schedule_work(&keypad->work);
>> +     } else {
>> +             dev_err(&keypad->client->dev,
>> +                             "Another job is currently pending \n");
>
> Is this truly an error?

I changed dev_err to dev_warn.

>> +
>> +static int __exit max7359_remove(struct i2c_client *client)
>
> __devexit, not __exit.

Fixed.

>> +
>> +static int max7359_suspend(struct i2c_client *client, pm_message_t mesg)
>> +{
>> +     /* If no keys are pressed, enter sleep mode for 8192 ms */
>
> What happens if there are keys that are pressed?

I added more comments in new function(max7359_fall_deepsleep) as below:
/*
 * Let MAX7359 fall into a deep sleep:
 * If no keys are pressed, enter sleep mode for 8192 ms. And if any
 * key is pressed, the MAX7359 returns to normal operating mode.
 */

>> +     max7359_write_reg(client, MAX7359_REG_SLEEP, 0x01);
>> +
>> +     return 0;
>> +}
>> +
>> +static int max7359_resume(struct i2c_client *client)
>> +{
>> +     /* Restore the default setting (autosleep for 256 ms) */
>> +     max7359_write_reg(client, MAX7359_REG_SLEEP, 0x07);
>> +
>> +     return 0;
>> +}
>
> Could we also have similar open and close? It seems prudent to be in low
> power mode if there are no users of the device.

Sure we can. I added max7359_open, max7359_close

>> +
>> +static struct i2c_driver max7359_i2c_driver = {
>> +     .driver = {
>> +             .name = "max7359",
>> +     },
>> +     .probe          = max7359_probe,
>> +     .remove         = __exit_p(max7359_remove),
>
> __devexit_p();

Fixed.

>> +     .suspend        = max7359_suspend,
>> +     .resume         = max7359_resume,
>
> Guard suspend/resume with #ifdef CONFIG_PM please.

I guarded them.

>> +
>> +#define MAX_MATRIX_KEY_ROWS  8
>> +#define MAX_MATRIX_KEY_COLS  8
>
> These names are too generic, may clash with other #includes
> eventially... adding MAX7359_ prefix seems prudent.

I added MAX7539_ prefix and these macros are moved to max7359_keypad.c file.
