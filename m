Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYEZUz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYEZUz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 16:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYEZUzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 16:55:13 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:59159 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYEZUzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 16:55:12 -0400
Message-ID: <483B239D.4090402@krogh.cc>
Date: Mon, 26 May 2008 22:54:53 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, matheos.worku@sun.com
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <4827E930.3000008@krogh.cc>	<483B0986.70606@krogh.cc>	<20080526.123338.161271834.davem@davemloft.net> <20080526.123951.260448303.davem@davemloft.net>
In-Reply-To: <20080526.123951.260448303.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 26 May 2008 12:33:38 -0700 (PDT)
> 
>> From: Jesper Krogh <jesper@krogh.cc>
>> Date: Mon, 26 May 2008 21:03:34 +0200
>>
>>> Ok. Now I also hit it in production with the NFS-server, so this
>>> is definately a real bug somewhere in the driver. Should I register it
>>> at bugzilla?
>> Please feel free to do that.
> 
> BTW, I did stare at some of the transmit code of the NIU driver
> while flying from Tokyo to Seattle a few hours ago, and I
> found one possible theory on the transmit timeouts.
> 
> Can you try the patch below and let us know if the symptoms
> continue?
> 
> [ Note to Matheos: The IRQ marking scheme of the NIU doesn't mesh
>   well with how things work under Linux.  We really needs a
>   "TX queue empty" interrupt status in order to handle all cases
>   properly.  Otherwise we really cannot decide not mark some TX
>   descriptors without potentially entering a deadlock condition.  ]
> 
> diff --git a/drivers/net/niu.c b/drivers/net/niu.c
> index 918f802..7ab7f8e 100644
> --- a/drivers/net/niu.c
> +++ b/drivers/net/niu.c
> @@ -6165,7 +6165,7 @@ static int niu_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	rp->tx_buffs[prod].mapping = mapping;
>  
>  	mrk = TX_DESC_SOP;
> -	if (++rp->mark_counter == rp->mark_freq) {
> +	if (1 /*++rp->mark_counter == rp->mark_freq*/) {
>  		rp->mark_counter = 0;
>  		mrk |= TX_DESC_MARK;
>  		rp->mark_pending++;

Applied and running.. I've now pushed 400GB of data through it trying to
get it to hit the bug but it is still running.

So without saying that it solved the problem, it definately seems so.
2.6.26-rc4 + above patch.

Jesper
-- 
Jesper
