Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYLRVtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYLRVtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYLRVtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:49:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:19045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYLRVtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:49:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,245,1228118400"; 
   d="scan'208";a="650978906"
Date: Thu, 18 Dec 2008 13:49:41 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 7/7] x86 PAT: update documentation to cover pgprot and remap_pfn related changes - v3
Message-ID: <20081218214940.GA31088@linux-os.sc.intel.com>
References: <20081218194126.963894000@intel.com> <20081218194617.987565000@intel.com> <494ABCF8.8050802@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494ABCF8.8050802@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 01:13:28PM -0800, Randy Dunlap wrote:
> venkatesh.pallipadi@intel.com wrote:
> 
> +Advanced APIs for drivers
> +-------------------------
> +A. Exporting pages to user with remap_pfn_range, io_remap_pfn_range,
> 
>                     to users
> or                  to userspace
> 
> +vm_insert_pfn
> +
> +Drivers wanting to export some pages to userspace, do it by using mmap
> 
> Drop comma.
> 
> +interface and a combination of
> +1) pgprot_noncached()
> +2) io_remap_pfn_range() or remap_pfn_range() or vm_insert_pfn()
> +
> +With pat support, a new API pgprot_writecombine is being added. So, driver can
> 
> s/pat/PAT/
> s/driver/drivers/ or s/driver/a driver/
> 
> +continue to use the above sequence, with either pgprot_noncached() or
> +pgprot_writecombine() in step 1, followed by step 2.
> +
> +In addition, step 2 internally tracks the region as UC or WC in memtype
> +list in order to ensure no conflicting mapping.
> +
> +Note that this set of APIs only work with IO (non RAM) regions. If driver
> 
>                                  works with IO (non-RAM) regions. If a driver
> 
> +wants to export RAM region, it has to do set_memory_uc() or set_memory_wc()
> 
>           export a RAM region,
> 
> +as step 0 above and also track the usage of those pages and use set_memory_wb()
> +before the page is freed to free pool.
> 
> 

refreshed patch below

Thanks,
Venki


Add documentation related to pgprot_* change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 Documentation/x86/pat.txt |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: linux-2.6/Documentation/x86/pat.txt
===================================================================
--- linux-2.6.orig/Documentation/x86/pat.txt	2008-12-17 15:01:50.000000000 -0800
+++ linux-2.6/Documentation/x86/pat.txt	2008-12-17 17:23:16.000000000 -0800
@@ -80,6 +80,30 @@ pci proc               |    --    |    -
                        |          |            |                  |
 -------------------------------------------------------------------
 
+Advanced APIs for drivers
+-------------------------
+A. Exporting pages to users with remap_pfn_range, io_remap_pfn_range,
+vm_insert_pfn
+
+Drivers wanting to export some pages to userspace do it by using mmap
+interface and a combination of
+1) pgprot_noncached()
+2) io_remap_pfn_range() or remap_pfn_range() or vm_insert_pfn()
+
+With pat support, a new API pgprot_writecombine is being added. So, drivers can
+continue to use the above sequence, with either pgprot_noncached() or
+pgprot_writecombine() in step 1, followed by step 2.
+
+In addition, step 2 internally tracks the region as UC or WC in memtype
+list in order to ensure no conflicting mapping.
+
+Note that this set of APIs only work with IO (non RAM) regions. If a driver
+wants to export a RAM region, it has to do set_memory_uc() or set_memory_wc()
+as step 0 above and also track the usage of those pages and use set_memory_wb()
+before the page is freed to free pool.
+
+
+
 Notes:
 
 -- in the above table mean "Not suggested usage for the API". Some of the --'s
