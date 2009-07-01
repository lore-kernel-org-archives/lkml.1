Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZGAJT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZGAJT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZGAJTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:19:18 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:46322 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbZGAJTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:19:17 -0400
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
In-Reply-To: <20090701075332.GA17252@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 01 Jul 2009 10:18:57 +0100
Message-Id: <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2009 09:18:58.0478 (UTC) FILETIME=[F6E99CE0:01C9FA2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 09:53 +0200, Ingo Molnar wrote:
> * Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > Gitweb:     http://git.kernel.org/linus/acf4968ec9dea49387ca8b3d36dfaa0850bdb2d5
> > Commit:     acf4968ec9dea49387ca8b3d36dfaa0850bdb2d5
> > Parent:     4698c1f2bbe44ce852ef1a6716973c1f5401a4c4
> > Author:     Catalin Marinas <catalin.marinas@arm.com>
> > AuthorDate: Fri Jun 26 17:38:29 2009 +0100
> > Committer:  Catalin Marinas <catalin.marinas@arm.com>
> > CommitDate: Fri Jun 26 17:38:29 2009 +0100
> > 
> >     kmemleak: Slightly change the policy on newly allocated objects
> 
> I think one of the kmemleak fixes that went upstream yesterday 
> caused the following scheduling-while-holding-the-tasklist-lock 
> regression/crash on x86:

Thanks for the patch. The bug was always there, only that the task stack
scanning is now enabled by default (and I probably have a small number
of tasks that the rescheduling didn't happen during stack scanning).

> The minimal fix below removes scan_yield() and adds a cond_resched() 
> to the outmost (safe) place of the scanning thread. This solves the 
> regression.

With CONFIG_PREEMPT disabled it won't reschedule during the bss scanning
but I don't see this as a real issue (task stacks scanning probably
takes longer anyway).

> The background scanning thread could probably also be reniced
> to +10.

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index e766e1d..6006553 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1039,6 +1039,7 @@ static int kmemleak_scan_thread(void *arg)
 	static int first_run = 1;
 
 	pr_info("Automatic memory scanning thread started\n");
+	set_user_nice(current, 10);
 
 	/*
 	 * Wait before the first scan to allow the system to fully initialize.

-- 
Catalin

