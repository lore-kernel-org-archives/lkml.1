Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbYAPHe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbYAPHe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYAPHeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:34:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbYAPHeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:34:20 -0500
Date: Wed, 16 Jan 2008 08:33:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 4/4] x86: PAT followup - use ioremap for devmem read of
	reserved regions
Message-ID: <20080116073322.GE30950@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116024112.291093000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116024112.291093000@intel.com>
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


* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:

> --- linux-2.6.git.orig/drivers/char/mem.c	2008-01-15 10:05:13.000000000 -0800
> +++ linux-2.6.git/drivers/char/mem.c	2008-01-15 10:05:51.000000000 -0800
> @@ -127,9 +127,14 @@
>  		 * by the kernel or data corruption may occur
>  		 */
>  		ptr = xlate_dev_mem_ptr(p);
> +		if (!ptr)
> +			return -EFAULT;
>  
>  		if (copy_to_user(buf, ptr, sz))
>  			return -EFAULT;
> +
> +		unxlate_dev_mem_ptr(p, ptr);

sidenote: drivers/char/mem.c has no locking here, are you sure it's safe 
to create a possibly large number of aliases here? At least on 32-bit it 
could deplete the vmalloc area. (where all ioremaps go)

since /dev/mem access is strongly discouraged anyway (except perhaps for 
debugging purposes), wouldnt it be safer to stick a mutex around these 
areas?

	Ingo
