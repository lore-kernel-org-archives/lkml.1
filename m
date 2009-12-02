Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZLBPYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZLBPYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZLBPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:24:46 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:58495 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbZLBPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:24:44 -0500
Subject: Re: [PATCH] hugetlb: Abort a hugepage pool resize if a signal is
 pending
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091202141504.GE1457@csn.ul.ie>
References: <20091202141504.GE1457@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 02 Dec 2009 07:24:35 -0800
Message-Id: <1259767475.24696.2368.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 14:15 +0000, Mel Gorman wrote:
> If a user asks for a hugepage pool resize but specified a large number, the
> machine can begin trashing. In response, they might hit ctrl-c but signals
> are ignored and the pool resize continues until it fails an allocation. This
> can take a considerable amount of time so this patch aborts a pool resize
> if a signal is pending.
> 
> [dave@linux.vnet.ibm.com: His idea]
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/hugetlb.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index af02ee8..a952cb8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1238,6 +1238,9 @@ static unsigned long set_max_huge_pages(struct hstate *h, unsigned long count)
>  		if (!ret)
>  			goto out;
> 
> +		/* Bail for signals. Probably ctrl-c from user */
> +		if (signal_pending(current))
> +			goto out;

Thanks, Mel!

This will help m unwedge my system the next time I fat-finger an extra
zero or two into my hugepage pool size.

-- Dave

