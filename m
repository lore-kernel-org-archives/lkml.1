Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZEROWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZEROWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbZEROWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:22:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:42436 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZEROWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lVPmnmr7y3aYf2Rn2QYlBpmRLoHf05rt5ZNnjcCa9GyyhEe07a2XVp4zLbzA6QAIzr
         RnnmJFh6rQgWwcweuqUCpuIvfUgdpEkJM6rxK37C5cNQJ1ZWQjUZhkmMTo1/6mkrtpVL
         spNlQDjQQs2hFiMsM0DSkHUD9KSHnrRkMWRpY=
MIME-Version: 1.0
In-Reply-To: <4A0BF776.9030301@compulab.co.il>
References: <63386a3d0905140129s5fd0f32cxde1114489678f012@mail.gmail.com>
	 <4A0BF776.9030301@compulab.co.il>
Date: Mon, 18 May 2009 16:22:36 +0200
Message-ID: <63386a3d0905180722u282f0dd3ua62b119a1a6a97e8@mail.gmail.com>
Subject: Re: [PATCH] MFD: Add U300 AB3100 core support v1
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
       linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/14 Mike Rapoport <mike@compulab.co.il>:

> A few comments.

First a BIG THANKS. I worked the last few days according to your and
Samuel's comments, great input!

I'll send a v2 soonish with all issues fixed as far as possible. Below
I just discuss things I haven't yet figured out how to fix properly.
(Most stuff is simply just fixed.)

>> +     /*
>> +      * A two-byte write message with the first byte containing the register
>> +      * number and the second byte containing the value to be written
>> +      * effectively sets a register in the AB3100.
>> +      */
>> +     if ((i2c_transfer(ab3100_i2c_client->adapter,
>> +                                     &msgs[0], 1)) != 1) {
>
> Is it necessary to use i2c_transfer here? Maybe i2c_master_send or even
> i2c_smbus_write_word_data would do the job?

Yep it works nicely here but...

>> +/*
>> + * The test registers exist at an I2C bus address up one
>> + * from the ordinary base. They are not supposed to be used
>> + * in production code, but sometimes you have to do that
>> + * anyway. It's currently only used from this file so declare
>> + * it static and do not export.
>> + */
>> +static int ab3100_set_test_register(u8 reg, u8 regval)
>> +{
>> +     u8 regandval[2] = {reg, regval};
>> +     struct i2c_msg msgs[1];
>> +     int err = 0;
>> +
>> +     if (!ab3100_initialized)
>> +             return -ENODEV;
>> +
>> +     msgs[0].addr = ab3100_i2c_client->addr + 1;
>> +     msgs[0].flags = 0;
>> +     msgs[0].len = 2;
>> +     msgs[0].buf = regandval;
>> +     err = mutex_lock_interruptible(&ab3100_access_mutex);
>> +     if (err)
>> +             return err;
>> +
>> +     /*
>> +      * A two-byte write message with the first byte containing the register
>> +      * number and the second byte containing the value to be written
>> +      * effectively sets a register in the AB3100.
>> +      */
>> +     if ((i2c_transfer(ab3100_i2c_client->adapter,
>> +                       &msgs[0], 1)) != 1) {
>
> i2c_master_send?

Here we have a problem. See above:
msgs[0].addr = ab3100_i2c_client->addr + 1;

So this chip actually has two addresses. A "special" address
to deal with test registers, one address up. The I2C framework
assume all devices have one and one address only (which is
of course mostly true).

Here is a special case. When the first device has registered,
you know that the other address is available as well.

You could think of several ugly solutions:

* Keep using i2c_transfer() directly as we do now.

* Make a raw copy of the i2c_device with something like
  memcpy(mock_client, i2c_client, sizeof(i2c_client);
  mock_client->addr++;
  then use i2c_master_send()

* Register a new i2c_device in board_info for the other
  address while strictly speaking it is the same device, and
  this will yield a lot of probing and synchronization code,
  because writing the test registers is used when probing the
  first device, so we have to wait for that device to be probed
  before we can probe the other one etc.

Right now I lean toward the first alternative.

Yours,
Linus Walleij
