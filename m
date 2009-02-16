Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbZBPNgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbZBPNgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZBPNgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:36:24 -0500
Received: from mail-gx0-f163.google.com ([209.85.217.163]:52885 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbZBPNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:36:22 -0500
MIME-Version: 1.0
In-Reply-To: <200902160931.34771.oliver@neukum.org>
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com>
	 <200902160931.34771.oliver@neukum.org>
Date: Mon, 16 Feb 2009 08:22:05 -0500
X-Google-Sender-Auth: 69cd3f0c52d4f575
Message-ID: <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com>
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 3:31 AM, Oliver Neukum <oliver@neukum.org> wrote:
...
>
> 1. You need to check the returns of sscanf

Will add... this is currently preliminary and not very well tested.

> 2. This is very ugly:
>
> +/* read-only attrs */
> +static ssize_t xpad_show_int(struct xpad_data *xd, struct xpad_attribute *attr,
> +       char *buf)
> +{
> +       int value;
> +       if (!strcmp(attr->attr.name, "controller_number"))
> +               value = xd->controller_number;
> +       else if (!strcmp(attr->attr.name, "pad_present"))
> +               value = xd->pad_present;
> +       else if (!strcmp(attr->attr.name, "controller_type"))
> +               value = xd->controller_type;
> +       else
> +               value = 0;
> +       return sprintf(buf, "%d\n", value);
> +}

The above code is basically following the example in
samples/kobject/kset-example.c. I broke the rest of the sysfs stuff
out such that it uses separate functions for show/store, which
definitely looks cleaner. However, given the large amount of code that
results, I'm starting to think that re-factoring and pulling the sysfs
code out to a separate file might be useful.

>
> 3. Possible memory leak in error case:
>
> +static struct xpad_data *xpad_create_data(const char *name, struct kobject *parent) {
> +       struct xpad_data *data = NULL;
> +       int check;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return NULL;
> +
> +       check = kobject_init_and_add(&data->kobj, &xpad_ktype, parent, "%s", name);
> +       if (check) {
> +               kobject_put(&data->kobj);
> +               return NULL;
> +       }
>

My understanding from Documentation/kobject.txt is that the
kobject_put in the 2nd error check will set the kobj's reference
counter to zero, eventually causing the kobject core to call my
cleanup function for the ktype (xpad_release) and free the memory. Is
this not correct? I find the sysfs docs to be fairly thin... and sysfs
seems to be substantially more complex than procfs or ioctls would be
for the same purpose. However, everything I read suggested that sysfs
is the "best" way to go in a modern kernel.

> 4. Why the cpup variety?
>
> +       coords[0] = (__s16) le16_to_cpup((__le16 *)(data + x_offset));
>

The cpup cast is in the original stable driver
(drivers/input/joystick/xpad.c), and I didn't question it.

> 5. What happens if this work is already scheduled?
>
>        if (data[0] & 0x08) {
> +               padnum = xpad->controller_data->controller_number;
>                if (data[1] & 0x80) {
> -                       xpad->pad_present = 1;
> -                       usb_submit_urb(xpad->bulk_out, GFP_ATOMIC);
> -               } else
> -                       xpad->pad_present = 0;
> +                       printk(KERN_INFO "Wireless Xbox 360 pad #%d present\n", padnum);
> +                       xpad->controller_data->pad_present = 1;
> +
> +                       INIT_WORK(&xpad->work, &xpad_work_controller);
> +                       schedule_work(&xpad->work);
>

I'm still a little fuzzy on this... in theory, I could see that
INIT_WORK would clobber the existing work structures while they wait
in the queue (thought about changing to PREPARE_WORK).

However, in practice, this work queue trick is only used when a
wireless 360 controller connects to the receiver. There is 1 instance
of struct usb_xpad per wireless controller (4 total, since the
receiver exposes 4 controller slots), and each instance has a separate
struct work_struct. So two things have to happen to reschedule the
work before it completes:

1. The user has to remove the battery pack from the controller,
reinstall the battery pack, and re-activate the controller by pushing
and holding the center button for at least 1 second.

2. The kernel has to be busy enough not to have completed the work in
the ~2 seconds a human could have done (1).

I need a bit of guidance from someone who has a better understanding
of the work queues to have a good solution to this one. Is switching
to PREPARE_WORK sufficient (with an INIT_WORK somewhere in
xpad_probe)? Or is a more involved solution needed?

> 6. No GFP_ATOMIC. If you can take a mutex you can sleep.
> +               usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
>

Per the "Linux Device Drivers" book (O'Reilly, 3rd ed), the claim is
made that submissions while holding a mutex should be GFP_ATOMIC. My
tests seemed to verify this claim... as sending LED commands
GFP_KERNEL while holding the mutex resulted in BUGs (scheduling while
atomic) in dmesg. Switching those GFP_KERNELs to GFP_ATOMICs
eliminated that particular BUG.

>        Regards
>                Oliver

Thanks for your reply... I will keep working on the driver as time
allows. This is really the first driver on which I've done any
substantial hacking, and my formal kernel-level programming training
was on an older version of the FreeBSD kernel, so I'm having to learn
things as I go. I'm trying to develop based off the latest stable
sources, so the outdated nature of most of the reference material I
have is not helping matters.

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
