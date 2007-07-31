Return-Path: <linux-kernel-owner+w=401wt.eu-S941023AbXGaEav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941023AbXGaEav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759708AbXGaE3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:29:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42245 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940778AbXGaE3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:29:45 -0400
Date: Mon, 30 Jul 2007 21:31:24 -0700
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
Subject: [patch 03/26] rt-mutex: Fix stale return value
Message-ID: <20070731043124.GD3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rt-mutex-fix-stale-return-value.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

Alexey Kuznetsov found some problems in the pi-futex code. 

The major problem is a stale return value in rt_mutex_slowlock():

When the pi chain walk returns -EDEADLK, but the waiter was woken up 
during the phases where the locks were dropped, the rtmutex could be
acquired, but due to the stale return value -EDEADLK returned to the
caller.

Reset the return value in the woken up path.

Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/rtmutex.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-2.6.21.6.orig/kernel/rtmutex.c
+++ linux-2.6.21.6/kernel/rtmutex.c
@@ -659,9 +659,16 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 			 * all over without going into schedule to try
 			 * to get the lock now:
 			 */
-			if (unlikely(!waiter.task))
+			if (unlikely(!waiter.task)) {
+				/*
+				 * Reset the return value. We might
+				 * have returned with -EDEADLK and the
+				 * owner released the lock while we
+				 * were walking the pi chain.
+				 */
+				ret = 0;
 				continue;
-
+			}
 			if (unlikely(ret))
 				break;
 		}

-- 
