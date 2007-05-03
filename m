Return-Path: <linux-kernel-owner+w=401wt.eu-S376232AbXECRIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376232AbXECRIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031360AbXECRIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:08:10 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:37917 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031363AbXECRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:08:08 -0400
Date: Thu, 3 May 2007 19:07:03 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
In-Reply-To: <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de>
References: <20070501195052.390551603@mail.of.borg>  <20070501195129.842338339@mail.of.borg>
 <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static unsigned char rep_scancode;
> > +static struct timer_list atakeyb_rep_timer = {
> > +       .function = atakeyb_rep,
> > +};
>
> Is there a problem with repeat implementation in input core that
> requres custom-made repeater here?

Apparently not - the homebrew repeater has not been active pretty much
since I started to work on Atari in 2.6... time to kill that code.

> > +
> > +                               // handle_scancode(scancode, !break_flag);
>
> The code looks a bit dirty (old code commented out, C++ style comments).

You got that right.

> > +
> > +
> > +int atari_kbdrate(struct kbd_repeat *k)
> > +{
> > +       if (k->delay > 0) {
> > +               /* convert from msec to jiffies */
> > +               key_repeat_delay = (k->delay * HZ + 500) / 1000;
>
> If this is really needed - msecs_to_jiffies().

That has to go as well (together with the repeater).

>
> >
> > +config KEYBOARD_ATARI
> > +       tristate "Atari keyboard"
> > +       depends on ATARI
> > +       select ATARI_KBD_CORE
> > +       help
> > +         Say Y here if you are running Linux on any Atari and have a keyboard
> > +         attached.
> > +
> > +         To compile this driver as a module, choose M here: the
> > +         module will be called atakbd.
>
> Can we spell it out: atarikbd or atari_kbd?

Could do that, yes. Christoph suggested to fold everythig into atakeyb.c
so modularization would go away here.

>
> > +
> > +       if (!(atakbd_dev = input_allocate_device()))
> > +               return -ENOMEM;
> > +
> > +       // need to init core driver if not already done so
> > +       if (atari_keyb_init())
>
> Memory leak

How so? If the core has been initialized already this will just return ...

> > +       for (i = 1; i < 0x72; i++) {
> > +               atakbd_keycode[i] = i;
> > +               set_bit(atakbd_keycode[i], atakbd_dev->keybit);
>
> It looks like this driver is not using standard input event codes. If
> Roman does not want to adjust keymaps on Amiga and Atari that should
> be handled in legacy keyboard driver (drivers/char/keyboard.c). As it
> is programs using /dev/input/eventX have no chance of working.

The translation map should not have been overwritten like above, is that
what you mean?
My original patch didn't have that bit; scancodes were translated to
input keycodes using atakbd_keycode[scancode] instead. I'll have that
reverted...

> > +       }
> > +
> > +       input_register_device(atakbd_dev);
>
> Error handling.

Oops.

>
> > +
> > +static int mouse_threshold[2] = {2,2};
> > +
> > +#ifdef __MODULE__
> > +MODULE_PARM(mouse_threshold, "2i");
>
> MODULE_PARM is so 20th century...

Never tested, sorry.

> > +
> > +static int atamouse_open(struct input_dev *dev)
> > +{
> > +       if (atamouse_used++)
> > +               return 0;
>
> No need to count, input core takes care of this.

OK; I'll delete this.

> > +
> > +       printk(KERN_INFO "input: %s at keyboard ACIA\n", atamouse_dev->name);
>
> Input core already logs every input device registered, do we need to
> repeat it in the driver?

Not really ... I'll merge atakeyb.c, atakbd.c and atamouse.c and send a
new patch to Geert.

Thanks,

	Michael
