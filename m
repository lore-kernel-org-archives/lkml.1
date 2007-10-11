Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbXJKMpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbXJKMpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXJKMpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:45:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:15093 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbXJKMpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NMgvojSctQ9E1HRYExa5QTDJEa6tLq66REieRr1VeITFmYUlWCNTVAzlfS3rHCSFEKh4M6mhPTyLbpK/CkmueDYal5Wl88Fbar59iJKc0bEQTjEKEio4lANXduhlWtZe945b5RGu5NWQB8kzmsmivV88xm/pWxenRn/GlASZZ98=
Message-ID: <d120d5000710110544u4cf45efbwe29869578efe5495@mail.gmail.com>
Date: Thu, 11 Oct 2007 08:44:57 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>,
       "Michael Hennerich" <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/3] Input/Joystick Driver: add support AD7142 joystick driver
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1192098220-25828-2-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192098220-25828-1-git-send-email-bryan.wu@analog.com>
	 <1192098220-25828-2-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian, Michael,

On 10/11/07, Bryan Wu <bryan.wu@analog.com> wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>

Thank you for the patch. The formatting of the patch is unorthodox,
could you please run it through lindent? Also:

> +
> +#undef  DEBUG
> +
> +#ifdef DEBUG
> +#define DPRINTK(x...)   printk(x)
> +#else
> +#define DPRINTK(x...)   do { } while (0)
> +#endif
> +

pr_debug()

> +MODULE_AUTHOR("Aubrey Li <aubrey.li@analog.com>");
> +MODULE_DESCRIPTION("Driver for AD7142 joysticks");
> +MODULE_LICENSE("GPL");
> +
> +/*
> + * Feeding the output queue to the device is handled by way of a
> + * workqueue.
> + */
> +static struct task_struct *ad7142_task;
> +static DECLARE_WAIT_QUEUE_HEAD(ad7142_wait);
> +
> +static int ad7142_used=0;

No need to initialize. In fact, this variable is not needed at all.

> +static struct input_dev *ad7142_dev;
> +static char *ad7142_phys={"ad7142/input0"};
> +
> +static char *ad7142_name = "ad7142 joystick";
> +

Just use literals right in the _probe() function - that is the only
place where they are used as far as I can see.


