Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbXKILyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbXKILyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 06:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXKILy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 06:54:27 -0500
Received: from ozlabs.org ([203.10.76.45]:32905 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbXKILy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 06:54:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] virtio config_ops refactoring
Date: Fri, 9 Nov 2007 22:54:07 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Anthony Liguori <aliguori@us.ibm.com>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org
References: <4730A8F3.6020008@us.ibm.com> <200711090924.28659.rusty@rustcorp.com.au> <47338EA0.6050100@codemonkey.ws>
In-Reply-To: <47338EA0.6050100@codemonkey.ws>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711092254.08099.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 November 2007 09:33:04 Anthony Liguori wrote:
> I really want to make sure that if a guest tries
> to read a 4-byte PCI config field, that it does so using an "outl"
> instruction so that in my QEMU backend

So you want to enforce PCI requirements onto virtio config accesses.  This 
doesn't seem very nice: the fact that PCI accesses use different namespaces 
for different sizes makes sense from a primitive hardware point of view, but 
sucks for software.  Fortunately, if you insist on byte-at-a-time they're the 
same.

> switch (addr) {
> case VIRTIO_BLK_CONFIG_MAX_SEG:
>    return vdev->max_seg & 0xFF;
> case VIRTIO_BLK_CONFIG_MAX_SEG + 1:
>    return (vdev->max_seg >> 8) & 0xFF;
> case VIRTIO_BLK_CONFIG_MAX_SEG + 2:
>    return (vdev->max_seg >> 16) & 0xFF;
> case VIRTIO_BLK_CONFIG_MAX_SEG + 3:
>    return (vdev->max_seg >> 24) & 0xFF;
> case VIRTIO_BLK_CONFIG_MAX_SIZE:
>    return vdev->max_size & 0xFF;
> case VIRTIO_BLK_CONFIG_MAX_SIZE + 1:
>    return (vdev->max_size >> 8) & 0xFF;
> case VIRTIO_BLK_CONFIG_MAX_SIZE + 2:
>    return (vdev->max_size >> 16) & 0xFF;
> case VIRTIO_BLK_CONFIG_MAX_SIZE + 3:
>    return (vdev->max_size >> 24) & 0xFF;
> ...

	struct virtio_blk_config
	{
		uint32_t max_seg, max_size;
	};

	...
	struct virtio_blk_config conf = { vdev->max_seg, vdev->max_size };

	return ((unsigned char *)&conf)[addr];

(Which strongly implies our headers should expose that nominal struct, rather 
than numerical constants).

Rusty.
