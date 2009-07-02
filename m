Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZGBRKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZGBRKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZGBRKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:10:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbZGBRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:10:34 -0400
Date: Thu, 2 Jul 2009 10:10:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Pavel Levshin <lpk@581.spb.su>, wli@movementarian.org,
       Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: fio mmap sequential read 30% regression
In-Reply-To: <1246521682.2560.490.camel@ymzhang>
Message-ID: <alpine.LFD.2.01.0907020956410.4830@localhost.localdomain>
References: <1246521682.2560.490.camel@ymzhang>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Jul 2009, Zhang, Yanmin wrote:
> 
> Bisect down to below patch.
> 
> ef00e08e26dd5d84271ef706262506b82195e752 ("readahead: clean up and 
> simplify the code for filemap page fault readahead")
> 
> The bisect is stable.

Hmm. That patch is the one patch in the whole series that should _not_ 
have changed any behavior, but it got forward-ported by something like 8 
months, so maybe something changed in the meantime.

Also, I do think it changes the exact details of "ra->mmap_miss" (along 
with the fault counters). The old code was really quite odd in the 
statistics department, and would do some odd things wrt the miss counts 
and statistics - because it had this re-try loop that essentially updated 
the stats twice (once on the first try, and then once more when doing the 
"retry_find" thing).

The patch gets rid of the hard-to-follow retry logic (it had that 
"did_readaround" logic to determine if it was on the first loop or the 
second one, and used those _sometimes_), and should _fix_ those stats, but 
obviously all historical tuning had happened with the old stats. So it's 
entirely possible that as part of "fixing" them, I actually broke what the 
old logic tried to do.

There's also one _intentional_ change: the new code doesn't take the lock 
on the page before it starts async read-ahead. That can certainly change 
timings a lot. It _should_ cause better behavior (more IO overlap), but 
depending on read-ahead code and the exact behavior of your IO subsystem, 
maybe it causes you problems.

But it is also possible that the patch simply changes behavior in 
unintended ways. Either originally, or due to being forward-ported with 
all the other read-ahead changes. I'm not seeing it, though - the patch 
still looks like it shouldn't change any semantics.

			Linus
