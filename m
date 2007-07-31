Return-Path: <linux-kernel-owner+w=401wt.eu-S967408AbXGaEbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967408AbXGaEbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940789AbXGaE3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:29:49 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42256 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177AbXGaE3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:29:48 -0400
Date: Mon, 30 Jul 2007 21:31:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       kuznet@ms2.inr.ac.ru, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 04/26] rt-mutex: Fix chain walk early wakeup bug
Message-ID: <20070731043130.GE3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rt-mutex-fix-chain-walk-early-wakeup-bug.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

Alexey Kuznetsov found some problems in the pi-futex code. 

One of the root causes is:

When a wakeup happens, we do not to stop the chain walk so we
we follow a non existing locking chain.

Drop out when this happens.

Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/rtmutex.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- linux-2.6.21.6.orig/kernel/rtmutex.c
+++ linux-2.6.21.6/kernel/rtmutex.c
@@ -212,6 +212,19 @@ static int rt_mutex_adjust_prio_chain(st
 	if (!waiter || !waiter->task)
 		goto out_unlock_pi;
 
+	/*
+	 * Check the orig_waiter state. After we dropped the locks,
+	 * the previous owner of the lock might have released the lock
+	 * and made us the pending owner:
+	 */
+	if (orig_waiter && !orig_waiter->task)
+		goto out_unlock_pi;
+
+	/*
+	 * Drop out, when the task has no waiters. Note,
+	 * top_waiter can be NULL, when we are in the deboosting
+	 * mode!
+	 */
 	if (top_waiter && (!task_has_pi_waiters(task) ||
 			   top_waiter != task_top_pi_waiter(task)))
 		goto out_unlock_pi;

-- 
