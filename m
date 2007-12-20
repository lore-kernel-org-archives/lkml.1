Return-Path: <linux-kernel-owner+w=401wt.eu-S937528AbXLTRlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937528AbXLTRlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933444AbXLTRka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:40:30 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:43536 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933385AbXLTRk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:40:28 -0500
X-Greylist: delayed 1559 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2007 12:40:28 EST
Message-ID: <476AA2E2.5010007@opengridcomputing.com>
Date: Thu, 20 Dec 2007 11:14:10 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       Wen Xiong <wenxiong@us.ibm.com>
Subject: iommu dma mapping alignment requirements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Roland (and any iommu/ppc/dma experts out there):

I'm debugging a data corruption issue that happens on PPC64 systems 
running rdma on kernels where the iommu page size is 4KB yet the host 
page size is 64KB.  This "feature" was added to the PPC64 code recently, 
and is in kernel.org from 2.6.23.  So if the kernel is built with a 4KB 
page size, no problems.  If the kernel is prior to 2.6.23 then 64KB page 
  configs work too. Its just a problem when the iommu page size != host 
page size.

It appears that my problem boils down to a single host page of memory 
that is mapped for dma, and the dma address returned by dma_map_sg() is 
_not_ 64KB aligned.  Here is an example:

app registers va 0x000000002d9a3000 len 12288
ib_umem_get() creates and maps a umem and chunk that looks like (dumping 
state from a registered user memory region):

>     umem len 12288 off 12288 pgsz 65536 shift 16
>     chunk 0: nmap 1 nents 1
>         sglist[0] page 0xc000000000930b08 off 0 len 65536 dma_addr 000000005bff4000 dma_len 65536
> 

So the kernel maps 1 full page for this MR.  But note that the dma 
address is 000000005bff4000 which is 4KB aligned, not 64KB aligned.  I 
think this is causing grief to the RDMA HW.

My first question is: Is there an assumption or requirement in linux 
that dma_addressess should have the same alignment as the host address 
they are mapped to?  IE the rdma core is mapping the entire 64KB page, 
but the mapping doesn't begin on a 64KB page boundary.

If this mapping is considered valid, then perhaps the rdma hw is at 
fault here.  But I'm wondering if this is an PPC/iommu bug.

BTW:  Here is what the Memory Region looks like to the HW:

> TPT entry:  stag idx 0x2e800 key 0xff state VAL type NSMR pdid 0x2
>             perms RW rem_inv_dis 0 addr_type VATO
>             bind_enable 1 pg_size 65536 qpid 0x0 pbl_addr 0x003c67c0
>             len 12288 va 000000002d9a3000 bind_cnt 0
> PBL: 000000005bff4000



Any thoughts?

Steve.


