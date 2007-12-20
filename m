Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbXLTUSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbXLTUSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXLTUSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:18:32 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60806 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbXLTUSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:18:31 -0500
Subject: Re: iommu dma mapping alignment requirements
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
Reply-To: benh@au1.ibm.com
To: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       Wen Xiong <wenxiong@us.ibm.com>, Olof Johansson <olof@lixom.net>,
       Paul Mackerras <pmac@au1.ibm.com>
In-Reply-To: <476AA2E2.5010007@opengridcomputing.com>
References: <476AA2E2.5010007@opengridcomputing.com>
Content-Type: text/plain
Organization: IBM Ozlabs
Date: Fri, 21 Dec 2007 07:17:42 +1100
Message-Id: <1198181862.6779.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding A few more people to the discussion. You may well be right and we
would have to provide the same alignment, though that sucks a bit as one
of the reason we switched to 4K for the IOMMU is that the iommu space
available on pSeries is very small and we were running out of it with
64K pages and lots of networking activity.

On Thu, 2007-12-20 at 11:14 -0600, Steve Wise wrote:
> Hey Roland (and any iommu/ppc/dma experts out there):
> 
> I'm debugging a data corruption issue that happens on PPC64 systems 
> running rdma on kernels where the iommu page size is 4KB yet the host 
> page size is 64KB.  This "feature" was added to the PPC64 code recently, 
> and is in kernel.org from 2.6.23.  So if the kernel is built with a 4KB 
> page size, no problems.  If the kernel is prior to 2.6.23 then 64KB page 
>   configs work too. Its just a problem when the iommu page size != host 
> page size.
> 
> It appears that my problem boils down to a single host page of memory 
> that is mapped for dma, and the dma address returned by dma_map_sg() is 
> _not_ 64KB aligned.  Here is an example:
> 
> app registers va 0x000000002d9a3000 len 12288
> ib_umem_get() creates and maps a umem and chunk that looks like (dumping 
> state from a registered user memory region):
> 
> >     umem len 12288 off 12288 pgsz 65536 shift 16
> >     chunk 0: nmap 1 nents 1
> >         sglist[0] page 0xc000000000930b08 off 0 len 65536 dma_addr 000000005bff4000 dma_len 65536
> > 
> 
> So the kernel maps 1 full page for this MR.  But note that the dma 
> address is 000000005bff4000 which is 4KB aligned, not 64KB aligned.  I 
> think this is causing grief to the RDMA HW.
> 
> My first question is: Is there an assumption or requirement in linux 
> that dma_addressess should have the same alignment as the host address 
> they are mapped to?  IE the rdma core is mapping the entire 64KB page, 
> but the mapping doesn't begin on a 64KB page boundary.
> 
> If this mapping is considered valid, then perhaps the rdma hw is at 
> fault here.  But I'm wondering if this is an PPC/iommu bug.
> 
> BTW:  Here is what the Memory Region looks like to the HW:
> 
> > TPT entry:  stag idx 0x2e800 key 0xff state VAL type NSMR pdid 0x2
> >             perms RW rem_inv_dis 0 addr_type VATO
> >             bind_enable 1 pg_size 65536 qpid 0x0 pbl_addr 0x003c67c0
> >             len 12288 va 000000002d9a3000 bind_cnt 0
> > PBL: 000000005bff4000
> 
> 
> 
> Any thoughts?
> 
> Steve.
> 

