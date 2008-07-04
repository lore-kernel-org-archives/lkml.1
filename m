Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYGDGeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYGDGeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYGDGeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:34:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54043 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYGDGd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:33:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <486DC42A.2080105@s5r6.in-berlin.de>
Date: Fri, 04 Jul 2008 08:33:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
CC: Philippe De Muyter <phdm@macqel.be>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: mmap'ed memory in core files ?
References: <20080701132149.GA32510@frolo.macqel>     <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>     <20080702105027.GA1111@frolo.macqel>     <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com>     <486C4CC5.2060006@hitachi.com> <20080703092247.GA13430@frolo.macqel> <486DBA21.3080106@hitachi.com>
In-Reply-To: <486DBA21.3080106@hitachi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidehiro Kawai wrote:
> Philippe De Muyter wrote:
>> drivers/ieee1394/dma.c:
>>     int dma_region_mmap(struct dma_region *dma, struct file *file,
>> 			struct vm_area_struct *vma)
>>     {
>>     [...]
>>     vma->vm_ops = &dma_region_vm_ops;
>>     vma->vm_private_data = dma;
>>     vma->vm_file = file;
>>     vma->vm_flags |= VM_RESERVED;
>>
>>     return 0;
>>     }
>>
>> So, actually the zone I would like to get dumped in the core file is tagged
>> VM_RESERVED.
>>
>> I see the following ways to solve my problem :
>>     - do not tag the zone as VM_RESERVED in ieee1394::dma_region_mmap
>>     - tag the zone as VM_ALWAYSDUMP in ieee1394::dma_region_mmap
>>     - add a bit in coredump_filter to dump the VM_RESERVED zones.
>>
>> As I don't know the real meaning of VM_RESERVED, I do not know which choice
>> is the best one for the official kernel tree,

I don't know these things either.  But among else, VM_RESERVED prevents 
a vma from being swapped out.  Makes kind of sense, given that besides 
the CPUs also the FireWire controller writes to this memory.

>> but locally I'll go for
>> adding VM_ALWAYSDUMP in ieee1394::dma_region_mmap.
> 
> I'm afraid I don't know real usages of VM_RESERVED and VM_IO, either.
> Allowing everyone to choose whether dump the dma region or not,
> perhaps we need to introduce a new VM flag (e.g. VM_DUMPABLE) and
> a coredump_filter bit which controls (VM_IO | VM_RESERVED) &&
> VM_DUMPABLE area, for example.
> 
> I think it is also OK to just add VM_ALWAYSDUMP flag to the dma
> region if the device driver knows the region is safely readable
> and small enough.

It is safely readable.  I don't know if it is small enough.  The size of 
the DMA buffer is AFAIK chosen by userspace (by the application program 
or maybe a library) which uses the character device file ABIs for 
isochronous FireWire IO of raw1394, video1394, or dv1394.
-- 
Stefan Richter
-=====-==--- -=== --=--
http://arcgraph.de/sr/
