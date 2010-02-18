Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab0BRQcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:32:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536Ab0BRQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:32:29 -0500
Date: Thu, 18 Feb 2010 08:31:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Johannes Berg <johannes@sipsolutions.net>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
In-Reply-To: <1266485775.6539.6.camel@jlt3.sipsolutions.net>
Message-ID: <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
References: <1264740107.20211.53.camel@pasglop> <1266485775.6539.6.camel@jlt3.sipsolutions.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Feb 2010, Johannes Berg wrote:
> >  
> > Basically, the machine deadlocks right after printing the following
> > when doing a shutdown:
> > 
> > halt/4071 is trying to acquire lock:
> >  (s_active){++++.+}, at: [<c0000000001ef868>]
> > .sysfs_addrm_finish+0x58/0xc0
> > 
> > but task is already holding lock:
> >  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c0000000004cd6ac>]
> > .lock_policy_rwsem_write+0x84/0xf4
> > 
> > which lock already depends on the new lock.

You don't have a full backtrace for these things?

We've had lots of trouble with the cpu governors, and I suspect the 
problem isn't new, but the lockdep warning is likely new (see commit 
846f99749ab68bbc7f75c74fec305de675b1a1bf: "sysfs: Add lockdep annotations 
for the sysfs active reference").

So it is likely to be an old issue that (a) now gets warned about and (b) 
might have had timing changes enough to trigger it.

I suspect it is G5-specific (or specific to whatever CPU frequency code 
that gets used there), since I think we'd have had lots of reports if this 
happened on x86.

		Linus
