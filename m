Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0CIHsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:48:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:28336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0CIHs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:48:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,607,1262592000"; 
   d="scan'208";a="779166206"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jdike@c2.user-mode-linux.org" <jdike@c2.user-mode-linux.org>
Date: Tue, 9 Mar 2010 15:47:46 +0800
Subject: RE: [PATCH v1 0/3] Provide a zero-copy method on KVM virtio-net.
Thread-Topic: [PATCH v1 0/3] Provide a zero-copy method on KVM virtio-net.
Thread-Index: Acq95QQP7uunPFKaR1CgOk7KiGdjPgBc2YOA
Message-ID: <97F6D3BD476C464182C1B7BABF0B0AF5C15FE38E@shzsmsx502.ccr.corp.intel.com>
References: <1267868318-19268-1-git-send-email-xiaohui.xin@intel.com>
 <20100307105031.GA20004@redhat.com>
In-Reply-To: <20100307105031.GA20004@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Sat, Mar 06, 2010 at 05:38:35PM +0800, xiaohui.xin@intel.com wrote:
>> The idea is simple, just to pin the guest VM user space and then
> >let host NIC driver has the chance to directly DMA to it. 
> >The patches are based on vhost-net backend driver. We add a device
> >which provides proto_ops as sendmsg/recvmsg to vhost-net to
> >send/recv directly to/from the NIC driver. KVM guest who use the
> >vhost-net backend may bind any ethX interface in the host side to
> >get copyless data transfer thru guest virtio-net frontend.
> >
> >We provide multiple submits and asynchronous notifiicaton to 
> >vhost-net too.
> > 
> >Our goal is to improve the bandwidth and reduce the CPU usage.
> >Exact performance data will be provided later. But for simple
> >test with netperf, we found bindwidth up and CPU % up too,
> >but the bindwidth up ratio is much more than CPU % up ratio.
> >
> >What we have not done yet:
> >	packet split support
> >	To support GRO
> >	Performance tuning
> >
>Am I right to say that nic driver needs changes for these patches
>to work? If so, please publish nic driver patches as well.

For drivers not support packet split mode, the NIC drivers don't need to change.
For packet split support drivers, we plan to add the drivers API in updated versions.
Now for PS support drivers, just disable the PS mode, it also works.

> > what we have done in v1:
> > 	polish the RCU usage
> >	deal with write logging in asynchroush mode in vhost
> >	add notifier block for mp device
> >	rename page_ctor to mp_port in netdevice.h to make it looks generic
> >	add mp_dev_change_flags() for mp device to change NIC state
> >	add CONIFG_VHOST_MPASSTHRU to limit the usage when module is not load
> >	a small fix for missing dev_put when fail
> >	using dynamic minor instead of static minor number
> >	a __KERNEL__ protect to mp_get_sock()
> >
> >performance:
> >	using netperf with GSO/TSO disabled, 10G NIC, 
> >	disabled packet split mode, with raw socket case compared to vhost.
> >
> >	bindwidth will be from 1.1Gbps to 1.7Gbps
> >	CPU % from 120%-140% to 140%-160%

> That's pretty low for a 10Gb nic. Are you hitting some other bottleneck,
> like high interrupt rate? Also, GSO support and performance tuning
> for raw are incomplete. Try comparing with e.g. tap with GSO.

I'm curious too. 
I have tested vhost-net without zero-copy patch at first in RAW socket case with ixgbe driver, with that driver GRO feature is enabled default, but netperf data is extremely low, after disabled GRO, then I can get more than 1Gbps. So I thought I have missed something there, but I had send 2 emails to you about this before and got no reply from you.
Have you got some perf data in raw socket case with vhost-net? 
The data I have got from your web page is always tap with GSO case.

If GSO is not supported, I think the data cannot compare with tap with GSO case in 1500 MTU. 
Maybe mergable buffers may help the performance in raw socket case?

Thanks Xiaohui
