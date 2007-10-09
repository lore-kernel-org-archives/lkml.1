Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbXJIPA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbXJIPA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbXJIPAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:00:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44548 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXJIPAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:00:48 -0400
Subject: Re: [PATCH 0/5] RT: scheduler fixes and rt_overload enhancements
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, linux-rt-users@vger.kernel.org, rostedt@goodmis.org,
       kravetz@us.ibm.com, linux-kernel@vger.kernel.org, pmorreale@novell.com,
       sdietrich@novell.com
In-Reply-To: <20071009142044.4941.65189.stgit@novell1.haskins.net>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 17:00:29 +0200
Message-Id: <1191942029.6848.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 10:25 -0400, Gregory Haskins wrote:
> Hi All,
> 
> The first two patches are from Mike and Steven on LKML, which the rest of my
> series is dependent on.  Patch #4 is a resend from earlier.
> 
> Series Summary:
> 
> 1) Send IPI on overload regardless of whether prev is an RT task
> 2) Set the NEEDS_RESCHED flag on reception of RESCHED_IPI
> 3) Fix a mistargeted IPI on overload
> 4) Track which CPUS are in overload for efficiency
> 5) Track which CPUs are eligible for rebalancing for efficiency
> 
> These have been built and boot-tested on a 4-core Intel system.

Ok, I'm not liking these.

I really hate setting TIF_NEED_RESCHED from the IPI handler. Also, I
don't see how doing a resched pulls tasks to begin with.

How about keeping a per rq variable that indicates the highest priority
of runnable tasks. And on forced preemption look for a target rq to send
your last highest task to.

There is no need to broadcast rebalance, that will only serialise on the
local rq lock again. So pick a target rq, and stick with that.

Also, I think you meant to use cpus_and() with the rto and allowed
masks.

