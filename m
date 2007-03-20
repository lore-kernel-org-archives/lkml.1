Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbXCTHl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbXCTHl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXCTHl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:41:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51731 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbXCTHl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:41:56 -0400
Date: Mon, 19 Mar 2007 23:38:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Neil Brown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.21 patch] net/sunrpc/svcsock.c: fix a check
Message-Id: <20070319233837.38f1aab7.akpm@linux-foundation.org>
In-Reply-To: <20070319093341.GS752@stusta.de>
References: <20070319093341.GS752@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 10:33:42 +0100 Adrian Bunk <bunk@stusta.de> wrote:

> The return value of kernel_recvmsg() should be assigned to "err", not 
> compared with the random value of a never initialized "err"
> (and the "< 0" check wrongly always returned false since == comparisons 
> never have a result < 0).
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.21-rc3-mm2/net/sunrpc/svcsock.c.old	2007-03-19 09:44:40.000000000 +0100
> +++ linux-2.6.21-rc3-mm2/net/sunrpc/svcsock.c	2007-03-19 09:45:18.000000000 +0100
> @@ -779,8 +779,8 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
>  	}
>  
>  	clear_bit(SK_DATA, &svsk->sk_flags);
> -	while ((err == kernel_recvmsg(svsk->sk_sock, &msg, NULL,
> -				      0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
> +	while ((err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
> +				     0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
>  	       (skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
>  		if (err == -EAGAIN) {
>  			svc_sock_received(svsk);

Cute.  The compiler must have decided to apply the "(a==b) can never be
less than zero" optimisation before performing uninitialised variable
analysis.

Neil, this one needs runtime testing before we can apply it to 2.6.21, I
think.
