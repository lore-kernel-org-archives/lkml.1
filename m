Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbXKXXp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbXKXXp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 18:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXKXXpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 18:45:20 -0500
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:58081 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbXKXXpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 18:45:19 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: 2.6.24-rc3, 4GB RAM, swiotlb, r8169, out of space
Date: Sat, 24 Nov 2007 23:44:49 +0000
User-Agent: KMail/1.9.7
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2712
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200711242344.49958.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have recently assembled a Core 2 Duo system with 4GB RAM and I believe there 
might be a bug in the r8169 driver in >4GB RAM configurations.

Initially I can use one of two active r8169 NICs on the motherboard with this 
quantity of RAM with other devices, without issue. But after some amount of 
data (generally about 50MB), no more network packets are sent/received.

The "choke" affects other devices on the system too, notably libata, which 
does not recover gracefully. In my logs, I see a stream of:

DMA: Out of SW-IOMMU space for 7222 bytes at device 0000:04:00.0
DMA: Out of SW-IOMMU space for 7222 bytes at device 0000:04:00.0

The device 0000:04:00.0 corresponds to one of the r8169s.

The reason I believe r8169 is at fault is that I was doing a rebuild of my 
RAID5 across 3 SATA drives via libata's ahci driver, and transferring over the 
network. When the "choke" occurred the RAID sync stopped, libata errors were 
seen, and I simply did a "ifconfig br0 down" (which contained the r8169) and 
the messages went away. Bringing the NIC up again would see some initial 
functionality then very rapidly it would go back to the same error messages.

The Intel chipset I am using does not support any kind of hardware IOMMU, so I 
am forced to use swiotlb in a 4GB RAM configuration. In an attempt to delay 
the failures, I used the swiotlb option to increase the swiotlb's page 
allocation with "swiotlb=65536" (which seems to correspond to a 256MB bounce 
buffer).

Assuming both libata and r8169 use the swiotlb, and both systems are impaired 
when these messages appear, removing r8169 would appear to be key. Indeed, if 
there is no significant libata activity, the problem still occurs on the NIC 
within approximately the same amount of transfer.

This option delays the failure for some time but it will happen eventually, 
which makes me suspicious that maybe the driver is somehow pinning an area of 
the buffer and not releasing it. (I hunted bugzilla for reports similar to 
this one, but couldn't find anything.)

Having tested the r8169 driver on an AMD system I did not experience the same 
problems with 4GB RAM, so this could be a bug specific to swiotlb. I would 
have added more people to CC but I have no idea who might be responsible.

Andrew, I've added you just in case you're aware of other similar reports 
(maybe r8169 on big iron) and have anybody from the sw-iommu camp that could 
be added to CC.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
