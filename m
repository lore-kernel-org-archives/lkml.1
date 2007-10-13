Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbXJMRQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbXJMRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbXJMRQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:16:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34949 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbXJMRP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:15:59 -0400
Date: Sat, 13 Oct 2007 20:15:52 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Willy Tarreau <w@1wt.eu>
cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.21 review 12/35] TCP: Fix TCP handling of SACK in
 bidirectional flows.
In-Reply-To: <20071013143452.%N@1wt.eu>
Message-ID: <Pine.LNX.4.64.0710132007430.27718@kivilampi-30.cs.helsinki.fi>
References: <20071013142822.%N@1wt.eu> <20071013143452.%N@1wt.eu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; boundary="-696243703-320683280-1192295294=:27718"
Content-ID: <Pine.LNX.4.64.0710132008170.27718@kivilampi-30.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-320683280-1192295294=:27718
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0710132008171.27718@kivilampi-30.cs.helsinki.fi>

On Sat, 13 Oct 2007, Willy Tarreau wrote:

> It's possible that new SACK blocks that should trigger new LOST
> markings arrive with new data (which previously made is_dupack
> false). In addition, I think this fixes a case where we get
> a cumulative ACK with enough SACK blocks to trigger the fast
> recovery (is_dupack would be false there too).
> 
> I'm not completely pleased with this solution because readability
> of the code is somewhat questionable as 'is_dupack' in SACK case
> is no longer about dupacks only but would mean something like
> 'lost_marker_work_todo' too... But because of Eifel stuff done
> in CA_Recovery, the FLAG_DATA_SACKED check cannot be placed to
> the if statement which seems attractive solution. Nevertheless,
> I didn't like adding another variable just for that either... :-)
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  net/ipv4/tcp_input.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> Index: 2.6/net/ipv4/tcp_input.c
> ===================================================================
> --- 2.6.orig/net/ipv4/tcp_input.c
> +++ 2.6/net/ipv4/tcp_input.c
> @@ -1951,7 +1951,10 @@ tcp_fastretrans_alert(struct sock *sk, u
>  {
>  	struct inet_connection_sock *icsk = inet_csk(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
> -	int is_dupack = (tp->snd_una == prior_snd_una && !(flag&FLAG_NOT_DUP));
> +	int is_dupack = (tp->snd_una == prior_snd_una &&
> +			 (!(flag&FLAG_NOT_DUP) ||
> +			  ((flag&FLAG_DATA_SACKED) &&
> +			   (tp->fackets_out > tp->reordering))));
>  
>  	/* Some technical things:
>  	 * 1. Reno does not count dupacks (sacked_out) automatically. */

FYI,

This ended up being a non complete fix. Day after these two patches 
(11-12) I submitted two other patches to complete this fix series (got 
bitten by release-early-release-often, fixed day-after-submission 
thoughts in those two later patches). For some reason these two keep 
floating around as separate ones from those two later ones.

To make things even more complicated, eb7bdad82e8 (see stable-2.6.22) 
could have been split more logically to do_lost addition and 
FLAG_SND_UNA_ADVANCED parts (but that didn't occur to me back then).

All of them listed here (from stable-2.6.22 since one of them is
reduced from mainline version):

6d742fb6e2b8913457e1282e1be77d6f4e45af00 Fix TCP DSACK cwnd handling
eb7bdad82e8af48e1ed1b650268dc85ca7e9ff39 Handle snd_una in tcp_cwnd_down()
8385cffd22359ad561a173accefeb354bd606ce4 TCP: Fix TCP handling of SACK in 
783366ad4b212cde069c50903494eb6a6b83958c TCP: Fix TCP rate-halving on 


-- 
 i.
---696243703-320683280-1192295294=:27718--
