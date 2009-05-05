Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZEENjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZEENjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZEENj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:39:27 -0400
Received: from mail-qy0-f133.google.com ([209.85.221.133]:51081 "EHLO
	mail-qy0-f133.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZEENj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Y5BatU6wpL/z+3sVdPXx7+RleSPIyF71KuY38N56nZ+qxjI0/4896Z2VV3oKYYnG46
         ld6S3dOSW/ru8xsBUGrcqoT8sNHUfO5WE7EDuU3/JiXF9ChM5DPuLRELk8cc0X+wAaV7
         S6bykyVRqp0NSKdIuA9xeSvCMhCGEXNXDVjEE=
MIME-Version: 1.0
Date: Tue, 5 May 2009 19:02:00 +0530
Message-ID: <9a2da8520905050632sa9a4935md668387339c748a0@mail.gmail.com>
Subject: duplicate arp request problem with bonding driver
From: Deepjyoti Kakati <dkakati73@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am having the following issue with a fedora10 (2.6.27) type installation.

setup: my bonding and vlan topology
----------------------------------------------------

qemu(eth0)-----tap0-----bridge0----bond3.vlan----bond3-----bond2---{eth3,
eth4 in balance-rr mode}
                                                                   |

+-----------bond1--{eth1, eth2 in balance-rr mode}

bond3 enslaves the bond2 & bond1 in primary-backup bonding mode. I am
using miimon
on all of bond1,2,3 interfaces

eth1,eth2 connect to switch1 via a etherchannel
eth3, eth4 connect to switch2 via a etherchannel
all these four ports allow the same vlans.

now I desired to put my qemu virtual machine eth0 into a particular vlan so
created the bond3.vlan and hooked it into the bridge.

problem:
------------
from the qemu I ping a IP address of a router beyond the two switches.

the ARP request goes out of bond1 which is the active_slave

due to same vlans, the ARP request  floods back into my box via the {eth3,eth4}
from the other switch.

my version of kernel is supposed to have the bonding driver fix which
discards broadcasts/multicasts except a few cases for the inactive slave of a
primary-backup pair.(the skb_bond work)

but a tcpdump on the bridge0 or bond3.vlan indicates this 2nd arp
request pkt is also being seen - apparently bond3 isnt dropping them.

consequences
---------------------
as the qemu sends out its arp requests to resolve my ping, the bridge0
sees these with src_mac=(qemu eth0 macaddr) and thinks it is somewhere
in the bond3.vlan side. "brctl showmacs bridge0" clearly shows my
qemu MAC addr as now mapped to that port, instead of the tap0 port.

so when arp response comes back from my ping target the bridge0
does not forward it on the tap0 port - all my pings timeout and fail.

when the arp's stop, that entry is aged out and it again points back to tap0
port but meantime all my pings have failed.

when I shut down the (eth3,eth4) portchannel things work fine because this
misleading flooded arp request is not seen.

any clue why this might be happening? I am using the "sysfs" method of
configuring bonds per the bonding driver Howto document and my
bonding_masters file has bond1 bond2 bond3.

when I tried primary-backup with the slaves as pure eth interfaces it
seemed to work fine in a similar condition.

is there anything special if bond interfaces are enslaved below other
bond interfaces?

thanks
Deepjyoti Kakati
