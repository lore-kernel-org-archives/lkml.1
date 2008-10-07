Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYJGFZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYJGFZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 01:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYJGFZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 01:25:19 -0400
Received: from smtp28.orange.fr ([80.12.242.101]:61892 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbYJGFZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 01:25:18 -0400
X-ME-UUID: 20081007052516959.EA589700008E@mwinf2822.orange.fr
Message-ID: <48EAF29D.8050203@cosmosbay.com>
Date: Tue, 07 Oct 2008 07:24:45 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: minyard@acm.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local>	<48EA8197.6080502@cosmosbay.com> <20081006.144002.56418911.davem@davemloft.net>
In-Reply-To: <20081006.144002.56418911.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Mon, 06 Oct 2008 23:22:31 +0200
> 
>> Me wondering what impact this synchronize_rcu() can have on mono-threaded
>> VOIP applications using lot of UDP sockets. What is the maximum delay of
>> this function ?
> 
> The cost is enormous, we really can't use it here.
> 
> I have a patch that did top-level socket destruction using RCU,
> and that didn't use synchronize_rcu(), and that killed connection
> rates by up to %20.
> 
> I can only imagine what the cost would be if I had to add such a call
> in there.
> 
> Really, I can't consider these changes seriously, as-is.

Yes, I suppose you are right about TCP sessions, that should stay as they are.

Then if we use call_rcu() RCU freeing only for UDP sockets, we should get rid of
taking this rwlock each time we handle an incoming datagram, and introduce
no extra cost for other sockets.

Most UDP sockets are setup for long periods (RTP trafic), or if an application really
wants to {open/send or receive one UDP frame/close} many sockets, it already hits
RCU handling of its file structures and should not be slowed down that much.

By 'long period' I mean thousand of packets sent/received by each RTP session, being
voice (50 packets/second) or even worse video...




