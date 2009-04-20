Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbZDTUBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbZDTUBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZDTUAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:00:52 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:46786 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZDTUAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t20r/5kGsAZSuFJ+89+OczTMykAkb90azLCn7lgHHax3rMDfQt1ZYUm71WHCr4po9z
         ay6UR0w99qrWijxeEr4B7Ko6XykP/BXzg/s1lkgY0J3KdlkEUTggUUb1zXS+ZWr7gZxY
         ZJENtq9X5YPOYuhsHTmzfG5pVLT8eTudP6Kj4=
MIME-Version: 1.0
In-Reply-To: <30257.1240252651@death.nxdomain.ibm.com>
References: <1ef444010904201050g72651387se3feca3fbd68ce30@mail.gmail.com>
	 <49ECBBF0.80202@cosmosbay.com>
	 <30257.1240252651@death.nxdomain.ibm.com>
Date: Mon, 20 Apr 2009 22:00:49 +0200
Message-ID: <1ef444010904201300r43268672sb74277f4a0242236@mail.gmail.com>
Subject: Re: bond interface arp, vlan and trunk / network question
From: stefan novak <lms.brubaker@gmail.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> nic1 --trunk--> bladesw1 --trunk--> backbone switch
>> nic2 --trunk--> bladesw2 --trunk--> backbone switch
>>
>> So far vlan and trunking works as expected. But if one trunk
>> connection from a bladeswitch to the backbone switch is down the
>> mii-tool cant recognize this.
>
> What is the exact problem on this one ?

The exact problem is that the bonding driver don't switch the
interface because the mii-tool don't recognize that the connection
between the two switches is now broken.

nic1 --trunk--> bladesw1 --trunk--> backbone switch (passive if)
nic2 --trunk--> bladesw2 --xxx--broken-trunk-xx-> backbone switch (active if)

>   Sufficiently recent versions of bonding should VLAN tag the ARP
>probes, provided you are using a VLAN device configured above the bond.
>My recollection is that VLAN tagging of ARP probes was added about three
>years ago.
>
>       If the switch port is configured as native to a VLAN, then it
>should tag everything coming in.
>
>      As Eric asks, what are you running?

I've got a bonding interface over eth0 and eth1 and on that bonding
interface several vlans. The arp probe is in vlan 600 and i can ping
it from the bash.
Also a arpping with -I bond0.600 is working. Arpping with -I bond0 is
not working.
So the arp check is not working for me :(

the nic driver is:
alias eth0 igb
alias eth1 igb

the bond setiings:
cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.2.4 (January 28, 2008)

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: None
Currently Active Slave: eth0
MII Status: up
MII Polling Interval (ms): 0
Up Delay (ms): 0
Down Delay (ms): 0
ARP Polling Interval (ms): 30
ARP IP target/s (n.n.n.n form): 172.21.0.254

Slave Interface: eth0
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:30:48:94:7d:1a

Slave Interface: eth1
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:30:48:94:7d:1b


On Mon, Apr 20, 2009 at 8:37 PM, Jay Vosburgh <fubar@us.ibm.com> wrote:
> Eric Dumazet <dada1@cosmosbay.com> wrote:
>
>>stefan novak a écrit :
>>> Hello list,
>>>
>>> I've got a Problem with my bladecenter and bond interfaces.
>>> My Server has 2 interface, each on a seperate switch. Each
>>> serverinterface is connected via a trunk to one of the switches.
>>> Each switch has a trunk to stacked-backbone switch.
>>>
>>> nic1 --trunk--> bladesw1 --trunk--> backbone switch
>>> nic2 --trunk--> bladesw2 --trunk--> backbone switch
>>>
>>> So far vlan and trunking works as expected. But if one trunk
>>> connection from a bladeswitch to the backbone switch is down the
>>> mii-tool cant recognize this.
>>
>>What is the exact problem on this one ?
>
>        This is the expected behavior, the external switch to
> bladecenter switch (ESM) link status does not affect the ESM to blade
> link status.
>
>        Unless... your ESM supports "trunk failover."  I believe the
> Cisco ESMs do, I'm not sure about others.  With trunk failover enabled,
> loss of link on an external switch port will in turn drop link on the
> corresponding internal switch ports.  There is a long-ish delay for
> this, on the order of 750 ms, as I recall.
>
>>> I tried to use an arp target on the backbone switch to check the
>>> connection state.
>>>
>>> Now i'm running into problems. :(
>>> My bladesw1 is configured with a trunk and a private vlan id of 600.
>>> On the backbone switch is a server in the vlan 600 connected, but i
>>> can't get an arp request.
>>>
>>> What can be the problem, or is it possible to add a vlan tag on the arp check?
>>>
>>
>>What driver is in use on your NIC interface ?
>>
>>Could you post your bonding settings ?
>>
>>cat /proc/net/bonding/bond0
>
>        Sufficiently recent versions of bonding should VLAN tag the ARP
> probes, provided you are using a VLAN device configured above the bond.
> My recollection is that VLAN tagging of ARP probes was added about three
> years ago.
>
>        If the switch port is configured as native to a VLAN, then it
> should tag everything coming in.
>
>        As Eric asks, what are you running?
>
>        -J
>
> ---
>        -Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
>
