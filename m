Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZH0MpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZH0MpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZH0MpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:45:05 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37311 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZH0MpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:45:03 -0400
Message-ID: <4A967FCE.3000807@gmail.com>
Date: Thu, 27 Aug 2009 14:45:02 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Li_Xin2@emc.com
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: TCP keepalive timer problem
References: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com> <4A93E36C.8070502@gmail.com> <0939B589FC103041945B9F13274963E303B1AD89@CORPUSMX90A.corp.emc.com>
In-Reply-To: <0939B589FC103041945B9F13274963E303B1AD89@CORPUSMX90A.corp.emc.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 27 Aug 2009 14:45:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please dont top post on these lists, find my answers below

Li_Xin2@emc.com a ¨¦crit :
>  
> Thanks for your quick reply, let me explain my problem in detail.
> 
> Suppose the client side of communication sets the keep alive socket option, connects to
> server, then > we pulls out the network cable of server box. After the connection is idle for TCP_KEEPIDLE 

seconds, the first keepalive probe packet is sent, and of course no reply is received. 

Just after the first probe packet, the client sends some data. No response is received, and 

as you said, the normal retransmission takes place and no further keepalive probe will be sent. 
> 
> 	The problem is: application that tries the keepalive mechanism expects communication peer 

crash detection within TCP_KEEPIDLE + TCP_KEEPCNT * TCP_KEEPINTVL seconds. Application may set

 relative smaller TCP_KEEPIDLE, TCP_KEEPCNT and TCP_KEEPINTVL value so that peer crash can be

 detected quickly, for example, 60 seconds. But if the keepalive is intervened with 

retransmission, the latter takes higher priority, so that peer crash will be detected after

 13 to 30 minutes, which may not be acceptable for some applications.
> 
> We tried TCP implementation on Windows XP SP3, the keepalive and retransmission don't intervene.
> 


> Regards,
> Xin Li
> EMC Shanghai R&D Centre
> Email: Li_Xin2@emc.com
> Tel: 86 21 6095 1100 x 2257
> 
> -----Original Message-----
> From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
> Sent: 2009Äê8ÔÂ25ÈÕ 21:13
> To: Li, Xin
> Cc: linux-kernel@vger.kernel.org; Linux Netdev List
> Subject: Re: TCP keepalive timer problem
> 
> Li_Xin2@emc.com a ¨¦crit :
>> Greetings,
>>
>> I found one problem in Linux TCP keepalive timer processing, after
>> searching on google, I found Daniel Stempel reported the same problem in
>> 2007 (http://lkml.indiana.edu/hypermail/linux/kernel/0702.2/1136.html),
>> but got no answer. So I have to reraise it.
>>
>> Can anyone help answer this two-years long question?
>>
>>
> 
> You should explain your problem in detail, since Daniel one was probably different.
> 
> He mentioned "(timeout is set to e.g. 30 seconds)" which is kind of nasty, given normal one is 7200
> 
> If some packets are in flight, keepalive is not fired at all, since normal
> retransmits should take place (check tcp_retries2 sysctl).
> 
> TCP Keepalive is only fired when no trafic occurred for a long time, only if 
> SO_KEEPALIVE socket option was enabled by application.
> 
> tcp_retries2 (integer; default: 15)
>     The maximum number of times a TCP packet is retransmitted in established state
> before giving up. The default value is 15, which corresponds to a duration of
> approximately between 13 to 30 minutes, depending on the retransmission timeout.
> The RFC 1122 specified minimum limit of 100 seconds is typically deemed too short. 
> 

RFC1122 , section 4.2.3.6 tells :

Keep-alive packets MUST only be sent when no data or acknowledgement packets have
 been received for the connection within an interval. This interval MUST be 
configurable and MUST default to no less than two hours. 

So :

Normal tcp_retries2 settings should make sure connection is reset if packets in flight are not acknowledged way before TCP_KEEPIDLE (>= 7200 seconds)


Now, 7200 seconds might be inappropriate for special needs, and considering
there is no way to change tcp_retries2 for a given socket (only choice being the global
tcp_retries2 setting), I would vote for a change in our stack, to *relax* RFC,
and get smaller keepalive timers if possible.

So when keepalive_timer fires, we should not care of outgoing packets,
only care on tp->rcv_tstamp, timestamp of last received ACK.


diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b144a26..719f198 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -484,18 +484,13 @@ static void tcp_keepalive_timer (unsigned long data)
 			}
 		}
 		tcp_send_active_reset(sk, GFP_ATOMIC);
-		goto death;
+		tcp_done(sk);
+		goto out;
 	}
 
 	if (!sock_flag(sk, SOCK_KEEPOPEN) || sk->sk_state == TCP_CLOSE)
 		goto out;
 
-	elapsed = keepalive_time_when(tp);
-
-	/* It is alive without keepalive 8) */
-	if (tp->packets_out || tcp_send_head(sk))
-		goto resched;
-
 	elapsed = tcp_time_stamp - tp->rcv_tstamp;
 
 	if (elapsed >= keepalive_time_when(tp)) {
@@ -522,13 +517,7 @@ static void tcp_keepalive_timer (unsigned long data)
 	TCP_CHECK_TIMER(sk);
 	sk_mem_reclaim(sk);
 
-resched:
 	inet_csk_reset_keepalive_timer (sk, elapsed);
-	goto out;
-
-death:
-	tcp_done(sk);
-
 out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
