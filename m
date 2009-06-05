Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZFEEUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZFEEUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZFEEU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:20:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbZFEEU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:20:28 -0400
Date: Thu, 4 Jun 2009 21:20:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       andreas.herrmann3@amd.com, mingo@elte.hu
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
Message-Id: <20090604212018.b9e9f354.akpm@linux-foundation.org>
In-Reply-To: <200906050400.n5540Sx0052981@www262.sakura.ne.jp>
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp>
	<20090605023835.GA7933@cr0.nay.redhat.com>
	<20090604201733.746928c6.akpm@linux-foundation.org>
	<200906050339.n553d684048041@www262.sakura.ne.jp>
	<20090604205103.bbfe9af2.akpm@linux-foundation.org>
	<200906050400.n5540Sx0052981@www262.sakura.ne.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jun 2009 13:00:28 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> > Perhaps it's this:
> > 
> > static void __init memtest(u64 pattern, u64 start_phys, u64 size)
> > {
> > 	u64 i, count;
> > 	u64 *start;
> > 	u64 start_bad, last_bad;
> > 	u64 start_phys_aligned;
> > 	size_t incr;
> > 
> > 	incr = sizeof(pattern);
> > 	start_phys_aligned = ALIGN(start_phys, incr);
> > 	count = (size - (start_phys_aligned - start_phys))/incr;
> Bingo!

OK, thanks.  We should fix this for 2.6.30.

We could do the obvious:

--- a/arch/x86/mm/memtest.c~a
+++ a/arch/x86/mm/memtest.c
@@ -8,6 +8,7 @@
 #include <linux/pfn.h>
 
 #include <asm/e820.h>
+#include <asm/div64.h>
 
 static u64 patterns[] __initdata = {
 	0,
@@ -48,7 +49,8 @@ static void __init memtest(u64 pattern, 
 
 	incr = sizeof(pattern);
 	start_phys_aligned = ALIGN(start_phys, incr);
-	count = (size - (start_phys_aligned - start_phys))/incr;
+	count = size - (start_phys_aligned - start_phys);
+	do_div(count, incr);
 	start = __va(start_phys_aligned);
 	start_bad = 0;
 	last_bad = 0;
_

but I wonder why all those things are u64.  They all hold virtual
addresses, don't they?  The code doesn't test highmem.  So shouldn't
these all be unsigned longs?


