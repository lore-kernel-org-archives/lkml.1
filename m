Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbZDABES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbZDABES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZDABEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:04:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:52895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZDABED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:04:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,304,1235980800"; 
   d="scan'208";a="502474826"
Subject: RE: PAGE_CACHE_WC strikes again
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
	 <20090331171431.69ad044f@hobbes>
	 <7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 31 Mar 2009 17:03:10 -0800
Message-Id: <1238547790.27006.7743.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 17:29 -0700, Pallipadi, Venkatesh wrote:
> The key point here is 
> 
> > setting PAGE_CACHE_WC disables the WC effect of the
> > MTRR on my non-PAT (disabled due to CPU errata)
> 
> When PAT is disabled, the default setting in PAT MSR is
> 00 - WB
> 01 - WT
> 10 - UC_MINUS
> 11 - UC
> 
> There is no way to set WC with PAT. By hardcoding _PAGE_CACHE_WC
> (which is 01) the driver is basically selecting write-through!
> 
> And when MTRR says WC and PAT says WT, effective type is UC.
> 
> Basically, no one should be hard-coding the memory type. Please use
> pgprot_writecombine() which does the right thing by using WC
> (when PAT is enabled) or UC_MINUS (when PAT is disabled).

And the driver should use right API to track the underlying page frame
thats getting mapped by this vma, with the corresponding attribute.
API's like remap_pfn_range(), vm_insert_pfn() will setup the PTE's
aswell as track the pfn's attributes.

API's like set_memory_uc/wc() will explicitly setup the page attributes.

Jesse, As far as I see, the drm GEM fault handler routines don't seem to
do any of this. Am I missing something? We need to fix this so that we
can avoid potential aliasing issues.

thanks,
suresh



