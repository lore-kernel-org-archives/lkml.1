Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbXEUV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbXEUV0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbXEUVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:25:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:39389 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755760AbXEUVZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:25:50 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX19/fIkH695/pLVc0IiSy6VEoPK4WmbeE5u0VnhObs
	XhHZnH6hzBVRQ4
From: Uwe Bugla <uwe.bugla@gmx.de>
To: "Ken Chen" <kenchen@google.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Mon, 21 May 2007 23:20:54 +0200
User-Agent: KMail/1.9.5
References: <464F42F3.1080300@madrabbit.org> <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com> <b040c32a0705211348r664e37f4hf03bec6ab27a7139@mail.gmail.com>
In-Reply-To: <b040c32a0705211348r664e37f4hf03bec6ab27a7139@mail.gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kay Sievers" <kay.sievers@vrfy.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705212320.55270.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. Mai 2007 22:48 schrieben Sie:
> On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> > The easiest way is to reinstate max_loop and create "max_loop" device
> > up front at module load time.  However, that will lose all the "fancy
> > on-demand device instantiation feature".
> >
> > So I propose we do the following:
> >
> > 1. have the module honor "max_loop" parameter and create that many
> > device upfront on module load (max_loop will also be a hard max) iff
> > user specify the parameter.
> > 2. if max_loop is not specified, default create 8 loop device.  User
> > can extent more loop device by create device node themselves and have
> > kernel automatically instantiate loop device on-demand.
> >
> > Is this acceptable?  Patch in a bit.
>
> Could people who has problem with loop device please test this?  I
> tested it on my Ubuntu feisty distribution and it works fine. Though I
> typically don't use loop device at all.
>
> ---
>
> The kernel on-demand loop device instantiation breaks several user
> space tools as the tools are not ready to cope with the "on-demand
> feature".  Fix it by instantiate default 8 loop devices and also
> reinstate max_loop module parameter.
>
> Signed-off-by: Ken Chen <kenchen@google.com>
>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 5526ead..0aae8d8 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1354,7 +1354,7 @@ #endif
>   */
>  static int max_loop;
>  module_param(max_loop, int, 0);
> -MODULE_PARM_DESC(max_loop, "obsolete, loop device is created on-demand");
> +MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
>
> @@ -1462,34 +1462,66 @@ static struct kobject *loop_probe(dev_t
>  	return kobj;
>  }
>
> -static int __init loop_init(void)
> -{
> -	if (register_blkdev(LOOP_MAJOR, "loop"))
> -		return -EIO;
> -	blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
> -				  THIS_MODULE, loop_probe, NULL, NULL);
> -
> -	if (max_loop) {
> -		printk(KERN_INFO "loop: the max_loop option is obsolete "
> -				 "and will be removed in March 2008\n");
> -
> -	}
> -	printk(KERN_INFO "loop: module loaded\n");
> -	return 0;
> -}
> -
>  static void __exit loop_exit(void)
>  {
> +	unsigned long range;
>  	struct loop_device *lo, *next;
>
> +	range = max_loop ? max_loop :  1UL << MINORBITS;
> +
>  	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
>  		loop_del_one(lo);
>
> -	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
> +	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
>  	if (unregister_blkdev(LOOP_MAJOR, "loop"))
>  		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
>  }
>
> +static int __init loop_init(void)
> +{
> +	int i, nr;
> +	unsigned long range;
> +
> +	/*
> +	 * loop module now has a feature to instantiate underlying device
> +	 * structure on-demand, provided that there is an access dev node.
> +	 * However, this will not work well with user space tool that doesn't
> +	 * know about such "feature".  In order to not break any existing
> +	 * tool, we do the following:
> +	 *
> +	 * (1) if max_loop is specified, create that many upfront, and this
> +	 *     also becomes a hard limit.
> +	 * (2) if max_loop is not specified, create 8 loop device on module
> +	 *     load, user can further extend loop device by create dev node
> +	 *     themselves and have kernel automatically instantiate actual
> +	 *     device on-demand.
> +	 */
> +	if (max_loop) {
> +		nr = max_loop;
> +		range = max_loop;
> +	} else {
> +		nr = 8;
> +		range = 1UL << MINORBITS;
> +	}
> +
> +	if (register_blkdev(LOOP_MAJOR, "loop"))
> +		return -EIO;
> +	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
> +				  THIS_MODULE, loop_probe, NULL, NULL);
> +
> +	for (i = 0; i < nr; i++) {
> +		if (!loop_init_one(i))
> +			goto err;
> +	}
> +
> +	printk(KERN_INFO "loop: module loaded\n");
> +	return 0;
> +err:
> +	loop_exit();
> +	printk(KERN_INFO "loop: out of memory\n");
> +	return -ENOMEM;
> +}
> +
>  module_init(loop_init);
>  module_exit(loop_exit);

Thank you, Ken :)
Excellent work, everything runs as expected.

Starting compilation of 2.6.22-rc2 I get the following nasty messages:

scripts/kconfig/conf -s arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config 
symbol 'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH' 
refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config 
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config 
symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

But, please note, that has nothing to do with the loop issue, which is solved 
with this patch.

Other sidenote:

I meanwhile tried to find out why my AMD K7 machine oopses with 2.6.21.1.
I first suspected sis5513 ide module, reverted all its dependencies, even 
changed a Makefile, but the Oops is still there after 10 modules reverted. I 
am standing in the dark, although I really would like to help to close down 
2.6.21.x "cleanly".

On Intel P 4 machines this Oops does not happen at all, only on the AMD K7 
machine.
Already planned to start a new thread but instead of wild guessing around I do 
not have any idea wht the reason for the kernel Oops could be.

Best Regards and Thanks

Uwe
