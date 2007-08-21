Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbXHUVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbXHUVMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXHUVMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:12:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:49412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbXHUVMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:12:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,291,1183359600"; 
   d="scan'208";a="281942672"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH][2.6.23-rc2-mm2] small fix for ia64 icache sync patch
Date: Tue, 21 Aug 2007 14:12:02 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023B2254@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070821201507.36641d76.kamezawa.hiroyu@jp.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][2.6.23-rc2-mm2] small fix for ia64 icache sync patch
Thread-Index: Acfj5EExdWOpgY1ZT+azIo9x5nKKiAAUpVGg
References: <20070821201507.36641d76.kamezawa.hiroyu@jp.fujitsu.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 21 Aug 2007 21:12:03.0314 (UTC) FILETIME=[EBC37D20:01C7E437]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (pte_present(pteval) &&// swap out ?
> +	    pte_exec(pteval) &&    // flush only new executable page.
> 	    pte_user(pteval) &&    // ignore kernel page
> 	    (!pte_present(*ptep) ||// do_no_page or swap in, migration,
> 		pte_pfn(*ptep) != pte_pfn(pteval))) // do_wp_page(), page copy

David Mosberger was concerned about the increase in code
size from this inline function.  We can reduce the bloat
a bit by defining a macro that tests for "present &&
executable && user-mode" in one go:

#define pte_pux(pte)            ((pte_val(pte) & (_PAGE_P|_PAGE_PL_MASK|_PAGE_AR_RX)) == \
                                        (_PAGE_P|_PAGE_PL_3|_PAGE_AR_RX))

Perhaps there is a better name than "pte_pux"?  I don't know whether
the code that this generates is faster, but it is smaller (bloat
is only 3k instead of 4k).

One last cleanup needed ... don't use C-99/C++ style comments.

-Tony
