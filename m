Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZHSKjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZHSKjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZHSKjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:39:41 -0400
Received: from mail.serverraum.org ([78.47.150.89]:52965 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbZHSKjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:39:41 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 06:39:41 EDT
Message-ID: <9e8b01b1556687e0b78ca63dfb5ca8dc.squirrel@ssl.serverraum.org>
Date: Wed, 19 Aug 2009 12:29:42 +0200 (CEST)
Subject: dropped packets with bonding and 8021q
From: "Michael Walle" <michael@walle.cc>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

i have some strange bonding and vlan configuration. The bonding interface
is in active-standby mode and i want to send and receive raw ethernet
frames on _both_ enslaved interfaces. Additionally the frames are tagged
with a vlan id. So one config could be:

# modprobe bonding mode=1
# modprobe 8021q
# ifenslave bond0 eth1
# ifenslave bond0 eth2
# vconfig add eth1 10
# vconfig add eth2 20
# vconfig add bond0 1000

# [activate bonding active slave etc..]

I use raw/dgram sockets (AF_PACKET) with eth1.10 and eth2.20 (or dump the
frames with tcpdump).

As long as i don't use the bonding module everything works as expected.
But if the physical interfaces are enslaved, frames received on the
standby device will be dropped.

The network driver is e1000. So the hardware acceleration for tagged VLAN
frames gets used and the frame gets through __vlan_hwaccel_rx() in the
receiving path. And there it seems to get dropped by
skb_bond_should_drop().

On the "normal" receive path there was a patch by Joe Eykholt that allows
to receive frames on the physical interface even if it is enslaved and not
active (git commit 0d7a3681232f545).

Shouldn't __vlan_hwaccel_rx() (in net/8021q/vlan_core.c) be patched in the
same way to allow reception on inactive enslaved interfaces?

Thanks,
  Michael

PS. could you please cc me, as i'm not subscribed to the ml.

