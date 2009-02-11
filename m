Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbZBKAxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbZBKAxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbZBKAiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:38:21 -0500
Received: from mail-ew0-f26.google.com ([209.85.219.26]:55513 "EHLO
	mail-ew0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835AbZBKAiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZPQYwRTs0672BEFfbR7656PTul2kuCpdHa2UumHGCjdqbTOuXBxiaJoQi0WUvYRj6I
         FgwMPFsWZ9wN6CE1joFk3CKyjWsV4dhbKBox95OiX6pkPYslYEWe1fCFBS6j964gE1Rx
         jHZaeO14Satpm8IOqpFFA8Z+GLtFEwnzQOUAk=
MIME-Version: 1.0
In-Reply-To: <499218C4.4080808@tremplin-utc.net>
References: <1234310519-14230-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <499218C4.4080808@tremplin-utc.net>
Date: Wed, 11 Feb 2009 01:38:18 +0100
Message-ID: <cb7bb73a0902101638x6f63ba47wa47fd99aacfab185@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: support both one- and two-byte sensors
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 1:16 AM, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> Giuseppe Bilotta schreef:
>
>> As pointed out by Eric, there's no need to jump through hoops to obtain
>> a signed 16-bit number from a signed 8-bit number.
>>
>> This patch is good for -mm
>>
>> Note also that this patch is only about 8 vs 16 bit data, so the axis
>> orientation for HP notebooks still has to be fixed in a separate patch,
>> but at least now I should be able to check it out properly.
>>
> Whoops, sorry for not catching it before, this part is not nice:
>
>> @@ -121,6 +125,21 @@ void lis3lv02d_poweron(acpi_handle handle)
>>  {
>>        adev.is_on = 1;
>>        adev.init(handle);
>> +       adev.read(handle, WHO_AM_I, &adev.whoami);
>> +       /* Tell apart LISxLV02Dy from LISx02Dy family by checking the LSB
>> +        * (0x3A vs 0x3B). TODO More sophisticated checks on other
>> registers
>> +        * could be implemented, for example to see if we have 2 or 3
>> axes, and
>> +        * configure the joystick accordingly.
>> +        */
>> +       if (adev.whoami & 1) {
>> +               printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
>> +               adev.lis3lv02d_read = lis3lv02d_read_8;
>> +               adev.mdps_max_val = 128;
>> +       } else {
>> +               printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
>> +               adev.lis3lv02d_read = lis3lv02d_read_16;
>> +               adev.mdps_max_val = 2048;
>> +       }
>>  }
>
> poweron() is called each time the joystick is opened, no need to check (and
> do a printk) so often! You need to move all this check to lis3lv02d_add() in
> hp_accel.c . Moreover, don't do tricky things like (adev.whoami & 1): just
> do a:
> switch (adev.whoami) {
> LIS302DL_ID:
>        printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found.\n");
>        adev.lis3lv02d_read = lis3lv02d_read_8;
>        adev.mdps_max_val = 128;
>        break;
> LIS3LV02DL_ID:
>        printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found.\n");
>        adev.lis3lv02d_read = lis3lv02d_read_16;
>        adev.mdps_max_val = 2048;
>        break;
> default:
>        printk(KERN_ERR DRIVER_NAME ": unknown sensor found of type %d.\n",
> adev.whoami);
>        return -EINVAL;
> }

I'm on it. There's still some unclear separation between the two
files, I must say.

-- 
Giuseppe "Oblomov" Bilotta
