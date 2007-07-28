Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbXG1UDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbXG1UDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXG1UDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:03:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49471 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbXG1UDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:03:37 -0400
Date: Sat, 28 Jul 2007 22:04:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: alpha compile failure (srm_printk)
Message-ID: <20070728200450.GA25619@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0706041419470.7370@math> <20070605231712.ff1df46f.akpm@linux-foundation.org> <Pine.SOC.4.64.0707281950340.20474@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0707281950340.20474@math.ut.ee>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 08:05:08PM +0300, Meelis Roos wrote:
> Retested this compile error with todays 2.6.23-rc1+git, still the same.
> 
> > >   LD      arch/alpha/boot/bootloader
> > > arch/alpha/boot/bootloader.lds:25: undefined symbol `srm_printk' referenced in expression
> > 
> > I was unable to repeoduce these errors on 2.6.22-rc4 with your config.
> 
> Hmm. Just make works, make bootimage does not. I debugged this further 
> today and I can not see how it can work.
> 
> The link command in question is
> ld   -static -uvsprintf -T   arch/alpha/boot/bootloader.lds arch/alpha/boot/head.o arch/alpha/boot/main.o -o arch/alpha/boot/bootloader
> and it still tells
> arch/alpha/boot/bootloader.lds:25: undefined symbol `srm_printk' referenced in expression
> 
> arch/alpha/boot/bootloader.lds contains a single related line referring 
> to srm_printk:
> printk = srm_printk;
> This only seems to define an alias to srm_printk so not important (and 
> unused)?

Hi Meelis.
I took the time to investige this a bit. The relevant files in
this case (arch/alpha/MAkefile + boot/Makefile has not seen many changes
when browsing the git tree.
So I looked back a bit further in the bitkeeper based tree.

Before boot/Makefile were converted to kbuild style bootloader indeed
referenced $(LIBS). That was lost in the process.
So adding $(LIBS_Y) is the right thing to do.

The linker error you get is due to kasprintf uses kmalloc and
it gets pulled in when srm_printf uses vsprintf.

The fix is to split kasprintf out to a separate file to
avoid pulling in more stuff than necessary.

PS. I had trouble compiling objstrip and had to due a lot of ugly
hacks before it compiles. I assume it is a toolchain issue..

	Sam
