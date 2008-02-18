Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYBRO06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYBRO06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYBRO0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:26:49 -0500
Received: from www.tglx.de ([62.245.132.106]:34695 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYBRO0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:26:48 -0500
Date: Mon, 18 Feb 2008 15:26:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
In-Reply-To: <20080218133852.GA1573@elf.ucw.cz>
Message-ID: <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de>
References: <20080218133852.GA1573@elf.ucw.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Pavel Machek wrote:
> Hi!
> 
> I'm trying to use the "sleepy test" here, unfortunately it locks for
> 10-or-so seconds.
> 
> Problem is in wait_event_timeout: timeouts take about 100x as long as
> they should. Code in drivers/input/serio/libps2.c:
> 
> +       printk("ps2_command waiting event: %d\n", timeout);
>         timeout = wait_event_timeout(ps2dev->wait,
>                                      !(ps2dev->flags & PS2_FLAG_CMD1),timeout);
> 
>         if (ps2dev->cmdcnt && timeout > 0) {
> +               printk("wait_event returned: %d\n", timeout);
> 
>                 timeout = ps2_adjust_timeout(ps2dev, command, timeout);
> +
> +               printk("ps2_command adjust timeout: %d\n", timeout);
>                 wait_event_timeout(ps2dev->wait,
>                                    !(ps2dev->flags & PS2_FLAG_CMD), timeout);
>         }
> 
> +       printk("ps2_command receiving\n");
> 
> 
> ...and I get hang after "ps2_command adjust timeout" for 10 seconds,
> while it should  wait 10msec or so.

When is this code called ?
 
> I even tried adding:
> 
> +       printk("ps2: testing timeouts\n");
> +       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
> +       printk("ps2: testing timeouts\n");
> +       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
> +       printk("ps2: testing timeouts\n");
> +       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
> +       printk("ps2: testing timeouts\n");
> +       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
> +       printk("ps2: testing timeouts\n");
> +       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
> +       printk("ps2: timeouts ok?\n");
> 
> before that, and yes, those wait too long, too... (but only during
> suspend, they work ok during boot).

Again, at which point during suspend is this ?
 
> nohz=off fixes that.
> 
> notsc fixes that, too... On my system (thinkpad x60 in UP mode) tsc is
> normally marked unstable very shortly after boot, so only sleepy test
> can trigger this.

I do not understand, what you mean. When exactly is "sleeppy test"
running ?

Also the TSC unstable detection is in a 500ms timeframe, so you should
never get a 10s delay.

> I believe it is very bad idea to use tsc, it does not work on 90%+ of
> machines. Yes, we do detect it is broken during runtime, but that's
> too late.

Why is it too late ? Can you please describe in detail ?

> I believe fix is very simple:

NAK. 

This kills TSC on machines which have a working TSC and never go into
suspend.

	tglx
