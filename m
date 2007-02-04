Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbXBDUd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbXBDUd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXBDUd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:33:29 -0500
Received: from mail.screens.ru ([213.234.233.54]:55153 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXBDUd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:33:28 -0500
Date: Sun, 4 Feb 2007 23:33:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] workqueue: don't migrate pending works from the dead CPU
Message-ID: <20070204203305.GA225@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please drop the workqueue-rework-threads-hotplug-management.patch,
and please take this one (feel free to just kill me instead).

We have workqueue callbacks (slab for example) which assume that CPU is
stable during the execution since cwq->thread is pinned to a processor.
With or without that patch this is not true with CONFIG_HOTPLUG_CPU, and
the problem is not connected to workqueue.c.

However, my patch makes the things worse, because CPU_UP_PREPARE creates
cwq->thread which is not pinned to CPU until CPU_ONLINE. This is solvable,
but needs a serious complication, so this patch can't be considered as a
cleanup.

The new patch removes take_over_work() and friends (as the old one did),
but retains an unfortunate property of the current implementation: the
workqueue_mutex is held from CPU_LOCK_ACQUIRE to CPU_LOCK_RELEASE, and
CPU_DEAD stops cwq->thread synchronously.

This means that cpu-hotplug callbacks can't create/destroy workqueues
(Gautham needs this?), and work->func() can't share a lock with cpu hotplug.
May be we can change this later, but this needs a separate patch.

Srivatsa, do you have any objections?

The new patch is very similar (in fact, a subset), I don't send incremental
update because this will break changelogs.

Oleg.

