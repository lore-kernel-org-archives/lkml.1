Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183Ab0ALKqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0ALKqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134Ab0ALKqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:46:12 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:53492 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab0ALKqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:46:12 -0500
Message-ID: <4B4C52EA.6070705@gmail.com>
Date: Tue, 12 Jan 2010 11:46:02 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] tcp: harmonize tcp_vx_rcv header length assumptions
References: <4B49D001.4000302@gmail.com> <4B4C4962.8040207@gmail.com>
In-Reply-To: <4B4C4962.8040207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 12 Jan 2010 11:46:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/01/2010 11:05, William Allen Simpson a écrit :
> Harmonize tcp_v4_rcv() and tcp_v6_rcv() -- better document tcp doff and
> header length assumptions.
> 
> Reduces multiply/shifts, marginally improving speed.
> 
> Retains redundant tcp header length checks before checksumming.
> 
> Stand-alone patch, originally developed for TCPCT.
> 
> Requires:
>   net: tcp_header_len_th and tcp_option_len_th
> 
> Signed-off-by: William.Allen.Simpson@gmail.com
> ---
>  net/ipv4/tcp_ipv4.c |   36 +++++++++++++++++++-------------
>  net/ipv6/tcp_ipv6.c |   56
> ++++++++++++++++++++++++++++----------------------
>  2 files changed, 52 insertions(+), 40 deletions(-)

Seems fine, but :

1) What means the "Transformed ?" you wrote several times ?

2) This part :

-	th = tcp_hdr(skb);
-
-	if (th->doff < sizeof(struct tcphdr)/4)
+	/* Check bad doff, compare doff directly to constant value */
+	tcp_header_len = tcp_hdr(skb)->doff;
+	if (tcp_header_len < (sizeof(struct tcphdr) / 4))
 		goto bad_packet;
-	if (!pskb_may_pull(skb, th->doff*4))
+
+	/* Check too short header and options */
+	tcp_header_len *= 4;
+	if (!pskb_may_pull(skb, tcp_header_len))
 		goto discard_it;


could be :  (no need for 4 multiplies/divides)

	tcp_header_len = tcp_header_len_th(tcp_hdr(skb));
	if (tcp_header_len < sizeof(struct tcphdr))
		goto bad_packet;
	/* Check too short header and options */
	if (!pskb_may_pull(skb, tcp_header_len))
		goto discard_it;

	 
