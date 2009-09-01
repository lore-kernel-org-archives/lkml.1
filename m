Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZIAO6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZIAO6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZIAO6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:58:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:13531 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbZIAO6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:58:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,312,1249282800"; 
   d="scan'208";a="489438560"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "mst@redhat.com" <mst@redhat.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "gregory.haskins@gmail.com" <gregory.haskins@gmail.com>
Date: Tue, 1 Sep 2009 22:58:44 +0800
Subject: RE: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Thread-Topic: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Thread-Index: AcoqT0ccVCX0gBkkQU+2Dw5Bu9YM1gAxNQkw
Message-ID: <C85CEDA13AB1CF4D9D597824A86D2B9006AEC02EC0@PDSMSX501.ccr.corp.intel.com>
References: <E88DD564E9DC5446A76B2B47C3BCCA150219600F9B@pdsmsx503.ccr.corp.intel.com>
 <C85CEDA13AB1CF4D9D597824A86D2B9006AEB944B8@PDSMSX501.ccr.corp.intel.com>
 <200908311723.34067.arnd@arndb.de>
In-Reply-To: <200908311723.34067.arnd@arndb.de>
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

>I don't think we should do that with the tun/tap driver. By design, tun/tap is a way to interact >with the
>networking stack as if coming from a device. The only way this connects to an external >adapter is through
>a bridge or through IP routing, which means that it does not correspond to a specific NIC.
>I have worked on a driver I called 'macvtap' in lack of a better name, to add a new tap >frontend to
>the 'macvlan' driver. Since macvlan lets you add slaves to a single NIC device, this gives you >a direct
>connection between one or multiple tap devices to an external NIC, which works a lot better >than when
>you have a bridge inbetween. There is also work underway to add a bridging capability to >macvlan, so
>you can communicate directly between guests like you can do with a bridge.
>Michael's vhost_net can plug into the same macvlan infrastructure, so the work is >complementary.

We use TUN/TAP device to implement the prototype, and agree that it's not the only
choice here. We'd compare the two if possible.
And what we cares more about is the modification in the kernel like the net_dev and 
skb structures' modifications, thanks.

Thanks
Xiaohui

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de] 
Sent: Monday, August 31, 2009 11:24 PM
To: Xin, Xiaohui
Cc: mst@redhat.com; netdev@vger.kernel.org; virtualization@lists.linux-foundation.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; mingo@elte.hu; linux-mm@kvack.org; akpm@linux-foundation.org; hpa@zytor.com; gregory.haskins@gmail.com
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server

On Monday 31 August 2009, Xin, Xiaohui wrote:
> 
> Hi, Michael
> That's a great job. We are now working on support VMDq on KVM, and since the VMDq hardware presents L2 sorting
> based on MAC addresses and VLAN tags, our target is to implement a zero copy solution using VMDq.

I'm also interested in helping there, please include me in the discussions.

> We stared
> from the virtio-net architecture. What we want to proposal is to use AIO combined with direct I/O:
> 1) Modify virtio-net Backend service in Qemu to submit aio requests composed from virtqueue.

right, that sounds useful.

> 2) Modify TUN/TAP device to support aio operations and the user space buffer directly mapping into the host kernel.
> 3) Let a TUN/TAP device binds to single rx/tx queue from the NIC.

I don't think we should do that with the tun/tap driver. By design, tun/tap is a way to interact with the
networking stack as if coming from a device. The only way this connects to an external adapter is through
a bridge or through IP routing, which means that it does not correspond to a specific NIC.

I have worked on a driver I called 'macvtap' in lack of a better name, to add a new tap frontend to
the 'macvlan' driver. Since macvlan lets you add slaves to a single NIC device, this gives you a direct
connection between one or multiple tap devices to an external NIC, which works a lot better than when
you have a bridge inbetween. There is also work underway to add a bridging capability to macvlan, so
you can communicate directly between guests like you can do with a bridge.

Michael's vhost_net can plug into the same macvlan infrastructure, so the work is complementary.

> 4) Modify the net_dev and skb structure to permit allocated skb to use user space directly mapped payload
> buffer address rather then kernel allocated.

yes.

> As zero copy is also your goal, we are interested in what's in your mind, and would like to collaborate with you if possible.
> BTW, we will send our VMDq write-up very soon.

Ok, cool.

	Arnd <><
