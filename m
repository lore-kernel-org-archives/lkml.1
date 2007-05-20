Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbXETJky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbXETJky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 05:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbXETJkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 05:40:47 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2103 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbXETJkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 05:40:46 -0400
Date: Sun, 20 May 2007 10:40:33 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: kconfig select warnings bogus?
Message-ID: <20070520094033.GA9645@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Roman Zippel <zippel@linux-m68k.org>
References: <20070519151523.GA26724@uranus.ravnborg.org> <20070519110944.2a52061e.akpm@linux-foundation.org> <20070519230537.GI6291@stusta.de> <20070519162239.1bcb03d6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519162239.1bcb03d6.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 04:22:39PM -0700, Andrew Morton wrote:
> On Sun, 20 May 2007 01:05:37 +0200 Adrian Bunk <bunk@stusta.de> wrote:
> 
> > Look for example at the last one in drivers/input/mouse/Kconfig:
> > 
> > config MOUSE_ATARI
> >         tristate "Atari mouse"
> >         depends on ATARI
> >         select ATARI_KBD_CORE
> > 
> > This is perfectly correct (the select'ed symbol is only unavailable when 
> > the dependency can't be fulfilled), and all things to "fix" the warning 
> > will make it worse.
> 
> If ATARI is unset then we shouldn't be generating the "'select' used by
> config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'"
> warnings, should we?

Playing devils advocate here.  What if "ATARI_KBD_CORE" never exists?
Let's say you run 'make kconfig' and you select the ATARI option.  When
does the lack of ATARI_KBD_CORE get noticed and what is the expected
result?

Let's put it another way.  Given the complexities of the configuration
system as it is today, if we do not generate a warning at parse time,
how do we find things like:

config SHARPSL_PM
        bool
        select APM_EMULATION

config PXA_SHARP_C7xx
        bool
        select PXA_SSP
        select SHARPSL_PM

config MACH_CORGI
        bool "Enable Sharp SL-C700 (Corgi) Support"
        depends on PXA_SHARPSL_25x
        select PXA_SHARP_C7xx

and (lets say for the sake of argument) APM_EMULATION were to go away.

Do we really need an exhaustive set of configuration combinations to
run through Kconfig to find possible missing symbols?  Or do we need a
Kconfig lint to find them?

If we're going to make Kconfig warn on missing symbols only when they're
attempted to be selected, you'll have to choose one of those two options.
Choosing none is not an option.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
