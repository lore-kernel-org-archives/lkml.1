Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYJEVqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYJEVqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYJEVp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:45:58 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:43762 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754650AbYJEVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:45:58 -0400
From: swivel@shells.gnugeneration.com
Date: Sun, 5 Oct 2008 16:45:57 -0500
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20081005214556.GL18569@fc6222126.aspadmin.net>
References: <20080921145134.GT2761@fc6222126.aspadmin.net> <20080921211337.74e8f1f1@lxorguk.ukuu.org.uk> <20080921220926.GA18569@fc6222126.aspadmin.net> <20081005.132722.203253085.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005.132722.203253085.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 01:27:22PM -0700, David Miller wrote:
> 
> Give this patch a try:
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 1ab341e..0e43875 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -384,13 +384,17 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
>  
>  	/* Connected? */
>  	if ((1 << sk->sk_state) & ~(TCPF_SYN_SENT | TCPF_SYN_RECV)) {
> +		int target = sock_rcvlowat(sk, 0, INT_MAX);
> +
> +		if (tp->urg_seq == tp->copied_seq &&
> +		    !sock_flag(sk, SOCK_URGINLINE) &&
> +		    tp->urg_data)
> +			target--;
> +
>  		/* Potential race condition. If read of tp below will
>  		 * escape above sk->sk_state, we can be illegally awaken
>  		 * in SYN_* states. */
> -		if ((tp->rcv_nxt != tp->copied_seq) &&
> -		    (tp->urg_seq != tp->copied_seq ||
> -		     tp->rcv_nxt != tp->copied_seq + 1 ||
> -		     sock_flag(sk, SOCK_URGINLINE) || !tp->urg_data))
> +		if (target >= tp->rcv_nxt - tp->copied_seq)
>  			mask |= POLLIN | POLLRDNORM;
>  
>  		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {


I will be testing this patch today.  At a glance it appears with this
patch we're still not taking rcvlowat into consideration in recv()
with MSG_PEEK flag set.  This should probably also be corrected, as
mentioned in the thread previously.

Regards,
Vito Caputo
