Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXBMM6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXBMM6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbXBMM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:58:37 -0500
Received: from stinky.trash.net ([213.144.137.162]:35407 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXBMM6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:58:37 -0500
Message-ID: <45D1B5FA.5050704@trash.net>
Date: Tue, 13 Feb 2007 13:58:34 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20 13/14] nfnetlink_log: fix reference counting
References: <20070212003738.GA8262@rere.qmqm.pl>	<20070212202052.GA28704@rere.qmqm.pl> <20070212202255.GD28704@rere.qmqm.pl>
In-Reply-To: <20070212202255.GD28704@rere.qmqm.pl>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micha³ Miros³aw wrote:
> Fix reference counting (memory leak) problem in __nfulnl_send() and callers
> related to packet queueing.
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> 
> --- linux-2.6.20/net/netfilter/nfnetlink_log.c.11	2007-02-12 17:35:50.000000000 +0100
> +++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:58:01.000000000 +0100
> @@ -223,6 +223,11 @@ _instance_destroy2(struct nfulnl_instanc
>  
>  	spin_lock_bh(&inst->lock);
>  	if (inst->skb) {
> +		/* timer "holds" one reference (we have one more) */
> +		if (timer_pending(&inst->timer)) {
> +			del_timer(&inst->timer);
> +			instance_put(inst);

This should be done outside of the locked section and using
del_timer_sync to make sure the timer is not already active
and waiting for the lock.

Please combine this with 07/10 if possible.
