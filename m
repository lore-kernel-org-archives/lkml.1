Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424Ab0ADQaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0ADQaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:30:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394Ab0ADQaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:30:00 -0500
Received: from stinky.trash.net ([213.144.137.162]:37530 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0ADQ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:29:59 -0500
Message-ID: <4B421785.6090403@trash.net>
Date: Mon, 04 Jan 2010 17:29:57 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Milan Dadok <milan@dadok.name>
CC: uaca@alumni.uv.es, johann.baudy@gnu-log.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] 1/1 net: packet: Keep 802.1Q VLAN tag in packet on SOCK_DGRAM
 socket - resend
References: <001801ca8d1d$90c68de0$b253a9a0$@name> <4B41F292.8080908@trash.net> <001b01ca8d52$817d07d0$84771770$@name>
In-Reply-To: <001b01ca8d52$817d07d0$84771770$@name>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Dadok wrote:
> Patrick McHardy wrote:
> 
>> Milan Dadok wrote:
>>> Keep 802.1Q VLAN tag on non HW vlan accelerated network card received to SOCK_DGRAM socket.
> 
>> So not including the link layer header for SOCK_DGRAM sockets
>> seems to be the intended behaviour.
> 
>>From my point of view i have question
> Is 802.1Q encapsulation (or another type of encapsulation (IPSec?)) part of link level header or part of data packet?
> 
> Currently pseudo-header contains for OUTGOING packet on physical card (vlan10@eth1)
> a) HW accelarated network card  
> protocol = ethertype IPv4 (0x0800)
> tci = vlan number = 10
> and data starts with 4500 0028
> 
> b) non HW accelerated network card 
> protocol = ethertype 802.1Q (0x8100)
> tci = 0
> and data starts with 4500 0028
> vlan tci and real protocol number (ARP,IPV4,IPV6) of data is lost 

As mentioned in the text I quoted, this is apparently what is
intended for SOCK_DGRAM packet sockets. The accelerated case is
inconsistent and vlan_tci should be cleared I guess.

I agree that sll_protocol should reflect the network protocol
in this case however.

> And with more nested vlans it is getting worse
> for example
> 
> vlan1010@vlan10@eth1
> 
> a) HW accelarated network card  
> protocol = ethertype IPv4 (0x8100)
> tci = 10
> and data starts with 4500 0028
> 
> the 4 bytes of real packet 03f2 0800 is lost too
> 
> b) non HW accelarated network card  
> 4 words of data packet are lost ...
> 
> I have no problems with received packets, only outgoing packet have problem.
> I think that out packet on SOCK_DGRAM sockets MUST BE in same format as in (received) packet on same interface.
> Can we agree on this?

Yes, agreed.
