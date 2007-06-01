Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbXFAWgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbXFAWgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXFAWgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:36:24 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:50638 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbXFAWgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:36:24 -0400
Subject: [PATCH RT] add might_sleep in rt_spin_lock_fastlock
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-jgTmng/RcFNHiVaU9w/Z"
Date: Fri, 01 Jun 2007 18:35:21 -0400
Message-Id: <1180737321.21781.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jgTmng/RcFNHiVaU9w/Z
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Ingo,

Every so often we get bit by a bug "scheduling in atomic", and it comes
from a rtmutex spin_lock.  The bug only happens when that lock has
contention, so we miss it a lot.

This patch adds a might_sleep() to the rt_spin_lock_fastlock to find
bugs where we can schedule in atomic.

The one place that exists now is from do_page_fault and sending a
signal.  I wrote a simple crash program that segfaults (attached) and
with this patch, I get the warning.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rt9/kernel/rtmutex.c
===================================================================
--- linux-2.6.21-rt9.orig/kernel/rtmutex.c
+++ linux-2.6.21-rt9/kernel/rtmutex.c
@@ -602,6 +602,8 @@ static inline void
 rt_spin_lock_fastlock(struct rt_mutex *lock,
 		void fastcall (*slowfn)(struct rt_mutex *lock))
 {
+	might_sleep();
+
 	if (likely(rt_mutex_cmpxchg(lock, NULL, current)))
 		rt_mutex_deadlock_account_lock(lock, current);
 	else


--=-jgTmng/RcFNHiVaU9w/Z
Content-Disposition: attachment; filename=crashme.c
Content-Type: text/x-csrc; name=crashme.c; charset=us-ascii
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int argc, char **argv)
{
	unsigned long *p = (void*)-1;

	printf("crashing...\n");

	/* nighty night */
	*p = 0xbed;

	printf("did we crash??\n");	
	return 0;
}

--=-jgTmng/RcFNHiVaU9w/Z--

