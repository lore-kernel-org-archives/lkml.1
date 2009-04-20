Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZDTVDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZDTVDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZDTVDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:03:11 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48410 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbZDTVDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sSHvmaeKXEVeM8nFxWIsHK4pvVKrIpj5bthp6htDlJZGtkpWtufoCZAmFp4NX5Gunb
         E163rD7BvEF+NZPxrY0XDyu4xJP6xtUqOyKRNlxjq88QmwNSQM31R2/iI0H9Fz7wnT/L
         gIXL/Sjp71nW+rHHyPBE9OVlxq+NrjdqF2MVY=
MIME-Version: 1.0
In-Reply-To: <7609.1240259780@death.nxdomain.ibm.com>
References: <1ef444010904201050g72651387se3feca3fbd68ce30@mail.gmail.com>
	 <49ECBBF0.80202@cosmosbay.com>
	 <30257.1240252651@death.nxdomain.ibm.com>
	 <1ef444010904201300r43268672sb74277f4a0242236@mail.gmail.com>
	 <7609.1240259780@death.nxdomain.ibm.com>
Date: Mon, 20 Apr 2009 23:03:07 +0200
Message-ID: <1ef444010904201403s5d583750i1ce3a5da6c6f4059@mail.gmail.com>
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

>
>        I believe you're seeing the expected behavior from arping here,
> and it does not automatically indicate that anything is wrong.
>
>        It's very possible that your network topology is such that
> arping -I bond0 won't work while arping -I bond0.600 does.  If the
> target you specify is reachable only on the VLAN, it's expected behavior
> that arping -I bond0 of that target won't work (because the interface
> bond0 is not attached to the VLAN, only bond0.600 is).  That doesn't
> mean that the ARPs generated internally by bonding are untagged /
> failing, as bonding itself adds VLAN tags to its own ARP probes as
> needed.

Ok. I've checked the tcpdump's on the machines and I think something is working.

tcpdump  -v -i eth0 arp
tcpdump: WARNING: eth0: no IPv4 address assigned
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
22:56:38.817599 arp who-has 172.21.0.254 tell 172.21.0.1
22:56:38.847597 arp who-has 172.21.0.254 tell 172.21.0.1
22:56:38.877598 arp who-has 172.21.0.254 tell 172.21.0.1
22:56:38.907596 arp who-has 172.21.0.254 tell 172.21.0.1

tcpdump  -v -i bond0.600 arp
tcpdump: listening on bond0.600, link-type EN10MB (Ethernet), capture
size 96 bytes
22:56:49.167157 arp reply 172.21.0.254 is-at 00:1d:70:d1:ad:83 (oui Unknown)
22:56:49.197162 arp reply 172.21.0.254 is-at 00:1d:70:d1:ad:83 (oui Unknown)
22:56:49.227130 arp reply 172.21.0.254 is-at 00:1d:70:d1:ad:83 (oui Unknown)
22:56:49.257144 arp reply 172.21.0.254 is-at 00:1d:70:d1:ad:83 (oui Unknown)

the arp's are sent out on eth0 and recieved via bond0.600. When they
are sent on eth0 then the switch must tag the vlan600 (private vlan).
Then they come in at the right interface. Is it normal that so many
arp's are sent?
Is there a way to check if the arp check is working right in the proc
fs oder something like that?

>        Also, are you running multiple blades with bonding behind the
> same set of switches?

Yes, 14 blades with 2 seperate(not connected) switches.

>  If you are, you probably want to set the
> arp_validate option to either "active" or "all", as the default setting
> (none) relies only on the existance of traffic on the slaves, and
> doesn't check the source of that traffic.  The end result of that is the
> probes from multiple bonding instances fool one another into thinking
> the path is up, when it is not.  With arp_validate enabled, it'll check
> that the slaves are actually receiving their own ARP traffic.

Ok, sounds right for me. I've set the arp_validate option to "all".
