Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZAMSWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZAMSWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZAMSVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:21:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:15315 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbZAMSVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:21:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,260,1231142400"; 
   d="scan'208";a="378111338"
Date: Tue, 13 Jan 2009 10:21:30 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "pageexec@freemail.hu" <pageexec@freemail.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Daniel.Beschorner@facton.com" <Daniel.Beschorner@facton.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch] x86: fix PTE corruption issue while mapping RAM using /dev/mem
Message-ID: <20090113182130.GC13157@linux-os.sc.intel.com>
References: <20090112235135.GA22722@elte.hu> <496BDDFD.27997.A74B06@pageexec.freemail.hu> <20090113003147.GA18115@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113003147.GA18115@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 04:31:47PM -0800, Ingo Molnar wrote:
> 
> Suresh, could you please resend against tip/master? Thanks,

Ok. Here it is:

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

Reported-by: PaX Team <pageexec@freemail.hu>
Reported-and-tested-by: Beschorner Daniel <Daniel.Beschorner@facton.com>
Tested-and-Acked-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: <stable@kernel.org>
---

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ec8cd49..c2a0538 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,6 +333,9 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
+	if (new_type)
+		*new_type = actual_type;
+
 	/*
 	 * For legacy reasons, some parts of the physical address range in the
 	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
@@ -356,9 +359,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	new->end	= end;
 	new->type	= actual_type;
 
-	if (new_type)
-		*new_type = actual_type;
-
 	spin_lock(&memtype_lock);
 
 	if (cached_entry && start >= cached_start)
