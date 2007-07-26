Return-Path: <linux-kernel-owner+w=401wt.eu-S1763596AbXGZOiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763596AbXGZOiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbXGZOh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:37:58 -0400
Received: from styx.suse.cz ([82.119.242.94]:38627 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754333AbXGZOh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:37:57 -0400
Date: Thu, 26 Jul 2007 16:38:04 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] fix return value of i8042_aux_test_irq
Message-ID: <20070726143804.GB31507@suse.cz>
References: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp> <d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 09:54:50AM -0400, Dmitry Torokhov wrote:
> Hi,
> 
> On 7/26/07, Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:
> >I made an interesting finding while testing the two patches below.
> >
> >http://lkml.org/lkml/2007/7/19/685
> >http://lkml.org/lkml/2007/7/19/687
> >
> >These patches modify the traditional CONFIG_DEBUG_KERNEL in such a way
> >that the request_irq prints a warning if after calling the handler it
> >returned IRQ_HANDLED .
> >
> >The code looks like this:
> >
> >int request_irq(unsigned int irq, irq_handler_t handler,
> >               unsigned long irqflags, const char *devname, void
> >*dev_id)
> >.....
> >       if (irqflags & IRQF_DISABLED) {
> >               unsigned long flags;
> >
> >               local_irq_save(flags);
> >               retval = handler(irq, dev_id);
> >               local_irq_restore(flags);
> >       } else
> >               retval = handler(irq, dev_id);
> >       if (retval == IRQ_HANDLED) {
> >               printk(KERN_WARNING
> >                      "%s (IRQ %d) handled a spurious interrupt\n",
> >                      devname, irq);
> >       }
> >.....
> >
> >I discovered that i8042_aux_test_irq handles the "fake" interrupt,
> >which, in principle, is not correct because it obviously isn't a real
> >interrupt and it could have been a spurious interrupt as well.
> >
> >The problem is that the interrupt handler unconditionally returns IRQ
> >handled, which does not seem correct. Anyway I am not very familiar with
> >this code so I may be missing the whole point. I would appreciate your
> >comments on this.
> >
> 
> The handler does handle the interrupt - both status and data registers
> are read so from the keyboard controller point of view the interrupt
> has been handled even if we happen to discard the data. As far as I
> know IRQ12 is never shared by BIOS... Vojtech, do you remember why we
> request IRQ12 with IRQF_SHARED?
 
I believe it was needed on PPC.

-- 
Vojtech Pavlik
Director SuSE Labs
