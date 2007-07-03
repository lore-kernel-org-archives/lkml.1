Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXGCFdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXGCFdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXGCFdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:33:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:35768 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbXGCFdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X3wqoKFfteNJlVZLvtCHVW/oZTg1A9vASUJhJNgaudAedOzpN339B0uqKXcjkgnG7DCXki08Q6CZZ1zdBH0VQtfePFk93/t02QSm9nTv1F1G5rCfTrkQYN41IrHBT4wtzWeqjgAkj8YQz8bynqiaxmjCTqzITidq57JyfOKs+3c=
Message-ID: <86802c440707022233g2021b49dg48534f813f628585@mail.gmail.com>
Date: Mon, 2 Jul 2007 22:33:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 3/4] usb: allocated usb releated dma buffer with kmalloc_node
Cc: linux-usb-devel@lists.sourceforge.net, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070703051129.GA18420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
	 <200707021536.37814.yinghai.lu@sun.com>
	 <20070703051129.GA18420@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Jul 02, 2007 at 03:36:37PM -0700, Yinghai Lu wrote:
> > [PATCH 3/4] usb: allocated usb releated dma buffer with kmalloc_node
> >
> > For amd64 based two way system. USB always on node0. but dma buffer for urb
> > allocated via kmalloc always get ram on node1. So change to kmalloc_node to
> > get dma_buffer on corresponding node
>
> Are all of these changes really necessary?  You are doing this for some
> allocations that take a _long_ time when sending to the device due to
> the speed of the device.
>
> I could possibly see this making a difference on some drivers, but for
> the core, and for the basic USB structures, I can't imagine it is really
> worth it.
>
> Or do you have numbers showing the differences here?
>
> Patch included fully below for the benifit of the usb list, which you
> should have cc:ed...

dma buffer could be allocated via alloc_pages_coherent. or
kmalloc/dma_map_single.
alloc_pages_coherent get the dma_buffer on corresponding node.
but kmalloc/dma_map_single always get dma_buffer on last node. or say
device is on HT chain node0,  it will get dma buffer on node 7 of 8
socket system.
also on two way system with 4G+4G RAM conf. device on node 0 will get
dma_buffer above 4G, and if the dma_mask is less 32bit, will need
extra iommu mapping.
In my mcp55+io55 system, it show dma_map_single is keepping called by
usb input: keyboard/mouse (8/0x40 bytes), and forcedeth. (0x670bytes)

YH
