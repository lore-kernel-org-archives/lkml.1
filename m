Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab0CIS63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:58:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:58912 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab0CIS60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:58:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,609,1262592000"; 
   d="scan'208";a="547521251"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 9 Mar 2010 11:58:19 -0700
Subject: RE: [2.6.34-rc1] CPU stalls when closing TCP sockets.
Thread-Topic: [2.6.34-rc1] CPU stalls when closing TCP sockets.
Thread-Index: Acq/oRj8FzTXY3PzTJ2/cVHxzOQkqQAGMPrw
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FE46FA932@rrsmsx501.amr.corp.intel.com>
References: <201003090319.o293J6WF026448@www262.sakura.ne.jp>
	 <1268116647.2819.64.camel@edumazet-laptop>
	 <201003090654.o296sCnh065487@www262.sakura.ne.jp>
 <1268150156.3113.12.camel@edumazet-laptop>
In-Reply-To: <1268150156.3113.12.camel@edumazet-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o29KVnwk003040

Eric Dumazet wrote:
> Le mardi 09 mars 2010 Ã  15:54 +0900, Tetsuo Handa a Ã©crit :
>> Eric Dumazet wrote:
>>> Nothing comes to my mind, I'll try to reproduce this here.
>> 
>> When stopped at (8), Ctrl-C doesn't work.
>> 
>>> Is 2.6.33 OK ?
>> 
>> Yes. 2.6.33 and earlier are OK.
> 
> OK thanks !
> 
> I believe commit d218d11133d888f9745802146a50255a4781d37a
> (tcp: Generalized TTL Security Mechanism) might be the bug origin.
> 
> I am testing following patch, based on latest net-2.6 tree (including
> the LINUX_MIB_TCPMINTTLDROP bit)
> 
> [PATCH] tcp: Fix tcp_v4_rcv()
> 
> Commit d218d111 (tcp: Generalized TTL Security Mechanism) added a bug
> for TIMEWAIT sockets. We should not test min_ttl for TW sockets.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 8d51d39..70df409 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1651,15 +1651,15 @@ int tcp_v4_rcv(struct sk_buff *skb)
>  	if (!sk)
>  		goto no_tcp_socket;
> 
> +process:
> +	if (sk->sk_state == TCP_TIME_WAIT)
> +		goto do_time_wait;
> +
>  	if (unlikely(iph->ttl < inet_sk(sk)->min_ttl)) {
>  		NET_INC_STATS_BH(net, LINUX_MIB_TCPMINTTLDROP);
>  		goto discard_and_relse;
>  	}
> 
> -process:
> -	if (sk->sk_state == TCP_TIME_WAIT)
> -		goto do_time_wait;
> -
>  	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
>  		goto discard_and_relse;
>  	nf_reset(skb);

This patch fixes hangs with ftp and rsh sessions I have been experiencing for some time now with the net-next tree. Hundreds of iterations passed without problems.

Thanks!
Emilÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
