Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYFEQmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYFEQmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYFEQmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:42:03 -0400
Received: from saeurebad.de ([85.214.36.134]:33046 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbYFEQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:42:01 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
References: <20080605115235.6453.E1E9C6FF@jp.fujitsu.com>
	<87abi0semc.fsf@saeurebad.de>
	<20080605170323.645F.E1E9C6FF@jp.fujitsu.com>
Date: Thu, 05 Jun 2008 18:41:11 +0200
In-Reply-To: <20080605170323.645F.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
	message of "Thu, 05 Jun 2008 17:31:50 +0900")
Message-ID: <87zlpz6di0.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

> I gotcha!  :-)
>
>  	max -= PFN_DOWN(bdata->node_boot_start);
>  	start -= PFN_DOWN(bdata->node_boot_start);
> +	fallback -= PFN_DOWN(bdata->node_boot_start);
>  
>  	if (bdata->last_success > start) {
> -		/* Set goal here to trigger a retry on failure */
> -		start = goal = ALIGN(bdata->last_success, step);
> +		fallback = start; -------------------------------- (*)
> +		start = ALIGN(bdata->last_success, step);
>  	}
>
> (*) is root cause. "fallback" is set as 0, because start is index of bitmap
> at here. When normal zone is allocated first, and DMA zone is required by
> alloc_bootmem_low() later and first page is free yet, fallback is set as 0.
>
> +	if (fallback) {
> +		start = ALIGN(fallback, step);
> +		fallback = 0;
> +		goto find_block;
> +	}
> +
>
> As a result, this retry code is skipped, and alloc_bootmem_low() fails. 
> So, when I change here from fallback to a retry_flag, my box can boot
> up.

Ah, you got there too :-)

Here is the original Email I wrote but waited to send out until after I
slept:

---

Hi Yasunori,

here is hopefully the fix to your bootup problem.  Let me explain:

This is the last but one bootmem allocation on your box:

Jun  5 11:50:43 localhost kernel: bootmem::alloc_bootmem_core nid=0 size=40000 [16 pages] align=80 goal=100000000 limit=0
Jun  5 11:50:43 localhost kernel: bootmem::__reserve nid=0 start=1020588 end=1020598 flags=1

(->last_success is at 1020588 now)

And this is the last one:

Jun  5 11:50:43 localhost kernel: bootmem::alloc_bootmem_core nid=0 size=8000 [2 pages] align=80 goal=0 limit=ffffffff

Goal is zero.  So sidx is set to zero as well.  last_success is bigger
than sidx, so fallback gets the value of sidx and sidx is updated to
last_succes.  But now sidx (1020588) is bigger than the limit (3ffff)
and we fail the first search iteration because of that.  We should
fall back to the original sidx stored in fallback now but take a look
at what value fallback must have for this branch to be taken...

I am pretty sure this is the bug you encountered.  I spotted it in the
code but your logfile proves my theory. 

	Hannes

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -444,7 +444,11 @@ static void * __init alloc_bootmem_core(
 	midx = max - PFN_DOWN(bdata->node_boot_start);
 
 	if (bdata->last_success > sidx) {
-		fallback = sidx;
+		/*
+		 * Handle the valid case of sidx being zero and still
+		 * catch the fallback below.
+		 */
+		fallback = sidx + 1;
 		sidx = ALIGN(bdata->last_success, step);
 	}
 
@@ -493,7 +497,7 @@ find_block:
 	}
 
 	if (fallback) {
-		sidx = ALIGN(fallback, step);
+		sidx = ALIGN(fallback - 1, step);
 		fallback = 0;
 		goto find_block;
 	}
