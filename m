Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXCSJ1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXCSJ1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXCSJ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:27:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34856 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753396AbXCSJ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:26:52 -0400
Date: Mon, 19 Mar 2007 10:26:55 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rolandd@cisco.com>
Cc: mshefty@ichips.intel.com, halr@voltaire.com, openib-general@openib.org,
       linux-kernel@vger.kernel.org
Subject: drivers/infiniband/hw/cxgb3/iwch_provider.c: uninitialized variable used
Message-ID: <20070319092655.GR752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that "npages" will be used uninitialized in 
the following code if !(mr_rereg_mask & IB_MR_REREG_TRANS):

<--  snip  -->

...
static int iwch_reregister_phys_mem(struct ib_mr *mr,
                                     int mr_rereg_mask,
                                     struct ib_pd *pd,
                                     struct ib_phys_buf *buffer_list,
                                     int num_phys_buf,
                                     int acc, u64 * iova_start)
{

        struct iwch_mr mh, *mhp;
        struct iwch_pd *php;
        struct iwch_dev *rhp;
        __be64 *page_list = NULL;
        int shift = 0;
        u64 total_size;
        int npages;
        int ret;

        PDBG("%s ib_mr %p ib_pd %p\n", __FUNCTION__, mr, pd);

        /* There can be no memory windows */
        if (atomic_read(&mr->usecnt))
                return -EINVAL;

        mhp = to_iwch_mr(mr);
        rhp = mhp->rhp;
        php = to_iwch_pd(mr->pd);

        /* make sure we are on the same adapter */
        if (rhp != php->rhp)
                return -EINVAL;

        memcpy(&mh, mhp, sizeof *mhp);

        if (mr_rereg_mask & IB_MR_REREG_PD)
                php = to_iwch_pd(pd);
        if (mr_rereg_mask & IB_MR_REREG_ACCESS)
                mh.attr.perms = iwch_ib_to_tpt_access(acc);
        if (mr_rereg_mask & IB_MR_REREG_TRANS)
                ret = build_phys_page_list(buffer_list, num_phys_buf,
                                           iova_start,
                                           &total_size, &npages,
                                           &shift, &page_list);

        ret = iwch_reregister_mem(rhp, php, &mh, shift, page_list, npages);
...

<--  snip  -->

Looking at the code, it also seems some orignally planned error handling 
code for the build_phys_page_list() call was forgotten ("ret" is never 
checked before it's overwritten again).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

