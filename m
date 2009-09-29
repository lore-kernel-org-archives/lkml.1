Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZI2Qt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZI2Qt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZI2Qt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:49:28 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:51151 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZI2Qt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YeLCIQ0ZuR/twCUNJLgHqZozFgSh2woFb9nk6tWwuaOSxjCbvgabCA6+tgYm2PZF7Z
         MnI4ZMJrXphREpp6MnJfYcgWdhvT7hDjrtKw9oVi6UAGDyFLFMSKiL+TZVqocSHHNwO1
         8hHvVQK1u67SgNeuZ88TGEdEDuJvI3oUTWg3s=
MIME-Version: 1.0
In-Reply-To: <20090929141618.GD18847@vespa.holoscopio.com>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com>
	 <9b2b86520909290220g6b5f6beal6337b17f1bdd339@mail.gmail.com>
	 <20090929141618.GD18847@vespa.holoscopio.com>
Date: Tue, 29 Sep 2009 17:41:42 +0100
Message-ID: <9b2b86520909290941g6295ba36i907dfda62b968529@mail.gmail.com>
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org, dtor@mail.ru,
       dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/29/09, Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
> On Tue, Sep 29, 2009 at 10:20:44AM +0100, Alan Jenkins wrote:
> Hello, Allan.
>
> Thanks for the feedback. I am considering an investigation whether we
> have lots of other ACPI input devices that could share some code like
> {add,remove}_acpi_notify_device. Regarding the driver naming, I will
> send a second version with it and other modifications considering your
> feedback and that of other people too.
>
> I will also ask for some explicit feedback and add linux-input and
> Dmitry to the loop.
>

I'll leave the input questions for the list.  I don't have any
suggestions about your choice of keycode for the house key, or how to
calibrate accelerometers.

>> > +struct device_attribute cmpc_accel_sense_attr = {
>> > +	.attr = { .name = "sense", .mode = 0220 },
>> > +	.store = cmpc_accel_sense_store
>> > +};

> This changes the accelerometer device sensitivity. I will take a look at
> the ACPI tables to get a range. If very much sensitive, the device will
> generate too much ACPI notifications, even when the classmate PC is no a
> table and there seems to be no movement. If not very much sensitive, you
> must throw it spinning into the air to get anything.  :-)
>
> I will pick a default value, although I think we could let it to
> userspace, but a sensible default value will not hurt here. As far as I
> know, there is no ACPI method to do get_sense, but we can mirror the
> last value written and provide a .show.
>
> What do you recommend as a documentation? Something at
> Documentation/ABI/testing/, perhaps? I don't know if there are any other
> devices with something similar, but I would not be surprised if there
> are some of them.

Documentation/ABI seems reasonable; "sysfs-platform-eeepc-laptop" was
accepted there.

You could try (either in place of documentation, or in addition to)
making the interface self-explanatory.  Call the attribute
"sensitivity", and add a "max_sensitivity" attribute.  It would also
make the interface more generic.

>> > +static void cmpc_tablet_idev_init(struct input_dev *inputdev)
>> > +{
>> > +	set_bit(EV_SW, inputdev->evbit);
>> > +	set_bit(SW_TABLET_MODE, inputdev->swbit);
>>
>> Don't you need to initialize the switch value here?
>>
>
> No, input_allocate_device does kzalloc. Otherwise, this would apply to
> the other bitmaps as well.

The other bitmaps aren't for switches though.  Here's what prompted
this comment - a snippet from the old (2.6.29) version of
Documentation/rfkill.txt:

"2. Input device switches (sources of EV_SW events) DO store their current state
(so you *must* initialize it by issuing a gratuitous input layer event on
driver start-up and also when resuming from sleep), and that state CAN be
queried from userspace through IOCTLs."

>> Also, have you tested this with changing the switch value while
>> suspended?  I _think_ you need to update the switch state on resume.
>> This is purely from looking at other acpi drivers and their evolution;
>> I don't have any practical experience with input drivers.
>>
>
> Interesting point. I will do the testing.

Thanks
Alan
