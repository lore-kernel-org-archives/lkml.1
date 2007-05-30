Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbXE3VBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbXE3VBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbXE3VBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:01:40 -0400
Received: from mail.screens.ru ([213.234.233.54]:42936 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbXE3VBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:01:40 -0400
Date: Thu, 31 May 2007 01:01:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Stephen Hemminger <shemminger@osdl.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fix-soft-lockup-when-removing-netconsole-module.patch added to -mm tree
Message-ID: <20070530210137.GA225@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
>
> The netpoll_cleanup handler can hang the kernel if there is no work in the
> work queue because a call to cancel_rearming_delayed_work() with no work
> goes into an infinite loop.

This should not be true any longer, cancel_rearming_delayed_work() should work
correctly in any case.

Could you please clarify?

> @@ -771,30 +771,32 @@ void netpoll_cleanup(struct netpoll *np)
>
> [...snip...]
>
> +		if (atomic_dec_and_test(&npinfo->refcnt)) {
> +			skb_queue_purge(&npinfo->arp_tx);
> +			skb_queue_purge(&npinfo->txq);
> +			if (delayed_work_pending(&npinfo->tx_work)) {
>  				cancel_rearming_delayed_work(&npinfo->tx_work);
>  				flush_scheduled_work();

But this "if (delayed_work_pending())" is racy anyway?

Oleg.

