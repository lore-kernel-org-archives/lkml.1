Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbXDUQfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbXDUQfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXDUQfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:35:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627AbXDUQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:35:42 -0400
Date: Sat, 21 Apr 2007 09:34:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
In-Reply-To: <20070421161818.GC7840@1wt.eu>
Message-ID: <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
 <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Apr 2007, Willy Tarreau wrote:
> 
> If you remember, with 50/50, I noticed some difficulties to fork many
> processes. I think that during a fork(), the parent has a higher probability
> of forking other processes than the child. So at least, we should use
> something like 67/33 or 75/25 for parent/child.

It would be even better to simply have the rule:
 - child gets almost no points at startup
 - but when a parent does a "waitpid()" call and blocks, it will spread 
   out its points to the childred (the "vfork()" blocking is another case 
   that is really the same).

This is a very special kind of "priority inversion" logic: you give higher 
priority to the things you wait for. Not because of holding any locks, but 
simply because a blockign waitpid really is a damn big hint that "ok, the 
child now works for the parent".

		Linus
