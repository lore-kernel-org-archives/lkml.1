Return-Path: <linux-kernel-owner+w=401wt.eu-S937194AbXHJSRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937194AbXHJSRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbXHJSRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:17:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:10410 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbXHJSRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:17:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,245,1183359600"; 
   d="scan'208";a="277213950"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] flush icache before set_pte() on ia64  take9 [2/2] flush icache at set_pte
Date: Fri, 10 Aug 2007 11:17:30 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0224C511@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070809135721.08841cd7.kamezawa.hiroyu@jp.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] flush icache before set_pte() on ia64  take9 [2/2] flush icache at set_pte
Thread-Index: AcfaQaU3+R2ZqeLNQjGP5Jca2AzHJABMdNyw
References: <20070809135311.0676a947.kamezawa.hiroyu@jp.fujitsu.com> <20070809135721.08841cd7.kamezawa.hiroyu@jp.fujitsu.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <linux-ia64@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <Zoltan.Menyhart@bull.net>,
       <nickpiggin@yahoo.com.au>
X-OriginalArrivalTime: 10 Aug 2007 18:17:31.0293 (UTC) FILETIME=[B768A4D0:01C7DB7A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This version looks really clean.  Thank for keeping working on
this through 9 versions!

A couple of small issues.

1) In arch/ia64/mm/init.c: __ia64_sync_icache_dcache()

-	if (!pte_exec(pte))
-		return;				/* not an executable page... */
+	BUG_ON(!pte_exec(pte));

In this latest version the only route to this routine is from set_pte()
inside the test :

	if (pte_exec(pteval) && ....) {
	}

So this BUG_ON is now redundant.

2) In include/asm-ia64/pgtable.h

+	if (pte_exec(pteval) &&    // flush only new executable page.
+	    pte_present(pteval) && // swap out ?
+	    pte_user(pteval) &&    // ignore kernel page
+	    (!pte_present(*ptep) ||// do_no_page or swap in, migration,
+		pte_pfn(*ptep) != pte_pfn(pteval))) // do_wp_page(), page copy
+		/* load_module() calles flush_icache_range() explicitly*/
+		__ia64_sync_icache_dcache(pteval);

Just above this there is a comment saying that pte_exec() only works
when pte_present() is true.  So we must re-order the conditions so that
we check that the pteval satisfies pte_present() before using either of
pte_exec() or pte_user() on it like this:

	if (pte_present(pteval) &&
          pte_exec(pteval) &&
          pte_user(pteval) &&

I put in some crude counters to see whether we should check pte_exec() or
pte_user() next ... and it was very clear that the pte_exec() check gets
us out of the if() faster (at least during a kernel build).

I also compared how often the old code called lazy_mmu_prot_update()
with how often the new code calls __ia64_sync_icache_dcache() (again
using kernel build as my workload) ... and the answer is about the
same (less than 0.2% change ... probably less than run-to-run variation).


So now the only remaining task is to convince myself that this
new version covers all the cases.

-Tony
