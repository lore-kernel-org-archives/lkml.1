Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYKRMlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYKRMlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKRMlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:41:16 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:19931 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYKRMlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:41:14 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62704317"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Date: Tue, 18 Nov 2008 12:40:53 -0000
Message-ID: <8A42379416420646B9BFAC9682273B6D069364B6@limkexm3.ad.analog.com>
In-Reply-To: <200811140052.10520.laurent.pinchart@skynet.be>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Thread-Index: AclF66hfXAYatNU9RumNGP6ZSI99pADiHljg
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org> <200811092222.18047.laurent.pinchart@skynet.be> <8A42379416420646B9BFAC9682273B6D065BA718@limkexm3.ad.analog.com> <200811140052.10520.laurent.pinchart@skynet.be>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: "Bryan Wu" <cooloney@kernel.org>, <linux-uvc-devel@lists.berlios.de>,
       <video4linux-list@redhat.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Nov 2008 12:40:55.0628 (UTC) FILETIME=[E65A38C0:01C9497A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Laurent Pinchart [mailto:laurent.pinchart@skynet.be]
>Sent: Friday, November 14, 2008 12:52 AM
>To: Hennerich, Michael
>Cc: Bryan Wu; linux-uvc-devel@lists.berlios.de; video4linux-
>list@redhat.com; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to
NOMMU
>
>Hi Michael,
>
>On Monday 10 November 2008, Hennerich, Michael wrote:
>> >On Thursday 06 November 2008, Bryan Wu wrote:
>> > > @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file
*file,
>> > > struct vm_area_struct *vma) addr += PAGE_SIZE;
>> > >  		size -= PAGE_SIZE;
>> > >  	}
>> > > +#else
>> > > +	if (i == video->queue.count ||
>> > > +		PAGE_ALIGN(size) != video->queue.buf_size) {
>> >
>> > Just out of curiosity, why do you need to PAGE_ALIGN size for
non-MMU
>> > platforms ?
>>
>> Size and video->queue.buf_size is not the 100% same size (off by a
few
>> bytes < pagesize), I think it's because on NOMMU the kernel calls
>> kmalloc() to allocate the buffer, not get_free_page().
>
>That's right, but only for private mappings. It makes little sense to
>create a
>private mapping on a V4L2 device as the kernel will read() device data
into
>the buffer when mapping the device (at least on NOMMU platforms). Only
>shared
>mappings make sense in this case.
>
>> > > +		ret = -EINVAL;
>> > > +		goto done;
>> > > +	}
>> > > +
>> > > +	vma->vm_flags |= VM_IO | VM_MAYSHARE; /*
documentation/nommu-
>mmap.txt
>> >
>> > VM_MAYSHARE is not documented anywhere in Documentation/ in Linux
>> > 2.6.28-rc3. Why is it needed for non-MMU architectures only ?
>>
>> mmap on NOMMU is a bit tricky and very restricted.
>> In case user does a MAP_SHARED with some combination of the PROT_###
>> Flags the mmap fails. What's allowed and what's not is documented in
>> documentation/nommu-mmap.txt
>> Setting VM_MAYSHARE allows user MAP_PRIVATE mappings.
>
>There's something I don't understand. I've had a quick look at NOMMU
mmap
>(mm/nommu.c) and it seems neither MAP_SHARED nor MAP_PRIVATE can
succeed
>with
>UVC devices.
>
>The uvcvideo driver doesn't implements the read and get_unmapped_area
file
>operations. validate_mmap_request will thus clear the
BDI_CAP_MAP_DIRECT
>and
>BDI_CAP_MAP_COPY from the device mapping capabilities. As shared
mappings
>require BDI_CAP_MAP_DIRECT and private mappings require
BDI_CAP_MAP_COPY
>validate_mmap_request will return an error and mmap will fail.
>
>I might be wrong in my analysis, but if mapping a UVC device is
impossible
>on
>a NOMMU platform the patch doesn't make much sense. Feel free to prove
me
>wrong and send me back to mm/ if you've been able to map a UVC device
on a
>NOMMU platform :-)

Hi Laurent,

I can only say when we map the buffers in user space (ffmpeg, luvcview,
etc.) as MAP_PRIVTE with PROT_READ | PROT_WRITE set, this patch works on
NOMMU. It passes validate_mmap_request(),determine_vm_flags() doesn't
set VM_MAYSHARE, so we finally call do_mmap_private() which in turn
calls the uvc v4l2 private mmap function. There is no copy etc.
involved. User and kernel share the same physical contiguous addresses.
This is even more efficient on NOMMU.


-Michael

>
>Laurent Pinchart
