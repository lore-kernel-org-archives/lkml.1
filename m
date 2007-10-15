Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbXJOWkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbXJOWkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXJOWkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:40:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58625 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbXJOWkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:40:32 -0400
Message-ID: <4713EC59.4010106@pobox.com>
Date: Mon, 15 Oct 2007 18:40:25 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: Re: [patch] forcedeth: fix the NAPI poll function
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu>
In-Reply-To: <20071015223009.GA27425@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>> but this one should be inactive (not plugged into the network). 
>>> Should i try to get a debug print out of the actual 'weight' and 
>>> 'work' integers, and of the n->poll function address?
>> ok, i've added such a patch.
>>
>> looking at the dev.c code - can napi_struct->weight be zero 
>> legitimately? If yes then the 0 gets passed to the driver and the 
>> driver would return 1 - violating the assertion.
> 
> update:
> 
> [  186.635916] WARNING: at net/core/dev.c:2166 net_rx_action()
> [  186.641351]  [<c060d9f5>] net_rx_action+0x145/0x1b0
> [  186.646191]  [<c011d752>] __do_softirq+0x42/0x90
> [  186.650784]  [<c011d7c6>] do_softirq+0x26/0x30
> [  186.655202]  [<c011db48>] local_bh_enable+0x48/0xa0
> [  186.660055]  [<c06023e0>] lock_sock_nested+0xa0/0xc0
> [  186.664995]  [<c065da16>] tcp_recvmsg+0x16/0xbc0
> [  186.669588]  [<c013e94b>] __generic_file_aio_write_nolock+0x27b/0x520
> [  186.676001]  [<c0601d75>] sock_common_recvmsg+0x45/0x70
> [  186.681202]  [<c05ff5df>] sock_aio_read+0x11f/0x140
> [  186.686054]  [<c015c086>] do_sync_read+0xc6/0x110
> [  186.690735]  [<c012b9b0>] autoremove_wake_function+0x0/0x40
> [  186.696280]  [<c060dcfc>] net_tx_action+0x3c/0xe0
> [  186.700961]  [<c015c9c2>] vfs_read+0x132/0x140
> [  186.705378]  [<c015cd41>] sys_read+0x41/0x70
> [  186.709625]  [<c0102b66>] sysenter_past_esp+0x5f/0x89
> [  186.714651]  =======================
> [  186.718210] work: 65, weight: 64
> [  186.721414] ->poll: (nv_napi_poll+0x0/0x760)
> 
> so nv_napi_poll() returned with 65. How is that possible? Ah ...:
> 
>               (rx_processed_cnt++ < limit)) {
> 
> that should be:
> 
>               (++rx_processed_cnt < limit)) {
> 
> right? Find the fix below.
> 
> 	Ingo
> 
> -------------------->
> Subject: forcedeth: fix the NAPI poll function
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix the forcedeth NAPI poll function to not emit this warning:
> 
> [  186.635916] WARNING: at net/core/dev.c:2166 net_rx_action()
> [  186.641351]  [<c060d9f5>] net_rx_action+0x145/0x1b0
> [  186.646191]  [<c011d752>] __do_softirq+0x42/0x90
> [  186.650784]  [<c011d7c6>] do_softirq+0x26/0x30
> [  186.655202]  [<c011db48>] local_bh_enable+0x48/0xa0
> [  186.660055]  [<c06023e0>] lock_sock_nested+0xa0/0xc0
> [  186.664995]  [<c065da16>] tcp_recvmsg+0x16/0xbc0
> [  186.669588]  [<c013e94b>] __generic_file_aio_write_nolock+0x27b/0x520
> [  186.676001]  [<c0601d75>] sock_common_recvmsg+0x45/0x70
> [  186.681202]  [<c05ff5df>] sock_aio_read+0x11f/0x140
> [  186.686054]  [<c015c086>] do_sync_read+0xc6/0x110
> [  186.690735]  [<c012b9b0>] autoremove_wake_function+0x0/0x40
> [  186.696280]  [<c060dcfc>] net_tx_action+0x3c/0xe0
> [  186.700961]  [<c015c9c2>] vfs_read+0x132/0x140
> [  186.705378]  [<c015cd41>] sys_read+0x41/0x70
> [  186.709625]  [<c0102b66>] sysenter_past_esp+0x5f/0x89
> [  186.714651]  =======================
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/net/forcedeth.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/net/forcedeth.c
> ===================================================================
> --- linux.orig/drivers/net/forcedeth.c
> +++ linux/drivers/net/forcedeth.c
> @@ -2274,7 +2274,7 @@ static int nv_rx_process(struct net_devi
>  
>  	while((np->get_rx.orig != np->put_rx.orig) &&
>  	      !((flags = le32_to_cpu(np->get_rx.orig->flaglen)) & NV_RX_AVAIL) &&
> -		(rx_processed_cnt++ < limit)) {
> +		(++rx_processed_cnt < limit)) {
>  
>  		dprintk(KERN_DEBUG "%s: nv_rx_process: flags 0x%x.\n",
>  					dev->name, flags);
> @@ -2412,7 +2412,7 @@ static int nv_rx_process_optimized(struc
>  
>  	while((np->get_rx.ex != np->put_rx.ex) &&
>  	      !((flags = le32_to_cpu(np->get_rx.ex->flaglen)) & NV_RX2_AVAIL) &&
> -	      (rx_processed_cnt++ < limit)) {
> +	      (++rx_processed_cnt < limit)) {

Two comments:

1) we have a vague definition of "RX work processed."  Due to error 
conditions and goto's in that function, rx_processed_cnt may or may not 
equal the number of packets actually processed.

2) man I dislike these inline C statement combinations (ranting at 
original code style, not you).  I would much rather waste a few extra 
lines of source code and make the conditions obvious:

	while (... && (rx_processed_cnt < limit)) {
		rx_processed_cnt++;

		...
	}

or even

	while (1) {
		...
		if (rx_processed_cnt == limit)
			break;
		rx_processed_cnt++;
	}

The compiler certainly doesn't care, and IMO it prevents bugs.

	Jeff


