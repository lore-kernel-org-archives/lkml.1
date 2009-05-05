Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZEED7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZEED7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZEED7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:59:06 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45384 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZEED7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:59:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18943.47474.963294.862139@drongo.ozlabs.ibm.com>
Date: Tue, 5 May 2009 13:58:42 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: round-robining per-cpu counters
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It used to be, and as far as I can see still is, the case that per-cpu
counters take priority over per-task counters by virtue of being
scheduled in first.  That is, if you have N hardware counters and >= N
per-cpu counters, then no per-task counters will ever get scheduled
onto the PMU.

That being the case, I don't see what the point of having the
perf_reserved_percpu variable is.  It doesn't do anything except set
cpuctx->max_pertask, which isn't actually used anywhere.  In any case
with the current counter scheduling system there's no need to
"reserve" hardware counters for use by per-cpu counters since any new
per-cpu counters will just bump existing per-task counters off - if
not immediately then the next time that perf_counter_task_tick gets
called.

What was the intended meaning of perf_reserved_percpu?  I presume it
was that there would always be that many hardware counters available
for per-cpu counters regardless of how many per-task counters there
are.  But that doesn't answer the complementary question - how many
hardware counters can we rely on being available for per-task
counters?  At the moment the answer is 0, but I don't think that is a
good answer.

Does anyone have any good ideas about what the scheduling policy
should be?

Paul.
