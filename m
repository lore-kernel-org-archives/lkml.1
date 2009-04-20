Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbZDTVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbZDTVXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbZDTVXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:23:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37281 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036AbZDTVW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:22:58 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: stefan novak <lms.brubaker@gmail.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: bond interface arp, vlan and trunk / network question
In-reply-to: <1ef444010904201403s5d583750i1ce3a5da6c6f4059@mail.gmail.com>
References: <1ef444010904201050g72651387se3feca3fbd68ce30@mail.gmail.com> <49ECBBF0.80202@cosmosbay.com> <30257.1240252651@death.nxdomain.ibm.com> <1ef444010904201300r43268672sb74277f4a0242236@mail.gmail.com> <7609.1240259780@death.nxdomain.ibm.com> <1ef444010904201403s5d583750i1ce3a5da6c6f4059@mail.gmail.com>
Comments: In-reply-to stefan novak <lms.brubaker@gmail.com>
   message dated "Mon, 20 Apr 2009 23:03:07 +0200."
X-Mailer: MH-E 8.0.3; nmh 1.3-RC3; GNU Emacs 22.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Apr 2009 14:23:01 -0700
Message-ID: <13606.1240262581@death.nxdomain.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefan novak <lms.brubaker@gmail.com> wrote:

>>
>>        I believe you're seeing the expected behavior from arping here,
>> and it does not automatically indicate that anything is wrong.
>>
>>        It's very possible that your network topology is such that
>> arping -I bond0 won't work while arping -I bond0.600 does.  If the
>> target you specify is reachable only on the VLAN, it's expected behavior
>> that arping -I bond0 of that target won't work (because the interface
>> bond0 is not attached to the VLAN, only bond0.600 is).  That doesn't
>> mean that the ARPs generated internally by bonding are untagged /
>> failing, as bonding itself adds VLAN tags to its own ARP probes as
>> needed.
>
>Ok. I've checked the tcpdump's on the machines and I think something is working.
>
>tcpdump  -v -i eth0 arp
>tcpdump: WARNING: eth0: no IPv4 address assigned
>tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
>22:56:38.817599 arp who-has 172.21.0.254 tell 172.21.0.1
>22:56:38.847597 arp who-has 172.21.0.254 tell 172.21.0.1
>22:56:38.877598 arp who-has 172.21.0.254 tell 172.21.0.1
>22:56:38.907596 arp who-has 172.21.0.254 tell 172.21.0.1
>
>tcpdump  -v -i bond0.600 arp
>tcpdump: listening on bond0.600, link-type EN10MB (Ethernet), capture
>size 96 bytes
>22:56:49.167157 arp reply 172.21.0.254 is-at 00:1d:70:d1:ad:83 (oui Unknown)
>22:56:49.197162 arp reply 172.21.0.254 is-at 00:1d:70:d1:ad:83 (oui Unknown)
>22:56:49.227130 arp reply 172.21.0.254 is-at 00:1d:70:d1:ad:83 (oui Unknown)
>22:56:49.257144 arp reply 172.21.0.254 is-at 00:1d:70:d1:ad:83 (oui Unknown)
>
>the arp's are sent out on eth0 and recieved via bond0.600. When they
>are sent on eth0 then the switch must tag the vlan600 (private vlan).
>Then they come in at the right interface. Is it normal that so many
>arp's are sent?

	You set arp_interval to 30, so you get one probe every 30
milliseconds, 33 per second.

	As far as seeing the ARPs on eth0 and bond0.600, I believe
that's normal, as the interfaces are logically stacked, so you can see
the traffic in both places.  If the device supports VLAN acceleration
(and maybe even if it doesn't; I'd have to look), I don't think you'll
see the tag in the tcpdumped traffic, as the tagging is done by the
hardware, not in software.

	It's also normal on bonding to see transmits on the slave and
received traffic on the bond device; that has to do with how the
transmit and receive paths differ.

>Is there a way to check if the arp check is working right in the proc
>fs oder something like that?

	There's no "self test" or anything like that, if that's what you
mean.  If the ARPs work (make the round trip) the link is up, if they
don't, the link is down.  That's subject to some details related to
arp_validate, but is basically it.

>>        Also, are you running multiple blades with bonding behind the
>> same set of switches?
>
>Yes, 14 blades with 2 seperate(not connected) switches.
>
>>  If you are, you probably want to set the
>> arp_validate option to either "active" or "all", as the default setting
>> (none) relies only on the existance of traffic on the slaves, and
>> doesn't check the source of that traffic.  The end result of that is the
>> probes from multiple bonding instances fool one another into thinking
>> the path is up, when it is not.  With arp_validate enabled, it'll check
>> that the slaves are actually receiving their own ARP traffic.
>
>Ok, sounds right for me. I've set the arp_validate option to "all".

	That may make the phantom "up" link go away.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
