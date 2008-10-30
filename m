Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYJ3S3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYJ3S3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYJ3S3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:29:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53294 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbYJ3S3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:29:20 -0400
Date: Thu, 30 Oct 2008 19:29:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       tim@scalemp.com, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: Fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081030182902.GF14102@elte.hu>
References: <20081030020203.GA12423@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030020203.GA12423@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Fix mmap to /dev/mem when CONFIG_X86_PAT is off and CONFIG_STRICT_DEVMEM is
> off
> 
> mmap to /dev/mem on kernel memory has been failing since the
> introduction of PAT (CONFIG_STRICT_DEVMEM=n case).   Seems like
> the check to avoid cache aliasing with PAT is kicking in even
> when PAT is disabled. The bug seems to have crept in 2.6.26.
> 
> This patch makes sure that mmap to regular kernel memory
> succeeds if CONFIG_STRICT_DEVMEM=n and
> PAT is disabled.  The checks to avoid cache aliasing
> still happens if PAT is enabled.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> Tested-by: Tim Sirianni <tim@scalemp.com>
> 
> Index: git.tip/arch/x86/mm/pat.c
> ===================================================================
> --- git.tip.orig/arch/x86/mm/pat.c	2008-10-21 14:02:57.000000000 -0700
> +++ git.tip/arch/x86/mm/pat.c	2008-10-29 13:19:47.000000000 -0800
> @@ -481,6 +481,7 @@
>  	return 1;
>  }
>  #else
> +/* This check is needed to avoid cache aliasing when PAT is enabled */
>  static inline int range_is_allowed(unsigned long pfn, unsigned long size)
>  {
>  	u64 from = ((u64)pfn) << PAGE_SHIFT;
> @@ -508,7 +509,8 @@
>  	unsigned long flags = -1;
>  	int retval;
>  
> -	if (!range_is_allowed(pfn, size))
> +	/* Ensure cache aliasing does not occur if and only if PAT is on */
> +	if (pat_enabled && !range_is_allowed(pfn, size))
>  		return 0;

I guess it might be cleaner to push this check into the 
range_is_allowed() function?

	Ingo