> +static unsigned short stage[5][8]={

const?

> +
> +static int
> +ad7142_i2c_write(struct i2c_client *client,
> +                    unsigned short    offset,
> +                     unsigned short    *data,
> +                     unsigned int       len)
> +{
> +        int ret = -1;
> +       int i;
> +
> +       if(len<1 || len>16){
> +               printk("AD7142: Write data length error\n");
> +               return ret;
> +       }
> +        /* the adv7142 has an autoincrement function, use it if
> +         * the adapter understands raw I2C */
> +        if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +                /* do raw I2C, not smbus compatible */
> +               u8 block_data[34];
> +
> +               block_data[0] = (offset & 0xFF00)>>8;
> +               block_data[1] = (offset & 0x00FF);
> +               for(i=0;i<len;i++){
> +                       block_data[2*i+2] = (*data & 0xFF00)>>8;
> +                       block_data[2*i+3] = *data++ & 0x00FF;
> +               }
> +               if((ret = i2c_master_send(client, block_data,len*2+2))<0){
> +                       printk("AD7142: I2C write error\n");
> +                       return ret;
> +               }
> +       } else
> +               printk("AD7142: i2c bus doesn't support raw I2C operation\n");

Does not this condition cause driver to fail completely? If so I'd
move it in probe function and  not even try initializing the device if
functionality is missing.

> +
> +unsigned short old_status_low=0,old_status_high=0;

Initialization is not needed and I'd move these inside ad7142_decode().

> +
> +static void ad7142_decode(void)
> +{
> +       unsigned short irqno_low=0,irqno_high=0;

Why do you need to initialize these?

> +        unsigned short temp;
> +
> +        ad7142_i2c_read(ad7142_client,INTSTAT_REG0,&irqno_low,1);
> +        temp = irqno_low ^ old_status_low;
> +       switch(temp){
> +       case 0x0001:    input_report_key(ad7142_dev, BTN_BASE, irqno_low&0x0001);
> +                       old_status_low = irqno_low;

This can be moved out of switch statement.

> +                       break;
> +       case 0x0002:    input_report_key(ad7142_dev, BTN_BASE4, (irqno_low&0x0002)>>1);
> +                        old_status_low = irqno_low;
> +                        break;
> +       case 0x0004:    input_report_key(ad7142_dev, KEY_UP, (irqno_low&0x0004)>>2);
> +                        old_status_low = irqno_low;
> +                        break;
> +       case 0x0008:    input_report_key(ad7142_dev, KEY_RIGHT, (irqno_low&0x0008)>>3);
> +                        old_status_low = irqno_low;
> +                        break;
> +        }
> +        ad7142_i2c_read(ad7142_client,INTSTAT_REG1,&irqno_high,1);
> +        temp = irqno_high ^ old_status_high;
> +       switch(temp){
> +       case 0x0001:    input_report_key(ad7142_dev, BTN_BASE2, irqno_high&0x0001);
> +                       old_status_high = irqno_high;

Same here.

> +                       break;
> +       case 0x0002:    input_report_key(ad7142_dev, BTN_BASE3, (irqno_high&0x0002)>>1);
> +                        old_status_high = irqno_high;
> +                        break;
> +       case 0x0004:    input_report_key(ad7142_dev, KEY_DOWN, (irqno_high&0x0004)>>2);
> +                        old_status_high = irqno_high;
> +                        break;
> +       case 0x0008:    input_report_key(ad7142_dev, KEY_LEFT, (irqno_high&0x0008)>>3);
> +                        old_status_high = irqno_high;
> +                        break;
> +        }
> +        input_sync(ad7142_dev);
> +}
> +
> +
> +static int intr_flag = 0;
> +static int ad7142_thread(void *nothing)
> +{
> +        do {
> +               wait_event_interruptible(ad7142_wait, kthread_should_stop() || (intr_flag!=0));
> +               ad7142_decode();
> +                intr_flag = 0;
> +               enable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +        } while (!kthread_should_stop());
> +        printk(KERN_DEBUG "ad7142: kthread exiting\n");
> +        return 0;
> +}
> +
> +static irqreturn_t ad7142_interrupt(int irq, void *dummy, struct pt_regs *fp)
> +{
> +       disable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +       intr_flag = 1;
> +       wake_up_interruptible(&ad7142_wait);
> +       return IRQ_HANDLED;
> +}
> +
> +static int ad7142_open(struct input_dev *dev)
> +{
> +       int *used = dev->private;

input_get_drvdata()

> +       unsigned short id,value;
> +       ad7142_i2c_read(ad7142_client, DEVID, &id, 1);
> +       if(id != AD7142_I2C_ID){
> +               printk(KERN_ERR "Open AD7142 error\n");
> +               return -ENODEV;
> +       }
> +       if ((*used)++)
> +               return 0;

No need to count, input core serializes open and close and makes sure
they are called only once.

> +
> +       if (request_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt, \
> +               IRQF_TRIGGER_LOW, "ad7142_joy", ad7142_interrupt)) {
> +               (*used)--;
> +               printk(KERN_ERR "ad7142.c: Can't allocate irq %d\n",CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +               return -EBUSY;
> +       }

What are the chances for IRQ to be used by 2 drivers? Maybe just
request_irq in proble?

> +
> +
> +       ad7142_i2c_write(ad7142_client,STAGE0_CONNECTION,stage[0],8);
> +       ad7142_i2c_write(ad7142_client,STAGE1_CONNECTION,stage[1],8);
> +       ad7142_i2c_write(ad7142_client,STAGE2_CONNECTION,stage[2],8);
> +       ad7142_i2c_write(ad7142_client,STAGE3_CONNECTION,stage[3],8);
> +       ad7142_i2c_write(ad7142_client,STAGE4_CONNECTION,stage[4],8);
> +       ad7142_i2c_write(ad7142_client,STAGE5_CONNECTION,stage[4],8);
> +       ad7142_i2c_write(ad7142_client,STAGE6_CONNECTION,stage[4],8);
> +       ad7142_i2c_write(ad7142_client,STAGE7_CONNECTION,stage[4],8);
> +       ad7142_i2c_write(ad7142_client,STAGE8_CONNECTION,stage[4],8);
> +       ad7142_i2c_write(ad7142_client,STAGE9_CONNECTION,stage[4],8);
> +       ad7142_i2c_write(ad7142_client,STAGE10_CONNECTION,stage[4],8);
> +       ad7142_i2c_write(ad7142_client,STAGE11_CONNECTION,stage[4],8);
> +
> +       value = 0x00B0;
> +       ad7142_i2c_write(ad7142_client,PWRCONVCTL,&value,1);
> +
> +       value = 0x0690;
> +       ad7142_i2c_write(ad7142_client,AMBCOMPCTL_REG1,&value,1);
> +
> +       value = 0x0664;
> +       ad7142_i2c_write(ad7142_client,AMBCOMPCTL_REG2,&value,1);
> +
> +       value = 0x290F;
> +       ad7142_i2c_write(ad7142_client,AMBCOMPCTL_REG3,&value,1);
> +
> +       value = 0x000F;
> +       ad7142_i2c_write(ad7142_client,INTEN_REG0,&value,1);
> +       ad7142_i2c_write(ad7142_client,INTEN_REG1,&value,1);
> +
> +       value = 0x0000;
> +       ad7142_i2c_write(ad7142_client,INTEN_REG2,&value,1);
> +
> +       ad7142_i2c_read(ad7142_client,AMBCOMPCTL_REG1,&value,1);
> +
> +       value = 0x000F;
> +       ad7142_i2c_write(ad7142_client,AMBCOMPCTL_REG0,&value,1);
> +
> +       ad7142_task = kthread_run(ad7142_thread, NULL, "ad7142_task");
> +        if (IS_ERR(ad7142_task)) {
> +                printk(KERN_ERR "serio: Failed to start kseriod\n");
> +                return PTR_ERR(ad7142_task);
> +        }
> +       return 0;
> +}
> +
> +static void ad7142_close(struct input_dev *dev)
> +{
> +       int *used = dev->private;
> +
> +       if (!--(*used))
> +               free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
> +       kthread_stop(ad7142_task);
> +}
> +
> +static int __init ad7142_init(void)
> +{
> +       ad7142_dev = input_allocate_device();
> +       if(!ad7142_dev)
> +               return -ENOMEM;

This should be done when you bind to i2c device, not before.

> +       ad7142_dev->open = ad7142_open;
> +       ad7142_dev->close = ad7142_close;
> +       ad7142_dev->evbit[0] = BIT(EV_KEY);
> +       ad7142_dev->keybit[LONG(BTN_BASE)] = BIT(BTN_BASE) | BIT(BTN_BASE2) | BIT(BTN_BASE3) | BIT(BTN_BASE4);
> +       ad7142_dev->keybit[LONG(KEY_UP)] |= BIT(KEY_UP) | BIT(KEY_DOWN) | BIT(KEY_LEFT) | BIT(KEY_RIGHT);
> +
> +       ad7142_dev->name = ad7142_name;
> +       ad7142_dev->phys = ad7142_phys;
> +       ad7142_dev->id.bustype = BUS_I2C;
> +       ad7142_dev->id.vendor = 0x0001;
> +       ad7142_dev->id.product = 0x0001;
> +       ad7142_dev->id.version = 0x0100;
> +
> +       ad7142_dev->private = &ad7142_used;

input_set_drvdata();

> +
> +       input_register_device(ad7142_dev);

Error handling please.

> +       i2c_add_driver (&ad7142_driver);
> +
> +       return 0;
> +}
> +
> +static void __exit ad7142_exit(void)
> +{
> +       i2c_del_driver (&ad7142_driver);
> +       input_unregister_device(ad7142_dev);
> +}
> +
> +module_init(ad7142_init);
> +module_exit(ad7142_exit);
> --
> 1.5.3.4
>

Thanks!

-- 
Dmitry
