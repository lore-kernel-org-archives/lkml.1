Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbXJLOtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbXJLOtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbXJLOtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:49:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:62536 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbXJLOtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iiN1bIKjhXtskHvmMlsAo0KpJsKGGHZnL0rzNUkQL/uQdwXLfdG8I0Ti9GGSSIP5AQQKdO6odjc6s9nxGxOPChpwPalrMK/1WL7xbKf4LcvN4CxnIRB1fBDoW8X9Y4Hlf/juJQRjVliyWEuN9w7lV5dJgaFrkmw8fEfsWiZIQFw=
Message-ID: <d120d5000710120749o2505dd7aq42559c35298f05d0@mail.gmail.com>
Date: Fri, 12 Oct 2007 10:49:13 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystick driver
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1192174727.6247.20.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192174727.6247.20.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> +
> +static int
> +ad7142_probe(struct i2c_adapter *adap, int addr, int kind)
> +{
> +       struct i2c_client *client;
> +       int rc;
> +
> +       client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
> +       if (!client)
> +               return -ENOMEM;
> +       memset(client, 0, sizeof(struct i2c_client));

kzalloc?

> +       strncpy(client->name, AD7142_DRV_NAME, I2C_NAME_SIZE);

strlcpy?

> +       client->addr = addr;
> +       client->adapter = adap;
> +       client->driver = &ad7142_driver;
> +
> +       rc = i2c_attach_client(client);
> +       if (rc) {
> +               printk(KERN_ERR "i2c_attach_client fail: %d\n", rc);
> +               goto fail_attach;
> +       }
> +
> +       /*
> +        * The ADV7142 has an autoincrement function,
> +        * use it if the adapter understands raw I2C
> +        */
> +       rc = i2c_check_functionality(client->adapter, I2C_FUNC_I2C);
> +       if (!rc) {
> +               printk(KERN_ERR
> +                       "AD7142: i2c bus doesn't support raw I2C operation\n");
> +               rc = -EINVAL;

I wonder if -ENOSYS is any better here...

> +               goto fail_check;
> +       }
> +
> +       rc = request_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt,
> +                       IRQF_TRIGGER_LOW, "ad7142_joy", ad7142_interrupt);
> +       if (rc) {
> +               printk(KERN_ERR "AD7142: Can't allocate irq %d\n",
> +                       CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +               rc = -EBUSY;

Just use rc as is.

...
> +
> +static int ad7142_i2c_read(struct i2c_client *client, unsigned short offset,
> +               unsigned short *data, unsigned int len)
> +{
> +       int ret = -1;
> +       int i;
> +       u8 block_data[32];
> +
> +       if (len < 1 && len > 16) {

What Roel said ;)

> +
> +static int ad7142_thread(void *nothing)
> +{
> +       do {
> +               wait_event_interruptible(ad7142_wait,
> +                       kthread_should_stop() || (intr_flag != 0));

should we add "if (intr_flag) { " here? How would the kernel react if
you enable_irq() on irq that is already enabled?

> +               ad7142_decode();
> +               intr_flag = 0;
> +               enable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +       } while (!kthread_should_stop());
> +
> +       pr_debug("ad7142: kthread exiting\n");
> +
> +       return 0;
> +}
> +
> +static int ad7142_open(struct input_dev *dev)
> +{
> +       unsigned short id, value;
> +
> +       ad7142_i2c_read(ad7142_client, DEVID, &id, 1);
> +       if (id != AD7142_I2C_ID) {
> +               printk(KERN_ERR "Open AD7142 error\n");
> +               return -ENODEV;
> +       }
> +
> +       ad7142_i2c_write(ad7142_client, STAGE0_CONNECTION, stage[0], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE1_CONNECTION, stage[1], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE2_CONNECTION, stage[2], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE3_CONNECTION, stage[3], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE4_CONNECTION, stage[4], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE5_CONNECTION, stage[4], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE6_CONNECTION, stage[4], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE7_CONNECTION, stage[4], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE8_CONNECTION, stage[4], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE9_CONNECTION, stage[4], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE10_CONNECTION, stage[4], 8);
> +       ad7142_i2c_write(ad7142_client, STAGE11_CONNECTION, stage[4], 8);
> +
> +       value = 0x00B0;
> +       ad7142_i2c_write(ad7142_client, PWRCONVCTL, &value, 1);
> +
> +       value = 0x0690;
> +       ad7142_i2c_write(ad7142_client, AMBCOMPCTL_REG1, &value, 1);
> +
> +       value = 0x0664;
> +       ad7142_i2c_write(ad7142_client, AMBCOMPCTL_REG2, &value, 1);
> +
> +       value = 0x290F;
> +       ad7142_i2c_write(ad7142_client, AMBCOMPCTL_REG3, &value, 1);
> +
> +       value = 0x000F;
> +       ad7142_i2c_write(ad7142_client, INTEN_REG0, &value, 1);
> +       ad7142_i2c_write(ad7142_client, INTEN_REG1, &value, 1);
> +
> +       value = 0x0000;
> +       ad7142_i2c_write(ad7142_client, INTEN_REG2, &value, 1);
> +
> +       ad7142_i2c_read(ad7142_client, AMBCOMPCTL_REG1, &value, 1);
> +
> +       value = 0x000F;
> +       ad7142_i2c_write(ad7142_client, AMBCOMPCTL_REG0, &value, 1);
> +
> +       ad7142_task = kthread_run(ad7142_thread, NULL, "ad7142_task");
> +       if (IS_ERR(ad7142_task)) {
> +               printk(KERN_ERR "serio: Failed to start kseriod\n");
> +               return PTR_ERR(ad7142_task);
> +       }
> +       return 0;
> +}
> +
> +static void ad7142_close(struct input_dev *dev)
> +{
> +       free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
> +       kthread_stop(ad7142_task);

Don't you need to write something over i2c to shut the devoce off?
What stops it from continuing to generate interrupts?

> +}
> +
> +static int __init ad7142_init(void)
> +{
> +       int ret;
> +
> +       ad7142_dev = input_allocate_device();
> +       if (!ad7142_dev)
> +               return -ENOMEM;
> +
> +       ad7142_dev->open = ad7142_open;
> +       ad7142_dev->close = ad7142_close;
> +       ad7142_dev->evbit[0] = BIT(EV_KEY);
> +       ad7142_dev->keybit[LONG(BTN_BASE)] = BIT(BTN_BASE) | BIT(BTN_BASE2) |
> +                                               BIT(BTN_BASE3) | BIT(BTN_BASE4);
> +       ad7142_dev->keybit[LONG(KEY_UP)] |= BIT(KEY_UP) | BIT(KEY_DOWN) |
> +                                               BIT(KEY_LEFT) | BIT(KEY_RIGHT);
> +
> +       ad7142_dev->name = "ad7142 joystick";
> +       ad7142_dev->phys = "ad7142/input0";
> +       ad7142_dev->id.bustype = BUS_I2C;
> +       ad7142_dev->id.vendor = 0x0001;
> +       ad7142_dev->id.product = 0x0001;
> +       ad7142_dev->id.version = 0x0100;
> +
> +       ret = input_register_device(ad7142_dev);
> +       if (ret) {
> +               printk(KERN_ERR "Failed to register AD7142 input device!\n");
> +               goto fail_register;
> +       }
> +

This all should go into ad7142_probe(). There is no need to create an
input device if we not going to attach to i2c adapter.

> +       ret = i2c_add_driver(&ad7142_driver);
> +       if (ret) {
> +               printk(KERN_ERR "Failed to add AD7142 I2C driver!\n");
> +               goto fail_add;
> +       }
> +       return 0;
> +
> +fail_add:
> +       input_unregister_device(ad7142_dev);

You need to stick "ad7142_dev" here - you are not allowed to call
input_free_device() after calling input_unregister_device().

> +fail_register:
> +       input_free_device(ad7142_dev);
> +       return ret;
> +}
> +
> +static void __exit ad7142_exit(void)
> +{
> +       i2c_del_driver(&ad7142_driver);
> +       input_unregister_device(ad7142_dev);
> +}
> +
> +module_init(ad7142_init);
> +module_exit(ad7142_exit);
> --
> 1.5.3.4
>
>

-- 
Dmitry
