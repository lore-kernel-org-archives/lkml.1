Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbZGIXaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbZGIXaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZGIXaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:30:12 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:54294 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbZGIXaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:30:10 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2009 19:30:10 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Huzm9uEhxj9wqNhZzBt7IVdacc5Kz2SWi0QPN2PgW/lgGExevw+K7p2Kd86MDbjIGk
         xGVhNWrp9o5Z/UnIMUbIMNH6ItL2T3wGF+qj7RrPH9l24bdFbyk2gtTOoISMi8VmflZz
         LF1g35cuOWhjb/6/5kfBXBdBt0Th4EyuM59Gg=
MIME-Version: 1.0
In-Reply-To: <ab18d8520907090849p14d3c48eub6d01bdfd750cdf5@mail.gmail.com>
References: <20090709123301.15654.4698.stgit@localhost.localdomain>
	 <20090709123523.15654.15754.stgit@localhost.localdomain>
	 <ab18d8520907090849p14d3c48eub6d01bdfd750cdf5@mail.gmail.com>
Date: Fri, 10 Jul 2009 07:22:39 +0800
Message-ID: <ab18d8520907091622w2a22e6bar3e15bb1397a4dbb2@mail.gmail.com>
Subject: Re: [PATCH 1/3] tty: Sort out the USB sysrq changes that wrecked 
	performance
From: Fengwei Yin <yfw.kernel@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 11:49 PM, Fengwei Yin<yfw.kernel@gmail.com> wrote:
> Hi Alan,
>
> On Thu, Jul 9, 2009 at 8:35 PM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>> From: Alan Cox <alan@linux.intel.com>
>>
>> We can't go around calling all sorts of magic per character functions at
>> full rate 3G data speed.
>>
>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>> ---
>>
>>  drivers/usb/serial/generic.c |   15 +++++++++++----
>>  1 files changed, 11 insertions(+), 4 deletions(-)
>>
>>
>> diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
>> index 932d624..e9aa7a4 100644
>> --- a/drivers/usb/serial/generic.c
>> +++ b/drivers/usb/serial/generic.c
>> @@ -424,10 +424,17 @@ static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
>>        if (!tty)
>>                goto done;
>>
>> -       /* Push data to tty */
>> -       for (i = 0; i < urb->actual_length; i++, ch++) {
>> -               if (!usb_serial_handle_sysrq_char(port, *ch))
>> -                       tty_insert_flip_char(tty, *ch, TTY_NORMAL);
>> +       /* The per character mucking around with sysrq path it too slow for
>> +          stuff like 3G modems, so shortcircuit it in the 99.9999999% of cases
>> +          where the USB serial is not a console anyway */
>> +       if (!port->console || !port->sysrq)
>> +               tty_insert_flip_string(tty, ch, urb->actual_length);
>> +       else {
>> +               /* Push data to tty */
>> +               for (i = 0; i < urb->actual_length; i++, ch++) {
>> +                       if (!usb_serial_handle_sysrq_char(port, *ch))
>> +                               tty_insert_flip_char(tty, *ch, TTY_NORMAL);
>> +               }
>>        }
>>        tty_flip_buffer_push(tty);
>>        tty_kref_put(tty);
>>
>
> What about the change like this:
>
> diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
> index 932d624..b4fd33b 100644
> --- a/drivers/usb/serial/generic.c
> +++ b/drivers/usb/serial/generic.c
> @@ -424,10 +424,26 @@ static void flush_and_resubmit_read_urb(struct
> usb_serial_port *port)
>        if (!tty)
>                goto done;
>
> -       /* Push data to tty */
> -       for (i = 0; i < urb->actual_length; i++, ch++) {
> -               if (!usb_serial_handle_sysrq_char(port, *ch))
> -                       tty_insert_flip_char(tty, *ch, TTY_NORMAL);
> +        /* The per character mucking around with sysrq path it too slow for
> +           stuff like 3G modems, so shortcircuit it in the 99.9999999% of cases
> +           where the USB serial is not a console anyway */
> +        if (!port->console || !port->sysrq)
> +                tty_insert_flip_string(tty, ch, urb->actual_length);
> +        else {
> +               /*
> +                * Most of data shouldn't be sysrq request even when
> +                * tty is a printk console.
> +                */
> +               if (time_before(jiffies, port->sysrq)) {
> +                       /* Push data to tty */
> +                       for (i = 0; i < urb->actual_length; i++, ch++) {
> +                               if (!usb_serial_handle_sysrq_char(port, *ch))
> +                                       tty_insert_flip_char(tty, *ch,
> +                                                       TTY_NORMAL);
> +                       }
> +               } else {
> +                       tty_insert_flip_string(tty, ch, urb->actual_length);
> +               }
>        }
>        tty_flip_buffer_push(tty);
>        tty_kref_put(tty);
>
Oh. Just ignore my change. If it's console, we don't need this "optimization".

Regards
Yin, Fengwei

>
> Regards
> Yin, Fengwei
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
