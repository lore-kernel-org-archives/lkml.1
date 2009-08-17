Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZHQIRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZHQIRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbZHQIRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:17:33 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:24117 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370AbZHQIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:17:31 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: Check task on counter read IPI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <19076.63614.277861.368125@drongo.ozlabs.ibm.com>
References: <19076.63614.277861.368125@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 10:16:56 +0200
Message-Id: <1250497016.5241.1675.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 15:39 +1000, Paul Mackerras wrote:
> In general, code in perf_counter.c that is called through an IPI
> checks, for per-task counters, that the counter's task is still the
> current task.  This is to handle the race condition where the cpu
> switches from the task we want to another task in the interval between
> sending the IPI and the IPI arriving and being handled on the target
> CPU.
> 
> For some reason, __perf_counter_read is missing this check, yet there
> is no reason why the race condition can't occur.  This adds a check
> that the current task is the one we want.  If it isn't, we just
> return.  In that case the counter->count value should be up to date,
> since it will have been updated when the counter was scheduled out,
> which must have happened since the IPI was sent.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> I don't have an example of an actual failure due to this race, but it
> seems obvious that it could occur and we need to guard against it, so
> I think this should go in .31.

Hmm, right.

However those other sites have retry loops in the caller, but callers of
__perf_counter_read() do not. Granted, I'm not sure what they should
retry on exactly, but this patch trades an invalid update to a missing
update.

While I think the balance tips towards favouring the missing update, its
not really much of an improvement.

I guess we could keep a sequence count with the update and loop until it
gets increased or something?


