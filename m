Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYKMXwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYKMXwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYKMXwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:52:01 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:19106 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbYKMXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:52:00 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuIAAOhMHElR8VAS/2dsb2JhbAAI0WGCeA
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Date: Fri, 14 Nov 2008 00:52:10 +0100
User-Agent: KMail/1.9.9
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-uvc-devel@lists.berlios.de,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org> <200811092222.18047.laurent.pinchart@skynet.be> <8A42379416420646B9BFAC9682273B6D065BA718@limkexm3.ad.analog.com>
In-Reply-To: <8A42379416420646B9BFAC9682273B6D065BA718@limkexm3.ad.analog.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811140052.10520.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Monday 10 November 2008, Hennerich, Michael wrote:
> >On Thursday 06 November 2008, Bryan Wu wrote:
> > > @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file,
> > > struct vm_area_struct *vma) addr += PAGE_SIZE;
> > >  		size -= PAGE_SIZE;
> > >  	}
> > > +#else
> > > +	if (i == video->queue.count ||
> > > +		PAGE_ALIGN(size) != video->queue.buf_size) {
> >
> > Just out of curiosity, why do you need to PAGE_ALIGN size for non-MMU
> > platforms ?
>
> Size and video->queue.buf_size is not the 100% same size (off by a few
> bytes < pagesize), I think it's because on NOMMU the kernel calls
> kmalloc() to allocate the buffer, not get_free_page().

That's right, but only for private mappings. It makes little sense to create a 
private mapping on a V4L2 device as the kernel will read() device data into 
the buffer when mapping the device (at least on NOMMU platforms). Only shared 
mappings make sense in this case.

> > > +		ret = -EINVAL;
> > > +		goto done;
> > > +	}
> > > +
> > > +	vma->vm_flags |= VM_IO | VM_MAYSHARE; /* documentation/nommu-mmap.txt
> >
> > VM_MAYSHARE is not documented anywhere in Documentation/ in Linux
> > 2.6.28-rc3. Why is it needed for non-MMU architectures only ?
>
> mmap on NOMMU is a bit tricky and very restricted.
> In case user does a MAP_SHARED with some combination of the PROT_###
> Flags the mmap fails. What's allowed and what's not is documented in
> documentation/nommu-mmap.txt
> Setting VM_MAYSHARE allows user MAP_PRIVATE mappings.

There's something I don't understand. I've had a quick look at NOMMU mmap 
(mm/nommu.c) and it seems neither MAP_SHARED nor MAP_PRIVATE can succeed with 
UVC devices.

The uvcvideo driver doesn't implements the read and get_unmapped_area file 
operations. validate_mmap_request will thus clear the BDI_CAP_MAP_DIRECT and 
BDI_CAP_MAP_COPY from the device mapping capabilities. As shared mappings 
require BDI_CAP_MAP_DIRECT and private mappings require BDI_CAP_MAP_COPY 
validate_mmap_request will return an error and mmap will fail.

I might be wrong in my analysis, but if mapping a UVC device is impossible on 
a NOMMU platform the patch doesn't make much sense. Feel free to prove me 
wrong and send me back to mm/ if you've been able to map a UVC device on a 
NOMMU platform :-)

Laurent Pinchart
