Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbZBESCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbZBESCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZBESCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:02:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:10214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760222AbZBESCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:02:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,386,1231142400"; 
   d="scan'208";a="663085344"
Subject: Re: 2.6.29 pat issue
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thellstrom@vmware.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <498ADFE3.9020907@vmware.com>
References: <498ADFE3.9020907@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Feb 2009 10:03:08 -0800
Message-Id: <1233856988.4286.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 04:47 -0800, Thomas Hellström wrote:
> Hi!
> 
> The function in include/linux/mm.h:
> is_linear_pfn_mapping()
> 
> doesn't seem valid to me.
> 
> In particular, we have VMAs to graphics devices in which vma->vm_pgoff
> is non-zero (Points to an offset in the drm device node), and the VMA is
> sparsely populated with pfns pointing to uncached discontigous RAM pages.
> 
> This causes the X86 PAT code to hit the optimized path when it
> shouldn't, and issue a warning.

Only place where vm_pgoff is getting set for a PFNMAP vma is in
remap_pfn_range() which maps the entire range. vm_insert_pfn() which may
have sparsely populated ranges does not set vm_pgoff. What interface are
you using to map discontig pages, where you are seeing these errors?

> Also a question about the philosofy behind this strict checking that all
> PTEs have the same caching attributes: I guess this is only to catch
> bugs in kernel drivers that don't get this right. At the same time, now
> that also user-space VMAs are checked this will probably have a
> significant performance impact. Shouldn't this checking really live
> behind a debug define?

The result of not having the caching attribute right can be really bad
as to hang/crash the system. So, having this only in debug is not the
enough, IM0. Kernel has to enforce UC and WC caching types are
consistent at all times. And we also have to keep the indentity map and
other mappings that may be present for that address consistent.

Thanks,
Venki


