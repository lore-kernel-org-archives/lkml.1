Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbYEOGQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbYEOGQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYEOGQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:16:41 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:2402 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbYEOGQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:16:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuIIAClwK0iWZR7iWmdsb2JhbACSDQEdm1w
X-IronPort-AV: E=Sophos;i="4.27,489,1204464600"; 
   d="scan'208";a="112756008"
Message-ID: <B0A599AA8CD34E47901804F014F15903@uglypunk>
From: "Kingsley Foreman" <kingsley@internode.com.au>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <B28DA1911F61434C804723B7EE8A5C67@uglypunk> <20080514205604.e669a28f.akpm@linux-foundation.org> <482BC84E.3000401@cosmosbay.com>
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Date: Thu, 15 May 2008 15:46:11 +0930
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 12.0.1606
X-MimeOLE: Produced By Microsoft MimeOLE V12.0.1606
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--------------------------------------------------
From: "Eric Dumazet" <dada1@cosmosbay.com>
Sent: Thursday, May 15, 2008 2:51 PM
To: "Kingsley Foreman" <kingsley@internode.com.au>
Cc: "Andrew Morton" <akpm@linux-foundation.org>; 
<linux-kernel@vger.kernel.org>; <netdev@vger.kernel.org>
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface

> Andrew Morton a écrit :
>> (cc netdev)
>>
>> On Thu, 15 May 2008 12:25:19 +0930 "Kingsley Foreman" 
>> <kingsley@internode.com.au> wrote:
>>
>>
>>> Ive been using qdisc for quite a while without any problems,
>>> I just rebuilt a gentoo box with 2.6.25 kernel that does a lot of 
>>> traffic
>>> ~1000mbits+ over a bonded interface
>>>
>>> Im however seeing a big problem with cbq class dropping packets for no
>>> reason i can see, and it is causing a lot of speed issues.
>>>
>>> the basic config is this
>>> _____________________________________________________________________
>>> /sbin/tc qdisc del dev bond0 root
>>> /sbin/tc qdisc add dev bond0 root handle 1 cbq bandwidth 2000Mbit avpkt 
>>> 1000
>>> cell 8
>>> /sbin/tc class change dev bond0 root cbq weight 200Mbit allot 1514
>>>
>>> /sbin/tc class add dev bond0 parent 1: classid 1:1280 cbq bandwidth 
>>> 2000Mbit
>>> rate 1200Mbit weight 120Mbit prio 1 allot 1514 cell 8 maxburst 120 
>>> minburst
>>> 1 minidle 0 avpkt 1000 bounded
>>> /sbin/tc filter add dev bond0 parent 1:0 protocol ip prio 300 route to 5
>>> classid 1:1280
>>>
>>> /sbin/tc class add dev bond0 parent 1: classid 1:1281 cbq bandwidth 
>>> 2000Mbit
>>> rate 400Mbit weight 40Mbit prio 6 allot 1514 cell 8 maxburst 120 
>>> minburst 1
>>> minidle 0 avpkt 1000 bounded
>>> /sbin/tc filter add dev bond0 parent 1:0 protocol ip prio 300 route to 6
>>> classid 1:1281
>>> ____________________________________________________________________
>>>
>>> So there is a lot of bandwidth handed out but it is still dropping a lot 
>>> of
>>> packets  for very small ammounts of traffic eg 300mbits.
>>>
>>> However the biggest problem im seeing is if i just do this
>>>
>>> __________________________________________________________________
>>> /sbin/tc qdisc del dev bond0 root
>>> /sbin/tc qdisc add dev bond0 root handle 1 cbq bandwidth 2000Mbit avpkt 
>>> 1000
>>> cell 8
>>> /sbin/tc class change dev bond0 root cbq weight 200Mbit allot 1514
>>> ___________________________________________________________________
>>>
>>> after 30sec I get results like
>>> ___________________________________________________________________
>>>
>>> ### bond0: queueing disciplines
>>>
>>> qdisc cbq 1: root rate 2000Mbit (bounded,isolated) prio no-transmit
>>>  Sent 574230043 bytes 407156 pkt (dropped 2524, overlimits 0 requeues 0)
>>>  rate 0bit 0pps backlog 0b 0p requeues 0
>>>   borrowed 0 overactions 0 avgidle 3 undertime 0
>>>
>>> ### bond0: traffic classes
>>>
>>> class cbq 1: root rate 2000Mbit (bounded,isolated) prio no-transmit
>>>  Sent 574330783 bytes 407225 pkt (dropped 2525, overlimits 0 requeues 0)
>>>  rate 0bit 0pps backlog 0b 0p requeues 0
>>>   borrowed 0 overactions 0 avgidle 3 undertime 0
>>> __________________________________________________________________
>>>
>>> I can't for the life if me work out why it is dropping so many packets 
>>> for while doing so little traffic when i enable  cbq the transfer rate 
>>> drops by approx 30%, any help would be great, and any improvements to my 
>>> command lines would be good also.
>>>
>>>
>>> Kingsley Foreman
>>>
>>
>>
>>
>>
> Could you provide your linux-2.6.25 .config file please ?
>
> What kind of hardware is your box ? (CPU, network interfaces)
>
> CBQ and other packet schedulers depend on a fast ktime_get() interface, so 
> maybe
> slowdown you notice has its root on core kernel facilities
> (CONFIG_HZ, SCHED_HRTICK, HIGH_RES_TIMERS, ...)
>
> If you remove CBQ, do you get same slowdown if you have a tcpdump running 
> on your machine ?
>
Im seeing it on a sun v20z and a sun x220m2, both multicore Opteron both tg3
Im not seeing a slowdown if tcpdump is running on the same machine without 
CBQ

you can grab the config here
http://games.internode.on.net/ker-config.txt




 

