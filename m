Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZBGWQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZBGWQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 17:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZBGWQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 17:16:28 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49270 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZBGWQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 17:16:26 -0500
Date: Sat, 7 Feb 2009 14:16:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090207221627.GA26162@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090207151028.GA11150@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207151028.GA11150@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 07:10:28AM -0800, Paul E. McKenney wrote:
> So, how to fix?  Here are some approaches:
> 
> o	Make urcu_publish_content() do two parity flips rather than one.
> 	I use this approach in my rcu_rcpg, rcu_rcpl, and rcu_rcpls
> 	algorithms in CodeSamples/defer.
> 
> o	Use a single free-running counter, in a manner similar to rcu_nest,
> 	as suggested earlier.  This one is interesting, as I rely on a
> 	read-side memory barrier to handle the long-preemption case.
> 	However, if you believe that any thread that waits several minutes
> 	between executing adjacent instructions must have been preempted
> 	(which the memory barriers that are required to do a context
> 	switch), then a compiler barrier suffices.  ;-)
> 
> Of course, the probability of seeing this failure during test is quite
> low, since it is unlikely that thread 0 would run just long enough to
> execute its signal handler.  However, it could happen.  And if you were
> to adapt this algorithm for use in a real-time application, then priority
> boosting could cause this to happen naturally.

And here is a patch, taking the first approach.  It also exposes a
synchronize_rcu() API that is used by the existing urcu_publish_content()
API.  This allows easier handling of structures that are referenced by
more than one pointer.  And should also allow to be more easily plugged
into my rcutorture test.  ;-)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 urcu.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/urcu.c b/urcu.c
index e401d8d..1a276ce 100644
--- a/urcu.c
+++ b/urcu.c
@@ -113,13 +113,35 @@ void wait_for_quiescent_state(int parity)
 	force_mb_all_threads();
 }
 
+static void switch_qparity(void)
+{
+	int prev_parity;
+
+	/* All threads should read qparity before accessing data structure. */
+	/* Write ptr before changing the qparity */
+	force_mb_all_threads();
+	prev_parity = switch_next_urcu_qparity();
+
+	/*
+	 * Wait for previous parity to be empty of readers.
+	 */
+	wait_for_quiescent_state(prev_parity);
+}
+
+void synchronize_rcu(void)
+{
+	rcu_write_lock();
+	switch_qparity();
+	switch_qparity();
+	rcu_write_unlock();
+}
+
 /*
  * Return old pointer, OK to free, no more reference exist.
  * Called under rcu_write_lock.
  */
 void *urcu_publish_content(void **ptr, void *new)
 {
-	int prev_parity;
 	void *oldptr;
 
 	/*
@@ -134,19 +156,10 @@ void *urcu_publish_content(void **ptr, void *new)
 	 */
 	oldptr = *ptr;
 	*ptr = new;
-	/* All threads should read qparity before ptr */
-	/* Write ptr before changing the qparity */
-	force_mb_all_threads();
-	prev_parity = switch_next_urcu_qparity();
 
-	/*
-	 * Wait for previous parity to be empty of readers.
-	 */
-	wait_for_quiescent_state(prev_parity);
-	/*
-	 * Deleting old data is ok !
-	 */
-	
+	switch_qparity();
+	switch_qparity();
+
 	return oldptr;
 }
 
