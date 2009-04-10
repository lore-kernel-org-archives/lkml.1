Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbZDJRdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbZDJRdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbZDJRdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:33:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:7195 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZDJRdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,168,1239001200"; 
   d="scan'208";a="680553527"
Subject: Re: [patch 0/6] x86, PAT, CPA: Cleanups and minor bug fixes
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <20090410115348.GK21506@elte.hu>
References: <20090409212646.511925000@intel.com>
	 <20090410115348.GK21506@elte.hu>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 10:31:23 -0700
Message-Id: <1239384683.4529.8567.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 04:53 -0700, Ingo Molnar wrote:
> * venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:
> 
> > This patchset contains cleanups and minor bug fixes in x86 PAT and 
> > CPA related code. The bugs were mostly found by code inspection. 
> > There should not be any functionality changes with this patchset.
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Great, this series looks really nice!
> 
> Does this solve the problems reported in the "2.6.29 git master and 
> PAT problems" thread and addressed via an earlier patch of yours:
> 
>  Subject: [PATCH] x86, PAT: Remove page granularity tracking for vm_insert_pfn maps

> i am worried about this particular patch - it looks more like a 
> workaround than a true realization of a bug.
> 

No. This patchset does not fix that problem. "Remove page granularity
tracking" patch is still needed with this patchset.

Yes. That patch is more of a workaround or a direction change about how
we want to handle vm_insert_pfn with PAT.
When we added the page level tracking, there were no in kernel users of
vm_insert_pfn() and we did not consider the usages where same address
space/vma will be used to map different physical addresses over time
with unmap_mapping_range() and re -inserting different pfns to the same
vma. That is what X 915 driver is doing now.
You are right in saying that the patch is not handling the bug of
"freeing invalid memtype" errors. They are happening due to unbalanced
reserve/free (more free than reserve) in the code path of tracking
vm_insert_pfn pages. I couldn't really reproduce the problem where we
are getting those unbalanced frees as reported in that bug report. But,
that bug report also points to another issue. The issue of 1000s of
single page UC_MINUS or WC mappings from X driver. Even though it is not
a functionality problem, it will have major performance impact tracking
thousands of memtypes. We don't have to really track memtypes of such
small chunks and they want WC (or UC_MINUS) for all those mappings.
So, the plan is to forget about tracking of individual pages. That
automatically takes care of the unbalanced reserve/free problem.

We are adding a new API where driver can ask for a type for a big
address range, something like the entire PCI map range. And then used
the type for each individual page that they may map on demand. This way
we don't have to keep track of individual pages that driver may map and
unmap. This is still in works, I should have a patch for this soon (a
week or so).

Thanks,
Venki


