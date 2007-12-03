Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbXLCRiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbXLCRiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXLCRiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:38:13 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:51945 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbXLCRiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:38:12 -0500
Message-ID: <47543EEC.7010900@nortel.com>
Date: Mon, 03 Dec 2007 11:37:48 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: davids@webmaster.com
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
References: <MDEHLPKNGKAHNMBLJOLKOEGJIJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEGJIJAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2007 17:37:52.0563 (UTC) FILETIME=[3B148030:01C835D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
> 	I've asked versions of this question at least three times and never gotten
> anything approaching a straight answer:
> 
> 	1) What is the current default 'sched_yield' behavior?
> 
> 	2) What is the current alternate 'sched_yield' behavior?

I'm pretty sure I've seen responses from Ingo describing this multiple 
times in various threads.  Google should have them.

If I remember right, the default is to simply recalculate the task's 
position in the tree and reinsert it, and the alternate is to yield to 
everything currently runnable.

> 	3) Are either of them sensible? Simply acting as if the current thread's
> timeslice was up should be sufficient.

The new scheduler doesn't really have a concept of "timeslice".  This is 
one of the core problems with determining what to do on sched_yield().

> 	The implication I keep getting is that neither the default behavior nor the
> alternate behavior are sensible. What is so hard about simply scheduling the
> next thread?

The problem is where do we insert the task that is yielding?  CFS is 
based around a tree structure ordered by time.

The old scheduler was priority-based, so you could essentially yield to 
everyone of the same niceness level.

With the new scheduler, this would be possible, but would involve extra 
work tracking the position of the rightmost task at each priority level. 
  This additional overhead is what Ingo is trying to avoid.

> 	We don't need perfection, but it sounds like we have two alternatives of
> which neither is sensible.

sched_yield() isn't a great API.  It just says to delay the task, 
without specifying how long or what the task is waiting *for*.  Other 
constructs are much more useful because they give the scheduler more 
information with which to make a decision.

Chris
