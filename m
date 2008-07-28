Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbYG1X6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbYG1X6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYG1X6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:58:06 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:15058 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752038AbYG1X6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:58:04 -0400
Date: Tue, 29 Jul 2008 08:57:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh <linux-sh@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh/maple: clean maple bus code
Message-ID: <20080728235727.GE28055@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1217288656.6875.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217288656.6875.26.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 12:44:16AM +0100, Adrian McMenamin wrote:
>  static struct mapleq *maple_allocq(struct maple_device *mdev)
>  {
>  	struct mapleq *mq;
>  
>  	mq = kmalloc(sizeof(*mq), GFP_KERNEL);
>  	if (!mq)
> -		return NULL;
> +		goto failed_nomem;
>  
>  	mq->dev = mdev;
>  	mq->recvbufdcsp = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
>  	mq->recvbuf = (void *) P2SEGADDR(mq->recvbufdcsp);
> -	if (!mq->recvbuf) {
> -		kfree(mq);
> -		return NULL;
> -	}
> +	if (!mq->recvbuf)
> +		goto failed_p2;

This is really the wrong thing to check, you want to be checking
mq->recvbufdcsp here, as kmem_cache_zalloc() will return an error, while
P2SEGADDR() casts away. I expect that if you toss a NULL pointer or
something similar at it you will just get the P2 base back anyways, it
was never intended for error cases.

I expect you will also want to document your locking strategy in detail
at the top of the file. You do have some corner cases that are handled
that are not immediately obvious at first glance, it would be good to
spell it out explicitly.
