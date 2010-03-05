Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0CEVhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:37:55 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:48960 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab0CEVhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:37:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wp/FNDCA/9sQypFFMOU/v6DTlhP3QduX+ct5+iXuXOmu+gaGmwNV6UFs+q1oL+40y3
         JcWSRf5Um5fhmhdSE/whWpP7oY1E+Ir25+DOdbMvrph9yJYZpVU74cfcp8s6Uw2ZONx1
         Ra9LoKFJWih4obIOHcRhKrXwVFtmBpW3h3uDs=
MIME-Version: 1.0
In-Reply-To: <20100303000938.GA3257@kroah.com>
References: <20100227051737.GA14976@kroah.com>
	 <Pine.LNX.4.44L0.1002271215290.25155-100000@netrider.rowland.org>
	 <20100303000938.GA3257@kroah.com>
Date: Fri, 5 Mar 2010 22:37:51 +0100
Message-ID: <d9def9db1003051337s1a73e98eu2644cc2b0d34715f@mail.gmail.com>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, werner@guyane.dyn-o-saur.com,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 1:09 AM, Greg KH <greg@kroah.com> wrote:
> On Sat, Feb 27, 2010 at 12:20:35PM -0500, Alan Stern wrote:
>> On Fri, 26 Feb 2010, Greg KH wrote:
>>
>> > Hm, so it's back to the original idea of just doing a kzalloc of the
>> > initial buffer, that should solve the problem that Marcus found.
>> >
>> > I'll go dig that back up and if you could test it, that would be most
>> > appreciated.
>>
>> Here's a better solution.  In theory we could copy just the individual
>> packets from within the transfer buffer, but that would probably take
>> longer than simply copying the whole buffer.
>>
>> (This was a little hasty; I haven't even compile-tested the patch.
>> Some small fixes may be needed.)
>
> Markus, did you test this patch out?
>

sorry just saw this now, will do tomorrow morning...

Markus

> thanks,
>
> greg k-h
>
>> -----------------------------------------------------------------------
>>
>> This patch fixes a bug in the way isochronous input data is returned
>> to userspace for usbfs transfers.  The entire buffer must be copied,
>> not just the first actual_length bytes, because the individual packets
>> will be discontiguous if any of them are short.
>>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>> CC: stable <stable@kernel.org>
>>
>> ---
>>
>> Index: usb-2.6/drivers/usb/core/devio.c
>> ===================================================================
>> --- usb-2.6.orig/drivers/usb/core/devio.c
>> +++ usb-2.6/drivers/usb/core/devio.c
>> @@ -1176,6 +1176,13 @@ static int proc_do_submiturb(struct dev_
>>                       free_async(as);
>>                       return -ENOMEM;
>>               }
>> +             /* Isochronous input data may end up being discontiguous
>> +              * if some of the packets are short.  Clear the buffer so
>> +              * that the gaps don't leak kernel data to userspace.
>> +              */
>> +             if (is_in && uurb->type == USBDEVFS_URB_TYPE_ISO)
>> +                     memset(as->urb->transfer_buffer, 0,
>> +                                     uurb->buffer_length);
>>       }
>>       as->urb->dev = ps->dev;
>>       as->urb->pipe = (uurb->type << 30) |
>> @@ -1312,10 +1319,14 @@ static int processcompl(struct async *as
>>       void __user *addr = as->userurb;
>>       unsigned int i;
>>
>> -     if (as->userbuffer && urb->actual_length)
>> -             if (copy_to_user(as->userbuffer, urb->transfer_buffer,
>> -                              urb->actual_length))
>> +     if (as->userbuffer && urb->actual_length) {
>> +             if (urb->number_of_packets > 0)         /* Isochronous */
>> +                     i = urb->transfer_buffer_length;
>> +             else                                    /* Non-Isoc */
>> +                     i = urb->actual_length;
>> +             if (copy_to_user(as->userbuffer, urb->transfer_buffer, i))
>>                       goto err_out;
>> +     }
>>       if (put_user(as->status, &userurb->status))
>>               goto err_out;
>>       if (put_user(urb->actual_length, &userurb->actual_length))
>
