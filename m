Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbXHWT0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbXHWT0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbXHWT0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:26:41 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:22261 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbXHWT0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:26:40 -0400
Message-Id: <200708232126.36475.borntraeger@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 23 Aug 2007 21:26:36 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Glauber <jan.glauber@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/2] s390 related scheduler patches and questions
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Thanks you for applying the accouting fix.

I looked into Jans sched_clock prototype, and 
here is an update for sched_clock on s390. This patch applies on
current git, but should not go in before 2.6.23 as this change
is not trivial. The patch itself is independent from other patches
and survived my tests. The current approach is to have a
monotonic timer, that is only increased if the cpu is backed by
a real cpu. If idle, the sched_clock does not increase. The last
discussion did not result in a statement, if that is ok for you.

I tried to make the accouting work without the array.c patch I posted
recently. Therefore, I added a second patch that removes a sanity
checkin the scheduler (already seen). The patch is probably nothing for 
upstream but with this patch the accouting for s390 seems to work
regarding steal time, even without CONFIG_VIRT_CPU_TIME (as long as 
CONFIG_VIRT_TIMER is set). You wrote this part is necessary for broken
TSCs on x86.
Unfortunately, we currently call scheduler tick using the
tod clock and not the virtual clock and a change would take some time.
Removing this specific check seems to help. Will it break anything?

Would you accept a patch, that removes checks and let architecture code 
sanitize broken hardware values? That would allow non-broken timers to 
directly report to the scheduler.

Another question:

nanosecond resolution seems not ideal for 64bit values, at least
if an architecture has to do calculations. For example our cpu timer
is signed 64bit and bit 51 (63=LSB) steps by one each microsecond.
To create a nanosecond based timer we need: nsecs= clock*125/512 or
nsecs = clock/512*125. The first variant overflows in a time frame
that is  still reasonable to be seen in practice (about 2 years if I
made no errors), the second variant introduces a stepping rate of 125ns.
Of course we could use nsec = (((((((clock/8)*5)/4)*5)/4)*5)/4), to have
a long overflow period and a 1.25ns stepping rate but this looks
quite ugly.
Are you going to stick with nanosecond resolution? If yes, do you think
a stepping rate of 125ns is ok? Any chance to change the scheduler 
resolution to microseconds? ;-)


Christian
