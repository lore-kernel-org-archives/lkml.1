Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbZDTUgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbZDTUgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbZDTUgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:36:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52254 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134AbZDTUgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:36:18 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: stefan novak <lms.brubaker@gmail.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: bond interface arp, vlan and trunk / network question
In-reply-to: <1ef444010904201300r43268672sb74277f4a0242236@mail.gmail.com>
References: <1ef444010904201050g72651387se3feca3fbd68ce30@mail.gmail.com> <49ECBBF0.80202@cosmosbay.com> <30257.1240252651@death.nxdomain.ibm.com> <1ef444010904201300r43268672sb74277f4a0242236@mail.gmail.com>
Comments: In-reply-to stefan novak <lms.brubaker@gmail.com>
   message dated "Mon, 20 Apr 2009 22:00:49 +0200."
X-Mailer: MH-E 8.0.3; nmh 1.3-RC3; GNU Emacs 22.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Apr 2009 13:36:20 -0700
Message-ID: <7609.1240259780@death.nxdomain.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefan novak <lms.brubaker@gmail.com> wrote:

>>> nic1 --trunk--> bladesw1 --trunk--> backbone switch
>>> nic2 --trunk--> bladesw2 --trunk--> backbone switch
>>>
>>> So far vlan and trunking works as expected. But if one trunk
>>> connection from a bladeswitch to the backbone switch is down the
>>> mii-tool cant recognize this.
>>
>> What is the exact problem on this one ?
>
>The exact problem is that the bonding driver don't switch the
>interface because the mii-tool don't recognize that the connection
>between the two switches is now broken.

	No, from your configuration information, you're running the ARP
monitor, in which case the actual link state ("mii-tool", although that
isn't really how it works) is not used in the failover decision.

	For the ARP monitor, the decision is based on whether or not
"replies" to the ARP probes come through.  More on that in a bit.

>nic1 --trunk--> bladesw1 --trunk--> backbone switch (passive if)
>nic2 --trunk--> bladesw2 --xxx--broken-trunk-xx-> backbone switch (active if)
>
>>   Sufficiently recent versions of bonding should VLAN tag the ARP
>>probes, provided you are using a VLAN device configured above the bond.
>>My recollection is that VLAN tagging of ARP probes was added about three
>>years ago.
>>
>>       If the switch port is configured as native to a VLAN, then it
>>should tag everything coming in.
>>
>>      As Eric asks, what are you running?
>
>I've got a bonding interface over eth0 and eth1 and on that bonding
>interface several vlans. The arp probe is in vlan 600 and i can ping
>it from the bash.
>Also a arpping with -I bond0.600 is working. Arpping with -I bond0 is
>not working.
>So the arp check is not working for me :(

	I believe you're seeing the expected behavior from arping here,
and it does not automatically indicate that anything is wrong.

	It's very possible that your network topology is such that
arping -I bond0 won't work while arping -I bond0.600 does.  If the
target you specify is reachable only on the VLAN, it's expected behavior
that arping -I bond0 of that target won't work (because the interface
bond0 is not attached to the VLAN, only bond0.600 is).  That doesn't
mean that the ARPs generated internally by bonding are untagged /
failing, as bonding itself adds VLAN tags to its own ARP probes as
needed.

	On the other hand, if you specify different targets to the
arping -I bond0 and arping -I bond0.600 (so that the "bond0" target
isn't a VLAN destination), then something unusual may be occuring.

	Also, are you running multiple blades with bonding behind the
same set of switches?  If you are, you probably want to set the
arp_validate option to either "active" or "all", as the default setting
(none) relies only on the existance of traffic on the slaves, and
doesn't check the source of that traffic.  The end result of that is the
probes from multiple bonding instances fool one another into thinking
the path is up, when it is not.  With arp_validate enabled, it'll check
that the slaves are actually receiving their own ARP traffic.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com



>the nic driver is:
>alias eth0 igb
>alias eth1 igb
>
>the bond setiings:
>cat /proc/net/bonding/bond0
>Ethernet Channel Bonding Driver: v3.2.4 (January 28, 2008)
>
>Bonding Mode: fault-tolerance (active-backup)
>Primary Slave: None
>Currently Active Slave: eth0
>MII Status: up
>MII Polling Interval (ms): 0
>Up Delay (ms): 0
>Down Delay (ms): 0
>ARP Polling Interval (ms): 30
>ARP IP target/s (n.n.n.n form): 172.21.0.254
>
>Slave Interface: eth0
>MII Status: up
>Link Failure Count: 0
>Permanent HW addr: 00:30:48:94:7d:1a
>
>Slave Interface: eth1
>MII Status: up
>Link Failure Count: 0
>Permanent HW addr: 00:30:48:94:7d:1b
>
>
>On Mon, Apr 20, 2009 at 8:37 PM, Jay Vosburgh <fubar@us.ibm.com> wrote:
>> Eric Dumazet <dada1@cosmosbay.com> wrote:
>>
>>>stefan novak a écrit :
>>>> Hello list,
>>>>
>>>> I've got a Problem with my bladecenter and bond interfaces.
>>>> My Server has 2 interface, each on a seperate switch. Each
>>>> serverinterface is connected via a trunk to one of the switches.
>>>> Each switch has a trunk to stacked-backbone switch.
>>>>
>>>> nic1 --trunk--> bladesw1 --trunk--> backbone switch
>>>> nic2 --trunk--> bladesw2 --trunk--> backbone switch
>>>>
>>>> So far vlan and trunking works as expected. But if one trunk
>>>> connection from a bladeswitch to the backbone switch is down the
>>>> mii-tool cant recognize this.
>>>
>>>What is the exact problem on this one ?
>>
>>        This is the expected behavior, the external switch to
>> bladecenter switch (ESM) link status does not affect the ESM to blade
>> link status.
>>
>>        Unless... your ESM supports "trunk failover."  I believe the
>> Cisco ESMs do, I'm not sure about others.  With trunk failover enabled,
>> loss of link on an external switch port will in turn drop link on the
>> corresponding internal switch ports.  There is a long-ish delay for
>> this, on the order of 750 ms, as I recall.
>>
>>>> I tried to use an arp target on the backbone switch to check the
>>>> connection state.
>>>>
>>>> Now i'm running into problems. :(
>>>> My bladesw1 is configured with a trunk and a private vlan id of 600.
>>>> On the backbone switch is a server in the vlan 600 connected, but i
>>>> can't get an arp request.
>>>>
>>>> What can be the problem, or is it possible to add a vlan tag on the arp check?
>>>>
>>>
>>>What driver is in use on your NIC interface ?
>>>
>>>Could you post your bonding settings ?
>>>
>>>cat /proc/net/bonding/bond0
>>
>>        Sufficiently recent versions of bonding should VLAN tag the ARP
>> probes, provided you are using a VLAN device configured above the bond.
>> My recollection is that VLAN tagging of ARP probes was added about three
>> years ago.
>>
>>        If the switch port is configured as native to a VLAN, then it
>> should tag everything coming in.
>>
>>        As Eric asks, what are you running?
>>
>>        -J
>>
>> ---
>>        -Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
>>
>--
>To unsubscribe from this list: send the line "unsubscribe netdev" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
