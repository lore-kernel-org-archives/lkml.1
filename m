Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZFEDvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZFEDvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZFEDvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:51:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255AbZFEDvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:51:14 -0400
Date: Thu, 4 Jun 2009 20:51:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
Message-Id: <20090604205103.bbfe9af2.akpm@linux-foundation.org>
In-Reply-To: <200906050339.n553d684048041@www262.sakura.ne.jp>
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp>
	<20090605023835.GA7933@cr0.nay.redhat.com>
	<20090604201733.746928c6.akpm@linux-foundation.org>
	<200906050339.n553d684048041@www262.sakura.ne.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jun 2009 12:39:06 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Andrew Morton wrote:
> > Do
> > 
> > 	make arch/x86/mm/pageattr.s
> > 
> > then have a look in pageattr.s to find the __udivdi3 callsite.
> > 
> > It might not even be in arch/x86/mm/pageattr.o at all.  If not, keep
> > building .s files in that directory until you find it.
> > 
> > Building with CONFIG_DEBUG_INFO=1 will allow you to find the exact C
> > file-n-line where the __udivdi3() call is being emmitted (look at the
> > .loc lines).
> 
> $ make -k CONFIG_DEBUG_INFO=1 `echo arch/x86/mm/*.c | sed -e 's/\.c/.s/g'`
> (...snipped...)
> $ grep __udivdi3 arch/x86/mm/*.s
> arch/x86/mm/memtest.s:.globl __udivdi3
> arch/x86/mm/memtest.s:  call    __udivdi3

Well, that tells us the .c file, but not the location within it. 
Please check the .loc info as I suggested.

Perhaps it's this:

static void __init memtest(u64 pattern, u64 start_phys, u64 size)
{
	u64 i, count;
	u64 *start;
	u64 start_bad, last_bad;
	u64 start_phys_aligned;
	size_t incr;

	incr = sizeof(pattern);
	start_phys_aligned = ALIGN(start_phys, incr);
	count = (size - (start_phys_aligned - start_phys))/incr;


