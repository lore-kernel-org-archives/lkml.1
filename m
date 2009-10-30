Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbZJ3Ozw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbZJ3Ozw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932259AbZJ3Ozv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:55:51 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:56054 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbZJ3Ozv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:55:51 -0400
Message-ID: <4AEAFE77.9030205@gmail.com>
Date: Fri, 30 Oct 2009 15:55:51 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct
References: <38b2ab8a0909290109m3f82c161j4fb0f1266152877e@mail.gmail.com>	 <4AC1D0F5.4050709@gmail.com>	 <38b2ab8a0910300144i7a3c190fi9aa3d079c9cdb754@mail.gmail.com>	 <4AEACD88.8080108@gmail.com>	 <38b2ab8a0910300533l4bbc9d3cj8812fe38726c8278@mail.gmail.com> <38b2ab8a0910300641q78c08124o800a9dfc9486fba7@mail.gmail.com>
In-Reply-To: <38b2ab8a0910300641q78c08124o800a9dfc9486fba7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 30 Oct 2009 15:55:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau a écrit :
> On Fri, Oct 30, 2009 at 1:33 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>> On Fri, Oct 30, 2009 at 12:27 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> This oops occurring again and again with SUNRPC finally gave me the right pointer.
>>>
>>> David, we added two years ago memory accounting to UDP, and this changed
>>> requirements about calling skb_free_datagram() in the right context.
>>>
>>> I wish we had an ASSERT_SOCK_LOCKED() debugging facility :(
>>>
>>> Francis, would you please test following patch ?
>> I'm applying it and testing it during a couple of days and see if
>> something wrong still happens.
> 
> Hmm, with the patch applied on a 2.6.32-rc5, my machine locks hard
> when starting nfsd.
> 

Please ignore/revert the last part of the patch (about net/sunrpc/xprtsock.c)

In xs_udp_data_ready() we really want to call skb_free_datagram(),
not skb_free_datagram_locked(), because socket is already locked.

Thanks

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 37c5475..d61be4a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -883,7 +883,7 @@ static void xs_udp_data_ready(struct sock *sk, int len)
  out_unlock:
 	spin_unlock(&xprt->transport_lock);
  dropit:
+	skb_free_datagram(sk, skb);
-	skb_free_datagram_locked(sk, skb);
  out:
 	read_unlock(&sk->sk_callback_lock);
 }

