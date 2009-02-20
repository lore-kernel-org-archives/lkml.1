Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbZBTPvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbZBTPvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZBTPuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:50:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34262 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZBTPuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:50:51 -0500
Date: Fri, 20 Feb 2009 16:50:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 page fault checker
Message-ID: <20090220155036.GA3225@elte.hu>
References: <alpine.DEB.2.00.0902201012220.29217@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902201012220.29217@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This is not an urgent fix, but I based it on your urgent 
> branch. The patch keeps the page fault handler from entering 
> an infinite loop if the PMD does not match the PTE, and the 
> PTE has the correct permissions but the PMD does not.
> 
> With your latest change, this should not happen again. But if 
> there's some other code out there that does have this bug, or 
> if some future change creates it (never know with all the 
> changes in virtualization) Perhaps it is still a good idea to 
> have this check.
> 
> This is not a fast path, and it should not hurt to have this 
> level of paranoia.
> 
> -- Steve
> 
> Please pull the latest tip/x86/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/x86/urgent
> 
> 
> Steven Rostedt (1):
>       x86: check PMD in spurious_fault handler
> 
> ----
>  arch/x86/mm/fault.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> ---------------------------
> commit 8ef2333f1bdcc4a43cb37b1b5d8febf8e3d8cdc7
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu Feb 19 11:46:36 2009 -0500
> 
>     x86: check PMD in spurious_fault handler
>     
>     Impact: fix to prevent hard lockup on bad PMD permissions
>     
>     If the PMD does not have the correct permissions for a page access,
>     but the PTE does, the spurious fault handler will mistake the fault
>     as a lazy TLB transaction. This will result in an infinite loop of:
>     
>      fault -> spurious_fault check (pass) -> return to code -> fault
>     
>     This patch adds a check and a warn on if the PTE passes the permissions
>     but the PMD does not.
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index c76ef1d..7b579a6 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -455,6 +455,7 @@ static int spurious_fault(unsigned long address,
>  	pud_t *pud;
>  	pmd_t *pmd;
>  	pte_t *pte;
> +	int ret;
>  
>  	/* Reserved-bit violation or user access to kernel space? */
>  	if (error_code & (PF_USER | PF_RSVD))
> @@ -482,7 +483,17 @@ static int spurious_fault(unsigned long address,
>  	if (!pte_present(*pte))
>  		return 0;
>  
> -	return spurious_fault_check(error_code, pte);
> +	ret = spurious_fault_check(error_code, pte);
> +	if (!ret)
> +		return 0;
> +
> +	/*
> +	 * Make sure we have permissions in PMD
> +	 * If not, then there's a bug in the page tables.
> +	 */
> +	ret = spurious_fault_check(error_code, (pte_t *) pmd);
> +	WARN_ON(!ret);
> +	return ret;
>  }

i guess we could do this - but i'd rather have it as a 
WARN_ONCE(), with some text - so that if it ever triggers it's 
one surgical message.

	Ingo
