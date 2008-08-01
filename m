Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYHAILk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYHAILk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 04:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYHAILX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 04:11:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49941
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbYHAILW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 04:11:22 -0400
Date: Fri, 01 Aug 2008 01:11:22 -0700 (PDT)
Message-Id: <20080801.011122.32782916.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl
Subject: Re: [git pull] scheduler fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080731.155504.167792984.davem@davemloft.net>
References: <20080731.150457.77077498.davem@davemloft.net>
	<20080731222624.GA22426@elte.hu>
	<20080731.155504.167792984.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 31 Jul 2008 15:55:04 -0700 (PDT)

> I am absolutely sure, I spent the whole night yesterday trying to
> debug this.

Followup.  I lost two days of my life debugging this because seemingly
nobody can friggin' agree on what to do about the "printk() wakeup
issue".  Thanks!

Can we fix this now, please?

The problem was that Peter's patch triggers a print_deadlock_bug()
in lockdep.c on the runqueue locks.

But those printk()'s quickly want to do a wakeup, which wants to
take the runqueue lock this thread already holds.  So I would only
get the first line of the lockdep debugging followed by a complete
hang.

Doing these wakeups in such a BUG message is unwise.  Please can
we apply something like the following and save other developers
countless wasted hours of their time?

Thanks :-)

--------------------

debug_locks: Set oops_in_progress if we will log messages.

Otherwise lock debugging messages on runqueue locks can deadlock the
system due to the wakeups performed by printk().

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index 0ef01d1..0218b46 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -8,6 +8,7 @@
  *
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
+#include <linux/kernel.h>
 #include <linux/rwsem.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
@@ -37,6 +38,7 @@ int debug_locks_off(void)
 {
 	if (xchg(&debug_locks, 0)) {
 		if (!debug_locks_silent) {
+			oops_in_progress = 1;
 			console_verbose();
 			return 1;
 		}
