Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYKIVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYKIVWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbYKIVWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:22:09 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:37531 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243AbYKIVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:22:08 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4BAFziFknZiM6E/2dsb2JhbAAIx3CDWA
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Date: Sun, 9 Nov 2008 22:22:17 +0100
User-Agent: KMail/1.9.9
Cc: linux-uvc-devel@lists.berlios.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1225963130-6784-1-git-send-email-cooloney@kernel.org>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811092222.18047.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, Michael,

On Thursday 06 November 2008, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
> Add NOMMU mmap support.
>
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/media/video/uvc/uvc_v4l2.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 758dfef..2237f5e 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1050,6 +1050,7 @@ static int uvc_v4l2_mmap(struct file *file, struct
> vm_area_struct *vma) break;
>  	}
>
> +#ifdef CONFIG_MMU
>  	if (i == video->queue.count || size != video->queue.buf_size) {
>  		ret = -EINVAL;
>  		goto done;
> @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file, struct
> vm_area_struct *vma) addr += PAGE_SIZE;
>  		size -= PAGE_SIZE;
>  	}
> +#else
> +	if (i == video->queue.count ||
> +		PAGE_ALIGN(size) != video->queue.buf_size) {

Just out of curiosity, why do you need to PAGE_ALIGN size for non-MMU 
platforms ?

> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	vma->vm_flags |= VM_IO | VM_MAYSHARE; /* documentation/nommu-mmap.txt */

VM_MAYSHARE is not documented anywhere in Documentation/ in Linux 2.6.28-rc3. 
Why is it needed for non-MMU architectures only ?

> +
> +	addr = (unsigned long)video->queue.mem + buffer->buf.m.offset;
>
> +	vma->vm_start = addr;
> +	vma->vm_end = addr +  video->queue.buf_size;
> +#endif
>  	vma->vm_ops = &uvc_vm_ops;
>  	vma->vm_private_data = buffer;
>  	uvc_vm_open(vma);

Best regards,

Laurent Pinchart
