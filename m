Return-Path: <linux-kernel-owner+w=401wt.eu-S1765566AbYD3VTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765566AbYD3VTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757523AbYD3VTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:19:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40583 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYD3VTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:19:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
	<alpine.LFD.1.10.0804281443090.3261@apollo.tec.linutronix.de>
	<20080428141116.GB9048@digi.com>
	<alpine.LFD.1.10.0804281640220.3261@apollo.tec.linutronix.de>
Date: Wed, 30 Apr 2008 14:19:05 -0700
In-Reply-To: <alpine.LFD.1.10.0804281640220.3261@apollo.tec.linutronix.de>
	(Thomas Gleixner's message of "Mon, 28 Apr 2008 18:10:30 +0200
	(CEST)")
Message-ID: <m1d4o7kpme.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] let setup_irq reenable a shared irq
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
 >
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

This case also happens on a regular basis in kdump kernels where we
deliberately don't shutdown the hardware before starting the new kernel.
This patch should reduce the need for using irqpoll in that situation
by a small amount.

> Index: linux-2.6/include/linux/irq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/irq.h
> +++ linux-2.6/include/linux/irq.h
> @@ -61,6 +61,7 @@ typedef	void (*irq_flow_handler_t)(unsig
>  #define IRQ_WAKEUP 0x00100000 /* IRQ triggers system wakeup */
>  #define IRQ_MOVE_PENDING 0x00200000 /* need to re-target IRQ destination */
>  #define IRQ_NO_BALANCING 0x00400000 /* IRQ is excluded from balancing */
> +#define IRQ_SPURIOUS_DISABLED 0x00400000 /* IRQ was disabled by the spurious trap */

Looks like a duplicate define here. Don't you want:
+#define IRQ_SPURIOUS_DISABLED 0x00800000 /* IRQ was disabled by the spurious trap */
