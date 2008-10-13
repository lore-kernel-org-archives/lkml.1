Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYJMK1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYJMK1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbYJMK1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:27:23 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:36066 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758475AbYJMK1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:27:22 -0400
Date: Mon, 13 Oct 2008 12:27:27 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
Message-ID: <20081013122727.7298bd4a@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48EF7949.4010108@control.lth.se>
References: <48EF6762.2080205@control.lth.se>
	<20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>
	<48EF7949.4010108@control.lth.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Oct 2008 10:27:12.0105 (UTC) FILETIME=[4116C590:01C92D1E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Blomdell <anders.blomdell@control.lth.se> wrote:
> Haavard Skinnemoen wrote:
> > Anders Blomdell <anders.blomdell@control.lth.se> wrote:
> >> Make configuration of ATNGW100 serial ports selectable in kernel configuration.
> >>
> >> Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>
> > 
> > Gak. If we're going down this path, why not add #ifdefs for every other
> > conceivable hardware mod as well and turn the ATNGW100 board code into
> > an even worse mess than the ATSTK1000 board code?
> OK, good point. The reason I sent in the patch is that people on AVRFreaks had
> asked how to do it, and putting it in the configuration would (theoretically)
> make it possible to catch pin conflicts.

Yes, I do realize people want this kind of thing. But I also think
there's more than one way to do it, and while a Kconfig option might
make things easier while trying it out, I think it will cause
maintenance pains in the long run.

> > The ATNGW100 has one serial port on board, so IMO the standard board
> > code should only initialize that one port.
> Which was my intention, unless SERIAL_ATMEL_USARTn was selected.

Yes, but it's not sensible to even offer the option of other ports when
the board just doesn't have them.

> > However, it might be sensible to add some sort of interface for
> > expansion board code. For example something like this:
> > 
> > #ifdef CONFIG_ATNGW100_EXPANSION
> > 	atngw100_setup_expansion_board();
> > #endif
> Since that file has to reside inside the kernel tree (?), one could almost as
> easily replace the entire setup.c.

True...but it would take quite a bit of duplication, and you'll have to
sync up whenever the "main" setup.c changes.

> Shouldn't this be something like:
> 
> void __init setup_board(void)
> {
> ...
> #ifdef CONFIG_ATNGW100_EXPANSION
>  	atngw100_setup_expansion_board();
> #endif
> }
> 
> static int __init atngw100_init(void)
> {
> ...
> #ifdef CONFIG_ATNGW100_EXPANSION
>  	atngw100_init_expansion_board();
> #endif
> }

Well, you could do it like that, but you could also just add another
postcore_initcall. The only hook which is really needed is the "setup"
part, and only if you have additional serial ports.

In fact, it's probably better to just add a weak definition for it
since not all expansion boards will need to override it.

> > This will allow people with hardware mods to add all the extra devices
> > they need, including serial ports, by simply adding another file with
> > expansion board code. People who aren't afraid to solder stuff on their
> > boards shouldn't be afraid of writing some board code too, right?
> > 
> > What do you think?
> An even nicer way of handling it (provided that initialization does not need to
> take place during boot), might be to do EXPORT_SYMBOL() on
> at32_add_device_usart, at32_map_usart, etc and then write a loadable module that
> handles the initialization.

Hmm...why would that be nicer exactly?

What _I_ think would be a nicer way to do it is to implement support
for flattened device trees and get rid of the board code entirely. Or
almost entirely; it depends on how complete we can make the device tree.

Haavard
