Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYCIMKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYCIMKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYCIMKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:10:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYCIMKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:10:00 -0400
Date: Sun, 9 Mar 2008 13:09:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080309120940.GA1695@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > but it appears we dont do quicklist trimming anywhere else! So if a 
> > system has no idle time, the quicklist can grow unbounded, and 
> > that's a real memory leak IMO.
> 
> I test following method.
> 
> 1. $ hackbench 100 process 1000
> 2. $ cat /proc/meminfo
> 
> quicklist consume 1GB memory of 8GB total memory system.
> it seems too large cache ;)
> 
> IMHO we need shrink pgtable cache mecanism.

ouch! Could you try the patch below? How large is the quicklist cache 
with this applied?

	Ingo

---------------------->
Subject: x86: trim quicklist more agressively
From: Ingo Molnar <mingo@elte.hu>
Date: Sun Mar 09 12:59:41 CET 2008

trim the quicklists more agressively, up to 1024 pages at once.
(which pretty much means we keep this special-purpose cache as
small as possible)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pgtable_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/mm/pgtable_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pgtable_32.c
+++ linux-x86.q/arch/x86/mm/pgtable_32.c
@@ -358,7 +358,7 @@ void pgd_free(struct mm_struct *mm, pgd_
 
 void check_pgt_cache(void)
 {
-	quicklist_trim(0, pgd_dtor, 25, 16);
+	quicklist_trim(0, pgd_dtor, 25, 1024);
 }
 
 void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
