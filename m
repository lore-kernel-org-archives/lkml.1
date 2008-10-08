Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYJHIjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYJHIjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYJHIjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:39:01 -0400
Received: from smtp2e.orange.fr ([80.12.242.113]:58170 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYJHIi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:38:59 -0400
X-ME-UUID: 20081008083858193.2F51570000B9@mwinf2e18.orange.fr
Message-ID: <48EC70BB.9010709@cosmosbay.com>
Date: Wed, 08 Oct 2008 10:35:07 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: minyard@acm.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <48EA8197.6080502@cosmosbay.com>	<20081006.144002.56418911.davem@davemloft.net>	<48EAF29D.8050203@cosmosbay.com> <20081007.112622.73930718.davem@davemloft.net>
In-Reply-To: <20081007.112622.73930718.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Tue, 07 Oct 2008 07:24:45 +0200
> 
>> Most UDP sockets are setup for long periods (RTP trafic), or if an application really
>> wants to {open/send or receive one UDP frame/close} many sockets, it already hits
>> RCU handling of its file structures and should not be slowed down that much.
> 
> As stated, I added RCU destruction generically for socket objects, and it
> showed up clearly.
> 
> So "not be slowed down that much" has been disproven, at least to me,
> already :-)
> 
> 
RCU in hash table is ok for managing read mostly data, since
only during the read access you avoid to dirty a rwlock...

If we have a workload that insert/delete sockets as hell but
receive few frames (that hit the hash table in a read only way),
then you defeat the purpose of RCU, and pay the price of
throwing away (in rcu queue) hot data that will become cold
before reuse...

BTW is there any chance your results were obtained before October 2005 ?

At that time, RCU was able to queue an unlimited number of events.
a single loop doing close(open("/dev/null",0)) could exhaust RAM...


Refs: commit  5ee832dbc6770135ec8d63296af0a4374557bb79
and many others...

Anyway we can probably code something without call_rcu() cache blower
for UDP, if time permits :)



