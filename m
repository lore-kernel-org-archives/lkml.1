Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZDACUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZDACUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 22:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZDACUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 22:20:24 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:10586 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbZDACUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 22:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZvJvKwbKuAlHp9mSmaapI6odtrjm8eI1m2k+0VZegyCY1sYF3HWuNIfWpxnmKIzHPC
         Mlfcwd0HmqDUVTZXdU9AQF6Aavc/ZTUqRwHv1vaA/wE7TJsYYtsI4laqr8Y0DzBe3C5k
         GCGdNlTcgbz77igKAMfzWjurIUSbYKaZrVYMU=
MIME-Version: 1.0
In-Reply-To: <49D262F5.6020700@mnementh.co.uk>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
	 <20090316193010.56644165@mjolnir.ossman.eu>
	 <aec7e5c30903171858w12a9ee5bl4f3590d1a25a9971@mail.gmail.com>
	 <49C84060.6010903@mnementh.co.uk>
	 <aec7e5c30903250156v1eb38bd7qafe1c4236d9daef@mail.gmail.com>
	 <aec7e5c30903301951g792a25a2s3abef57ba59fe8ee@mail.gmail.com>
	 <49D262F5.6020700@mnementh.co.uk>
Date: Wed, 1 Apr 2009 02:20:21 +0000
Message-ID: <aec7e5c30903311920p6b1409b6q8a8a6cbee29b44bf@mail.gmail.com>
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/09, Ian Molton <ian@mnementh.co.uk> wrote:
> Magnus Damm wrote:
>
>
> > Ping? Please let me know how you want me to rework the patches. Unless
> > they are ok as-is. Any feedback on how to rewrite them would be
> > greatly appreciated.
> >
>
>  I replied to this earlier. Basically, investigate using the clk API. You
> should also try to work out how your board controls  clock / power to the
> socckets (if it can at all).

The SoC is directly connected to the SD connector. I've verified this
by looking at board schematics. There is no power control hardware on
the boards that I've seen so far, but I'm currently working with
hardware designers to make sure they will add such capabilities to
future boards. The power will then be controlled by board specific
code, most likely using GPIO pins. The hardware block that the
tmio_mmc driver is handling does not have any power control
functionality.

As for the clock API, adding such a feature to the tmio_mmc driver is
not very complicated, especially for the SoC case where we already
have control over all system clocks.

>  Like I said though, IIRC the clk API had shortcommings last time I looked
> which made it impossible to use on MFD devices (its tied to the CPU
> architecture, wheras the MFDs are platform independant. Dmitry did some work
> on this, but I dont recall how far he got.

Some architectures may have clock framework support, some may not. I
guess wrapping the clock functions in #ifdefs is one (ugly) way to
support both cases. And if we consider MFD it certainly becomes more
complicated.

>  Let me know if you come up with answers / solutions to these probelms.
> Until then, NAK - lets do it the right way, one time only. Not hack and
> bodge it repeatedly.

So the current tmio_mmc driver does not use the clock API. With my
patches the clock API us still unused. I agree that working on adding
clock API support is needed, but I don't see how this is related to
single iomem window support.

Regardless of clock API, I still need a way to use the driver with a
single iomem window. Please propose how to use single iomem window
harware with tmio_mmc.

>  Sorry if that seems harsh, but I dont have time to review a hack thats
> going to end up replaced anyway when its done properly.

So exactly what is the "proper" solution for single iomem window support?

And why does single iomem window support have to block on clock API support?

>  Best starting point would be to look up Dmitrys work on making the clk api
> CPU agnostic (if that hasnt already been merged). Then tmio-mmc can be
> modified to reqest a clock from its parent device (be that an MFD core or a
> platform device or whatever).

Yes, that sounds like a good starting point for clock API support.

But... How do I use tmio_mmc with hardware that only has a single
iomem window? I need that regardless of clock API, and that's what the
code in this patch series is all about.

Thanks,

/ magnus
