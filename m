Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYGDL0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYGDL0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYGDLZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:25:53 -0400
Received: from mail.macqel.be ([194.78.208.39]:22565 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYGDLZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:25:53 -0400
Date: Fri, 4 Jul 2008 13:25:48 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: mmap'ed memory in core files ?
Message-ID: <20080704112548.GB28377@frolo.macqel>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080702105027.GA1111@frolo.macqel> <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com> <486C4CC5.2060006@hitachi.com> <20080703092247.GA13430@frolo.macqel> <486DBA21.3080106@hitachi.com> <486DC42A.2080105@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486DC42A.2080105@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 08:33:14AM +0200, Stefan Richter wrote:
> Hidehiro Kawai wrote:
>> Philippe De Muyter wrote:
>>> drivers/ieee1394/dma.c:
>>>     int dma_region_mmap(struct dma_region *dma, struct file *file,
>>> 			struct vm_area_struct *vma)
>>>     {
>>>     [...]
>>>     vma->vm_ops = &dma_region_vm_ops;
>>>     vma->vm_private_data = dma;
>>>     vma->vm_file = file;
>>>     vma->vm_flags |= VM_RESERVED;
>>>
>>>     return 0;
>>>     }
>>>
>>> So, actually the zone I would like to get dumped in the core file is 
>>> tagged
>>> VM_RESERVED.
>>>
>>> I see the following ways to solve my problem :
>>>     - do not tag the zone as VM_RESERVED in ieee1394::dma_region_mmap
>>>     - tag the zone as VM_ALWAYSDUMP in ieee1394::dma_region_mmap
>>>     - add a bit in coredump_filter to dump the VM_RESERVED zones.
>>>
>>> As I don't know the real meaning of VM_RESERVED, I do not know which 
>>> choice
>>> is the best one for the official kernel tree,
>
> I don't know these things either.  But among else, VM_RESERVED prevents a 
> vma from being swapped out.  Makes kind of sense, given that besides the 
> CPUs also the FireWire controller writes to this memory.
>
>>> but locally I'll go for
>>> adding VM_ALWAYSDUMP in ieee1394::dma_region_mmap.
>> I'm afraid I don't know real usages of VM_RESERVED and VM_IO, either.
>> Allowing everyone to choose whether dump the dma region or not,
>> perhaps we need to introduce a new VM flag (e.g. VM_DUMPABLE) and
>> a coredump_filter bit which controls (VM_IO | VM_RESERVED) &&
>> VM_DUMPABLE area, for example.
>> I think it is also OK to just add VM_ALWAYSDUMP flag to the dma
>> region if the device driver knows the region is safely readable
>> and small enough.
>
> It is safely readable.  I don't know if it is small enough.  The size of 
> the DMA buffer is AFAIK chosen by userspace (by the application program or 
> maybe a library) which uses the character device file ABIs for isochronous 
> FireWire IO of raw1394, video1394, or dv1394.

For video1394, the size of the buffer is N times the size of a frame, with
N choosen by the application but small (let say < 32).  The size of the
frame depends on the camera.  I have already worked with 8bpp 1600x1200 cameras,but with a smaller N in that case.

1600x1200x32 gives 60M.  If they were allocated by malloc instead of by mmap,
they would be dumped in the core files without any question about the size.

So I think we may consider the 'small enough' criteria is met.

Best regards

Philippe
