Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbXJCSWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbXJCSWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXJCSVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:21:52 -0400
Received: from mga05.intel.com ([192.55.52.89]:57340 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757477AbXJCSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,226,1188802800"; 
   d="scan'208";a="334049094"
Message-ID: <4703DD8A.80602@linux.intel.com>
Date: Wed, 03 Oct 2007 11:20:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
References: <20071002.233731.119908363.anders@bostrom.dyndns.org> <20071002150748.906970bc.akpm@linux-foundation.org> <4702C756.8090108@redhat.com> <20071002162613.54c3ef43@laptopd505.fenrus.org> <4703D212.6040304@redhat.com> <alpine.LFD.0.999.0710031058320.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710031058320.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Without this, I can easily imagine that the rounding code tends to try to 
> round to an even second, and the load-average code generally also runs at 
> even seconds!
> 
> 		Linus
> 
> ---
>  include/linux/sched.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a01ac6d..643de0f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -113,7 +113,7 @@ extern unsigned long avenrun[];		/* Load averages */
>  
>  #define FSHIFT		11		/* nr of bits of precision */
>  #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
> -#define LOAD_FREQ	(5*HZ)		/* 5 sec intervals */
> +#define LOAD_FREQ	(5*HZ+1)	/* ~5 sec intervals */

not sure this is going to help; I mean, the load gets only updated in 
actual timer interrupts... and on a tickless system there's very few 
of those around..... and usually at places round_jiffies() already put 
a timer on.

(also.. one thing that might make Chuck's theory wrong is that the 
sampling code doesn't sample timer activity since that's run just 
after the sampler in the same irq)
