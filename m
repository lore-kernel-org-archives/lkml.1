Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbZBVRVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbZBVRVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZBVRVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:21:13 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:44193 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbZBVRVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:21:12 -0500
MIME-Version: 1.0
In-Reply-To: <20090222064806.GC8494@nowhere>
References: <5aa163d00902212131g7cf9218ewd8a6396a7f1c95fd@mail.gmail.com>
	 <20090222064806.GC8494@nowhere>
Date: Sun, 22 Feb 2009 12:21:10 -0500
X-Google-Sender-Auth: ab747f24580195df
Message-ID: <5aa163d00902220921s7c42f307xda6df7b071849fe4@mail.gmail.com>
Subject: Re: [PATCH] (revision 1) input: xpad.c - Xbox 360 wireless and sysfs 
	support
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 1:48 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
...
>> +static ssize_t xpad_store_rumble_enable(struct device *dev,
>> +             struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +     struct usb_xpad *xpad = to_xpad(dev);
>> +     int newrumble = xpad->rumble_enable;
>> +     if (1 == sscanf(buf, "%d", &newrumble))
>
>
> Oh, that's not wrong but it looks weird, usually, a code reader would
> expect to see if (sscanf(...) == 1)
>

Oops... I changed some stuff around (deleted an unneeded variable) and
didn't change the test form back.

The "backwards" expression is a trick that some of us teach when
teaching C, for the specific case of comparing a variable to a
constant. It allows the compiler to check for an unintentional "="
where a "==" was desired. (foo = 4) is not an error or a warning, but
(4 = foo) is. But in this case, I now effectively have constants on
both sides of the expression, so it just looks funny.

...
>> +
>> +static void xpad_init_controller(struct usb_xpad *xpad)
>> +{
>> +     set_stick_limit(XSTICK_LIMIT_DEFAULT, &xpad->left_stick_limit, xpad->left_dead_zone);
>> +     set_stick_limit(XSTICK_LIMIT_DEFAULT, &xpad->right_stick_limit, xpad->right_dead_zone);
>> +     set_dead_zone(XDEAD_ZONE_DEFAULT, &xpad->left_dead_zone, xpad->left_stick_limit);
>> +     set_dead_zone(XDEAD_ZONE_DEFAULT, &xpad->right_dead_zone, xpad->right_stick_limit);
>> +
>> +     if (xpad->controller_type == XCONTROLLER_TYPE_GUITAR) {
>> +             xpad->rumble_enable = 0;
>> +     }
>> +     else if (xpad->controller_type == XCONTROLLER_TYPE_DANCE_PAD) {
>> +             xpad->rumble_enable = 0;
>> +     }
>> +     else {
>> +             xpad->rumble_enable = 1;
>> +     }
>
>
> The brackets are not needed in these checks, may be you should run
> scripts/checkpatch.pl to check obvious coding styles issues.

Will do. This is not yet a "final" patch I'm ready to ask for
inclusion... I want to do some more testing first.

...
>> +#ifdef CONFIG_SYSFS
>> +     xpad->sysfs_ok = 1;
>> +     error = sysfs_create_group(&input_dev->dev.kobj, &xpad_default_attr_group);
>> +     if (error) {
>> +             /* Driver will work without the sysfs interface, but parameters
>> +              * will not be adjustable, so this failure is a warning. */
>> +             printk(KERN_WARNING "xpad: sysfs_create_group failed with error %d\n", error);
>> +             xpad->sysfs_ok = 0;
>> +     }
>> +#endif
>
>
> No need to check for CONFIG_SYSFS, sysfs_create_group will be a no-op which returns 0
> if not built.
>

Regarding this check and the others, if I remove them, the struct
usb_xpad instances will be slightly larger, and the code will be a bit
bigger than necessary (unless gcc optimizes away the un-called
functions), on systems where CONFIG_SYSFS is not set. In theory, I
don't see a need to have a system that uses this driver but does not
use the sysfs interface. In practice, however, I used to do all kinds
of crazy things when building systems for environmental sensing, so I
guess it could happen.

...
>
>
> Ditto. Actually it's useful for data which consume memory,
> or fields inside structures, but not for types themselves.
>
> But well, these parts are a removing, not new code.
>
> Anyway, looks like a nice work.
>
>
> Frederic.
>

Thanks for the feedback! I will clean up those issues and run the code
through the style checks. Tentatively, I'm hoping to have the final
revision of the patch by around mid-week for maybe one more round of
comments, then I'll post it "for real."

Thanks,
Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
