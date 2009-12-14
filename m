Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZLNS5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZLNS5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZLNS5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:57:19 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48253 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbZLNS5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:57:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EJP5/ctET7x21fZ4JOtkgnthDf3LlV00bIdpiD5I6DfarTC4sMb7F8TJ7Hs3l4c7ge
         b0ihM/Q+IQm+2Hp/nv+pbp/TuA6qT/GFAAQfeemSHUQBm3vLy8B7xVOh0Vth4mIAoA4n
         2EQmZ4S6cf7yHrRxdqHCYtHKlBoD7mRTB6v+w=
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
From: John Dykstra <john.dykstra1@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <4B267708.3010202@gmail.com>
References: <20091212.010340.227842186.davem@davemloft.net>
	 <4B2360BF.5000102@gmail.com>	<4B25D38F.1090702@gmail.com>
	 <20091213.234530.82029083.davem@davemloft.net> <4B267708.3010202@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 14 Dec 2009 18:57:13 +0000
Message-Id: <1260817033.9141.8.camel@merlyn>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 18:34 +0100, Eric Dumazet wrote:
> Le 14/12/2009 08:45, David Miller a écrit :
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Mon, 14 Dec 2009 06:56:31 +0100
> > 
> >> It seems to me tcp_create_openreq_child() doesnt properly initialize
> >> newtp->cookie_values to NULL, but this should not produce warnings like that ?
> > 
> > If oldtp->cookie_values is NULL, the child's should be as well
> > because of sk_clone().
> 
> Right, maybe then its a tcp_ack() or a syncookie validation change ?
> 
> 
> tcp_v4_rcv()
>         bh_lock_sock_nested(sk);
>         if (!sock_owned_by_user(sk)) {
> 
>         -> tcp_v4_do_rcv()
>                 -> tcp_v4_hnd_req()
>                         -> cookie_v4_check()
>                                 -> get_cookie_sock()
>                                         -> child = syn_recv_sock()
>                                         -> inet_csk_reqsk_queue_add(child) (TCP_SYN_RECV socket queued into parent)
>                 -> tcp_child_process() (backlog... not)
>                         -> tcp_rcv_state_process()
>                                 -> acceptable = tcp_ack() > 0;
>                                 -> if (acceptable) -> sk_state = TCP_ESTABLISHED
>                                         (but if tcp_ack() returned <= 0, state unchanged : TCP_SYN_RECV)
> 
> 
> And commit 96e0bf4b5193d0d97d139f99e2dd128763d55521
> (tcp: Discard segments that ack data not yet sent)
> 
> Did change this area a bit :
> 
> @@ -5632,7 +5639,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
>  
>         /* step 5: check the ACK field */
>         if (th->ack) {
> -               int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH);
> +               int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH) > 0;
>  
>                 switch (sk->sk_state) {
>                 case TCP_SYN_RECV:

That test was changed to match a change in the return values of
tcp_ack().  No logic change was intended.

I won't be able to catch up on this thread and take a look at the code
until this evening, CST.

  --  John

