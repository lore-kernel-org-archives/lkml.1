Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbYJVNio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbYJVNio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYJVNif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:38:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60550 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYJVNif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:38:35 -0400
Message-ID: <48FF2DDC.5010600@gmail.com>
Date: Wed, 22 Oct 2008 09:42:52 -0400
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: sched: deep power-saving states
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,
  I was giving some thought to that topic you brought up at our
LF-end-user session on RT w.r.t. deep power state wakeup adding latency.

As Steven mentioned, we currently have this thing called "cpupri"
(kernel/sched_cpupri.c) in the scheduler which allows us to classify
each core (on a per disjoint cpuset basis) as being either IDLE,
SCHED_OTHER, or RT1 - RT99.  (Note that currently we lump both IDLE and
SCHED_OTHER together as SCHED_OTHER because we don't yet care to
differentiate between them, but I have patches to fix this that I can
submit).

What I was thinking is that a simple mechanism to quantify the
power-state penalty would be to add those states as priority levels in
the cpupri namespace.  E.g. We could substitute IDLE-RUNNING for IDLE,
and add IDLE-PS1, IDLE-PS2, .. IDLE-PSn, OTHER, RT1, .. RT99.  This
means the scheduler would favor waking an IDLE-RUNNING core over an
IDLE-PS1-PSn, etc.  The question in my mind is: can the power-states be
determined in a static fashion such that we know what value to quantify
the idle state before we enter it?  Or is it more dynamic (e.g. the
longer it is in an MWAIT, the deeper the sleep gets).

If its dynamic, is there a deterministic algorithm that could be applied
so that, say, a timer on a different CPU (bsp makes sense to me) could
advance the IDLE-PSx state in cpupri on behalf of the low-power core as
time goes on?

Thoughts?
-Greg
