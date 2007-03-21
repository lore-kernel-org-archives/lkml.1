Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXCUHLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXCUHLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 03:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932489AbXCUHLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 03:11:13 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:30090 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566AbXCUHLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 03:11:12 -0400
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, ak@suse.de,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, trent.waddington@gmail.com
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
References: <200703200832.l2K8W3o5023643@harpo.it.uu.se>
	<9a8748490703200224v204ff9ebs5bd964abef61e9c6@mail.gmail.com>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Wed, 21 Mar 2007 10:11:35 +0300
In-Reply-To: <9a8748490703200224v204ff9ebs5bd964abef61e9c6@mail.gmail.com> (Jesper Juhl's message of "Tue, 20 Mar 2007 10:24:44 +0100")
Message-ID: <87648vm5p4.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jesper Juhl" <jesper.juhl@gmail.com> writes:

> On 20/03/07, Mikael Pettersson <mikpe@it.uu.se> wrote:
>> On Mon, 19 Mar 2007 18:42:22 +0100, Jesper Juhl wrote:
>> > --- a/drivers/block/floppy.c
>> > +++ b/drivers/block/floppy.c
>> > @@ -4302,7 +4302,12 @@ static int __init floppy_init(void)
>> >               if (err)
>> >                       goto out_flush_work;
>> >
>> > -             device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
>> > +             err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
>> > +             if (err)
>> > +                     goto out_flush_work;
>> > +
>> >               /* to be cleaned up... */
>> >               disks[drive]->private_data = (void *)(long)drive;
>> >               disks[drive]->queue = floppy_queue;
>>
>> The floppy driver's sysfs file just provides some auxiliary
>> information to user-space, none of which matters for most of
>> its users. It is IMO totally inappropriate to fail floppy
>> driver init in this case.
>>
>
> Which is why my original patch just output a warning to let the user
> know that creating the file had failed.
Ohh please... First of all you have to make you patch correct, and only
after this think about tiny shiny error massages.
Lets look at original code:
              err = platform_device_register(&floppy_device[drive]);
              if (err)
                        goto out_flush_work;

              device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
<<<<<<<<< You propose  "goto out_flush_work" here if device_create_file() failed
<<<<<<<<< ,as it was done if platform_device_register() failed. But at the 
<<<<<<<<< moment we call device_create_file() platform_device_register()
<<<<<<<<< succeed, this means we have to unregister it first and only after
<<<<<<<<< this jumpto out_flush_work.
>
> -- 
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

