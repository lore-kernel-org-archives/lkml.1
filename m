Return-Path: <linux-kernel-owner+w=401wt.eu-S1751215Ab0AIFpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab0AIFpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 00:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991Ab0AIFpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 00:45:11 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:47607 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0AIFpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 00:45:09 -0500
Date: Sat, 09 Jan 2010 00:44:28 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
In-reply-to: <4B4809EF.1070609@majjas.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4B4817BC.4060002@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B459368.2000503@majjas.com> <4B45F841.8030407@majjas.com>
 <20100107180114.GB3088@del.dom.local> <4B4625BD.3070202@majjas.com>
 <20100107183545.GA3208@del.dom.local> <4B462B3C.90506@majjas.com>
 <20100107185040.GB3208@del.dom.local> <4B466A26.5070506@majjas.com>
 <20100108074539.GA6205@ff.dom.local> <4B475FF9.7000702@majjas.com>
 <20100108212923.GA3078@del.dom.local> <4B47A81B.5040601@majjas.com>
 <4B4809EF.1070609@majjas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2010 11:45 PM, Michael Breuer wrote:
> On 1/8/2010 4:48 PM, Michael Breuer wrote:
>> On 1/8/2010 4:29 PM, Jarek Poplawski wrote:
>> ...
>>> BTW, don't hurry with that yet, but in the next test, please try
>>> alternative 2 again (i.e. with MMAP + no DMAR + disable_msi).
>>>
>> Will do - still up from yesterday... no more dropped packets... none 
>> of the dns errors either. To be expected I suppose as long as I'm 
>> trying to sniff it. Assuming no immediate erorrs with alt2, no DMAR + 
>> disable_msi I'll report back after it's been up for a while.
>> -- 
> Ok - ran alt1 and alt2, both with MMAP, no DMAR and disable_msi. Both 
> seem to behave similarly. No logged errors; large numbers of dropped 
> RX packets. One odd thing: when driving every sort of traffic through, 
> I was able to hose the client adapter (win7) repeatedly by runnnig the 
> win7 backup and connecting Windows Media Player to a Mediatomb stream 
> while also running a remote X11 session. Looks like the SSDP traffic 
> that occurs at the same time as the SMB traffic and X11 traffic takes 
> out the adapter on Win7 - Nforce.
> Reran with msi enabled, MMAP and no DMAR. Also no errors; much faster, 
> and the Win7 side survives the same conditions that don't work when 
> msi is disabled. Doesn't make sense to me, but it is what it is.
>
Tracked it down - this appears to be result of Win7 enabling 
"EnableDeadGWDetect" by default. Long story short, if this is set and a 
packet sent to the gw is retransmitted more than, 1/2 the value of 
maxdataretransmissions (default of 5), then the gateway is declared dead 
and the next one selected. If there is only one gateway, then the 
default gateway is effectively removed. So under load where the server 
is the default gateway, this is not a surprising result. With msi 
enabled, the system responds better, fewer retransmissions, no dropping 
the link.
> Going to leave this up for a while and see if things remain functional.
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

