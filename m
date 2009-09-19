Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZISCQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZISCQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 22:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZISCQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 22:16:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:51838 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754598AbZISCQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 22:16:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18W2fxoesEWIULk6d6ItRrdoIJhGiEEuqCgExj8ov
	DN5dEtUGTeuDQH
Subject: Re: [PATCH] Prevent immediate process rescheduling
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Langsdorf <mark.langsdorf@amd.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1253304203.10538.64.camel@laptop>
References: <200909181449.12311.mark.langsdorf@amd.com>
	 <20090918195455.GC11726@elte.hu>  <1253304203.10538.64.camel@laptop>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 04:16:45 +0200
Message-Id: <1253326605.7133.55.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 22:03 +0200, Peter Zijlstra wrote:

> Really hate this change though,. doesn't seem right to not pick the same
> task again if its runnable. Bad for cache footprint.
> 
> The scenario is quite common for stuff like:
> 
> CPU0                                      CPU1
> 
> set_task_state(TASK_INTERRUPTIBLE)
> 
> if (cond)
>   goto out;
>                                      <--- ttwu()
> schedule();

It also resists the scheduler's built in need to close spread, too much
of which can seriously damage latency for others later when the friendly
task later decides it wants to run hard.  OTOH, when it is a voluntary
schedule, not selecting another task is resisting the programmer.

Conundrum.

Another problem with that change is that it doesn't do diddly spit if
the top two are trying to yield, they'll just spin together.

Sounds like Mark's case really needs a gentle_yield() that moves the
task behind next, and slightly beyond if they are too close, but which
also ignores the request entirely if the gap is too large.

	-Mike

