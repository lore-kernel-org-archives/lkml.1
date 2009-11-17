Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZKQXWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZKQXWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZKQXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:22:14 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:62792 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZKQXWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:22:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=n1hICV0TgcezCQ4rTGDvv6fdDYyteY0+G+iJwzY3/QXnowQ1JVRDqw+oAt/THF699j
         wQEItO0wocimpG3ffnXV8hS/C9hDl4S/jX3iDYSJDDIvQbWJa894V9b6dSKw41yMFhN5
         L+ElvdQFS4wVIlXnn6k3yaS408eANEq41Hz4o=
MIME-Version: 1.0
In-Reply-To: <20091117165844.0fb043f3@lxorguk.ukuu.org.uk>
References: <20091117154641.3879.73168.stgit@localhost.localdomain> 
	<8bd0f97a0911170850x40f68e02y5a3d8ad39c4f9b90@mail.gmail.com> 
	<20091117165844.0fb043f3@lxorguk.ukuu.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 17 Nov 2009 18:21:58 -0500
Message-ID: <8bd0f97a0911171521t3641a6a2h69c209eccc89a2c9@mail.gmail.com>
Subject: Re: [RESEND PATCH] gpio_addr_flash: Fix warnings
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 11:58, Alan Cox wrote:
> On Tue, 17 Nov 2009 11:50:24 -0500 Mike Frysinger wrote:
>> On Tue, Nov 17, 2009 at 10:46, Alan Cox wrote:
>> > --- a/drivers/mtd/maps/gpio-addr-flash.c
>> > +++ b/drivers/mtd/maps/gpio-addr-flash.c
>> > -       state->gpio_addrs     = (void *)gpios->start;
>> > +       state->gpio_addrs     = (void *)(unsigned long)gpios->start;
>> > -       state->map.virt       = (void __iomem *)memory->start;
>> > +       state->map.virt       = (void __iomem *)(unsigned long)memory->start;
>>
>> on what system do you see warnings ?  start should be resource_size_t
>> which should be phys_addr_t which should cast fine to a void*.
>
> 32bit x86 shows it up because resource_size_t is a physaddr_t which is
> 64bit (because of PAE). Now given you don't seem likely to be using the
> top bits for any real world example that looks ok but really casting a
> physical address to a pointer type needs care and the compiler can't
> deduce your intent there.

i dont think the casts will work in either case here and it's a good
thing that the code doesnt compile warning free

the gpio_addrs member is an array of gpio ids which are 32bit unsigned
values.  overlaying an array of 64bit values isnt going to produce
correct behavior.

as for the memory->start, i do need to access that directly, so that
should probably be going through ioremap_nocache() instead.

i.e. i'll have to write/test/post a patch rather than adding casts to
pretend there isnt a problem
-mike
