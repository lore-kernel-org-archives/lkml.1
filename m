Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbYDSQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbYDSQmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbYDSQmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:42:38 -0400
Received: from stinky.trash.net ([213.144.137.162]:55359 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbYDSQmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:42:37 -0400
Message-ID: <480A2011.3080507@trash.net>
Date: Sat, 19 Apr 2008 18:38:41 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on latest
 -git
References: <20080419100034.GA9475@elte.hu> <20080419.030736.168169087.davem@davemloft.net>
In-Reply-To: <20080419.030736.168169087.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------030704000000000509070200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030704000000000509070200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 19 Apr 2008 12:00:35 +0200
>
> [ netfilter-devel and netdev added to CC: ]
>
>   
>> randconfig testing found a netfilter build failure in latest -git:
>>
>>   net/netfilter/nf_conntrack_sip.c: In function 'set_expected_rtp_rtcp':
>>   net/netfilter/nf_conntrack_sip.c:786: error: 'struct nf_conntrack_expect' has no member named 'saved_ip'
>>
>>   http://redhat.com/~mingo/misc/config-Sat_Apr_19_11_37_02_CEST_2008.bad
>>
>> disabling CONFIG_NF_CONNTRACK_SIP works it around.
>>     
>
> I think this will fix it.
>
> Patrick, is this how we should do it?

No, the SIP helper is also useful without NAT. This patch adds
an ifdef around the RTP call optimization for NATed clients.

Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------030704000000000509070200
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 65b3ba5..9f49000 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -781,7 +781,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
 		    exp->class != class)
 			break;
-
+#ifdef CONFIG_NF_NAT_NEEDED
 		if (exp->tuple.src.l3num == AF_INET && !direct_rtp &&
 		    (exp->saved_ip != exp->tuple.dst.u3.ip ||
 		     exp->saved_proto.udp.port != exp->tuple.dst.u.udp.port) &&
@@ -791,6 +791,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 			tuple.dst.u.udp.port	= exp->saved_proto.udp.port;
 			direct_rtp = 1;
 		} else
+#endif
 			skip_expect = 1;
 	} while (!skip_expect);
 	rcu_read_unlock();

--------------030704000000000509070200--
