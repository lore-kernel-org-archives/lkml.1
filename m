Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbXCSOFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbXCSOFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 10:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933951AbXCSOFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 10:05:34 -0400
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:54101 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933949AbXCSOFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 10:05:33 -0400
Subject: Re: drivers/infiniband/hw/cxgb3/iwch_provider.c: uninitialized
	variable used
From: Steve Wise <swise@opengridcomputing.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Roland Dreier <rolandd@cisco.com>, mshefty@ichips.intel.com,
       halr@voltaire.com, openib-general@openib.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070319092655.GR752@stusta.de>
References: <20070319092655.GR752@stusta.de>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 09:05:32 -0500
Message-Id: <1174313132.8747.0.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Adrian,

I'll address this...

Steve.


On Mon, 2007-03-19 at 10:26 +0100, Adrian Bunk wrote:
> The Coverity checker spotted that "npages" will be used uninitialized in 
> the following code if !(mr_rereg_mask & IB_MR_REREG_TRANS):
> 
> <--  snip  -->
> 
> ...
> static int iwch_reregister_phys_mem(struct ib_mr *mr,
>                                      int mr_rereg_mask,
>                                      struct ib_pd *pd,
>                                      struct ib_phys_buf *buffer_list,
>                                      int num_phys_buf,
>                                      int acc, u64 * iova_start)
> {
> 
>         struct iwch_mr mh, *mhp;
>         struct iwch_pd *php;
>         struct iwch_dev *rhp;
>         __be64 *page_list = NULL;
>         int shift = 0;
>         u64 total_size;
>         int npages;
>         int ret;
> 
>         PDBG("%s ib_mr %p ib_pd %p\n", __FUNCTION__, mr, pd);
> 
>         /* There can be no memory windows */
>         if (atomic_read(&mr->usecnt))
>                 return -EINVAL;
> 
>         mhp = to_iwch_mr(mr);
>         rhp = mhp->rhp;
>         php = to_iwch_pd(mr->pd);
> 
>         /* make sure we are on the same adapter */
>         if (rhp != php->rhp)
>                 return -EINVAL;
> 
>         memcpy(&mh, mhp, sizeof *mhp);
> 
>         if (mr_rereg_mask & IB_MR_REREG_PD)
>                 php = to_iwch_pd(pd);
>         if (mr_rereg_mask & IB_MR_REREG_ACCESS)
>                 mh.attr.perms = iwch_ib_to_tpt_access(acc);
>         if (mr_rereg_mask & IB_MR_REREG_TRANS)
>                 ret = build_phys_page_list(buffer_list, num_phys_buf,
>                                            iova_start,
>                                            &total_size, &npages,
>                                            &shift, &page_list);
> 
>         ret = iwch_reregister_mem(rhp, php, &mh, shift, page_list, npages);
> ...
> 
> <--  snip  -->
> 
> Looking at the code, it also seems some orignally planned error handling 
> code for the build_phys_page_list() call was forgotten ("ret" is never 
> checked before it's overwritten again).
> 
> cu
> Adrian
> 

