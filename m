Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZAZUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZAZUKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZAZUK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:10:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZAZUK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:10:28 -0500
Date: Mon, 26 Jan 2009 21:09:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, arjan@infradead.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [git pull] cpus4096 tree, part 3
Message-ID: <20090126200957.GB13471@elte.hu>
References: <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu> <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain> <20090103203621.GA2491@elte.hu> <20090103213856.GA24138@elte.hu> <alpine.LFD.2.00.0901031347570.3179@localhost.localdomain> <20090103223723.GA17047@elte.hu> <20090105011416.GG32239@wotan.suse.de> <20090105011630.GI32239@wotan.suse.de> <20090126110054.bdddbf38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126110054.bdddbf38.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> but why did the current code pass testing at all??

i queued it up a week ago and beyond a same-day breakage i reported to 
Nick (and which he fixed) this commit was problem-free and passed all 
testing here.

Does it cause problems for you? If yes then please describe the kind of 
problems.

Note: i see that -mm modifies a few other details of the x86 pagefault 
handling path (there a pagefault-retry patch in there) - so there might be 
contextual interactions there. But this particular cleanup/improvement 
from Nick is working fine on a wide range of systems here.

Btw., regarding pagefault retry. The bits that are in -mm currently i 
find a bit ugly:

> +++ a/arch/x86/mm/fault.c
> @@ -799,7 +799,7 @@ void __kprobes do_page_fault(struct pt_r
>  	struct vm_area_struct *vma;
>  	int write;
>  	int fault;
> -	unsigned int retry_flag = FAULT_FLAG_RETRY;
> +	int retry_flag = 1;
>  
>  	tsk = current;
>  	mm = tsk->mm;
> @@ -951,6 +951,7 @@ good_area:
>  	}
>  
>  	write |= retry_flag;
> +
>  	/*
>  	 * If for any reason at all we couldn't handle the fault,
>  	 * make sure we exit gracefully rather than endlessly redo
> @@ -969,8 +970,8 @@ good_area:
>  	 * be removed or changed after the retry.
>  	 */
>  	if (fault & VM_FAULT_RETRY) {
> -		if (write & FAULT_FLAG_RETRY) {
> -			retry_flag &= ~FAULT_FLAG_RETRY;
> +		if (retry_flag) {
> +			retry_flag = 0;
>  			goto retry;
>  		}
>  		BUG();

as this complicates every architecture with a 'can the fault be retried' 
logic and open-coded retry loop.

But that logic is rather repetitive and once an architecture filters out 
all its special in-kernel sources of faults and the hw quirks it has, the 
handling of pte faults is rather generic and largely offloaded into 
handle_pte_fault() already.

So when this patch was submitted a few weeks ago i suggested that retry 
should be done purely in mm/memory.c instead, and the low level code 
should at most be refactored to suit this method, but not complicated any 
further.

Any deep reasons for why such a more generic approach is not desirable?

	Ingo
