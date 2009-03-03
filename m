Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbZCCADN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbZCCADN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbZCCACz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:02:55 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43303 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236AbZCCACy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:02:54 -0500
Message-ID: <49AC73A9.4040804@us.ibm.com>
Date: Mon, 02 Mar 2009 16:02:49 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [TIP][RFC 0/7] requeue pi implemenation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is v5 of the requeue_pi patches against
linux-2.6-tip/core/futexes.  The current futex implementation doesn't
allow for requeueing of PI futexes, which leads to a thundering herd
during pthread_cond_broadcast (as opposed to a civilized priority
ordered wakeup sequence).  The core of the problem is that the
underlying rt_mutex can not be left with waiters and no owner (which
would break the PI logic).  This patch series updates the futex requeue
code to allow for requeueing from non-pi to pi futexes in support of PI
aware pthread_cond_* calls along with some needful rt_mutex helper
routines.  The credit for the design goes to Thomas Gleixner, while the
bugs and other idiocies present in this implementation should be
attributed to me.

I'd really appreciate feedback on the implementation as well as any
design critiques.  Answers to the questions posed in the patch headers
and patches are particularly welcome.

This patch series has a known race condition that I'm currently
debugging (see 5/7), as well as notes, questions and FIXMEs in the
comments. These will be resolved and removed prior to submission

Each patch contains some documentation, but the bulk of the general
approach is outlined in 6/7.

Darren Hart (6):
    RFC: futex: add requeue_pi calls
    RFC: rt_mutex: add proxy lock routines
    RFC: futex: finish_futex_lock_pi()
    RFC: futex: futex_lock_pi_atomic()
    RFC: futex: futex_top_waiter()
    RFC: futex: futex_wait_queue_me()

$ git diff HEAD~6 | diffstat
include/asm-generic/errno.h |    2 
include/linux/futex.h       |    8 
include/linux/thread_info.h |    4 
kernel/futex.c              | 1205 +++++++++++++++++++++++++++++++++-----------
kernel/rtmutex.c            |  192 +++++--
kernel/rtmutex_common.h     |    8 
6 files changed, 1104 insertions(+), 315 deletions(-)

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team


