Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZCJOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZCJOz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZCJOzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:55:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51526 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZCJOzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:55:11 -0400
Date: Tue, 10 Mar 2009 15:54:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090310145420.GJ3850@elte.hu>
References: <20090310135117.GC3850@elte.hu> <Pine.LNX.4.44L0.0903101019570.2962-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903101019570.2962-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 10 Mar 2009, Ingo Molnar wrote:
> 
> > 
> > There's also a few checkpatch warnings that need to be 
> > addressed:
> > 
> > ERROR: do not use assignment in if condition
> > #1084: FILE: arch/x86/kernel/ptrace.c:581:
> > +	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == 
> > NULL)
> 
> Changing this to remove the assignment from within the "if" 
> condition would make the code less readable, not more. [...]

It's not just about basic readability. We dont do assignmets 
like that because it's very easy to miss them (and their side 
effects) and conflating them with '=='.

  It's part of a long 
> series of tests; in schematic form:
> 
> 	if (n == 4 || n == 5)
> ...
> 	else if (n == 6) {
> ...
> 	}
> 	else if (!tsk->thread.hw_breakpoint_info && val == 0)
> ...
> 	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == NULL)
> ...
> 	else if (n < HB_NUM) {
> ...
> 	}
> 	else
> ...
> 
> If you can suggest a way to change the code without making it 
> worse, I'm sure Prasad will be happy to adopt it.

The obvious solution which we use in many other places in 
arch/x86 is to split out that butt-ugly if else if else if else 
maze into a helper inline function that does:

 	if (n == 4 || n == 5) {
		do stuff;
		return;
	}
		
 	if (n == 6) {
		do stuff;
		return;
 	}

	if (!tsk->thread.hw_breakpoint_info && val == 0) {
		do stuff;
		return;
	}

	thbi = alloc_thread_hw_breakpoint(tsk);

	if (!tbhi)
		...

	Ingo
