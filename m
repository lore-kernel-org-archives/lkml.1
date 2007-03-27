Return-Path: <linux-kernel-owner+w=401wt.eu-S934222AbXC0W2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222AbXC0W2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934231AbXC0W2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:28:39 -0400
Received: from 49.sub-75-208-212.myvzw.com ([75.208.212.49]:55530 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934222AbXC0W2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:28:38 -0400
Message-Id: <20070327214919.800272641@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Mar 2007 14:49:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Prarit Bhargava <prarit@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 0/4] Revised softlockup watchdog improvement patches
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series of patches implements a number of improvements to the
softlockup watchdog and its users.

They are:

1. Make the watchdog ignore stolen time

When running under a hypervisor, the kernel may lose an arbitrary amount
of time as "stolen time".  This may cause the softlockup watchdog to
trigger spruiously.  Xen and VMI implement sched_clock() as measuring
unstolen time, so use that as the timebase for the softlockup watchdog.
This also removes a dependency on jiffies.

2. Add a per-cpu enable flag for the watchdog

When the scheduler disables ticks for a specific CPU, this allows the
watchdog to be disabled as well.  This avoids spurious watchdog errors
if a CPU has been tickless for a long time.  The existing tick-sched.c
code tried to address this by periodically touching the watchdog, but
this seems more direct.

3. Use the per-cpu enable flags to temporarily disable the watchdog

Some drivers perform long operations which will cause the watchdog to
time out.  If we know we're about to start such an operation, disable
the watchdog timer for the interim.  This is more straightforward than
trying to periodically tickle the watchdog timer during the operation, and
safer than just doing it once at the start and hoping there's enough time.

4. Add a global disable flag

Sometimes a long operation will affect all CPUs' ability to tickle the
watchdog timer.  An obvious example is suspend/resume, but it can also
happen while generating lots of sysrq output, or other specialized
operations.  Add global enable/disable calls to deal with these case.

-- 

