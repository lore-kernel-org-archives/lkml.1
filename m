Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZLAItK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZLAItK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZLAItK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:49:10 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:41410 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbZLAItJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:49:09 -0500
Message-ID: <4B14D878.1070802@gmail.com>
Date: Tue, 01 Dec 2009 09:48:56 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Patch] net: fix an array index overflow
References: <20091201082901.4678.16688.sendpatchset@localhost.localdomain>
In-Reply-To: <20091201082901.4678.16688.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 01 Dec 2009 09:48:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang a écrit :
> Don't use the address of an out-of-boundary element.
> 
> Maybe this is not harmful at runtime, but it is still
> good to improve it.

Why ?

for (ptr = start; ptr < end; ptr++) {}

is valid, even if 'end' is 'outside of bounds'

It also works if start == end.

> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> 
> ---
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 57737b8..2669361 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1586,7 +1586,7 @@ static int __init inet_init(void)
>  #endif
>  
>  	/* Register the socket-side information for inet_create. */
> -	for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
> +	for (r = &inetsw[0]; r <= &inetsw[SOCK_MAX-1]; ++r)
>  		INIT_LIST_HEAD(r);
>  
>  	for (q = inetsw_array; q < &inetsw_array[INETSW_ARRAY_LEN]; ++q)
> --

I wonder why you want to 'fix' this loop and let following loop unchanged...

	for (q = inetsw_array; q < &inetsw_array[INETSW_ARRAY_LEN]; ++q)
		inet_register_protosw(q);

If this really hurts your eyes, why not using basic loops ?

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 7d12c6a..476cda7 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1540,8 +1540,7 @@ static struct packet_type ip_packet_type __read_mostly = {
 static int __init inet_init(void)
 {
 	struct sk_buff *dummy_skb;
-	struct inet_protosw *q;
-	struct list_head *r;
+	int i;
 	int rc = -EINVAL;
 
 	BUILD_BUG_ON(sizeof(struct inet_skb_parm) > sizeof(dummy_skb->cb));
@@ -1584,11 +1583,11 @@ static int __init inet_init(void)
 #endif
 
 	/* Register the socket-side information for inet_create. */
-	for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
-		INIT_LIST_HEAD(r);
+	for (i = 0; i < SOCK_MAX; i++)
+		INIT_LIST_HEAD(&inetsw[i]);
 
-	for (q = inetsw_array; q < &inetsw_array[INETSW_ARRAY_LEN]; ++q)
-		inet_register_protosw(q);
+	for (i = 0; i < INETSW_ARRAY_LEN; i++)
+		inet_register_protosw(&inetsw_array[i]);
 
 	/*
 	 *	Set the ARP module up
