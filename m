Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZHJP4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZHJP4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZHJP4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:56:03 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49078 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381AbZHJP4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:56:01 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090802111453.GA24927@elte.hu>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
	 <20090802111453.GA24927@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 10 Aug 2009 16:55:18 +0100
Message-Id: <1249919718.10848.55.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2009 15:55:19.0356 (UTC) FILETIME=[F5F19FC0:01CA19D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, 2009-08-02 at 13:14 +0200, Ingo Molnar wrote:
> hm, some recent kmemleak patch is causing frequent hard and 
> soft lockups in -tip testing (-rc5 based).

Thanks for reporting this. It shouldn't be caused by the patch mentioned
in the subject as this only deals with reading the seq file which
doesn't seem to be the case here.

Would enabling CONFIG_PREEMPT make a difference?

> The pattern is similar: the kmemleak thread keeps spinning 
> in scan_objects() and never seems to finish:
> 
> [  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
> [  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
> [  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
> [  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
> [  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
> [  177.093253]  [<ffffffff82d2b560>] ? page_fault+0x0/0x30
> [  177.093253]  <<EOE>>  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
> [  177.093253]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
> [  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
> [  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
> [  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
> [  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
> [  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0

I'm not sure exactly which scan_block call (or calls) is locked up.
Usually the task stacks scanning may take a significant amount of time
with the tasklist_lock held. You can disable this by echoing stack=off
to the /sys/kernel/debug/kmemleak file. The kmemleak branch currently
merged in -next avoids this problem by treating task stacks as any other
allocated object (top two commits at
http://www.linux-arm.org/git?p=linux-2.6.git;a=shortlog;h=kmemleak and
maybe the one called "Allow rescheduling during an object scanning").

There is also commit 2587362eaf5c which keeps scanning newly allocated
objects several times but there are cond_resched() calls and shouldn't
look like a lockup, unless some list gets corrupted and become circular.
Does the patch below make any difference:

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4872673..c192c57 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1076,8 +1076,7 @@ repeat:
 		object = tmp;
 	}
 
-	if (scan_should_stop() || ++gray_list_pass >= GRAY_LIST_PASSES)
-		goto scan_end;
+	goto scan_end;
 
 	/*
 	 * Check for new objects allocated during this scanning and add them

> Yesterday i let one of the testboxes run overnight in this 
> state and it never recovered from the lockup.

What other tests are run on such testbox when kmemleak locks up? Are
there lots of processes created or modules loaded/unloaded frequently?

Sorry for asking more questions than providing solutions but I cannot
currently reproduce the lockup (short lockups yes, but not a permanent
one). If you have time, maybe you could just merge the "kmemleak" branch
from git://linux-arm.org/linux-2.6.git and see whether it improves
things.

Thanks.

-- 
Catalin

