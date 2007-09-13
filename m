Return-Path: <linux-kernel-owner+w=401wt.eu-S1764556AbXIMEd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764556AbXIMEd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 00:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXIMEds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 00:33:48 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:61619 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXIMEdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 00:33:47 -0400
X-IronPort-AV: E=Sophos;i="4.20,248,1186383600"; 
   d="scan'208";a="398709018"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Make sure user pages are from hugetlb before using MR large pages
X-Message-Flag: Warning: May contain useful information
References: <200709121439.32641.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 12 Sep 2007 21:33:45 -0700
In-Reply-To: <200709121439.32641.fenkes@de.ibm.com> (Joachim Fenkes's message of "Wed, 12 Sep 2007 14:39:31 +0200")
Message-ID: <adaps0nmbfa.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Sep 2007 04:33:45.0987 (UTC) FILETIME=[45ACF530:01C7F5BF]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > -#define HCA_CAP_MR_PGSIZE_4K  1
 > -#define HCA_CAP_MR_PGSIZE_64K 2
 > -#define HCA_CAP_MR_PGSIZE_1M  4
 > -#define HCA_CAP_MR_PGSIZE_16M 8
 > +#define HCA_CAP_MR_PGSIZE_4K  0x80000000
 > +#define HCA_CAP_MR_PGSIZE_64K 0x40000000
 > +#define HCA_CAP_MR_PGSIZE_1M  0x20000000
 > +#define HCA_CAP_MR_PGSIZE_16M 0x10000000

Not sure I understand what this has to do with things... is this an
unrelated fix?

 > +static int ehca_is_mem_hugetlb(unsigned long addr, unsigned long size)

This is rather awful -- another call to get_user_pages() to iterate
over all the vmas...

I would suggest extending ib_umem_get() to check the vmas and adding a
member to struct ib_umem to say whether the memory is entirely covered
by hugetlb pages or not.

 > +		ret = ehca_is_mem_hugetlb(virt, length);
 > +		switch (ret) {
 > +		case 0: /* mem is not from hugetlb */
 > +			hwpage_size = PAGE_SIZE;
 > +			break;
 > +		case 1:
 > +			if (length <= EHCA_MR_PGSIZE4K
 > +			    && PAGE_SIZE == EHCA_MR_PGSIZE4K)
 > +				hwpage_size = EHCA_MR_PGSIZE4K;
 > +			else if (length <= EHCA_MR_PGSIZE64K)
 > +				hwpage_size = EHCA_MR_PGSIZE64K;
 > +			else if (length <= EHCA_MR_PGSIZE1M)
 > +				hwpage_size = EHCA_MR_PGSIZE1M;
 > +			else
 > +				hwpage_size = EHCA_MR_PGSIZE16M;
 > +			break;
 > +		default: /* out of mem */
 > +			ib_mr = ERR_PTR(-ENOMEM);
 > +			goto reg_user_mr_exit1;

It seems like it would be better to just assume the memory is not from
a hugetlb is ehca_is_mem_hugetlb() fails its memory allocation and
fall back to the PAGE_SIZE case rather than failing entirely.

Also if someone runs a kernel with 64K pages on a machine where they
end up being simulated from 4K pages, do you have the same issue with
the hypervisor ganging together non-contiguous pages?

 - R.
