Return-Path: <linux-kernel-owner+w=401wt.eu-S965085AbXLTRYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbXLTRYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbXLTRYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:24:11 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:52255 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759026AbXLTRYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:24:09 -0500
Subject: Re: [ofa-general] iommu dma mapping alignment requirements
From: Tom Tucker <tom@opengridcomputing.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Wen Xiong <wenxiong@us.ibm.com>
In-Reply-To: <476AA2E2.5010007@opengridcomputing.com>
References: <476AA2E2.5010007@opengridcomputing.com>
Content-Type: text/plain
Organization: Open Grid Computing, Inc.
Date: Thu, 20 Dec 2007 11:29:36 -0600
Message-Id: <1198171776.23924.22.camel@trinity.ogc.int>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

The Ammasso certainly works this way. If you tell it the page size is
64KB, it will ignore bits in the page address that encode 0-65535.

> 
> Steve.
> 
> 
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general

