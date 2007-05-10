Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbXEJVOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbXEJVOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761570AbXEJVNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:13:52 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57231 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762002AbXEJVNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:13:51 -0400
Date: Thu, 10 May 2007 23:14:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Wedgwood <cw@f00f.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510211446.GB23149@uranus.ravnborg.org>
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510204037.GE29713@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510204037.GE29713@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 09:40:38PM +0100, Russell King wrote:
> On Thu, May 10, 2007 at 01:34:18PM -0700, Chris Wedgwood wrote:
> > MODPOST seems to be spewing bogus warnings.  It's not clear how best
> > to fix it so perhaps we should silence it for now?
> 
> I agree.  Example bogus warning:
> 
> WARNING: arch/arm/mach-iop32x/built-in.o - Section mismatch:
>  reference to .init.text: from .data between 'iq80321_timer'
>  (at offset 0x428) and 'iq80321_serial_device'
> 
> c04088fc d iq80321_timer
> c0408950 d iq80321_serial_device
> 
> It's completely unclear what is referencing what, what the two named
> symbols mean, and even what "at offset" relates to.

The error message tells you that somewhere _between_ the symbol
iq80312_timer and iq80321_serial_device there is a recerence to an address
in the .init.text section.
The referenced address could not be resolved to an actual symbol.

Lets take a look:
git grep iq80321_timer reveals:
arch/arm/mach-iop32x/iq80321.c:static void __init iq80321_timer_init(void)
arch/arm/mach-iop32x/iq80321.c:static struct sys_timer iq80321_timer = {
arch/arm/mach-iop32x/iq80321.c: .init           = iq80321_timer_init,
arch/arm/mach-iop32x/iq80321.c: .timer          = &iq80321_timer,

So the one to look at is this structure:

static struct sys_timer iq80321_timer = {
	.init		= iq80321_timer_init,
	.offset		= iop_gettimeoffset,
};


iq80321_timer_init is a function marked __init
So we have a reference from .data to .init.text

If you remove the static definition of iq80321_timer then you will see
that modpost can resolve the symbol for you.

The usage of iq80321_timer is obscufated inside a MACHINCE_START/MACHINE_END
macor so I did not look further.
But based on the naming of the member in the struct ".init" I will assume
this is legitime reference to .init.text from .data.

Today modpost whitelist (avoid warnings) if a variable are named on of the 
following:

*driver, *_template, *_sht, *_ops, *_probe, *probe_one

We could add *timer to silence this particular warning indeed.
Or we could rename the varibale.
Or we could find a way to annotate the data to say "references to .init.*
is OK and should not be warned.


The latter seems to be most appropriate so this is the direction I'm heading.

	Sam
