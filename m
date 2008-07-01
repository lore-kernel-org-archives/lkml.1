Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYGAF2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYGAF2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 01:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYGAF2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 01:28:23 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:40212 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750872AbYGAF2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 01:28:22 -0400
Date: Tue, 1 Jul 2008 14:25:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Hideo Saito <saito@densan.co.jp>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: follow_page() performance regressions
Message-ID: <20080701052543.GA4726@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Hideo Saito <saito@densan.co.jp>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20080701.132439.68562265.saito@densan.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701.132439.68562265.saito@densan.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Linus and l-k to Cc..)

On Tue, Jul 01, 2008 at 01:24:39PM +0900, Hideo Saito wrote:
> I have a question as to performance of kernel on linux-2.6.25.9, but
> this may be off-topic, because the problem is not related to the SH
> architecture directly.
> 
> When I tested Hackbench benchmark test on our platform(SH7780, 400MHz),
> the performance decreases as follows.
> 
> The result on linux-2.6.25.9:
> #tcsh> ./hackbench 40 ; time ./hackbench 40 ; time ./hackbench 40
> Time: 69.858
> Time: 69.810
> Time: 70.356
> 
> The result on linux-2.6.25.8:
> #tcsh> ./hackbench 40 ; time ./hackbench 40 ; time ./hackbench 40
> Time: 65.353
> Time: 65.622
> Time: 65.413
> 
> I confirmed that the cause is in the following changes. Isn't this
> decrease of performance avoided, though it seems that this code is
> changed in order to handle ZERO_PAGE?
> 
> --- a/mm/memory.c
> +++ b/mm/memory.c
>     pte = *ptep;
>     if (!pte_present(pte))
> -       goto unlock;
> +       goto no_page;
>     if ((flags & FOLL_WRITE) && !pte_write(pte))
>         goto unlock;
>     page = vm_normal_page(vma, address, pte);
>     if (unlikely(!page))
> -       goto unlock;
> +       goto bad_page;
> 
>     if (flags & FOLL_GET)
>         get_page(page);

git blame points to:

commit 89f5b7da2a6bad2e84670422ab8192382a5aeb9f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jun 20 11:18:25 2008 -0700

    Reinstate ZERO_PAGE optimization in 'get_user_pages()' and fix XIP

...

So yes, the ZERO_PAGE handling in follow_page() is causing the slow-down here.
