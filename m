Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbXKNRJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbXKNRJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXKNRJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:09:03 -0500
Received: from nic2.axis.se ([193.13.178.10]:56826 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbXKNRJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:09:01 -0500
Date: Wed, 14 Nov 2007 18:08:50 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: [PATCH] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
Message-ID: <20071114170850.GR6347@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scrap the local __INLINE__ macro, and rename timeval_cmp to fasttime_cmp.

Inline macro was completely unnecessary since the macro was defined
locally to be inline.
timeval_cmp was inaccurately named since it does comparison on
struct fasttimer_t and not on struct timeval.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 fasttimer.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/fasttimer.c b/arch/cris/arch-v10/kernel/fasttimer.c
index 645d705..c1a3a21 100644
--- a/arch/cris/arch-v10/kernel/fasttimer.c
+++ b/arch/cris/arch-v10/kernel/fasttimer.c
@@ -46,8 +46,6 @@ static int sanity_failed;
 #define D2(x)
 #define DP(x)
 
-#define __INLINE__ inline
-
 static unsigned int fast_timer_running;
 static unsigned int fast_timers_added;
 static unsigned int fast_timers_started;
@@ -118,13 +116,13 @@ int timer_freq_settings[NUM_TIMER_STATS];
 int timer_delay_settings[NUM_TIMER_STATS];
 
 /* Not true gettimeofday, only checks the jiffies (uptime) + useconds */
-void __INLINE__ do_gettimeofday_fast(struct fasttime_t *tv)
+inline void do_gettimeofday_fast(struct fasttime_t *tv)
 {
 	tv->tv_jiff = jiffies;
 	tv->tv_usec = GET_JIFFIES_USEC();
 }
 
-int __INLINE__ timeval_cmp(struct fasttime_t *t0, struct fasttime_t *t1)
+inline int fasttime_cmp(struct fasttime_t *t0, struct fasttime_t *t1)
 {
 	/* Compare jiffies. Takes care of wrapping */
 	if (time_before(t0->tv_jiff, t1->tv_jiff))
@@ -140,7 +138,7 @@ int __INLINE__ timeval_cmp(struct fasttime_t *t0, struct fasttime_t *t1)
 	return 0;
 }
 
-void __INLINE__ start_timer1(unsigned long delay_us)
+inline void start_timer1(unsigned long delay_us)
 {
   int freq_index = 0; /* This is the lowest resolution */
   unsigned long upper_limit = MAX_DELAY_US;
@@ -264,7 +262,7 @@ void start_one_shot_timer(struct fast_timer *t,
   fast_timers_added++;
 
   /* Check if this should timeout before anything else */
-  if (tmp == NULL || timeval_cmp(&t->tv_expires, &tmp->tv_expires) < 0)
+	if (tmp == NULL || fasttime_cmp(&t->tv_expires, &tmp->tv_expires) < 0)
   {
     /* Put first in list and modify the timer value */
     t->prev = NULL;
@@ -280,8 +278,8 @@ void start_one_shot_timer(struct fast_timer *t,
     start_timer1(delay_us);
   } else {
     /* Put in correct place in list */
-    while (tmp->next &&
-           timeval_cmp(&t->tv_expires, &tmp->next->tv_expires) > 0)
+		while (tmp->next && fasttime_cmp(&t->tv_expires,
+				&tmp->next->tv_expires) > 0)
     {
       tmp = tmp->next;
     }
@@ -382,7 +380,7 @@ timer1_handler(int irq, void *dev_id)
 		D1(printk(KERN_DEBUG "t: %is %06ius\n",
 			tv.tv_jiff, tv.tv_usec));
 
-    if (timeval_cmp(&t->tv_expires, &tv) <= 0)
+		if (fasttime_cmp(&t->tv_expires, &tv) <= 0)
     {
       /* Yes it has expired */
 #ifdef FAST_TIMER_LOG

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
