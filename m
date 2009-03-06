Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZCFQxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZCFQxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZCFQw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:52:56 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56206 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCFQwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:52:55 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jan sonnek <ha2nny@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1236357616.3882.66.camel@pc1117.cambridge.arm.com>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
	 <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
	 <1236214452.22399.68.camel@nimitz>
	 <1236357616.3882.66.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 08:52:49 -0800
Message-Id: <1236358369.10626.58.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 16:40 +0000, Catalin Marinas wrote:
> It seems that node_start_pfn() isn't present on all the architectures. I
> ended up with something like below:
> 
> +	/* struct page scanning for each node */
> +	for_each_online_node(i) {
> +		pg_data_t *pgdat = NODE_DATA(i);
> +		unsigned long start_pfn = pgdat->node_start_pfn;
> +		unsigned long end_pfn = start_pfn +
> +			pgdat->node_spanned_pages - 1;
> +		unsigned long pfn;
> +
> +		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
> +			struct page *page;
> +
> +			if (!pfn_valid(pfn))
> +				continue;
> +			page = pfn_to_page(pfn);
> +			/* only scan if page is in use */
> +			if (page_count(page) == 0)
> +				continue;
> +			scan_block(page, page + 1, NULL);
> +		}
> +	}

What does scan_block() actually scan?  Is that second argument
inclusive?

I think you will miss scanning the contents of the last 'struct page' if
you do it this way because of the -1 you do to end_pfn.

> Are the pgdat->node_start_pfn and pgdat->node_spanned_pages always
> valid? Thanks.

The variables themselves?  I'm sure there's a window in early boot where
they aren't valid, but other than that they should be OK unless you're
int the middle of a hotplug operation.

See pgdat_resize_(un)lock() in include/linux/memory_hotplug.h.

-- Dave

