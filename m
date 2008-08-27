Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYH0L5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYH0L5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYH0L5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:57:43 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:44885 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754153AbYH0L5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:57:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0rsMrInFGo5I04sJsJV5pgWZI7PzOeJpWiclFb59/auen3e2ZpxTvoKso2SmqLa55H3gjE0e9UUpebtEPq0Qvtw71d8KXlkk+AQkgFEnlfPGVHQHJJxvpU38nAtskmODdhjkCaBFkv5ZAXZjeM3Q1Ns6x9C72I3WXJHzMu8t4C8=  ;
X-YMail-OSG: bQYs2iEVM1l3MIp9b13aXr9SVD9NwQQ28osua3SUK6vzBgFa2RHpXCCmjdDUNv8hvVegVKn73n_54fb8DKlRgRMOpu2Qgxtc1VkKCOLhA0IUM5SK0VH4UoN9RbWJEMFU9XA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 2/5] sched: pull only one task during NEWIDLE balancing to limit critical section
Date: Wed, 27 Aug 2008 21:57:34 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <200808271641.46359.nickpiggin@yahoo.com.au> <48B53F97.20101@novell.com>
In-Reply-To: <48B53F97.20101@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808272157.34494.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 21:50, Gregory Haskins wrote:
> Nick Piggin wrote:

> > I'm surprised 2 is too much but 1 is OK. Seems pretty fragile to me.
>
> Its not that 1 is magically "ok".  Its simply that newidle balancing
> hurts latency, and 1 is the minimum to pull to reasonably reduce the
> critical section.  I already check if we NEEDS_RESCHED before taking the
> rq->lock in newidle, so waiting for one task to pull is the first
> opportunity I have to end the section as quickly as possible.  It would
> be nice if I could just keep going if  I could detect whether there was
> not any real contention.  Let me  give this angle some more thought.

OK. Beware of introducing more cache coherency transitions, branches,
icache, etc. If you are already resigned to put some special cases under
CONFIG_PREEMPT, I think there is a lot to say for keeping the logic
really simple and correct even if there is a small expense to performance.

But of course I never object to speedups ;)


> > FWIW, if you haven't already, then for -rt you might want to look at a
> > more advanced data structure than simple run ordered list for moving
> > tasks from one rq to the other. A simple one I was looking at is a time
> > ordered list to pull the most cache cold tasks (and thus we can stop
> > searching when we encounter the first cache hot task, in situations where
> > it is appropriate, etc).
>
> Im not sure I follow your point, but if I do note that the RT scheduler
> uses a completely different load balancer (that is priority ordered).

You still use the normal scheduler for other tasks, though? At any
rate, no I haven't looked closely at the scheduler for a while, so
I'm quite likely to be talking nonsense.

