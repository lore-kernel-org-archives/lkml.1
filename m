Return-Path: <linux-kernel-owner+w=401wt.eu-S1765281AbYD3Vhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765281AbYD3Vhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761263AbYD3VhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:37:19 -0400
Received: from www.tglx.de ([62.245.132.106]:42335 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYD3VhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:37:17 -0400
Date: Wed, 30 Apr 2008 23:36:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
In-Reply-To: <m1d4o7kpme.fsf@frodo.ebiederm.org>
Message-ID: <alpine.LFD.1.10.0804302336000.6003@apollo.tec.linutronix.de>
References: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <alpine.LFD.1.10.0804281443090.3261@apollo.tec.linutronix.de> <20080428141116.GB9048@digi.com> <alpine.LFD.1.10.0804281640220.3261@apollo.tec.linutronix.de>
 <m1d4o7kpme.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
>  >
> > Subject: genirq: reenable a nobody cared disabled irq when a new driver arrives
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Mon, 28 Apr 2008 17:01:56 +0200
> >
> > Uwe Kleine-Koenig has some strange hardware where one of the shared
> > interrupts can be asserted during boot before the appropriate driver
> > loads. Requesting the shared irq line from another driver results in a
> > spurious interrupt storm which finally disables the interrupt line.
> >
> > I have seen similar behaviour on resume before (the hardware does not
> > work anymore so I can not verify) and this spurious irq issue is
> > raised on a regular base in bugreports.
> 
> This case also happens on a regular basis in kdump kernels where we
> deliberately don't shutdown the hardware before starting the new kernel.
> This patch should reduce the need for using irqpoll in that situation
> by a small amount.

Makes sense.
 
> > Index: linux-2.6/include/linux/irq.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/irq.h
> > +++ linux-2.6/include/linux/irq.h
> > @@ -61,6 +61,7 @@ typedef	void (*irq_flow_handler_t)(unsig
> >  #define IRQ_WAKEUP 0x00100000 /* IRQ triggers system wakeup */
> >  #define IRQ_MOVE_PENDING 0x00200000 /* need to re-target IRQ destination */
> >  #define IRQ_NO_BALANCING 0x00400000 /* IRQ is excluded from balancing */
> > +#define IRQ_SPURIOUS_DISABLED 0x00400000 /* IRQ was disabled by the spurious trap */
> 
> Looks like a duplicate define here. Don't you want:
> +#define IRQ_SPURIOUS_DISABLED 0x00800000 /* IRQ was disabled by the spurious trap */

Your the third one to notice :)

Thanks,
	tglx

