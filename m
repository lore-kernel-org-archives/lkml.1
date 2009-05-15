Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZEOTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZEOTbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZEOTbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:31:05 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56533 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZEOTbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ijmFO9P8ezfmtKslWRNR0QVmikEFX+uH3by2fw1Nfsar3iqpQwORADvFRznGf/E7o8
         nA2KM7J6gmABp9HeZLAmXndZte6YbQKqkrZdHVCT9yipuupg+eA5qFOFXps99gDkGSfk
         y6VPFPLm2u/LVDCHGye/ty3s682SEIEGvj4/4=
MIME-Version: 1.0
In-Reply-To: <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com>
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Fri, 15 May 2009 20:30:41 +0100
Message-ID: <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
To: Trilok Soni <soni.trilok@gmail.com>
Cc: felipe.balbi@nokia.com, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Jonathan Cameron <jic23@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am really interested about that.

But I want to know more about the device, its type, name, ...
The device isn't HID (Human Interface Device) ? If so, we should
rethink adding such thing but modify/use hid-input instead.

Because, I have an accelerometer phidget device and it is HID.
Handling should be the same.



On Fri, May 15, 2009 at 7:06 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Felipe,
>
> Adding linux-input and Jonathan, so not deleting any lines from this e-mail.
>
> On Fri, May 15, 2009 at 6:46 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
>> Hi all,
>>
>> the following patch is just an idea to see how the community feels about
>> it. Considering accelerometer devices, you might have different use
>> cases for it while running different applications. You could be using it
>> for screen rotation in one case but when opening a game, you could use
>> it as a game controller by turning the device side-by-side.
>
> There was one proposal from Jonathan called Industrial IO patchset
> which tried to address these sensor devices. Please grep in your
> linux-kernel archieve. I believe there are accelerometer drivers under
> drivers/hwmon.
>
>>
>> Thinking about that, I decided it would be nice to have some parameters
>> configured at runtime in order to be able to use the accelerometer on
>> different use cases.
>>
>> The following proposal (really draft) tries to add a new IOCTL on input
>> layer such as userland could use that for passing proper parameters to
>> accelerometer drivers.
>>
>> ps: the patch is in really early stage, I'm guessing the best would be
>> to, as force feedback devices, provide proper registration for an
>> accelerometer device.
>>
>> diff --git a/include/linux/input.h b/include/linux/input.h
>> index adc1332..c3c9e82 100644
>> --- a/include/linux/input.h
>> +++ b/include/linux/input.h
>> @@ -55,6 +55,26 @@ struct input_absinfo {
>>        __s32 flat;
>>  };
>>
>> +#define INPUT_ACCEL_IRQ_NONE   0
>> +#define INPUT_ACCEL_IRQ_HIGH   BIT(0)
>> +#define INPUT_ACCEL_IRQ_LOW    BIT(1)
>> +#define INPUT_ACCEL_IRQ_LATCH  BIT(2)
>> +
>> +struct input_accelinfo {
>> +       __u32 threshold;
>> +       __u32 duration;
>> +
>> +       /* the following 4 fields configure how the irqs will be generated:
>> +        * - High Event
>> +        * - Low Event
>> +        * - Latch irq request
>> +        */
>> +       __u8 x_irq;
>> +       __u8 y_irq;
>> +       __u8 z_irq;
>> +       __u8 click_irq;
>> +};
>> +
>>  #define EVIOCGVERSION          _IOR('E', 0x01, int)                    /* get driver version */
>>  #define EVIOCGID               _IOR('E', 0x02, struct input_id)        /* get device ID */
>>  #define EVIOCGREP              _IOR('E', 0x03, int[2])                 /* get repeat settings */
>> @@ -81,6 +101,8 @@ struct input_absinfo {
>>
>>  #define EVIOCGRAB              _IOW('E', 0x90, int)                    /* Grab/Release device */
>>
>> +#define EVIOCACCELINFO         _IOW('E', 0x91, struct input_accelinfo) /* set accelerometer's parameters */
>> +
>>  /*
>>  * Event types
>>  */
>> @@ -975,6 +997,8 @@ struct ff_effect {
>>  #include <linux/timer.h>
>>  #include <linux/mod_devicetable.h>
>>
>> +struct input_accelinfo;
>> +
>>  /**
>>  * struct input_dev - represents an input device
>>  * @name: name of the device
>> @@ -1069,6 +1093,7 @@ struct input_dev {
>>        void *keycode;
>>        int (*setkeycode)(struct input_dev *dev, int scancode, int keycode);
>>        int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
>> +       int (*set_accelinfo)(struct input_dev *dev, struct input_accelinfo *info);
>>
>>        struct ff_device *ff;
>>
>>
>>
>> --
>> balbi
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
>
> --
> ---Trilok Soni
> http://triloksoni.wordpress.com
> http://www.linkedin.com/in/triloksoni
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
