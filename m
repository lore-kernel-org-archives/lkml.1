Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbZJWLLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbZJWLLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 07:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZJWLLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 07:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZJWLLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 07:11:40 -0400
Date: Fri, 23 Oct 2009 13:08:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       mtosatti@redhat.com, xma@us.ibm.com
Subject: Re: [PATCH] virtio-pci: fix per-vq MSI-X request logic
Message-ID: <20091023110838.GA20248@redhat.com>
References: <20091022130606.GA6923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022130606.GA6923@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 03:06:06PM +0200, Michael S. Tsirkin wrote:
> Commit f68d24082e22ccee3077d11aeb6dc5354f0ca7f1
> in 2.6.32-rc1 broke requesting IRQs for per-VQ MSI-X vectors:
> - vector number was used instead of the vector itself
> - we try to request an IRQ for VQ which does not
>   have a callback handler
> 
> This is a regression that causes warnings in kernel log,
> potentially lower performance as we need to scan vq list,
> and might cause system failure if the interrupt
> requested is in fact needed by another system.
> 
> This was not noticed earlier because in most cases
> we were falling back on shared interrupt for all vqs.
> 
> The warnings often look like this:
> 
> virtio-pci 0000:00:03.0: irq 26 for MSI/MSI-X
> virtio-pci 0000:00:03.0: irq 27 for MSI/MSI-X
> virtio-pci 0000:00:03.0: irq 28 for MSI/MSI-X
> IRQ handler type mismatch for IRQ 1
> current handler: i8042
> Pid: 2400, comm: modprobe Tainted: G        W
> 2.6.32-rc3-11952-gf3ed8d8-dirty #1
> Call Trace:
>  [<ffffffff81072aed>] ? __setup_irq+0x299/0x304
>  [<ffffffff81072ff3>] ? request_threaded_irq+0x144/0x1c1
>  [<ffffffff813455af>] ? vring_interrupt+0x0/0x30
>  [<ffffffff81346598>] ? vp_try_to_find_vqs+0x583/0x5c7
>  [<ffffffffa0015188>] ? skb_recv_done+0x0/0x34 [virtio_net]
>  [<ffffffff81346609>] ? vp_find_vqs+0x2d/0x83
>  [<ffffffff81345d00>] ? vp_get+0x3c/0x4e
>  [<ffffffffa0016373>] ? virtnet_probe+0x2f1/0x428 [virtio_net]
>  [<ffffffffa0015188>] ? skb_recv_done+0x0/0x34 [virtio_net]
>  [<ffffffffa00150d8>] ? skb_xmit_done+0x0/0x39 [virtio_net]
>  [<ffffffff8110ab92>] ? sysfs_do_create_link+0xcb/0x116
>  [<ffffffff81345cc2>] ? vp_get_status+0x14/0x16
>  [<ffffffff81345464>] ? virtio_dev_probe+0xa9/0xc8
>  [<ffffffff8122b11c>] ? driver_probe_device+0x8d/0x128
>  [<ffffffff8122b206>] ? __driver_attach+0x4f/0x6f
>  [<ffffffff8122b1b7>] ? __driver_attach+0x0/0x6f
>  [<ffffffff8122a9f9>] ? bus_for_each_dev+0x43/0x74
>  [<ffffffff8122a374>] ? bus_add_driver+0xea/0x22d
>  [<ffffffff8122b4a3>] ? driver_register+0xa7/0x111
>  [<ffffffffa001a000>] ? init+0x0/0xc [virtio_net]
>  [<ffffffff81009051>] ? do_one_initcall+0x50/0x148
>  [<ffffffff8106e117>] ? sys_init_module+0xc5/0x21a
>  [<ffffffff8100af02>] ? system_call_fastpath+0x16/0x1b
> virtio-pci 0000:00:03.0: irq 26 for MSI/MSI-X
> virtio-pci 0000:00:03.0: irq 27 for MSI/MSI-X
> 
> Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
> Reported-by: Shirley Ma <xma@us.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

You can now add
Tested-by: Shirley Ma <mashirle@us.ibm.com>
Tested-by: Marcelo Tosatti <mtosatti@redhat.com>
