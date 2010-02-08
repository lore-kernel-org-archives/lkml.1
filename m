Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0BHOtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:49:05 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:49513 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab0BHOtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:49:03 -0500
Subject: Re: KVM in -next is somewhat busted
From: Adam Litke <agl@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       KVM list <kvm@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4B70229D.4080603@redhat.com>
References: <20100208142752.2e859b7d@lxorguk.ukuu.org.uk>
	 <4B70229D.4080603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 08 Feb 2010 08:48:52 -0600
Message-ID: <1265640532.3457.17.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably fixed by this patch from Rusty... Strangely, I have not
seen this on my test systems.

When running under qemu-kvm-0.11.0:

	BUG: unable to handle kernel paging request at 56e58955
	...
	Process vballoon (pid: 1297, ti=c7976000 task=c70a6ca0 task.ti=c7
	...
	Call Trace:
	 [<c88253a3>] ? balloon+0x1b3/0x440 [virtio_balloon]
	 [<c041c2d7>] ? schedule+0x327/0x9d0
	 [<c88251f0>] ? balloon+0x0/0x440 [virtio_balloon]
	 [<c014a2d4>] ? kthread+0x74/0x80
	 [<c014a260>] ? kthread+0x0/0x80
	 [<c0103b36>] ? kernel_thread_helper+0x6/0x30

need_stats_update should be zero-initialized.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Adam Litke <agl@us.ibm.com>

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -292,6 +292,7 @@ static int virtballoon_probe(struct virt
 	vb->num_pages = 0;
 	init_waitqueue_head(&vb->config_change);
 	vb->vdev = vdev;
+	vb->need_stats_update = 0;

 	/* We expect two virtqueues: inflate and deflate,
 	 * and optionally stat. */


On Mon, 2010-02-08 at 16:41 +0200, Avi Kivity wrote:
> (fixed kvm@ address)
> 
> 
> On 02/08/2010 04:27 PM, Alan Cox wrote:
> > Reliably at boot time with todays -next I get the following:
> >
> > BUG: unable to handle kernel paging request at 0000000000001028
> > IP: [<ffffffffa001c4c4>] balloon+0x1a1/0x309 [virtio_balloon]
> > PGD 2cd42067 PUD 3b9dc067 PMD 0
> > Oops: 0000 [#1] SMP
> > last sysfs file: /sys/devices/virtio-pci/virtio4/block/vdd/removable
> > CPU 3
> > Pid: 511, comm: vballoon Not tainted 2.6.33-rc7-next-20100208+ #51 /
> > RIP: 0010:[<ffffffffa001c4c4>]  [<ffffffffa001c4c4>] balloon+0x1a1/0x309 [virtio_balloon]
> >    
> 
> Looks like the guest is broken, not the host.  Do things work if you 
> leave out CONFIG_VIRTIO_BALLOON?
> 
> Copying Adam Litke, who's name is on the latest balloon changes.
> 


-- 
Thanks,
Adam

