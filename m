Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYJMVYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYJMVYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbYJMVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:23:50 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35640 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084AbYJMVXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:23:48 -0400
Date: Mon, 13 Oct 2008 23:23:52 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
Message-ID: <20081013232352.533d02d8@siona.skinnemoen.net>
In-Reply-To: <48F38E95.4090103@control.lth.se>
References: <48EF6762.2080205@control.lth.se>
	<20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>
	<48EF7949.4010108@control.lth.se>
	<20081013122727.7298bd4a@hskinnemo-gx745.norway.atmel.com>
	<48F32899.5000006@control.lth.se>
	<20081013143447.5e0519b3@hskinnemo-gx745.norway.atmel.com>
	<48F3473E.6070305@control.lth.se>
	<20081013153318.7ed8e8d8@hskinnemo-gx745.norway.atmel.com>
	<48F35F50.3000704@control.lth.se>
	<20081013172852.393584be@hskinnemo-gx745.norway.atmel.com>
	<48F37707.8040401@control.lth.se>
	<20081013191534.7cbeebc1@hskinnemo-gx745.norway.atmel.com>
	<48F38E95.4090103@control.lth.se>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2008 21:23:36.0984 (UTC) FILETIME=[F44E6180:01C92D79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 20:08:21 +0200
Anders Blomdell <anders.blomdell@control.lth.se> wrote:

> Dropped the kernel list CC on previous post, sorry.
> 
> Haavard Skinnemoen wrote:
> > Oh, that stuff. Yeah, when an expansion board needs to disable features
> > on the motherboard, it gets a bit messy.
> How should this be handled with device tree?

By simply leaving those pins out. Or perhaps there's some mechanism for
disabling them.

> > That's why you should send it upstream so that it can be kept in sync
> > whenever something changes. Also note that the same applies to your
> > out-of-tree module.
> Which is what I'm trying to do, but the maintainer is complaining :-)

No, you're trying to push a mechanism which will allow you to avoid
doing that, at the expense of less readable board code for everyone
else.

> But we probably don't want to add everyones prototype boards to the kernel tree!

Well, why not? It's not like it takes up much space. And it can always
be removed later when the prototype gets reassigned to collecting dust
at the top of some shelf.

It might even be a nice experience for later when you want support for
your production board upstream...

> > But I do think device trees along with a nice graphical editor, or a
> > few u-boot commands, would go a long way towards this goal. If we
> > manage to get something like that working, you won't even have to
> > recompile anything.
> As far as I can see, the device trees will push the conflict resolution to
> run-time instead of compile-time, which I belive is bad for both memory
> footprint as well as performance (as well as predictability, this kernel worked
> yesterday; who added which device which makes it crash today...)

Any conflict resolution _today_ happens at run time in the form of a
friendly error message and a stack dump if you try to assign the same
pin to two different devices.

And with your patch, some device might suddenly stop working because
you enabled a USART which conflicts with some other device that gets
initialized later (the USARTs are initialized very early). How is that
any better?

As for performance and memory footprint, I think the impact will be
minimal. This is init code that we're talking about -- it gets run once
and then discarded.

Oh, and the device tree stuff comes with some nice infrastructure which
would make it quite easy to write a static validator for pin assignments
and such. That would actually move the conflict resolution from
run-time to compile-time.

> >> But personally I would be happy with a generic ap7000
> >> board, where I could pick all the options I like and the ngw100 and stk100x
> >> would just be an instance of this board with all/most options preselected. That
> >> #ifdefs are messy to read is something we agree about...
> > 
> > Right, I also want more generic board support. But I don't think
> > Kconfig is the way to go. There are just too many variables.
> Wouldn't there be as many variables with a device tree?

Yes, but you're exposing them to the right audience: The board vendors,
not the users. In the case of hobbyists creating their own boards,
they're of course the same people, but they are definitely power users.

Also, I believe that, if the device tree layout is carefully designed,
it might be possible to turn bits of it on and off at run-time. That
would be great for configurable boards like the STK1000 -- with a bit
of extra support from u-boot, you should be able to do something like

	switch 5 on

to select between two different mux settings (e.g. second ethernet
controller vs. LCD).

> A graphical board-configurator against the Kconfig should certainly be possible?

It will probably be just as easy to have the board configurator
generate C code, or a device tree.

> I'm also not (yet) convinced that your approach makes the configuration any simpler.

I guess we'll just have to implement it and find out. Until then,
there's really no way to tell -- you may of course be right.

> How about putting each needed extension in a separate file (with a specified
> format), and use some kind of preprocessor to generate Kconfig's, Makefiles,
> setup.c, etc from those files (and generating the appropriate at32_reserve_*,
> at32_select* as well). I.e. something like:

If you're generating code, why bother with Kconfig at all?

> USART2.def:
> 
> %PINS {
>   PA08, PA09
> }
> 
> %GLOBAL {
>   platform device *usart2;
> }
> 
> %INIT {
>   usart2 = at32_add_device_usart(2);
> }
> 
> %SETUP {
>   new_at32_map_usart(usart2, at_32_last_mapped_usart++);
> }

You've already written most of the board code, and added quite a bit of
additional noise. Why not write it in C instead of some
yet-another-weird-configuration-language?

Hey, why not use XML? I'm sure lots of LKML subscribers would be
absolutely thrilled! ;-)

Haavard
