Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab0B0FiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 00:38:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:6749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0B0FiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 00:38:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wOYlt/jPPFqpG/cu1qzil/xLVckSZVbkFVl7U1tgbRCsRa4u8haklK6lkyAHPtUnSx
         OjstkXpWb6qvW8p3T62tNFuA9kBlt3gEC5kUJmGDslOQAxa4W0JdwIx6wLoKnv6GQA7Y
         msiXYLc3GnrbFuMCsRtsjR+UHopMV7Niv44ak=
MIME-Version: 1.0
In-Reply-To: <20100227052648.GA31418@kroah.com>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
	 <20100227035639.GA11680@kroah.com>
	 <d9def9db1002262005t6d63b902s673fb01dac228e4d@mail.gmail.com>
	 <20100227041815.GA12956@kroah.com>
	 <alpine.LFD.2.00.1002262022090.4513@localhost.localdomain>
	 <d9def9db1002262034p55cd569n6c423741c276798d@mail.gmail.com>
	 <20100227051737.GA14976@kroah.com> <20100227052648.GA31418@kroah.com>
Date: Sat, 27 Feb 2010 06:38:09 +0100
Message-ID: <d9def9db1002262138q63c410b7ga7c04f35b6f154ff@mail.gmail.com>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-usb@vger.kernel.org,
       werner@guyane.dyn-o-saur.com, Marcus Meissner <meissner@suse.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 6:26 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Feb 26, 2010 at 09:17:37PM -0800, Greg KH wrote:
>> On Sat, Feb 27, 2010 at 05:34:27AM +0100, Markus Rechberger wrote:
>> > On Sat, Feb 27, 2010 at 5:29 AM, Linus Torvalds
>> > <torvalds@linux-foundation.org> wrote:
>> > >
>> > >
>> > > On Fri, 26 Feb 2010, Greg KH wrote:
>> > >>
>> > >> Yes, and that patch didn't touch the iso frames. ?That happens later on
>> > >> in the functions that were modified. ?The patch should not have had any
>> > >> affect on iso transfers. ?Unless I'm missing something?
>> > >
>> > > Hmm. What seems to happen is that for an isochronous transfer, the buffer
>> > > is split for each microframe. No?
>> > >
>> >
>> > exactly. and each microframe has its own buffer length identifier.
>> >
>> > the current behaviour breaks VMware, QEMU and virtualbox .. probably
>> > other things too.
>> >
>> >
>> > > So the total length may be in 'urb->actual_length', but the actual data in
>> > > the buffer may not be contiguous, because it's created from multiple
>> > > smaller frames, some of which might not be full length?
>> > >
>> >
>> > yes, it's only contiguous for BULK.
>> >
>> > > I dunno. That would explain the problem - actual_length is correct, but
>> > > the 'copy_to_user()' still doesn't copy all the data, because it's
>> > > fragmented.
>> > >
>> >
>> > no you got it, but your patch does not work. The best way would be to
>> > revert it if someone wants to speed up BULK it should go down another
>> > path, leaving the old working implementation untouched.
>>
>> Hm, so it's back to the original idea of just doing a kzalloc of the
>> initial buffer, that should solve the problem that Marcus found.
>>
>> I'll go dig that back up and if you could test it, that would be most
>> appreciated.
>
> Here, can you try this on top of everything?
>

just tested it, everything's back to normal again now!

thanks,
Markus

> thanks,
>
> greg k-h
>
>
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index a678186..252d3b4 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1168,7 +1168,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>                return -ENOMEM;
>        }
>        if (uurb->buffer_length > 0) {
> -               as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
> +               as->urb->transfer_buffer = kzalloc(uurb->buffer_length,
>                                GFP_KERNEL);
>                if (!as->urb->transfer_buffer) {
>                        kfree(isopkt);
> @@ -1312,9 +1312,9 @@ static int processcompl(struct async *as, void __user * __user *arg)
>        void __user *addr = as->userurb;
>        unsigned int i;
>
> -       if (as->userbuffer && urb->actual_length)
> +       if (as->userbuffer)
>                if (copy_to_user(as->userbuffer, urb->transfer_buffer,
> -                                urb->actual_length))
> +                                urb->transfer_buffer_length))
>                        goto err_out;
>        if (put_user(as->status, &userurb->status))
>                goto err_out;
> @@ -1480,9 +1480,9 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
>        void __user *addr = as->userurb;
>        unsigned int i;
>
> -       if (as->userbuffer && urb->actual_length)
> +       if (as->userbuffer)
>                if (copy_to_user(as->userbuffer, urb->transfer_buffer,
> -                                urb->actual_length))
> +                                urb->transfer_buffer_length))
>                        return -EFAULT;
>        if (put_user(as->status, &userurb->status))
>                return -EFAULT;
>
