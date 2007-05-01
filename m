Return-Path: <linux-kernel-owner+w=401wt.eu-S1946006AbXEAUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946006AbXEAUqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945944AbXEAUqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:46:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:16494 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945974AbXEAUqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YMs2ljf+/gA7YIJZJ4KtEU0DXWVsDd02hcSz+Q9OBlcIEKfKLsEeYjg0lbWn9VobB90G78drcla3Thr5onX1n3KV+ugLY5WvxFWrE2sHmMU8SJx/J1HE4CJR4BO7AmbzzvjCn0/t+E+bDbvz0jLnJNmOb3WdLgDSdPemsd2/tnw=
Message-ID: <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com>
Date: Tue, 1 May 2007 16:46:22 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Michael Schmitz" <schmitz@debian.org>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <20070501195129.842338339@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070501195052.390551603@mail.of.borg>
	 <20070501195129.842338339@mail.of.borg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/1/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> +
> +/* These could be settable by some ioctl() in future... */
> +static unsigned int key_repeat_delay = DEFAULT_KEYB_REP_DELAY;
> +static unsigned int key_repeat_rate = DEFAULT_KEYB_REP_RATE;
> +
> +static unsigned char rep_scancode;
> +static struct timer_list atakeyb_rep_timer = {
> +       .function = atakeyb_rep,
> +};

Is there a problem with repeat implementation in input core that
requres custom-made repeater here?

> +
> +                               // handle_scancode(scancode, !break_flag);

The code looks a bit dirty (old code commented out, C++ style comments).

> +
> +
> +int atari_kbdrate(struct kbd_repeat *k)
> +{
> +       if (k->delay > 0) {
> +               /* convert from msec to jiffies */
> +               key_repeat_delay = (k->delay * HZ + 500) / 1000;

If this is really needed - msecs_to_jiffies().

>
> +config KEYBOARD_ATARI
> +       tristate "Atari keyboard"
> +       depends on ATARI
> +       select ATARI_KBD_CORE
> +       help
> +         Say Y here if you are running Linux on any Atari and have a keyboard
> +         attached.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called atakbd.

Can we spell it out: atarikbd or atari_kbd?

> +
> +       if (!(atakbd_dev = input_allocate_device()))
> +               return -ENOMEM;
> +
> +       // need to init core driver if not already done so
> +       if (atari_keyb_init())

Memory leak

> +               return -ENODEV;
> +
> +       atakbd_dev->name = "Atari Keyboard";
> +       atakbd_dev->phys = "atakbd/input0";
> +       atakbd_dev->id.bustype = BUS_ATARI;
> +       atakbd_dev->id.vendor = 0x0001;
> +       atakbd_dev->id.product = 0x0001;
> +       atakbd_dev->id.version = 0x0100;
> +
> +       atakbd_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
> +       atakbd_dev->keycode = atakbd_keycode;
> +       atakbd_dev->keycodesize = sizeof(unsigned char);
> +       atakbd_dev->keycodemax = ARRAY_SIZE(atakbd_keycode);
> +
> +       for (i = 1; i < 0x72; i++) {
> +               atakbd_keycode[i] = i;
> +               set_bit(atakbd_keycode[i], atakbd_dev->keybit);

It looks like this driver is not using standard input event codes. If
Roman does not want to adjust keymaps on Amiga and Atari that should
be handled in legacy keyboard driver (drivers/char/keyboard.c). As it
is programs using /dev/input/eventX have no chance of working.

> +       }
> +
> +       input_register_device(atakbd_dev);

Error handling.

> +
> +static int mouse_threshold[2] = {2,2};
> +
> +#ifdef __MODULE__
> +MODULE_PARM(mouse_threshold, "2i");

MODULE_PARM is so 20th century...

> +#endif
> +#ifdef FIXED_ATARI_JOYSTICK
> +extern int atari_mouse_buttons;
> +#endif
> +static int atamouse_used = 0;

Initialization is not needed. Moreover the counter is not needed.

> +
> +static int atamouse_open(struct input_dev *dev)
> +{
> +       if (atamouse_used++)
> +               return 0;

No need to count, input core takes care of this.

> +
> +static int __init atamouse_init(void)
> +{
> +       if (!MACH_IS_ATARI || !ATARIHW_PRESENT(ST_MFP))
> +               return -ENODEV;
> +
> +       if (!(atamouse_dev = input_allocate_device()))
> +               return -ENOMEM;
> +
> +       if (!(atari_keyb_init()))

Memory leak

> +               return -ENODEV;
> +
> +       atamouse_dev->name = "Atari mouse";
> +       atamouse_dev->phys = "atamouse/input0";
> +       atamouse_dev->id.bustype = BUS_ATARI;
> +       atamouse_dev->id.vendor = 0x0001;
> +       atamouse_dev->id.product = 0x0002;
> +       atamouse_dev->id.version = 0x0100;
> +
> +       atamouse_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
> +       atamouse_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
> +       atamouse_dev->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
> +       atamouse_dev->open = atamouse_open;
> +       atamouse_dev->close = atamouse_close;
> +
> +       input_register_device(atamouse_dev);

Error handling.

> +
> +       printk(KERN_INFO "input: %s at keyboard ACIA\n", atamouse_dev->name);

Input core already logs every input device registered, do we need to
repeat it in the driver?

-- 
Dmitry
