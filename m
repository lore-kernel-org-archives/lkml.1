Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbXLYH47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbXLYH47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 02:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXLYH4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 02:56:50 -0500
Received: from zyfb01-66.zyxel.com.tw ([59.124.183.66]:43817 "EHLO
	zyfb01-66.zyxel.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXLYH4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 02:56:50 -0500
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2007 02:56:49 EST
Message-ID: <001201c846c9$6d03de40$431a17ac@ZyXEL.com>
From: "lewis_zyxel" <lachang.li@zyxel.com.tw>
To: <linux-kernel@vger.kernel.org>
Subject: 2 ports could not bond to a aggregator in 802.3ad mode issue
Date: Tue, 25 Dec 2007 15:40:30 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-OriginalArrivalTime: 25 Dec 2007 07:40:31.0152 (UTC) FILETIME=[6D05B300:01C846C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wish to be personally CC'ed the answers/comments posted to the list in 
response to my posting.

I have 2 ports(eth0, eth1) in my device. I use kernel(2.6.23) bonding driver 
v3.1.3 (June 13, 2007) to bond 2 ports to one aggregator and use the 
following commands to setup the environment:
insmod ./bonding.ko mode=4 miimon=100
ifconfig bond0 172.23.26.223 netmask 255.255.255.0
ifconfig eth0 down
ifconfig eth1 down
ifenslave bond0 eth0 eth1

After the setting, I cat the proc entry and got the following information

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer2 (0)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

802.3ad info
LACP rate: slow
Active Aggregator Info:
        Aggregator ID: 1
        Number of ports: 1
        Actor Key: 17
        Partner Key: 1
        Partner Mac Address: 00:00:00:00:00:00

Slave Interface: eth0
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:e0:0c:48:00:04
Aggregator ID: 1

Slave Interface: eth1
MII Status: up
Link Failure Count: 0
Permanent HW addr: 6f:74:66:73:74:79
Aggregator ID: 2

It shows that 2 ports could not bond to a aggregator. After I trace the the 
bonding driver code, I modify the ad_port_selection_logic() in bond_3ad.c as 
following:

- ((MAC_ADDRESS_COMPARE(&(port->partner_oper_system), &(null_mac_addr)) && 
// partner answers
+ (!(MAC_ADDRESS_COMPARE(&(port->partner_oper_system), &(null_mac_addr)) && 
// partner answers
            !aggregator->is_individual)  // but is not individual OR
            )

After the modification, I cat the proc entry again and the result is as 
following:
/home/shares # cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.1.3 (June 13, 2007)

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer2 (0)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

802.3ad info
LACP rate: slow
Active Aggregator Info:
        Aggregator ID: 1
        Number of ports: 2
        Actor Key: 17
        Partner Key: 1
        Partner Mac Address: 00:00:00:00:00:00

Slave Interface: eth0
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:e0:0c:48:00:04
Aggregator ID: 1

Slave Interface: eth1
MII Status: up
Link Failure Count: 0
Permanent HW addr: 6f:74:66:73:74:79
Aggregator ID: 1

The behavior changes from 'one aggregator with one port'  to 'one aggregator 
with 2 ports', the latter seems more accurate. Is there a bug in bonding 
driver code v3.1.3 (June 13, 2007)?
Best regards,
Lewis Li

