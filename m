Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbZGFHnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbZGFHnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbZGFHnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:43:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56408 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755661AbZGFHni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:43:38 -0400
Date: Mon, 6 Jul 2009 15:43:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Guntsche <mike@it-loops.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090706074333.GA17276@gondor.apana.org.au>
References: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com> <20090627140643.7140f6a9@lxorguk.ukuu.org.uk> <33C7D336-F062-47B3-9033-D3DC465F793C@it-loops.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33C7D336-F062-47B3-9033-D3DC465F793C@it-loops.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 04:07:31PM +0000, Michael Guntsche wrote:
>
> after that (120 seconds later) I see..
>
> [  360.294730] INFO: task pptpgw:392 blocked for more than 120 seconds.
> [  360.301147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"  
> disables this message.
> [  360.309018] pptpgw        D 0ff2d510     0   392    390 0x00000000
> [  360.315257] Call Trace:
> [  360.317721] [c7a61870] [c794a400] 0xc794a400 (unreliable)
> [  360.323194] [c7a61930] [c0008b20] __switch_to+0x4c/0x6c
> [  360.328465] [c7a61940] [c02c6244] schedule+0x190/0x380
> [  360.333646] [c7a61980] [c02c6d7c] __mutex_lock_slowpath+0x80/0xd8
> [  360.339796] [c7a619b0] [c0175370] tty_throttle+0x20/0x78
> [  360.345151] [c7a619c0] [c01737f0] n_tty_receive_buf+0x344/0xfcc
> [  360.351115] [c7a61aa0] [c01789b8] pty_write+0x8c/0xdc
> [  360.356210] [c7a61ac0] [c01c1410] ppp_async_push+0x3d4/0x544
> [  360.361910] [c7a61b20] [c01c15d4] ppp_async_send+0x54/0x6c
> [  360.367438] [c7a61b30] [c01bd948] ppp_push+0x3f4/0x530
> [  360.372614] [c7a61b90] [c01be12c] ppp_xmit_process+0x444/0x548
> [  360.378488] [c7a61bf0] [c01bf62c] ppp_start_xmit+0x198/0x1d0
> [  360.384203] [c7a61c10] [c01f5554] dev_hard_start_xmit+0x1c0/0x350
> [  360.390341] [c7a61c40] [c0207010] __qdisc_run+0x1c8/0x250
> [  360.395784] [c7a61c70] [c01f78b0] net_tx_action+0xfc/0x11c
> [  360.401314] [c7a61c90] [c00256e0] __do_softirq+0xa8/0x120
> [  360.406767] [c7a61cd0] [c00064e4] do_softirq+0x58/0x5c
> [  360.411943] [c7a61ce0] [c0025530] irq_exit+0x94/0x98

I think the first backtrace is bogus, this is where the real
problem is.  So what see here is that on xmit from the network,
PPP will call pty_write from BH context which eventually leads
to tty_throttle and the sleep.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
