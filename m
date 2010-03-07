Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab0CGK5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 05:57:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0CGK5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 05:57:42 -0500
Date: Sun, 7 Mar 2010 12:50:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jdike@c2.user-mode-linux.org
Subject: Re: [PATCH v1 0/3] Provide a zero-copy method on KVM virtio-net.
Message-ID: <20100307105031.GA20004@redhat.com>
References: <1267868318-19268-1-git-send-email-xiaohui.xin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267868318-19268-1-git-send-email-xiaohui.xin@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 05:38:35PM +0800, xiaohui.xin@intel.com wrote:
> The idea is simple, just to pin the guest VM user space and then
> let host NIC driver has the chance to directly DMA to it. 
> The patches are based on vhost-net backend driver. We add a device
> which provides proto_ops as sendmsg/recvmsg to vhost-net to
> send/recv directly to/from the NIC driver. KVM guest who use the
> vhost-net backend may bind any ethX interface in the host side to
> get copyless data transfer thru guest virtio-net frontend.
> 
> We provide multiple submits and asynchronous notifiicaton to 
> vhost-net too.
> 
> Our goal is to improve the bandwidth and reduce the CPU usage.
> Exact performance data will be provided later. But for simple
> test with netperf, we found bindwidth up and CPU % up too,
> but the bindwidth up ratio is much more than CPU % up ratio.
> 
> What we have not done yet:
> 	packet split support
> 	To support GRO
> 	Performance tuning

Am I right to say that nic driver needs changes for these patches
to work? If so, please publish nic driver patches as well.

> what we have done in v1:
> 	polish the RCU usage
> 	deal with write logging in asynchroush mode in vhost
> 	add notifier block for mp device
> 	rename page_ctor to mp_port in netdevice.h to make it looks generic
> 	add mp_dev_change_flags() for mp device to change NIC state
> 	add CONIFG_VHOST_MPASSTHRU to limit the usage when module is not load
> 	a small fix for missing dev_put when fail
> 	using dynamic minor instead of static minor number
> 	a __KERNEL__ protect to mp_get_sock()
> 
> performance:
> 	using netperf with GSO/TSO disabled, 10G NIC, 
> 	disabled packet split mode, with raw socket case compared to vhost.
> 
> 	bindwidth will be from 1.1Gbps to 1.7Gbps
> 	CPU % from 120%-140% to 140%-160%

That's pretty low for a 10Gb nic. Are you hitting some other bottleneck,
like high interrupt rate? Also, GSO support and performance tuning
for raw are incomplete. Try comparing with e.g. tap with GSO.

-- 
MST
