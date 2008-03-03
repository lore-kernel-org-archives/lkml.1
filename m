Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbYCCIu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbYCCIu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYCCIuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:50:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33167 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYCCIuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:50:20 -0500
Date: Mon, 3 Mar 2008 09:50:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v2
Message-ID: <20080303085000.GB15943@elte.hu>
References: <20080301005141.997705000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301005141.997705000@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Split the FPU save area from the task struct. This allows easy 
> migration of FPU context, and it's generally cleaner. It also allows 
> the following two optimizations:
> 
> 1) only allocate when the application actually uses FPU, so in the 
> first lazy FPU trap. This could save memory for non-fpu using apps. 
> Next patch does this lazy allocation.
> 
> 2) allocate the right size for the actual cpu rather than 512 bytes 
> always. Patches enabling xsave/xrstor support (coming shortly) will 
> take advantage of this.

thanks, i've applied your two patches to x86.git#testing.

the #ifdefs are still a bit ugly:

> +#ifndef arch_task_cache_init
> +#define arch_task_cache_init()
> +#endif

use a __weak alias instead. (that way if an architecture defines the 
function, that function takes over automatically at link time, without 
any #ifdef complications)

> +#ifndef arch_dup_task_struct
> +static inline int arch_dup_task_struct(struct task_struct *dst,
> +				       struct task_struct *src)
> +{
> +	*dst = *src;
> +	return 0;
> +}
> +#endif

ditto.

	Ingo
