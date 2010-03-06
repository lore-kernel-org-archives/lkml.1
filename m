Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0CFJiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 04:38:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:29072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab0CFJiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 04:38:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,593,1262592000"; 
   d="scan'208";a="498323372"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mst@redhat.com, jdike@c2.user-mode-linux.org
Subject: [PATCH v1 0/3] Provide a zero-copy method on KVM virtio-net.
Date: Sat,  6 Mar 2010 17:38:35 +0800
Message-Id: <1267868318-19268-1-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is simple, just to pin the guest VM user space and then
let host NIC driver has the chance to directly DMA to it. 
The patches are based on vhost-net backend driver. We add a device
which provides proto_ops as sendmsg/recvmsg to vhost-net to
send/recv directly to/from the NIC driver. KVM guest who use the
vhost-net backend may bind any ethX interface in the host side to
get copyless data transfer thru guest virtio-net frontend.

We provide multiple submits and asynchronous notifiicaton to 
vhost-net too.

Our goal is to improve the bandwidth and reduce the CPU usage.
Exact performance data will be provided later. But for simple
test with netperf, we found bindwidth up and CPU % up too,
but the bindwidth up ratio is much more than CPU % up ratio.

What we have not done yet:
	packet split support
	To support GRO
	Performance tuning

what we have done in v1:
	polish the RCU usage
	deal with write logging in asynchroush mode in vhost
	add notifier block for mp device
	rename page_ctor to mp_port in netdevice.h to make it looks generic
	add mp_dev_change_flags() for mp device to change NIC state
	add CONIFG_VHOST_MPASSTHRU to limit the usage when module is not load
	a small fix for missing dev_put when fail
	using dynamic minor instead of static minor number
	a __KERNEL__ protect to mp_get_sock()

performance:
	using netperf with GSO/TSO disabled, 10G NIC, 
	disabled packet split mode, with raw socket case compared to vhost.

	bindwidth will be from 1.1Gbps to 1.7Gbps
	CPU % from 120%-140% to 140%-160%
