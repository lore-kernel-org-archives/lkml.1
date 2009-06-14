Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZFNMdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZFNMdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZFNMdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:33:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbZFNMdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:33:00 -0400
Date: Sun, 14 Jun 2009 14:32:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: tty_ldisc_try_get(): BUG kmalloc-8: Poison overwritten
Message-ID: <20090614123251.GA14785@elte.hu>
References: <20090614081052.GA9276@elte.hu> <4A34B2E2.7080702@cs.helsinki.fi> <20090614083254.GA23149@elte.hu> <20090614083531.GB23149@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090614083531.GB23149@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> --- a/drivers/char/tty_ldisc.c
> +++ b/drivers/char/tty_ldisc.c
> @@ -361,6 +361,7 @@ void tty_ldisc_deref(struct tty_ldisc *ld)
>  	unsigned long flags;
>  
>  	BUG_ON(ld == NULL);
> +	WARN_ON_ONCE(ld->refcount == (int)0xa56b6b6b);
>  
>  	spin_lock_irqsave(&tty_ldisc_lock, flags);

this does trigger:

[   70.198553] PM: Adding info for No Bus:vcsa2
[   70.223956] ------------[ cut here ]------------
[   70.233266] warning: `sudo' uses deprecated v2 capabilities in a way that may be insecure.
[   70.242894] WARNING: at drivers/char/tty_ldisc.c:364 tty_ldisc_deref+0x30/0x90()
[   70.242894] Modules linked in:
[   70.242894] Pid: 4252, comm: modprobe Not tainted 2.6.30-tip #746
[   70.242894] Call Trace:
[   70.242894]  [<413da1b0>] ? tty_ldisc_deref+0x30/0x90
[   70.242894]  [<41035c79>] warn_slowpath_common+0x49/0x60
[   70.242894]  [<41035c9d>] warn_slowpath_null+0xd/0x10
[   70.242894]  [<413da1b0>] tty_ldisc_deref+0x30/0x90
[   70.242894]  [<413d53ee>] tty_write+0x8e/0xa0
[   70.242894]  [<413d545f>] redirected_tty_write+0x5f/0x70
[   70.242894]  [<410b9002>] vfs_write+0x82/0xe0
[   70.242894]  [<413d5400>] ? redirected_tty_write+0x0/0x70
[   70.242894]  [<410b90fb>] sys_write+0x3b/0x60
[   70.242894]  [<4100388f>] sysenter_do_call+0x12/0x3c
[   70.242894]  [<4104007b>] ? timer_stats_timer_set_start_info+0xb/0x10
[   70.242894]  [<4104007b>] ? timer_stats_timer_set_start_info+0xb/0x10
[   70.242894] ---[ end trace 03c5764c731fa31f ]---
[   71.663044] device: 'vcs7': device_add

i suspect the swarm of mingetty's starting up during bootup is 
triggering some race.

	Ingo
