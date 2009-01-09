Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbZAIW0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbZAIW0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbZAIWZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:25:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:26425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245AbZAIWZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:25:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,241,1231142400"; 
   d="scan'208";a="655911097"
Date: Fri, 9 Jan 2009 14:25:53 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Daniel.Beschorner@facton.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       spender@grsecurity.net, pageexec@freemail.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: hwinfo problem since 2.6.28
Message-ID: <20090109222552.GB6472@linux-os.sc.intel.com>
References: <20090108015424.e9443521.akpm@linux-foundation.org> <20090108112543.GA25606@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108112543.GA25606@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Date: Tue, 6 Jan 2009 09:53:14 +0100
> > From: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
> > To: <linux-kernel@vger.kernel.org>
> > Subject: hwinfo problem since 2.6.28
> > 
> > 
> > Since 2.6.28 my hwinfo tool crashes badly on 2 years old OpenSuSE 10.2
> > x64/SMP.
> > Older kernels run fine, I did a "make oldconfig" and rather used
> > defaults (just skipping low-64k checks).
> > This seems to be the only affected binary as far I can see.
> > Did I miss a new legacy/compat option or is it a bug?
> > 
> > Thank you!
> > Daniel
> > 
> > hwinfo: Corrupted page table at address 7fd04de3ec00
> > PGD 7dc33067 PUD 3efe067 PMD 27b83067 PTE fffffffffffffbff
> > Bad pagetable: 000d [#9] SMP

Daniel, Can you please check and ack if the appended patch fixes this
page table corruption issue? We tried to reproduce your issue
locally here but didn't succeed because of different hwinfo versions.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: fix PTE corruption issue while mapping RAM using /dev/mem 

Beschorner Daniel reported:
> hwinfo problem since 2.6.28, showing this in the oops:
> 	Corrupted page table at address 7fd04de3ec00

PaX Team reported a regression with this commit:

>	commit 9542ada803198e6eba29d3289abb39ea82047b92
>	Author: Suresh Siddha <suresh.b.siddha@intel.com>
>	Date:   Wed Sep 24 08:53:33 2008 -0700
>
>	    x86: track memtype for RAM in page struct

This commit breaks mapping any RAM page through /dev/mem, as the
reserve_memtype() was not initializing the return attribute type and as such
corrupting the PTE entry that was setup with the return attribute type.

Because of this bug, application mapping this RAM page through /dev/mem
will die with "Corrupted page table at address xxxx" message in the kernel
log and also the kernel identity mapping which maps the underlying RAM
page gets converted to UC.

Fix this by initializing the return attribute type before calling
reserve_ram_pages_type()

Reported-and-bisected-by: PaX Team <pageexec@freemail.hu>
Reported-by: Beschorner Daniel <Daniel.Beschorner@facton.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: <stable@kernel.org>
---

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 85cbd3c..d52ba1a 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,6 +333,9 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
+	if (new_type)
+		*new_type = actual_type;
+
 	is_range_ram = pagerange_is_ram(start, end);
 	if (is_range_ram == 1)
 		return reserve_ram_pages_type(start, end, req_type, new_type);
@@ -347,9 +350,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	new->end	= end;
 	new->type	= actual_type;
 
-	if (new_type)
-		*new_type = actual_type;
-
 	spin_lock(&memtype_lock);
 
 	if (cached_entry && start >= cached_start)
