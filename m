Return-Path: <linux-kernel-owner+w=401wt.eu-S1764854AbXJORYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764854AbXJORYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXJORYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:24:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:28897 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbXJORYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JRCgKXE+ytjRXbOs0FpQpMey5uGOsiY8fB9DgDOpk8C8OFECEPx24zEFwmHfxVH23MRwpd8+RL5ggSXvYwBKDgh17Qa8mliC1jnH42IWbF1gCrsMIkSZEpY/jETENTCjgzcAncnXuZ+U2nt/GSJTTB+RYfxUM1KHaMqEuzdhjgM=
Message-ID: <386072610710151024s13e9c16qd7c974cde8000a9@mail.gmail.com>
Date: Tue, 16 Oct 2007 01:24:28 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH try #3] Input/Joystick Driver: add support AD7142 joystick driver
Cc: bryan.wu@analog.com, "Andrey Panin" <pazke@donpac.ru>,
       "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192459625.6215.17.camel@roc-laptop>
	 <d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Bryan,
>
> On 10/15/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > +
> > +static int ad7142_thread(void *nothing)
> > +{
> > +       do {
> > +               wait_for_completion(&ad7142_completion);
> > +               ad7142_decode();
> > +               enable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> > +       } while (!kthread_should_stop());
> > +
>
> No, this is not going to work well:
> - you at least need to reinitialize the completion before enabling
> IRQ, otherwise you will spin in a very tight loop
> - if noone would touch the joystick ad7142_clsoe would() block
> infinitely because noone would signal the completion and
> ad7142_thread() would never stop.
>
> Completion is just not a good abstraction here... Please use work
> abstraction and possibly a separate workqueue.

Yes, I agree with you now, although I have a little concern about the
possibility of big delay introduced by workqueue.

>
> > +
> > +       ad7142_task = kthread_run(ad7142_thread, NULL, "ad7142_task");
> > +       if (IS_ERR(ad7142_task)) {
> > +               printk(KERN_ERR "serio: Failed to start kseriod\n");
>
> kseriod?

My fault, I did't notice this copy words from other driver.

>
> > +               return PTR_ERR(ad7142_task);
> > +       }
> > +       return 0;
> > +}
> > +
> > +static void ad7142_close(struct input_dev *dev)
> > +{
>
> Don't you need to write something over i2c to tell the device to shut
> down? As it is now I expect the device to continue raising its IRQ
> until kernel decides that it is unhandled and should be ignored.
>
I am not sure here, should do some investigate of the hardware datasheet.


> > +       free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
>
> Ok, so you freeing IRQ here, but it is allocated in ad7142_probe().
> What happen if you try to open device after it was closed?
>
Yes, it should be move to ad7142_detach_client()

> > +       kthread_stop(ad7142_task);
> > +}
> > +
> > +static int __init ad7142_init(void)
> > +{
> > +       return i2c_add_driver(&ad7142_driver);
> > +}
> > +
> > +static void __exit ad7142_exit(void)
> > +{
> > +       i2c_del_driver(&ad7142_driver);
> > +       input_unregister_device(ad7142_dev);
>
> input_unregister_device() should be in ad7142_detach_client? I am not
> sure i2c - there seems to be 2 interface styles and you probably need
> to use the new one. I am CC-inj Jean on this.
>
Yes, no need input_unregister_device() here.

Thanks a lot for you kindly review.
I will resend update patch later.

Best Regards,
-Bryan Wu
