Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbZKXSKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbZKXSKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933764AbZKXSKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:10:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58396 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933761AbZKXSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:10:52 -0500
To: Patrick McHardy <kaber@trash.net>
Cc: Arnd Bergmann <arnd@arndb.de>, virtualization@lists.linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Anna Fischer <anna.fischer@hp.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Patrick Mullaney <pmullaney@novell.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       David Miller <davem@davemloft.net>
References: <1259024166-28158-1-git-send-email-arnd@arndb.de>
	<200911241002.20904.arnd@arndb.de> <4B0BB2A7.5040707@trash.net>
	<200911241034.43961.arnd@arndb.de> <4B0BB818.6090509@trash.net>
	<m1aaybc1s5.fsf@fess.ebiederm.org> <4B0C1031.4050803@trash.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Nov 2009 10:10:43 -0800
In-Reply-To: <4B0C1031.4050803@trash.net> (Patrick McHardy's message of "Tue\, 24 Nov 2009 17\:56\:17 +0100")
Message-ID: <m1aayb6bfg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/4] veth: move loopback logic to common location
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

> Eric W. Biederman wrote:
>> Patrick McHardy <kaber@trash.net> writes:
>> 
>>>>>> I did all my testing with macvlan interfaces in separate namespaces
>>>>>> communicating with each other, so I'd assume that we should always
>>>>>> clear skb->mark and skb->dst in this function.
>>>>> Good point, in that case we probably should clear it as well. But
>>>>> in the non-namespace case the TC classification currently works and
>>>>> this is consistent with any other virtual device driver, so it
>>>>> should continue to work.
>>>> Do you think we should be able to use TC to direct traffic between
>>>> macvlans on the same underlying device in bridge mode? It does sound
>>>> useful, but I'm not sure how to implement that or if you'd expect
>>>> it to work with the current code. If we support that, it should probably
>>>> also work with namespaces, by consuming the mark in the macvlan
>>>> and veth drivers.
>>> I don't think its necessary, we bypass outgoing queuing anyways.
>>> But if you'd want to add it, just keeping the skb->mark clearing
>>> in veth should work from what I can tell.
>> 
>> veth doesn't have an outgoing queue.  The reason we clear skb->mark
>> in veth is because when reentering the networking stack the packet
>> needs to be reclassified.  At the point of loopback we are talking
>> a packet that has at least logically gone out of the machine on a
>> wire and come back into the machine on another physical interface.
>> 
>> So it seems to me we should have consistent handling for macvlans,
>> veth, for the cases where we are looping packets back around.  In
>> practice I expect all of those cases are going to be cross namespace
>> as otherwise we would have intercepted the packet before going
>> out a physical interface.
>
> Agreed on the looping case, that's what we're doing now.
>
> In the layered case (macvlan -> eth0) its common behaviour to
> keep the mark however. But in case of different namespaces,
> I think macvlan should also clear the mark on the dev_queue_xmit()
> path since this is just a shortcut to looping the packets
> through veth. In fact probably both of them should also clear
> skb->priority so other namespaces don't accidentally misclassify
> packets.

That is why I pushed for what is becoming dev_forward_skb.  So that
we have one place where we can make all of those tweaks.  It seems
like in every review we find another field that should be cleared/handled
specially.

I don't quite follow what you intend with dev_queue_xmit when the macvlan
is in one namespace and the real physical device is in another.  Are
you mentioning that the packet classifier runs in the namespace where
the primary device lives with packets from a different namespace?

Eric

