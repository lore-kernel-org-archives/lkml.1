Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0BRSrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:47:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:2131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab0BRSrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:47:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,498,1262592000"; 
   d="scan'208";a="493597095"
Subject: Re: Uncool feature for TTM introduced by x86, pat: Use page flags
 to track memtypes of RAM pages
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       "airlied@linux.ie" <airlied@linux.ie>,
       "currojerez@riseup.net" <currojerez@riseup.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100218163505.GA11509@localhost.localdomain>
References: <20100218153032.GA4506@localhost.localdomain>
	 <20100218163505.GA11509@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 18 Feb 2010 10:46:09 -0800
Message-Id: <1266518769.2909.29.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 08:35 -0800, Jerome Glisse wrote:
> On Thu, Feb 18, 2010 at 04:30:32PM +0100, Jerome Glisse wrote:
> > Hi,
> > 
> > commit id: f58417409603d62f2eb23db4d2cf6853d84a1698
> > 
> > TTM is doing uncommon use of set_memory_wc|uc|wb for instance it's not
> > uncommon for TTM to change memory type from wc to uc or from uc to wc.
> > Since x86, pat: Use page flags to track memtypes of RAM pages (commit
> > id above) this isn't allowed anymore, before going from uc to wc or
> > wc to uc we first have to free the memtype by going through wb this
> > means an extra step which likely lead to some overhead (i guess that
> > uc -> wc or wc -> uc won't trigger massive tlb/cpu flush while
> > uc -> wb -> wc or wc -> wb -> uc will). reserve_ram_pages_type is the
> > function which will check that memory is wb thus enforcing us to go
> > through wb step.
> > 
> > Can we modify the interface to support again changing from uc to wc
> > or wc to uc ? (i can try to do a patch for that).
> 
> Ok, we are likely not hit by wc -> uc or uc -> wc change (which is dumb
> but i haven't yet understand what is exactly happening for the user)
> My guess is that on non PAT get_page_memtype always return -1
> Thus i think we will need to export a function bool pat_is_enabled() so
> ttm can pickup the proper path in the unlikely/broken case of
> wc -> uc.

Sure. We can definitely look into extending PAT API if there is a need.

But it looks like you have a bug in the commit
db78e27de7e29a6db6be7caf607cf803d84094aa causing this performance
regression.

> > If no, we have a sever regression on non PAT arch :
> > http://bugzilla.kernel.org/show_bug.cgi?id=15328

This is the commit db78e27de7e29a6db6be7caf607cf803d84094aa:

-       switch (c_state) {
-       case tt_cached:
-               return set_pages_wb(p, 1);
-       case tt_wc:
-           return set_memory_wc((unsigned long) page_address(p), 1);
-       default:
-               return set_pages_uc(p, 1);
+       if (get_page_memtype(p) != -1) {
+               /* p isn't in the default caching state, set it to
+                * writeback first to free its current memtype. */
+
+               ret = set_pages_wb(p, 1);
+               if (ret)
+                       return ret;
        }
+
+       if (c_state == tt_wc)
+               ret = set_memory_wc((unsigned long) page_address(p), 1);
+       else if (c_state == tt_uncached)
+               ret = set_pages_uc(p, 1);
+
+       return ret;

You are not setting the pages back to wb() before you free it. And this
is the reason for your performance issue.

We can fix it by changing the if check to something like:

if (get_page_memtype(p) != -1 || c_state == tt_cached)

thanks,
suresh



