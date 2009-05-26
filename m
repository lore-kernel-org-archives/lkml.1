Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZEZRdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZEZRdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZEZRde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:33:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:39948 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbZEZRdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:33:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="415779863"
Date: Tue, 26 May 2009 10:33:35 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tejun Heo <tj@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>,
       Suresh Siddha <suresh.d.siddha@intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
Message-ID: <20090526173335.GA28720@linux-os.sc.intel.com>
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org> <alpine.LFD.2.01.0905251543570.3435@localhost.localdomain> <alpine.LFD.2.01.0905251550320.3435@localhost.localdomain> <4A1B23AB.7090204@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1B23AB.7090204@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 04:03:07PM -0700, H. Peter Anvin wrote:
> Linus Torvalds wrote:
> > 
> > On Mon, 25 May 2009, Linus Torvalds wrote:
> >> Now you made it do two different "on_each_cpu" things. Maybe it doesn't 
> >> matter, but it just seems wrong.
> > 
> > Btw, I pulled, I just wanted to note that I don't think this was done 
> > optimally/cleanly.
> > 
> 
> Understood.  Do you want a fix now or for .31?
> 

Below is the patch that does this optimally.

Thanks,
Venki


[PATCH] x86: Avoid back to back on_each_cpu in cpa_flush_array

Cleanup cpa_flush_array() to avoid back to back on_each_cpu() calls.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/pageattr.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 0f9052b..532d05e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -213,21 +213,15 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 			    int in_flags, struct page **pages)
 {
 	unsigned int i, level;
+	unsigned long do_wbinvd = cache && numpages >= 1024; /* 4M threshold */
 
 	BUG_ON(irqs_disabled());
 
-	on_each_cpu(__cpa_flush_range, NULL, 1);
+	on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
 
-	if (!cache)
+	if (!cache || do_wbinvd)
 		return;
 
-	/* 4M threshold */
-	if (numpages >= 1024) {
-		if (boot_cpu_data.x86 >= 4)
-			on_each_cpu(wbinvd_local, NULL, 1);
-
-		return;
-	}
 	/*
 	 * We only need to flush on one CPU,
 	 * clflush is a MESI-coherent instruction that
-- 
1.6.0.6

