Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYLDFHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYLDFHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYLDFHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:07:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:17582 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYLDFHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:07:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HsEan2BwPMb0pI5k2pVQiVavRt/bHHfiR6Z0yWDR1iERPXoKm/fSRZOpkl6I0rQ5Zw
         HENeb0O+9FjnlptWAoY+ZEcmAybfmkau54nafXcdhWgSQ4udtfENYGEcy1OuMFTJsDZE
         uPp3Ryj6BfPeGu/GGrkWeGuyP7IH6mfAE0gKo=
Message-ID: <483a38b80812032107i761fb9bdkba9b2ce5e998ae6a@mail.gmail.com>
Date: Thu, 4 Dec 2008 14:07:30 +0900
From: "Kwangwoo Lee" <kwangwoo.lee@gmail.com>
To: felipe.balbi@nokia.com
Subject: Re: [PATCH] Add tsc2007 based touchscreen driver.
Cc: "ext Trilok Soni" <soni.trilok@gmail.com>, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
In-Reply-To: <20081203120144.GA10123@gandalf.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483a38b80812020539v2323a784h7f202749687764db@mail.gmail.com>
	 <5d5443650812030321p77c4941cj2202418f0b0d44a2@mail.gmail.com>
	 <20081203120144.GA10123@gandalf.research.nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 9:01 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
...
>> > +
>> > +static int tsc2007_xfer(void *tsc, unsigned char cmd)
>> > +{
>> > +       struct tsc2007    *ts     = tsc;
>> > +       struct i2c_client *client = ts->client;
>> > +
>> > +       unsigned char  rbuf[2];
>> > +       unsigned short val;
>> > +       int result;
>> > +
>> > +       result = i2c_master_send(client, &cmd, 1);
>> > +       if (result != 1) {
>> > +               dev_err(&client->dev, "send failed, cmd 0x%x\n", cmd);
>> > +               goto cmd_fail;
>> > +       }
>> > +
>> > +       result = i2c_master_recv(client, rbuf, 2);
>> > +       if (result != 2) {
>> > +               dev_err(&client->dev, "recv failed, cmd 0x%x\n", cmd);
>> > +               goto cmd_fail;
>> > +       }
>> > +
>> > +       rbuf[1] = (rbuf[1] >> 4) | ((rbuf[0] & 0x0f) << 4);
>> > +       rbuf[0] = rbuf[0] >> 4;
>> > +
>> > +       val = *((unsigned short *) rbuf);
>> > +       val = be16_to_cpu(val);
>> > +
>> > +       dev_dbg(&client->dev, "cmd [0x%x], rbuf [0x%x, 0x%x] => val [%u]\n",
>> > +               cmd, rbuf[0], rbuf[1], val);
>> > +
>> > +       return (int) val;
>> > +
>> > +cmd_fail:
>> > +       return -EIO;
>> > +}
>
> so you really need to go that low level ?? Did you try
> i2c_smbus_write_*() ??
>

Because the platform which I use did not implement smbus_xfer yet,
it only implemented  master_xfer in struct i2c_algorithm.
I can add smbus_xfer for my platform. I have one question and
I know that smbus is a subset from the I2C protocol.
Is smbus_xfer method better than master_xfer or is there any
special reason to use smbus_xfer?

>> > +
>> > +static int tsc2007_probe(struct i2c_client *client,
>> > +                       const struct i2c_device_id *id)
>> > +{
>> > +       struct i2c_adapter      *adapter = to_i2c_adapter(client->dev.parent);
>
> why ??

It's for i2c_check_functionality(). This function requried struct
i2c_adapter as an argument.

>> > +       struct tsc2007          *ts;
>> > +       struct tsc2007_platform_data *pdata;
>> > +       struct input_dev        *input_dev;
>> > +       int                     err;
>> > +
>> > +       pdata = client->dev.platform_data;
>> > +       if (pdata == NULL) {
>> > +               dev_err(&client->dev, "platform data is required!\n");
>> > +               return -EINVAL;
>> > +       }
>> > +
>> > +       if (!i2c_check_functionality(adapter,
>> > +                       I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
>> > +               return -EIO;
>
> should not be in this driver, I'd say.

I saw that some I2C driver uses this function, for example - max6875.c.
Is i2c_check_functionality() not necessary for a I2C client driver?

>> > +       ts->irq = client->irq;
>> > +       if (request_irq(ts->irq, tsc2007_irq, 0,
>> > +                       client->dev.driver->name, ts)) {
>> > +               dev_err(&client->dev, "irq %d busy?\n", ts->irq);
>> > +               err = -EBUSY;
>> > +               goto err_free_mem;
>
> would be better to:
>
> err = request_irq(...)
> if (err < 0) {
>        dev_err(..)
>        ...
> }
>
> Then we see the error request_irq() returned, which is more useful.

Thank you very much for your kind comments.

> Would be nice to get comments from Jean Delvare and Ben Dooks as well.

I also want to get more comments. Thank you, again.

-- 
Kwangwoo Lee <kwangwoo.lee@gmail.com>
