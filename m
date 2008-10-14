Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYJNLlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYJNLlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYJNLlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:41:12 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:47228 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755084AbYJNLlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:41:11 -0400
Date: Tue, 14 Oct 2008 17:10:41 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: fix serial port lock init
Message-ID: <20081014114041.GB7410@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <200810140005.39852.rjw@sisk.pl> <20081013235013.17e3106b@lxorguk.ukuu.org.uk> <20081014065541.GA11047@elte.hu> <20081014102253.GA13503@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081014102253.GA13503@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-10-14 12:22:53]:

> 
> > [   31.099528] BUG: spinlock bad magic on CPU#1, agetty/2608
> 
> the patch below fixes this. There's another incarnation of the bug that 
> i bisected today, a spontaneous reboot crash with certain configs:
> 
> | b70ac7718579b5cbf3bdd74fd01132d1c91596f4 is first bad commit
> | commit b70ac7718579b5cbf3bdd74fd01132d1c91596f4
> | Author: David Miller <davem@davemloft.net>
> | Date:   Mon Oct 13 10:36:31 2008 +0100
> |
> |     serial: allow 8250 to be used on sparc
> 
>  # bad:  [e7f2f991] Merge phase #5 (misc) of git://git.kernel.org/pub/
>  # good: [3fa8749e] Linux 2.6.27
>  # good: [4dd9ec49] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
>  # good: [5c3c4d9b] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
>  # good: [1a2217a9] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
>  # good: [cf81978d] i386: convert hardware exception 15 to an interrup
>  # good: [c00193f9] Merge branches 'oprofile-v2' and 'timers/hpet' int
>  # bad:  [8f520021] tty: Termios locking - sort out real_tty confusion
>  # good: [f1ddfd95] ip2: init/deinit cleanup
>  # bad:  [b70ac771] serial: allow 8250 to be used on sparc
>  # good: [9bde10a4] serial-make-uart_ports-ioport-unsigned-long-fix
>  # good: [43b11d33] ftdi: A few errors are err() that should be debug 
>  # good: [b5d674ab] 8250: remove a few inlines of dubious value
> 
> ( but it's the same basic problem: we lost the lock init sequence when a
>   patch was removed from the middle. )
> 
> 	Ingo
> 
> ----------------->
> From b15be1e63d0df3a1b4a25e7a28cfca9f93690884 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 14 Oct 2008 12:14:17 +0200
> Subject: [PATCH] serial: fix serial port lock init
> 

Thanks, the patch fixes the warning.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/serial/8250.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index d4104a3..d3ca7d3 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -2969,6 +2969,9 @@ static int __init serial8250_init(void)
>  		"%d ports, IRQ sharing %sabled\n", nr_uarts,
>  		share_irqs ? "en" : "dis");
> 
> +	for (i = 0; i < NR_IRQS; i++)
> +		spin_lock_init(&irq_lists[i].lock);
> +
>  #ifdef CONFIG_SPARC
>  	ret = sunserial_register_minors(&serial8250_reg, UART_NR);
>  #else
> 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
