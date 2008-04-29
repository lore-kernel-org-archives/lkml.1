Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYD2NLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYD2NLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761548AbYD2NKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:10:50 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:18493 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761456AbYD2NKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:10:49 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-29.messagelabs.com!1209474644!10949943!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 29 Apr 2008 15:08:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
Message-ID: <20080429130846.GA20461@digi.com>
References: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <alpine.LFD.1.10.0804281443090.3261@apollo.tec.linutronix.de> <20080428141116.GB9048@digi.com> <alpine.LFD.1.10.0804281640220.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0804281640220.3261@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 29 Apr 2008 13:08:46.0924 (UTC) FILETIME=[28AA80C0:01C8A9FA]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15878.007
X-TM-AS-Result: No--22.575000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thomas Gleixner wrote:
> On Mon, 28 Apr 2008, Uwe Kleine-König wrote:
> > > Oh no. There is lots of code in drivers, which does:
> > > 
> > >    disable_irq();
> > >    do_some_protected_stuff();
> > >    enable_irq();
> > > 
> > > So when the second driver is loaded on another CPU it would see the
> > > IRQ_DISABLED bit set and unconditionally reenable the interrupt. 
> > > 
> > > This unprotects the protected operation and definitely triggers the
> > > WARN_ON() in enable_irq() where we check for desc->depth == 0.
> > mmpf.
> > 
> > It's not nice to use disable_irq()/enable_irq() in a driver, is it?
> 
> Well, it's not nice, but it's there (in rather large quantities)
Ah, and now I finally understood desc->depth ...
 
> Subject: genirq: reenable a nobody cared disabled irq when a new driver arrives
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Mon, 28 Apr 2008 17:01:56 +0200
> 
> Uwe Kleine-Koenig has some strange hardware where one of the shared
> interrupts can be asserted during boot before the appropriate driver
> loads. Requesting the shared irq line from another driver results in a
> spurious interrupt storm which finally disables the interrupt line.
> 
> I have seen similar behaviour on resume before (the hardware does not
> work anymore so I can not verify) and this spurious irq issue is
> raised on a regular base in bugreports.
> 
> Change the spurious disable logic to increment the disable depth and
> mark the interrupt with an extra flag which allows us to reenable the
> interrupt when a new driver arrives which requests the same irq
> line. In the worst case this will disable the irq again via the
> spurious trap, but there is a decent chance that the new driver is the
> one which can handle the already asserted interrupt and makes the box
> usable again.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/irq.h   |    1 +
>  kernel/irq/manage.c   |   49 ++++++++++++++++++++++++++++++++-----------------
>  kernel/irq/spurious.c |    4 ++--
>  3 files changed, 35 insertions(+), 19 deletions(-)
> 
> Index: linux-2.6/include/linux/irq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/irq.h
> +++ linux-2.6/include/linux/irq.h
> @@ -61,6 +61,7 @@ typedef	void (*irq_flow_handler_t)(unsig
>  #define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
>  #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
>  #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
> +#define IRQ_SPURIOUS_DISABLED	0x00400000	/* IRQ was disabled by the spurious trap */
Is it intended that IRQ_NO_BALANCING == IRQ_SPURIOUS_DISABLED?

Other than that

Tested-and-Acked-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Best regards and thanks
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
