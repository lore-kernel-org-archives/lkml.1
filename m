Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZBPPVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZBPPVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZBPPUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:20:55 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:41249 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZBPPUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:20:54 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Mike Murphy <mamurph@cs.clemson.edu>
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
Date: Mon, 16 Feb 2009 16:21:27 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com> <200902160931.34771.oliver@neukum.org> <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com>
In-Reply-To: <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902161621.28142.oliver@neukum.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 16 February 2009 14:22:05 schrieb Mike Murphy:
> >
> > 3. Possible memory leak in error case:
> >
> > +static struct xpad_data *xpad_create_data(const char *name, struct kobject *parent) {
> > +       struct xpad_data *data = NULL;
> > +       int check;
> > +
> > +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> > +       if (!data)
> > +               return NULL;
> > +
> > +       check = kobject_init_and_add(&data->kobj, &xpad_ktype, parent, "%s", name);
> > +       if (check) {
> > +               kobject_put(&data->kobj);
> > +               return NULL;
> > +       }
> >
> 
> My understanding from Documentation/kobject.txt is that the
> kobject_put in the 2nd error check will set the kobj's reference
> counter to zero, eventually causing the kobject core to call my
> cleanup function for the ktype (xpad_release) and free the memory. Is
> this not correct? I find the sysfs docs to be fairly thin... and sysfs

I don't know. I also find that documentation thin.
Please add that the memory is freed elsewhere.

> seems to be substantially more complex than procfs or ioctls would be
> for the same purpose. However, everything I read suggested that sysfs
> is the "best" way to go in a modern kernel.
> 
> > 4. Why the cpup variety?
> >
> > +       coords[0] = (__s16) le16_to_cpup((__le16 *)(data + x_offset));
> >
> 
> The cpup cast is in the original stable driver
> (drivers/input/joystick/xpad.c), and I didn't question it.
> 
> > 5. What happens if this work is already scheduled?
> >
> >        if (data[0] & 0x08) {
> > +               padnum = xpad->controller_data->controller_number;
> >                if (data[1] & 0x80) {
> > -                       xpad->pad_present = 1;
> > -                       usb_submit_urb(xpad->bulk_out, GFP_ATOMIC);
> > -               } else
> > -                       xpad->pad_present = 0;
> > +                       printk(KERN_INFO "Wireless Xbox 360 pad #%d present\n", padnum);
> > +                       xpad->controller_data->pad_present = 1;
> > +
> > +                       INIT_WORK(&xpad->work, &xpad_work_controller);
> > +                       schedule_work(&xpad->work);
> >

> 1. The user has to remove the battery pack from the controller,
> reinstall the battery pack, and re-activate the controller by pushing
> and holding the center button for at least 1 second.
> 
> 2. The kernel has to be busy enough not to have completed the work in
> the ~2 seconds a human could have done (1).

Also what happens if the work is scheduled  and you unplug?

> I need a bit of guidance from someone who has a better understanding
> of the work queues to have a good solution to this one. Is switching
> to PREPARE_WORK sufficient (with an INIT_WORK somewhere in
> xpad_probe)? Or is a more involved solution needed?
> 
> > 6. No GFP_ATOMIC. If you can take a mutex you can sleep.
> > +               usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
> >
> 
> Per the "Linux Device Drivers" book (O'Reilly, 3rd ed), the claim is
> made that submissions while holding a mutex should be GFP_ATOMIC. My

That is not correct. It is true while holding a spinlock, not a mutex.

> tests seemed to verify this claim... as sending LED commands
> GFP_KERNEL while holding the mutex resulted in BUGs (scheduling while
> atomic) in dmesg. Switching those GFP_KERNELs to GFP_ATOMICs
> eliminated that particular BUG.

Please post that BUG.

	Regards
		Oliver
