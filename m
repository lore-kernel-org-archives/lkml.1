Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbZLNReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbZLNReK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZLNReJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:34:09 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:53932 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbZLNReI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:34:08 -0500
Message-ID: <4B267708.3010202@gmail.com>
Date: Mon, 14 Dec 2009 18:34:00 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: lists@nerdbynature.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, John Dykstra <john.dykstra1@gmail.com>
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
References: <20091212.010340.227842186.davem@davemloft.net>	<4B2360BF.5000102@gmail.com>	<4B25D38F.1090702@gmail.com> <20091213.234530.82029083.davem@davemloft.net>
In-Reply-To: <20091213.234530.82029083.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 14 Dec 2009 18:34:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/12/2009 08:45, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 14 Dec 2009 06:56:31 +0100
> 
>> It seems to me tcp_create_openreq_child() doesnt properly initialize
>> newtp->cookie_values to NULL, but this should not produce warnings like that ?
> 
> If oldtp->cookie_values is NULL, the child's should be as well
> because of sk_clone().

Right, maybe then its a tcp_ack() or a syncookie validation change ?


tcp_v4_rcv()
        bh_lock_sock_nested(sk);
        if (!sock_owned_by_user(sk)) {

        -> tcp_v4_do_rcv()
                -> tcp_v4_hnd_req()
                        -> cookie_v4_check()
                                -> get_cookie_sock()
                                        -> child = syn_recv_sock()
                                        -> inet_csk_reqsk_queue_add(child) (TCP_SYN_RECV socket queued into parent)
                -> tcp_child_process() (backlog... not)
                        -> tcp_rcv_state_process()
                                -> acceptable = tcp_ack() > 0;
                                -> if (acceptable) -> sk_state = TCP_ESTABLISHED
                                        (but if tcp_ack() returned <= 0, state unchanged : TCP_SYN_RECV)


And commit 96e0bf4b5193d0d97d139f99e2dd128763d55521
(tcp: Discard segments that ack data not yet sent)

Did change this area a bit :

@@ -5632,7 +5639,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 
        /* step 5: check the ACK field */
        if (th->ack) {
-               int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH);
+               int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH) > 0;
 
                switch (sk->sk_state) {
                case TCP_SYN_RECV:



