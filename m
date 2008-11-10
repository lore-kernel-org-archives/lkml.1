Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYKJLah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYKJLah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 06:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYKJLa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 06:30:27 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:11429 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYKJLa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 06:30:26 -0500
X-IronPort-AV: E=Sophos;i="4.33,574,1220241600"; 
   d="scan'208";a="62323864"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Date: Mon, 10 Nov 2008 11:30:19 -0000
Message-ID: <8A42379416420646B9BFAC9682273B6D065BA718@limkexm3.ad.analog.com>
In-Reply-To: <200811092222.18047.laurent.pinchart@skynet.be>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Thread-Index: AclCsc03DEGc3/kyRAi8KGcZfbqqOQAZG1Rg
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org> <200811092222.18047.laurent.pinchart@skynet.be>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>,
       "Bryan Wu" <cooloney@kernel.org>
Cc: <linux-uvc-devel@lists.berlios.de>, <video4linux-list@redhat.com>,
       <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 10 Nov 2008 11:30:22.0274 (UTC) FILETIME=[B7C5AA20:01C94327]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Laurent Pinchart [mailto:laurent.pinchart@skynet.be]
>Sent: Sunday, November 09, 2008 10:22 PM
>To: Bryan Wu
>Cc: linux-uvc-devel@lists.berlios.de; video4linux-list@redhat.com;
linux-
>kernel@vger.kernel.org; Michael Hennerich
>Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to
NOMMU
>
>Hi Bryan, Michael,
>
>On Thursday 06 November 2008, Bryan Wu wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Add NOMMU mmap support.
>>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/media/video/uvc/uvc_v4l2.c |   14 ++++++++++++++
>>  1 files changed, 14 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
>> b/drivers/media/video/uvc/uvc_v4l2.c index 758dfef..2237f5e 100644
>> --- a/drivers/media/video/uvc/uvc_v4l2.c
>> +++ b/drivers/media/video/uvc/uvc_v4l2.c
>> @@ -1050,6 +1050,7 @@ static int uvc_v4l2_mmap(struct file *file,
struct
>> vm_area_struct *vma) break;
>>  	}
>>
>> +#ifdef CONFIG_MMU
>>  	if (i == video->queue.count || size != video->queue.buf_size) {
>>  		ret = -EINVAL;
>>  		goto done;
>> @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file,
struct
>> vm_area_struct *vma) addr += PAGE_SIZE;
>>  		size -= PAGE_SIZE;
>>  	}
>> +#else
>> +	if (i == video->queue.count ||
>> +		PAGE_ALIGN(size) != video->queue.buf_size) {
>
>Just out of curiosity, why do you need to PAGE_ALIGN size for non-MMU
>platforms ?

Size and video->queue.buf_size is not the 100% same size (off by a few
bytes < pagesize), I think it's because on NOMMU the kernel calls
kmalloc() to allocate the buffer, not get_free_page().


>
>> +		ret = -EINVAL;
>> +		goto done;
>> +	}
>> +
>> +	vma->vm_flags |= VM_IO | VM_MAYSHARE; /*
documentation/nommu-mmap.txt
>*/
>
>VM_MAYSHARE is not documented anywhere in Documentation/ in Linux
2.6.28-
>rc3.
>Why is it needed for non-MMU architectures only ?

mmap on NOMMU is a bit tricky and very restricted.
In case user does a MAP_SHARED with some combination of the PROT_###
Flags the mmap fails. What's allowed and what's not is documented in
documentation/nommu-mmap.txt
Setting VM_MAYSHARE allows user MAP_PRIVATE mappings.
 
-Michael

>
>> +
>> +	addr = (unsigned long)video->queue.mem + buffer->buf.m.offset;
>>
>> +	vma->vm_start = addr;
>> +	vma->vm_end = addr +  video->queue.buf_size;
>> +#endif
>>  	vma->vm_ops = &uvc_vm_ops;
>>  	vma->vm_private_data = buffer;
>>  	uvc_vm_open(vma);
>
>Best regards,
>
>Laurent Pinchart
