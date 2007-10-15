Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbXJOPs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbXJOPs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXJOPsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:48:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:11639 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbXJOPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TW/RU2nsKu1IM3ZRzWOpkTVnVKUOw8nQR8/Ytiwuie1UHgX7YGQeZ+mjTJHXMQCP74+ajXuzs93iC6lkR6ZbmtOdQ4ZL4xUStHeWxcVc0aadTW5XVruKZmEmuG03RnHSr6RpNYlb1wF/8Gt8hWKi9T+mi5f2y/XcC3uoXq3PIvQ=
Message-ID: <d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com>
Date: Mon, 15 Oct 2007 11:48:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH try #3] Input/Joystick Driver: add support AD7142 joystick driver
Cc: "Andrey Panin" <pazke@donpac.ru>, "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <1192459625.6215.17.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192459625.6215.17.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 10/15/07, Bryan Wu <bryan.wu@analog.com> wrote:
> +
> +static int ad7142_thread(void *nothing)
> +{
> +       do {
> +               wait_for_completion(&ad7142_completion);
> +               ad7142_decode();
> +               enable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +       } while (!kthread_should_stop());
> +

No, this is not going to work well:
- you at least need to reinitialize the completion before enabling
IRQ, otherwise you will spin in a very tight loop
- if noone would touch the joystick ad7142_clsoe would() block
infinitely because noone would signal the completion and
ad7142_thread() would never stop.

Completion is just not a good abstraction here... Please use work
abstraction and possibly a separate workqueue.

> +
> +       ad7142_task = kthread_run(ad7142_thread, NULL, "ad7142_task");
> +       if (IS_ERR(ad7142_task)) {
> +               printk(KERN_ERR "serio: Failed to start kseriod\n");

kseriod?

> +               return PTR_ERR(ad7142_task);
> +       }
> +       return 0;
> +}
> +
> +static void ad7142_close(struct input_dev *dev)
> +{

Don't you need to write something over i2c to tell the device to shut
down? As it is now I expect the device to continue raising its IRQ
until kernel decides that it is unhandled and should be ignored.

> +       free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);

Ok, so you freeing IRQ here, but it is allocated in ad7142_probe().
What happen if you try to open device after it was closed?

> +       kthread_stop(ad7142_task);
> +}
> +
> +static int __init ad7142_init(void)
> +{
> +       return i2c_add_driver(&ad7142_driver);
> +}
> +
> +static void __exit ad7142_exit(void)
> +{
> +       i2c_del_driver(&ad7142_driver);
> +       input_unregister_device(ad7142_dev);

input_unregister_device() should be in ad7142_detach_client? I am not
sure i2c - there seems to be 2 interface styles and you probably need
to use the new one. I am CC-inj Jean on this.

> +}
> +
> +module_init(ad7142_init);
> +module_exit(ad7142_exit);
> --
> 1.5.3.4
>


-- 
Dmitry
