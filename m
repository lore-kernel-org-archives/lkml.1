Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZGONgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZGONgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZGONgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:36:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57844 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbZGONgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:36:35 -0400
Date: Wed, 15 Jul 2009 15:36:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Subject: Re: Support for synaptic touchscreen in HTC dream
Message-ID: <20090715133627.GA2538@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz> <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
> > +{
> 
> some documentation about this logic would be great.

Arve, can you help here?


> > +       int pos[2][2];
> > +       int f, a;
> > +       int base = 2;
> > +       int z = buf[1];
> > +       int w = buf[0] >> 4;
> > +       int finger = buf[0] & 7;
> > +       int finger2_pressed;
> > +
> > +       for (f = 0; f < 2; f++) {
> > +               u32 flip_flag = SYNAPTICS_FLIP_X;
> > +               for (a = 0; a < 2; a++) {
> > +                       int p = buf[base + 1];
> > +                       p |= (u16)(buf[base] & 0x1f) << 8;
> > +                       if (ts->flags & flip_flag)
> > +                               p = ts->max[a] - p;
> > +                       if (ts->flags & SYNAPTICS_SNAP_TO_INACTIVE_EDGE) {


> > +static irqreturn_t synaptics_ts_irq_handler(int irq, void *dev_id)
> > +{
> > +       struct synaptics_ts_data *ts = dev_id;
> > +
> > +       disable_irq(ts->client->irq);
> 
> disable_irq_nosync or convert this to request_threaded_irq(...).
> Please see recent discussion on linux-input for MAX key switch
> controller.

Do you have a link? (I replaced it with disable_irq_nosync, if that is
enough...)

> > +static int synaptics_ts_probe(
> > +       struct i2c_client *client, const struct i2c_device_id *id)
> > +{
> 
> __devinit ?

Ok.

> > +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> 
> check for SMBUS? I have added linux-i2c as this driver has i2c bits,
> so not removing any code.

I guess this driver is only probed on mach-pxa... on machines that
have the neccessary hardware.

> > +               printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
> 
> dev_xxx/pr_xxx friends?

Fixed all occurences.


> > +       ts->input_dev = input_allocate_device();
> > +       if (ts->input_dev == NULL) {
> > +               ret = -ENOMEM;
> > +               pr_err("synaptics: Failed to allocate input device\n");
> > +               goto err_input_dev_alloc_failed;
> > +       }
> > +       ts->input_dev->name = "synaptics-rmi-touchscreen";
> 
> other parameters of input_dev, like vendor, bus etc.,

Ok, what are those for? I can probably invent some dummy values, but...

> > +       set_bit(EV_SYN, ts->input_dev->evbit);
> > +       set_bit(EV_KEY, ts->input_dev->evbit);
> > +       set_bit(BTN_TOUCH, ts->input_dev->keybit);
> > +       set_bit(BTN_2, ts->input_dev->keybit);
> > +       set_bit(EV_ABS, ts->input_dev->evbit);
> > +
> 
> __set_bit or input_set_capability please.

__set_bit is easier, done.

> > +static int synaptics_ts_remove(struct i2c_client *client)
> > +{
> 
> __devexit

Applied.


> > +static int synaptics_ts_suspend(struct i2c_client *client, pm_message_t mesg)
> > +{
> 
> #ifdef CONFIG_PM ?

Yep.

> > +MODULE_DESCRIPTION("Synaptics Touchscreen Driver");
> > +MODULE_LICENSE("GPL");
> 
> MODULE_ALIAS?

Umm, why? This is loaded from board-*.c files, and I don't think i2c
has enumeration capabilities.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
