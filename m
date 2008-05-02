Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYEBHeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYEBHeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYEBHd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:33:58 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:58624 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYEBHd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:33:56 -0400
Date: Fri, 2 May 2008 09:33:35 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20080502073335.GK3002@enneenne.com>
References: <1207851751-25703-4-git-send-email-giometti@linux.it> <1207851751-25703-5-git-send-email-giometti@linux.it> <1207851751-25703-6-git-send-email-giometti@linux.it> <20080410210918.3be98868@core> <20080411075515.GH26777@enneenne.com> <20080411092840.3cc4de67@core> <20080411134724.GF2160@csclub.uwaterloo.ca> <20080411154652.4852b6d4@core> <20080430114107.GE3002@enneenne.com> <20080430172855.6d2e81a6@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430172855.6d2e81a6@core>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 5/7] PPS: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 05:28:55PM +0100, Alan Cox wrote:
> > if I add a dedicated line discipline to register/unregister the PPS
> > source and I leave the pps_event management into
> > uart_handle_dcd_change() function, it can be acceptable?
> 
> Keep the two things apart.
> 
> uart_handle_dcd_change looks a good basis for the UART layer support for
> drivers serial
> an LDISC looks right for the top layer
> 
> We just need the bits in the middle right. I've added the serial layer
> pass through for the set_ldisc() interface so that bit is done. Probably
> the main thing we need is to add  tty->ldisc.dcd_change() for reporting
> DCD change back to the line discipline. We could queue it as a TTY_ event
> but I assume you need it immediately not queued ?

Yes, you are right. PPS events should be registered as soon as they
arrive, that's why I'd like to put events registration (or at least
IRQ timestamps) into do_IRQ() as follow:

   fastcall unsigned int do_IRQ(struct pt_regs *regs)
   {
           struct pt_regs *old_regs;
           /* high bit used in ret_from_ code */
           int irq = ~regs->orig_eax;
           struct irq_desc *desc = irq_desc + irq;
   #ifdef CONFIG_4KSTACKS
           union irq_ctx *curctx, *irqctx;
           u32 *isp;
   #endif

           if (unlikely((unsigned)irq >= NR_IRQS)) {
                   printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
                                           __FUNCTION__, irq);
                   BUG();
           }

           pps_irq_event_register(irq);

           old_regs = set_irq_regs(regs);
           irq_enter();

but this solution arises two drawbacks:

1) the PPS echo functions should be executed by
pps_irq_event_register() into do_IRQ(). Brrrr... :)

2) the shared IRQ line may cause "false" PPS events.

The latter drawback can be solved simply not using the shared IRQs for
PPS sources but the former is not an easy task... so I suppose we
should delay the echo function call at "safer" time, maybe using the
function tty->ldisc.dcd_change().

> > The uart_handle_dcd_change() is generic and I need the DCD status to
> > correctly manage the pps_event. The USB layer is not useful for PPS
> > stuff
> 
> Not every character driver uses drivers/serial or USB. That is fine. What
> I care about is that you *could* add PPS support to another serial driver
> cleanly, not that it is done immediately. What matters is the interface,
> the rest will follow.

I see. So what do you suggest to do? Should I add an ldisc to
register/unregister serial PPS sources and adding function
tty->ldisc.dcd_change() to manage the events?

Thanks for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
