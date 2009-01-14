Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbZANNRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbZANNRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbZANNRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:17:39 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:46228 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZANNRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:17:38 -0500
Message-ID: <496DE5ED.8030609@hp.com>
Date: Wed, 14 Jan 2009 08:17:33 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Pierre Habouzit <pierre.habouzit@intersec.com>
CC: Wei Yongjun <yjwei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: if backlog is 0, listening shall not be deactivated.
References: <1231926123-26196-1-git-send-email-pierre.habouzit@intersec.com>
In-Reply-To: <1231926123-26196-1-git-send-email-pierre.habouzit@intersec.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Habouzit wrote:
> POSIX hints that when 0 is used for the listen backlog argument, the
> kernel shall chose a default automatic value. TCP for example, works this
> way.
> 

However SCTP API explicitly states that when the backlog is 0, listening is
disabled.  Here is an excerpt from the draft describing this:

   int listen(int sd,
              int backlog);

   and the arguments are
   sd:  The socket descriptor of the endpoint.
   backlog:  If backlog is non-zero, enable listening else disable
      listening.


So, this is something that spelled out in the draft.

NAK.

-vlad

> Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
> ---
> 
>  net/sctp/socket.c |   20 --------------------
>  1 files changed, 0 insertions(+), 20 deletions(-)
> 
>     To put a bit of background, I stumbled against this while doing a code
>     that basically did:
> 
> 	struct sctp_event_subscribe events;
> 	/* ... */
> 
> 	fd = socket(AF_INET, SOCK_SEQPACKETS, IPPROTO_SCTP);
> 	sctp_bindx(fd, ....);
> 	events = (struct sctp_event_subscribe){
> 	    .sctp_data_io_event     = 1,
> 	    .sctp_association_event = 1,
> 	};
> 	setsockopt(fd, SOL_SCTP, SCTP_EVENTS, &events, sizeof(events));
> 	listen(fd, 0);
> 	len = sctp_recvmsg(fd, .....);
> 
>     The latter call instead of blocking like I expected returned with
>     errno == ENOTCONN.
> 
>     I know POSIX doesn't _require_ listen() to accept 0 as a valid backlog,
>     but the other listen() implementation I have used in the kernel do, and
>     it looks really surprising for the programmer (who really searches the
>     error elsewhere).
> 
>     Fortunately I had another working code at hand and I managed to find the
>     problem resorting to reverting the changes I made to the original code
>     line per line (*sigh*).
> 
>     I'm unsure if the diff shouldn't do instead:
> 
>     if (!backlog)
>         backlog = 1;
> 
>     I'm not really comfortable around the kernel core ;)
> 
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index ff0a8f8..da1d96a 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -5866,16 +5866,6 @@ SCTP_STATIC int sctp_seqpacket_listen(struct sock *sk, int backlog)
>  	if (!sctp_style(sk, UDP))
>  		return -EINVAL;
>  
> -	/* If backlog is zero, disable listening. */
> -	if (!backlog) {
> -		if (sctp_sstate(sk, CLOSED))
> -			return 0;
> -
> -		sctp_unhash_endpoint(ep);
> -		sk->sk_state = SCTP_SS_CLOSED;
> -		return 0;
> -	}
> -
>  	/* Return if we are already listening. */
>  	if (sctp_sstate(sk, LISTENING))
>  		return 0;
> @@ -5919,16 +5909,6 @@ SCTP_STATIC int sctp_stream_listen(struct sock *sk, int backlog)
>  	struct sctp_sock *sp = sctp_sk(sk);
>  	struct sctp_endpoint *ep = sp->ep;
>  
> -	/* If backlog is zero, disable listening. */
> -	if (!backlog) {
> -		if (sctp_sstate(sk, CLOSED))
> -			return 0;
> -
> -		sctp_unhash_endpoint(ep);
> -		sk->sk_state = SCTP_SS_CLOSED;
> -		return 0;
> -	}
> -
>  	if (sctp_sstate(sk, LISTENING))
>  		return 0;
>  

