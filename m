Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYKEN1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYKEN1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYKEN1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:27:23 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:40738 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbYKEN1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:27:22 -0500
From: Sripathi Kodi <sripathik@in.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Inline double_unlock_balance()
Date: Wed, 5 Nov 2008 18:57:14 +0530
User-Agent: KMail/1.9.9
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811051857.14944.sripathik@in.ibm.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a test case which measures the variation in the amount of time 
needed to perform a fixed amount of work on the preempt_rt kernel. We 
started seeing deterioration in it's performance recently. The test 
should never take more than 10 microseconds, but we started 5-10% 
failure rate. Using elimination method, we traced the problem to commit 
1b12bbc747560ea68bcc132c3d05699e52271da0 (lockdep: re-annotate 
scheduler runqueues). When LOCKDEP is disabled, this patch only adds an 
additional function call to double_unlock_balance(). Hence I inlined 
double_unlock_balance() and the problem went away. Here is a patch to 
make this change.

Thanks,
Sripathi.

lockdep: Inline double_unlock_balance()

Additional function call for double_unlock_balance() causes latency 
problems for some test cases on the preempt_rt kernel.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

Index: linux-2.6.27.4/kernel/sched.c
===================================================================
--- linux-2.6.27.4.orig/kernel/sched.c	2008-11-05 05:01:01.000000000 -0800
+++ linux-2.6.27.4/kernel/sched.c	2008-11-05 05:01:20.000000000 -0800
@@ -2812,7 +2812,7 @@
 	return ret;
 }
 
-static void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
+static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(busiest->lock)
 {
 	spin_unlock(&busiest->lock);
