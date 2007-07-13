Return-Path: <linux-kernel-owner+w=401wt.eu-S936598AbXGMJls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936598AbXGMJls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763122AbXGMJlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:41:39 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:1583 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762703AbXGMJli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:41:38 -0400
Date: Fri, 13 Jul 2007 10:41:35 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ralf Baechle <ralf@linux-mips.org>, Mark Mason <mason@broadcom.com>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-duart.c: SB1250 DUART serial support
In-Reply-To: <20070712114712.de5d6c9d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64N.0707131019060.32029@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0707121745010.3029@blysk.ds.pg.gda.pl>
 <20070712114712.de5d6c9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Andrew Morton wrote:

> On Thu, 12 Jul 2007 18:39:00 +0100 (BST)
> "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> 
> >  This is a driver for the SB1250 DUART, a dual serial port implementation 
> > included in the Broadcom family of SOCs descending from the SiByte SB1250 
> > MIPS64 chip multiprocessor.  It is a new implementation replacing the 
> > old-fashioned driver currently present in the linux-mips.org tree.  It 
> > supports all the usual features one would expect from a(n asynchronous) 
> > serial driver, including modem line control (as far as hardware supports 
> > it -- there is edge detection logic missing from the DCD and RI lines and 
> > the driver does not implement polling of these lines at the moment), the 
> > serial console, BREAK transmission and reception, including the magic 
> > SysRq.  The receive FIFO threshold is not maintained though.
> > 
> > ...
> >
> > +
> > +#if defined(CONFIG_SIBYTE_BCM1x55) || defined(CONFIG_SIBYTE_BCM1x80)
> > +#include <asm/sibyte/bcm1480_regs.h>
> > +#include <asm/sibyte/bcm1480_int.h>
> > +
> > +#define SBD_CHANREGS(line)	A_BCM1480_DUART_CHANREG((line), 0)
> > +#define SBD_CTRLREGS(line)	A_BCM1480_DUART_CTRLREG((line), 0)
> > +#define SBD_INT(line)		(K_BCM1480_INT_UART_0 + (line))
> > +
> > +#elif defined(CONFIG_SIBYTE_SB1250) || defined(CONFIG_SIBYTE_BCM112X)
> > +#include <asm/sibyte/sb1250_regs.h>
> > +#include <asm/sibyte/sb1250_int.h>
> > +
> > +#define SBD_CHANREGS(line)	A_DUART_CHANREG((line), 0)
> > +#define SBD_CTRLREGS(line)	A_DUART_CTRLREG(0)
> > +#define SBD_INT(line)		(K_INT_UART_0 + (line))
> > +
> > +#else
> > +#error invalid SB1250 UART configuration
> > +
> > +#endif
> 
> If the #error can trigger, the Kconfig is broken, yes?  (No action is
> required though - it's always good to have checks)

 It should not trigger, because to the best of my knowledge all the chip 
variations we support are covered above.  Ultimately, this should become a 
platform device, where this will become a non-issue.  The conditions have 
been copied verbatim from the original driver.

> > +#define to_sport(uport) container_of(uport, struct sbd_port, port)
> 
> That didn't need to be implemented as a macro.

 Like the last time -- everybody seems to implement it as such.  If you 
think that should be changed, I could see if I find some time to grep the 
tree and reimplement all the to_*() macros.

> > +#define __unused __attribute__((__unused__))
> 
> Please use the generic implementations here.  `grep unused
> include/linux/compiler*.h'.

 Any changes there in the last few days?  Hmm, I must have missed them...  
I'll fix it up next week.

> > +/*
> > + * In bug 1956, we get glitches that can mess up uart registers.  This
> > + * "read-mode-reg after any register access" is an accepted workaround.
> > + */
> 
> <looks in bugzilla.kernel.org>
> 
> <wonders how a uart driver can fix an smbfs bug>
> 
> Perhaps a reference to where that bug number came from?

 Again, copied verbatim from the original driver.  It must be a chip 
erratum.  Which is not publicly available, but I think it is still better 
to have it referred to from here than not at all, in case someone wants to 
pester Broadcom about this one.  I can s/bug/erratum/, but I am not sure 
if it won't confuse them then if contacted. ;-)

> > +static void __war_sbd1956(struct sbd_port *sport)
> > +{
> > +	__read_sbdchn(sport, R_DUART_MODE_REG_1);
> > +	__read_sbdchn(sport, R_DUART_MODE_REG_2);
> > +}
> >
> > ...
> >
> > +static struct uart_ops sbd_ops = {
> 
> I suppose if we made this const, something would blow up.

 No problem at the moment -- I'll change it.  Though I have a strong 
suspicion .startup may have to be overridden at the run time at one point 
because of the way the port #1 is wired on the SWARM board (but nowhere 
else) -- the port is shared with a sound device (if it sounds odd, I can 
provide an overview of the hardware configuration).  Then again, perhaps I 
will do it in a different way...

> There is no power management support in this driver.

 Like nowhere in the chip.

  Maciej
