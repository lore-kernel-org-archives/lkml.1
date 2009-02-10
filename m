Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZBJTXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZBJTXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZBJTEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:42 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:57788 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbZBJTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:40 -0500
Message-ID: <4991CFD7.30503@oracle.com>
Date: Tue, 10 Feb 2009 11:04:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: rdreier@cisco.com, general@lists.openfabrics.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <20090210184448.22891.31130.stgit@dell3.ogc.int>
In-Reply-To: <20090210184448.22891.31130.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4991CFC1.023A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> From: Steve Wise <swise@opengridcomputing.com>
> 
> Removes the need for special u64 math on i386 systems.
> 
> Fixes i386 build break in linux-next introduced by 
> commit 1e27e8cee0698259ccb1fe6abeaf4b48969c0945.
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>

Yes, that works, thanks.  But this patch should go into 2.6.29, not
just 2.6.30.


> ---
> 
>  drivers/infiniband/hw/cxgb3/iwch_qp.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
> index 2cf6f13..5bb299a 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
> @@ -232,8 +232,8 @@ static int iwch_sgl2pbl_map(struct iwch_dev *rhp, struct ib_sge *sg_list,
>  			return -EINVAL;
>  		}
>  		offset = sg_list[i].addr - mhp->attr.va_fbo;
> -		offset += ((u64) mhp->attr.va_fbo) %
> -		          (1UL << (12 + mhp->attr.page_size));
> +		offset += mhp->attr.va_fbo &
> +			  ((1UL << (12 + mhp->attr.page_size)) - 1);
>  		pbl_addr[i] = ((mhp->attr.pbl_addr -
>  			        rhp->rdev.rnic_info.pbl_base) >> 3) +
>  			      (offset >> (12 + mhp->attr.page_size));
> @@ -263,8 +263,8 @@ static int build_rdma_recv(struct iwch_qp *qhp, union t3_wr *wqe,
>  		wqe->recv.sgl[i].len = cpu_to_be32(wr->sg_list[i].length);
>  
>  		/* to in the WQE == the offset into the page */
> -		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
> -				(1UL << (12 + page_size[i])));
> +		wqe->recv.sgl[i].to = cpu_to_be64(((u64) wr->sg_list[i].addr) &
> +				((1UL << (12 + page_size[i]))-1));
>  
>  		/* pbl_addr is the adapters address in the PBL */
>  		wqe->recv.pbl_addr[i] = cpu_to_be32(pbl_addr[i]);


-- 
~Randy
