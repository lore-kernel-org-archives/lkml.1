Return-Path: <linux-kernel-owner+w=401wt.eu-S1764781AbXF2L6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764781AbXF2L6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760519AbXF2L6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:58:22 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3857 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760456AbXF2L6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:58:16 -0400
Message-ID: <4684F3D8.1080800@domdv.de>
Date: Fri, 29 Jun 2007 13:58:16 +0200
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net>
In-Reply-To: <4684EF6A.7070109@trash.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Andreas Steinmetz wrote:
>> There seems to be a problem with mss to pmtu clamping for incoming syn
>> packets on reply to an outgoing connection on a ppp interface. The mss
>> of the outgoing syn packets is always always clamped to the pmtu, I did
>> check this with a target host I do have access to. The incoming syn
>> reply to such a packet, however, is mss clamped only sometimes and this
>> seems to depend on the DSL line used.
>>
>> The kernels tested were 2.6.20.1, 2.6.20.3 and 2.6.22rc6.
>>
>> Test setup: Two DSL lines, otherwise identical setup (same masquerading
>> linux gateway, same DSL account, same DSL modem, same DSL line provider,
>> same target host, request from and tcpdump on the same client).
>>
>> Linux Client<->Masquerading Linux Gateway<->DSL Modem<->DSL Line<->...
>>
>> DSL line 1, working:
>>
>> 22:26:39.319281 IP (tos 0x0, ttl  64, id 22377, offset 0, flags [DF],
>> length: 48
>> ) 192.168.0.253.1164 > 64.34.165.170.80: S [tcp sum ok]
>> 1465827859:1465827859(0)
>>  win 5840 <mss 1460,nop,nop,sackOK>
>> 22:26:39.459314 IP (tos 0x0, ttl  51, id 0, offset 0, flags [DF],
>> length: 48) 64
>> .34.165.170.80 > 192.168.0.253.1164: S [tcp sum ok]
>> 3667852791:3667852791(0) ack
>>  1465827860 win 5840 <mss 1452,nop,nop,sackOK>
>>
>> The tcpdump on the client shows that the mss of the incoming syn reply
>> packet is clamped to the ppp interface mtu.
>>
>> DSL line 2, not working:
>>
>> 22:03:57.725998 IP (tos 0x0, ttl  64, id 55984, offset 0, flags [DF],
>> length: 48
>> ) 192.168.0.253.1600 > 64.34.165.170.80: S [tcp sum ok]
>> 36968258:36968258(0) win
>>  5840 <mss 1460,nop,nop,sackOK>
>> 22:03:57.866966 IP (tos 0x0, ttl  51, id 0, offset 0, flags [DF],
>> length: 48) 64
>> .34.165.170.80 > 192.168.0.253.1600: S [tcp sum ok]
>> 2226854208:2226854208(0) ack
>>  36968259 win 5840 <mss 1460,nop,nop,sackOK>
>>
>> The tcpdump on the client shows that the mss of the incoming syn reply
>> packet is *NOT* clamped to the ppp interface mtu.
> 
> 
> You forgot to mention *how* you're clamping the MSS. Using
> TCPMSS? Do you have a rule for incoming packets?
> 

The relevant iptables commands I do use for masquerading and clamping are:

iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS \
	--clamp-mss-to-pmtu

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
