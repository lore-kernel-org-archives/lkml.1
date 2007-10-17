Return-Path: <linux-kernel-owner+w=401wt.eu-S935911AbXJQQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935911AbXJQQMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbXJQQMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:12:43 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:40858 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836AbXJQQMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fyV7GiW53Ex8hr2mbOo/J2bGAoVX93ckbVKTcqvNyh+O1/Q9HrwF6MnTfsFrM7PVrKH4YIajwvFaU7Kr5TdaFYxE7ir4QZb5+habOGfeInQWSS7vGOXaqdwGD5/YUxaNsug1TYWsIdUR5sK61+z1YjnhDAf7RVURTITwSBWsJlI=
Message-ID: <d120d5000710170912o3503a0f8s55bb4b7294f80e58@mail.gmail.com>
Date: Wed, 17 Oct 2007 12:12:38 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH try #4] Input/Joystick Driver: add support AD7142 joystick driver
Cc: "Andrey Panin" <pazke@donpac.ru>, "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <1192605120.7920.15.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192605120.7920.15.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 10/17/07, Bryan Wu <bryan.wu@analog.com> wrote:
> Subject: [PATCH try #4] Input/Joystick Driver: add support AD7142 joystick driver
>

My comments are in addition to Jean's:

> +
> +static void ad7142_close(struct input_dev *dev)
> +{
> +       struct ad7142_data *data = input_get_drvdata(dev);
> +       struct i2c_client *client = &data->client;
> +       unsigned short value;
> +

I think you need disable_irq() here

> +       flush_scheduled_work();
> +
> +       /*
> +        * Turn AD7142 to full shutdown mode
> +        * No CDC conversions
> +        */
> +       value = 0x0001;
> +       ad7142_i2c_write(client, PWRCONVCTL, &value, 1);

and enable_irq() here. This way you can be sure that you will not
re-arm the work between flush_scheduled_work() and shutting off the
controller.

> +
> +static int ad7142_attach(struct i2c_adapter *adap)
> +{
> +       return i2c_probe(adap, &addr_data, &ad7142_probe);
> +}
> +
> +static int ad7142_detach(struct i2c_client *client)
> +{
> +       int rc;
> +
> +       free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
> +
> +       flush_scheduled_work();
> +
> +       rc = i2c_detach_client(client);
> +       if (!rc)
> +               kfree(i2c_get_clientdata(client));
> +       return rc;
> +}
> +
> +
> +static int __init ad7142_init(void)
> +{
> +       return i2c_add_driver(&ad7142_driver);
> +}
> +
> +static void __exit ad7142_exit(void)
> +{
> +       i2c_del_driver(&ad7142_driver);
> +}
> +
> +module_init(ad7142_init);
> +module_exit(ad7142_exit);

Where did input_unregister_device() go? It still needs to be somewhere...

-- 
Dmitry
