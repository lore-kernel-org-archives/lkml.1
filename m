Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbXESFY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbXESFY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbXESFYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:24:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59308 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbXESFYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:24:47 -0400
Date: Fri, 18 May 2007 22:30:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [2.6 patch] net/llc/llc_conn.c: fix possible NULL dereference
Message-Id: <20070518223005.91236c38.randy.dunlap@oracle.com>
In-Reply-To: <464E8763.3010609@redhat.com>
References: <464E8763.3010609@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 13:13:07 +0800 Eugene Teo wrote:

> skb_peek() might return an empty list. skb should be checked before calling
> llc_pdu_sn_hdr() with it.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Eugene Teo <eteo@redhat.com>

Hi Eugene,

Networking patches need to be sent to the netdev@vger.kernel.org
mailing list  (and lkml can be omitted IMHO).

But... instead of doing the assignment and test in one swoop,
we prefer:

>         if (!q_len)
>                 goto out;
>         skb = skb_peek(&llc->pdu_unack_q);
> +       if (!skb)
> +               goto out;
>         pdu = llc_pdu_sn_hdr(skb);

Oh, and your patch has spaces instead of tabs.  It's a hassle to
get thunderbird to send a patch that preserves tabs.  See if this:
   http://mbligh.org/linuxdocs/Email/Clients/Thunderbird
helps you any.


> diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
> index 3b8cfbe..28a3994 100644
> --- a/net/llc/llc_conn.c
> +++ b/net/llc/llc_conn.c
> @@ -323,7 +323,8 @@ int llc_conn_remove_acked_pdus(struct sock *sk, u8 nr, u16
> *how_many_unacked)
> 
>         if (!q_len)
>                 goto out;
> -       skb = skb_peek(&llc->pdu_unack_q);
> +       if (! (skb = skb_peek(&llc->pdu_unack_q)))
> +               goto out;
>         pdu = llc_pdu_sn_hdr(skb);
> 
>         /* finding position of last acked pdu in queue */
> 
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
