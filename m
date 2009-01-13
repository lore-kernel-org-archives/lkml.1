Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZAMLg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZAMLg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZAMLgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:36:17 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:47902 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZAMLgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:36:16 -0500
Date: Tue, 13 Jan 2009 12:35:45 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Milton Miller <miltonm@bga.com>,
       Benjiman Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Peterson <joe@skyrush.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/4] hvc_console: do not set low_latency
Message-ID: <20090113113545.GB26819@cetus.boeblingen.de.ibm.com>
References: <hvc-console-29-3-1@bga.com> <200901131004.22609.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901131004.22609.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is yet another bug trace related to the low_latency issue, that is
experienced using the hvc_iucv backend.  The hvc_iucv backend now also uses irq
notifiers.
The bug trace below appears if hvc_kick() is called.

On Tue, Jan 13, 2009 at 10:04:22AM +0100, Christian Borntraeger wrote:
> Am Donnerstag 08 Januar 2009 schrieb Milton Miller:
> > hvc_console is setting low_latency unconditionally, but some clients are
> > interrupt driven and will call hvc_poll from irq context.  This will cause
> > tty_flip_buffer_push to be called from irq context, and it very clearly
> > states it must not be called from IRQ when low_latency is specified.
It seems that if low_latency is set, tty_flip_buffer_push() should also not be
called within an atomic context, because echo_char_raw() and other echo* calls
might sleep.

Christian's patch solves this problem for irq driven backends.
However, there might be still a problem with polled backends since the khvcd()
thread calls hvc_poll() while hvc_structs_lock is held.

I think the hvc_udbg backend is based on polling.
David, could you check if you experience any problems with your hvc_udbg
backend on latest git.

BUG: sleeping function called from invalid context at /root/cvs/linux-2.6.git/kernel/mutex.c:207
in_atomic(): 1, irqs_disabled(): 0, pid: 748, name: khvcd
1 lock held by khvcd/748:
 #0:  (hvc_structs_lock){--..}, at: [<00000000002ceb50>] khvcd+0x58/0x12c
CPU: 0 Not tainted 2.6.29-rc1git #29
Process khvcd (pid: 748, task: 000000002fb9a480, ksp: 000000002f66bd78)
070000000000000a 000000002f66ba00 0000000000000002 (null) 
       000000002f66baa0 000000002f66ba18 000000002f66ba18 0000000000104f08 
       ffffffffffffc000 000000002f66bd78 (null) (null) 
       000000002f66ba00 000000000000000c 000000002f66ba00 000000002f66ba70 
       0000000000466af8 0000000000104f08 000000002f66ba00 000000002f66ba50 
Call Trace:
([<0000000000104e7c>] show_trace+0x138/0x158)
 [<0000000000104f62>] show_stack+0xc6/0xf8
 [<0000000000105740>] dump_stack+0xb0/0xc0
 [<000000000013144a>] __might_sleep+0x14e/0x17c
 [<000000000045e226>] mutex_lock_nested+0x42/0x3b4
 [<00000000002c443e>] echo_char_raw+0x3a/0x9c
 [<00000000002c688c>] n_tty_receive_buf+0x1154/0x1208
 [<00000000002ca0a2>] flush_to_ldisc+0x152/0x220
 [<00000000002ca1da>] tty_flip_buffer_push+0x6a/0x90
 [<00000000002cea74>] hvc_poll+0x244/0x2c8
 [<00000000002ceb68>] khvcd+0x70/0x12c
 [<000000000015bbd0>] kthread+0x68/0xa0
 [<0000000000109d5a>] kernel_thread_starter+0x6/0xc
 [<0000000000109d54>] kernel_thread_starter+0x0/0xc
1 lock held by khvcd/748:
 #0:  (hvc_structs_lock){--..}, at: [<00000000002ceb50>] khvcd+0x58/0x12c

> This wont work, since the call to notifier_add is done later:
> What about:
> ---
>  drivers/char/hvc_console.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/char/hvc_console.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/hvc_console.c
> +++ linux-2.6/drivers/char/hvc_console.c
> @@ -318,8 +318,6 @@ static int hvc_open(struct tty_struct *t
>  	} /* else count == 0 */
> 
>  	tty->driver_data = hp;
> -	tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
> -
>  	hp->tty = tty;
> 
>  	spin_unlock_irqrestore(&hp->lock, flags);
> @@ -327,6 +325,9 @@ static int hvc_open(struct tty_struct *t
>  	if (hp->ops->notifier_add)
>  		rc = hp->ops->notifier_add(hp, hp->data);
> 
> +	if (!hp->irq_requested)
> +		tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
> +
>  	/*
>  	 * If the notifier fails we return an error.  The tty layer
>  	 * will call hvc_close() after a failed open but we don't want to clean

Acked-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
