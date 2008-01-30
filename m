Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYA3FWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYA3FWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYA3FWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:22:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYA3FWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:22:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=MyLlhfxqrlfXW5dqLYERsrJwh5IgEtpcOF2yeD8MYoAZAv3Tvv0bB4rfJwpE8/7Dr
	MVdu4zAx8sO4dhZRdJNgw==
Message-ID: <2846be6b0801292122p74b8a419l39ba025eeeb9bede@mail.gmail.com>
Date: Tue, 29 Jan 2008 21:22:28 -0800
From: "Naveen Gupta" <ngupta@google.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Andrea Righi" <righiandr@users.sourceforge.net>,
       "Jens Axboe" <jens.axboe@oracle.com>
Subject: [RFC] Proportional bandwidth scheduling using anticipatory I/O scheduler on 2.6.24
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates channels in anticipatory I/O scheduler for sharing
bandwidth in specified proportions. It uses the ioprio_(get/set) interface
to create various channels and as of now it is using the best effort levels.

It is an initial attempt to get proportional b/w working in I/O
schedulers. One of the applications can be to assign a portion of
b/w on a device to a specified container. The advantages of this
approach over putting absolute restricting on b/w of a container is
that by restricting the b/w, we may end up not utilizing additional
b/w in absence of load from other containers. Not to say that we cannot
do I/O limiting in schedulers.

The current patch works for read requests and we may need more work for
congested queues and writes limiting. The idea is to allow processes to submit
requests in a round-robin manner and if it exceeds it's limit wait till the
other channel is done submitting it's share. In order to prevent a very
active channel from submitting any request (even though it may have exceeded
it's limit) in absence of i/o from other channel, counters are reset after
a period of inactivity on idle channels. Also there is a loss of overall
average bandwidth when using multiple classes. Some of which can be expected
due to different behavior of applications in multiple containers sharing a
single device, but apart from that a major portion of that loss is due to
the fact that we are still not using the scheduler optimally. Here is a
simple fio script to test this patch.


<-- snip fio.script -->
[global]
ioengine=sync
rw=read
direct=0
exitall

[file]
name=buffered1
directory=/tmp
bs=256k
size=1g
prio=0
prioclass=2

[file]
name=buffered3
directory=/tmp
bs=1m
size=1g
prio=3
prioclass=2
<-- end snip -->

Other interfaces are in /sys/block/[device]/queue/iosched/
1. priority_weights - Assign proportions to various channels.
   Note these poportions are now expressed in multiples of 1024*1024. I will
   work on getting these into exact proportions.
2. bandwidth_scheduling - writing 0 into this stops proportional scheduling.
3. bw_timer_expire - time period after which counters are reset.
   Writing large value to it will give you more exact proportions and
   small values increase overall average bandwidth. This is the time
   after which b/w on a different channels is reset due to inactivity. Some
   tuning of this variable may be needed to get required results. I will work
   on making this transparent.
This patch has default four channels.

I would like to know initial feedback regarding what do we expect especially
when it comes to container groups. Is this something which is useful or we
need hard limits for various channels? What other things are expected? Would
assigning priorities be of any use, either absolute priorities or
soft priorities along with b/w limitations. I can add cgroup interfaces in
another patch.

Signed-off-by: Naveen Gupta <ngupta@google.com>

Index: linux-2.6.24/block/Kconfig.iosched
===================================================================
--- linux-2.6.24.orig/block/Kconfig.iosched     2008-01-24
14:58:37.000000000 -0800
+++ linux-2.6.24/block/Kconfig.iosched  2008-01-27 11:24:50.000000000 -0800
@@ -21,6 +21,13 @@ config IOSCHED_AS
          deadline I/O scheduler, it can also be slower in some cases
          especially some database loads.

+config IOPRIO_AS_MAX
+       int "Bandwidth channels in anticipatory I/O scheduler"
+       depends on IOSCHED_AS
+       default "4"
+       help
+         Number of valid b/w channels in anticipatory scheduler.
+
 config IOSCHED_DEADLINE
        tristate "Deadline I/O scheduler"
        default y
Index: linux-2.6.24/block/as-iosched.c
===================================================================
--- linux-2.6.24.orig/block/as-iosched.c        2008-01-24
14:58:37.000000000 -0800
+++ linux-2.6.24/block/as-iosched.c     2008-01-29 12:05:52.000000000 -0800
@@ -16,6 +16,8 @@
 #include <linux/compiler.h>
 #include <linux/rbtree.h>
 #include <linux/interrupt.h>
+#include <linux/ioprio.h>
+#include <linux/ctype.h>

 #define REQ_SYNC       1
 #define REQ_ASYNC      0
@@ -63,6 +65,9 @@
  */
 #define MAX_THINKTIME (HZ/50UL)

+#define default_bandwidth_scheduling  (0)
+#define default_bw_timer_expire (16)           /* msecs */
+
 /* Bits in as_io_context.state */
 enum as_io_states {
        AS_TASK_RUNNING=0,      /* Process has not exited */
@@ -89,10 +94,14 @@ struct as_data {
        /*
         * requests (as_rq s) are present on both sort_list and fifo_list
         */
-       struct rb_root sort_list[2];
-       struct list_head fifo_list[2];
+       struct {
+               struct rb_root sort_list[2];
+               struct list_head fifo_list[2];
+               struct request *next_rq[2];
+               unsigned long ioprio_wt;
+               unsigned long serviced;
+       } prio_q[IOPRIO_AS_MAX];

-       struct request *next_rq[2];     /* next in sort order */
        sector_t last_sector[2];        /* last REQ_SYNC & REQ_ASYNC sectors */

        unsigned long exit_prob;        /* probability a task will exit while
@@ -113,6 +122,7 @@ struct as_data {
        int write_batch_count;          /* max # of reqs in a write batch */
        int current_write_count;        /* how many requests left this batch */
        int write_batch_idled;          /* has the write batch gone idle? */
+       unsigned short batch_ioprio;

        enum anticipation_status antic_status;
        unsigned long antic_start;      /* jiffies: when it started */
@@ -122,12 +132,19 @@ struct as_data {
        int ioc_finished; /* IO associated with io_context is finished */
        int nr_dispatched;

+       int bw_timer_on;
+       unsigned long bw_timer_start;
+       struct timer_list bw_timer;
+       struct work_struct bw_work;
+
        /*
         * settings that change how the i/o scheduler behaves
         */
        unsigned long fifo_expire[2];
        unsigned long batch_expire[2];
        unsigned long antic_expire;
+       unsigned long bandwidth_scheduling;
+       unsigned long bw_timer_expire;
 };

 /*
@@ -155,6 +172,8 @@ static struct completion *ioc_gone;
 static void as_move_to_dispatch(struct as_data *ad, struct request *rq);
 static void as_antic_stop(struct as_data *ad);

+static unsigned short as_mapped_priority(unsigned short ioprio);
+
 /*
  * IO Context helper functions
  */
@@ -242,16 +261,25 @@ static void as_put_io_context(struct req
        put_io_context(RQ_IOC(rq));
 }

+static inline unsigned short rq_prio_level(struct request *rq)
+{
+       return IOPRIO_PRIO_DATA(as_mapped_priority(rq->ioprio));
+}
+
 /*
  * rb tree support functions
  */
-#define RQ_RB_ROOT(ad, rq)     (&(ad)->sort_list[rq_is_sync((rq))])
+static inline struct rb_root *rq_rb_root(struct as_data *ad,
+                                               struct request *rq)
+{
+       return (&(ad)->prio_q[rq_prio_level(rq)].sort_list[rq_is_sync(rq)]);
+}

 static void as_add_rq_rb(struct as_data *ad, struct request *rq)
 {
        struct request *alias;

-       while ((unlikely(alias = elv_rb_add(RQ_RB_ROOT(ad, rq), rq)))) {
+       while ((unlikely(alias = elv_rb_add(rq_rb_root(ad, rq), rq)))) {
                as_move_to_dispatch(ad, alias);
                as_antic_stop(ad);
        }
@@ -259,7 +287,14 @@ static void as_add_rq_rb(struct as_data

 static inline void as_del_rq_rb(struct as_data *ad, struct request *rq)
 {
-       elv_rb_del(RQ_RB_ROOT(ad, rq), rq);
+       elv_rb_del(rq_rb_root(ad, rq), rq);
+}
+
+static inline struct request *ad_fifo_next(struct as_data *ad,
+                                               unsigned short ioprio,
+                                               int dir)
+{
+       return rq_entry_fifo(ad->prio_q[ioprio].fifo_list[dir].next);
 }

 /*
@@ -367,9 +402,7 @@ as_find_next_rq(struct as_data *ad, stru
        if (rbnext)
                next = rb_entry_rq(rbnext);
        else {
-               const int data_dir = rq_is_sync(last);
-
-               rbnext = rb_first(&ad->sort_list[data_dir]);
+               rbnext = rb_first(rq_rb_root(ad, last));
                if (rbnext && rbnext != &last->rb_node)
                        next = rb_entry_rq(rbnext);
        }
@@ -479,6 +512,17 @@ static void as_antic_timeout(unsigned lo
        spin_unlock_irqrestore(q->queue_lock, flags);
 }

+static void bw_timer_timeout(unsigned long data)
+{
+       struct request_queue *q = (struct request_queue *)data;
+       struct as_data *ad = q->elevator->elevator_data;
+       unsigned long flags;
+
+       spin_lock_irqsave(q->queue_lock, flags);
+       kblockd_schedule_work(&ad->antic_work);
+       spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
 static void as_update_thinktime(struct as_data *ad, struct as_io_context *aic,
                                unsigned long ttime)
 {
@@ -750,7 +794,9 @@ static void as_update_rq(struct as_data
        const int data_dir = rq_is_sync(rq);

        /* keep the next_rq cache up to date */
-       ad->next_rq[data_dir] = as_choose_req(ad, rq, ad->next_rq[data_dir]);
+       ad->prio_q[rq_prio_level(rq)].next_rq[data_dir] =
+               as_choose_req(ad, rq,
+                        ad->prio_q[rq_prio_level(rq)].next_rq[data_dir]);

        /*
         * have we been anticipating this request?
@@ -872,8 +918,9 @@ static void as_remove_queued_request(str
         * Update the "next_rq" cache if we are about to remove its
         * entry
         */
-       if (ad->next_rq[data_dir] == rq)
-               ad->next_rq[data_dir] = as_find_next_rq(ad, rq);
+       if (ad->prio_q[rq_prio_level(rq)].next_rq[data_dir] == rq)
+               ad->prio_q[rq_prio_level(rq)].next_rq[data_dir] =
+                                               as_find_next_rq(ad, rq);

        rq_fifo_clear(rq);
        as_del_rq_rb(ad, rq);
@@ -887,7 +934,7 @@ static void as_remove_queued_request(str
  *
  * See as_antic_expired comment.
  */
-static int as_fifo_expired(struct as_data *ad, int adir)
+static int as_fifo_expired(struct as_data *ad, int adir, unsigned short ioprio)
 {
        struct request *rq;
        long delta_jif;
@@ -900,10 +947,10 @@ static int as_fifo_expired(struct as_dat

        ad->last_check_fifo[adir] = jiffies;

-       if (list_empty(&ad->fifo_list[adir]))
+       if (list_empty(&ad->prio_q[ioprio].fifo_list[adir]))
                return 0;

-       rq = rq_entry_fifo(ad->fifo_list[adir].next);
+       rq = rq_entry_fifo(ad->prio_q[ioprio].fifo_list[adir].next);

        return time_after(jiffies, rq_fifo_time(rq));
 }
@@ -925,6 +972,15 @@ static inline int as_batch_expired(struc
                || ad->current_write_count == 0;
 }

+static int as_has_request_at_priority(struct as_data *ad,
+                                       unsigned int priority)
+{
+       if (list_empty(&ad->prio_q[priority].fifo_list[REQ_SYNC]) &&
+           list_empty(&ad->prio_q[priority].fifo_list[REQ_ASYNC]))
+               return 0;
+       return 1;
+}
+
 /*
  * move an entry to dispatch queue
  */
@@ -958,7 +1014,8 @@ static void as_move_to_dispatch(struct a
        }
        ad->ioc_finished = 0;

-       ad->next_rq[data_dir] = as_find_next_rq(ad, rq);
+       ad->prio_q[rq_prio_level(rq)].next_rq[data_dir] =
+                                               as_find_next_rq(ad, rq);

        /*
         * take it off the sort and fifo list, add to dispatch queue
@@ -966,6 +1023,12 @@ static void as_move_to_dispatch(struct a
        as_remove_queued_request(ad->q, rq);
        WARN_ON(RQ_STATE(rq) != AS_RQ_QUEUED);

+       if (ad->bandwidth_scheduling)
+               ad->prio_q[rq_prio_level(rq)].serviced +=
+                                               rq->nr_sectors << 9;
+       else
+               ad->prio_q[rq_prio_level(rq)].serviced++;
+
        elv_dispatch_sort(ad->q, rq);

        RQ_SET_STATE(rq, AS_RQ_DISPATCHED);
@@ -974,6 +1037,76 @@ static void as_move_to_dispatch(struct a
        ad->nr_dispatched++;
 }

+static unsigned int select_priority_level(struct as_data *ad)
+{
+       unsigned int i, best_ioprio = 0, ioprio, found_alt = 0, count;
+       unsigned long rq_size;
+       struct request *rq;
+
+       for (count = 0; count < IOPRIO_AS_MAX; count++) {
+               if (ad->bandwidth_scheduling)
+                       ioprio = (ad->batch_ioprio + count + 1) % IOPRIO_AS_MAX;
+               else
+                       ioprio = count;
+               if (!as_has_request_at_priority(ad, ioprio)) {
+                       continue;
+               }
+
+               rq_size = 0;
+               rq = NULL;
+               if (!list_empty(&ad->prio_q[ioprio].fifo_list[REQ_SYNC]))
+                       rq = ad_fifo_next(ad, ioprio, REQ_SYNC);
+               if (rq)
+                       rq_size = rq->nr_sectors << 9;
+
+               if (!list_empty(&ad->prio_q[ioprio].fifo_list[REQ_ASYNC]))
+                       rq = ad_fifo_next(ad, ioprio, REQ_ASYNC);
+               if (rq)
+                       if (rq->nr_sectors << 9 < rq_size)
+                               rq_size = rq->nr_sectors << 9;
+
+               if (ad->bandwidth_scheduling && ((ad->prio_q[ioprio].serviced +
+                       rq_size) < ad->prio_q[ioprio].ioprio_wt)) {
+                       if (ad->bw_timer_on) {
+                               ad->bw_timer_on = 0;
+                               del_timer(&ad->bw_timer);
+                       }
+                       return ioprio;
+               }
+               if (!ad->bandwidth_scheduling && (ad->prio_q[ioprio].serviced <
+                       ad->prio_q[ioprio].ioprio_wt))
+                       return ioprio;
+               if (!found_alt) {
+                       best_ioprio = ioprio;
+                       found_alt = 1;
+               }
+       }
+
+       if (found_alt) {
+               if (ad->bandwidth_scheduling && !ad->bw_timer_on) {
+                       ad->bw_timer_on = 1;
+                       ad->bw_timer_start = jiffies;
+                       mod_timer(&ad->bw_timer, (ad->bw_timer_start +
+                                                       ad->bw_timer_expire));
+                       return IOPRIO_AS_MAX;
+               }
+               if (ad->bandwidth_scheduling && ad->bw_timer_on &&
+                       !time_after_eq(jiffies, (ad->bw_timer_start +
+                                       ad->bw_timer_expire))) {
+                       return IOPRIO_AS_MAX;
+               }
+               ioprio = best_ioprio;
+               for (i = 0; i < IOPRIO_AS_MAX; i++)
+                       ad->prio_q[i].serviced = 0;
+               if (ad->bandwidth_scheduling && ad->bw_timer_on) {
+                       ad->bw_timer_on = 0;
+                       del_timer(&ad->bw_timer);
+               }
+       }
+
+       return ioprio;
+}
+
 /*
  * as_dispatch_request selects the best request according to
  * read/write expire, batch expire, etc, and moves it to the dispatch
@@ -982,9 +1115,10 @@ static void as_move_to_dispatch(struct a
 static int as_dispatch_request(struct request_queue *q, int force)
 {
        struct as_data *ad = q->elevator->elevator_data;
-       const int reads = !list_empty(&ad->fifo_list[REQ_SYNC]);
-       const int writes = !list_empty(&ad->fifo_list[REQ_ASYNC]);
        struct request *rq;
+       unsigned short ioprio;
+       int reads, writes;
+       int changed_ioprio;

        if (unlikely(force)) {
                /*
@@ -1000,21 +1134,32 @@ static int as_dispatch_request(struct re
                ad->changed_batch = 0;
                ad->new_batch = 0;

-               while (ad->next_rq[REQ_SYNC]) {
-                       as_move_to_dispatch(ad, ad->next_rq[REQ_SYNC]);
-                       dispatched++;
-               }
-               ad->last_check_fifo[REQ_SYNC] = jiffies;
+               for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
+                       while (ad->prio_q[ioprio].next_rq[REQ_SYNC]) {
+                               as_move_to_dispatch(ad,
+                                   ad->prio_q[ioprio].next_rq[REQ_SYNC]);
+                               dispatched++;
+                       }
+                       ad->last_check_fifo[REQ_SYNC] = jiffies;

-               while (ad->next_rq[REQ_ASYNC]) {
-                       as_move_to_dispatch(ad, ad->next_rq[REQ_ASYNC]);
-                       dispatched++;
+                       while (ad->prio_q[ioprio].next_rq[REQ_ASYNC]) {
+                               as_move_to_dispatch(ad,
+                                   ad->prio_q[ioprio].next_rq[REQ_ASYNC]);
+                               dispatched++;
+                       }
+                       ad->last_check_fifo[REQ_ASYNC] = jiffies;
                }
-               ad->last_check_fifo[REQ_ASYNC] = jiffies;

                return dispatched;
        }

+       ioprio = select_priority_level(ad);
+       if (ioprio >= IOPRIO_AS_MAX)
+               return 0;
+
+       reads = !list_empty(&ad->prio_q[ioprio].fifo_list[REQ_SYNC]);
+       writes = !list_empty(&ad->prio_q[ioprio].fifo_list[REQ_ASYNC]);
+
        /* Signal that the write batch was uncontended, so we can't time it */
        if (ad->batch_data_dir == REQ_ASYNC && !reads) {
                if (ad->current_write_count == 0 || !writes)
@@ -1027,14 +1172,16 @@ static int as_dispatch_request(struct re
                || ad->changed_batch)
                return 0;

+       changed_ioprio = (ad->batch_ioprio != ioprio)?1:0;
+
        if (!(reads && writes && as_batch_expired(ad))) {
                /*
                 * batch is still running or no reads or no writes
                 */
-               rq = ad->next_rq[ad->batch_data_dir];
+               rq = ad->prio_q[ioprio].next_rq[ad->batch_data_dir];

                if (ad->batch_data_dir == REQ_SYNC && ad->antic_expire) {
-                       if (as_fifo_expired(ad, REQ_SYNC))
+                       if (as_fifo_expired(ad, REQ_SYNC, ioprio))
                                goto fifo_expired;

                        if (as_can_anticipate(ad, rq)) {
@@ -1043,7 +1190,7 @@ static int as_dispatch_request(struct re
                        }
                }

-               if (rq) {
+               if (!changed_ioprio && rq) {
                        /* we have a "next request" */
                        if (reads && !writes)
                                ad->current_batch_expires =
@@ -1058,9 +1205,10 @@ static int as_dispatch_request(struct re
         */

        if (reads) {
-               BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_SYNC]));
+               BUG_ON(RB_EMPTY_ROOT(&ad->prio_q[ioprio].sort_list[REQ_SYNC]));

-               if (writes && ad->batch_data_dir == REQ_SYNC)
+               if (!changed_ioprio && writes &&
+                                ad->batch_data_dir == REQ_SYNC)
                        /*
                         * Last batch was a read, switch to writes
                         */
@@ -1069,9 +1217,12 @@ static int as_dispatch_request(struct re
                if (ad->batch_data_dir == REQ_ASYNC) {
                        WARN_ON(ad->new_batch);
                        ad->changed_batch = 1;
-               }
+               } else if (changed_ioprio)
+                       ad->current_batch_expires =
+                               jiffies + ad->batch_expire[REQ_SYNC];
+               ad->batch_ioprio = ioprio;
                ad->batch_data_dir = REQ_SYNC;
-               rq = rq_entry_fifo(ad->fifo_list[REQ_SYNC].next);
+               rq = ad_fifo_next(ad, ioprio, REQ_SYNC);
                ad->last_check_fifo[ad->batch_data_dir] = jiffies;
                goto dispatch_request;
        }
@@ -1082,7 +1233,7 @@ static int as_dispatch_request(struct re

        if (writes) {
 dispatch_writes:
-               BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
+               BUG_ON(RB_EMPTY_ROOT(&ad->prio_q[ioprio].sort_list[REQ_ASYNC]));

                if (ad->batch_data_dir == REQ_SYNC) {
                        ad->changed_batch = 1;
@@ -1093,11 +1244,14 @@ dispatch_writes:
                         * cause a change of batch before the read is finished.
                         */
                        ad->new_batch = 0;
-               }
+               } else if (changed_ioprio)
+                       ad->current_batch_expires = jiffies +
+                                               ad->batch_expire[REQ_ASYNC];
+               ad->batch_ioprio = ioprio;
                ad->batch_data_dir = REQ_ASYNC;
                ad->current_write_count = ad->write_batch_count;
                ad->write_batch_idled = 0;
-               rq = rq_entry_fifo(ad->fifo_list[REQ_ASYNC].next);
+               rq = ad_fifo_next(ad, ioprio, REQ_ASYNC);
                ad->last_check_fifo[REQ_ASYNC] = jiffies;
                goto dispatch_request;
        }
@@ -1110,9 +1264,9 @@ dispatch_request:
         * If a request has expired, service it.
         */

-       if (as_fifo_expired(ad, ad->batch_data_dir)) {
+       if (as_fifo_expired(ad, ad->batch_data_dir, ioprio)) {
 fifo_expired:
-               rq = rq_entry_fifo(ad->fifo_list[ad->batch_data_dir].next);
+               rq = ad_fifo_next(ad, ioprio, ad->batch_data_dir);
        }

        if (ad->changed_batch) {
@@ -1163,7 +1317,8 @@ static void as_add_request(struct reques
         * set expire time and add to fifo list
         */
        rq_set_fifo_time(rq, jiffies + ad->fifo_expire[data_dir]);
-       list_add_tail(&rq->queuelist, &ad->fifo_list[data_dir]);
+       list_add_tail(&rq->queuelist,
+                       &ad->prio_q[rq_prio_level(rq)].fifo_list[data_dir]);

        as_update_rq(ad, rq); /* keep state machine up to date */
        RQ_SET_STATE(rq, AS_RQ_QUEUED);
@@ -1194,9 +1349,34 @@ static void as_deactivate_request(struct
 static int as_queue_empty(struct request_queue *q)
 {
        struct as_data *ad = q->elevator->elevator_data;
+       unsigned short ioprio;

-       return list_empty(&ad->fifo_list[REQ_ASYNC])
-               && list_empty(&ad->fifo_list[REQ_SYNC]);
+       for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
+               if (as_has_request_at_priority(ad, ioprio))
+                       return 0;
+       }
+       return 1;
+}
+
+static unsigned short as_mapped_priority(unsigned short ioprio)
+{
+       unsigned short class = IOPRIO_PRIO_CLASS(ioprio);
+       unsigned short data = IOPRIO_PRIO_DATA(ioprio);
+
+       if (class == IOPRIO_CLASS_BE)
+               return ((data < IOPRIO_AS_MAX)? ioprio:
+                       IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
+                                               (IOPRIO_AS_MAX - 1)));
+       else if (class == IOPRIO_CLASS_RT)
+               return IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0);
+       else if (class == IOPRIO_CLASS_IDLE)
+               return IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, (IOPRIO_AS_MAX - 1));
+       else if (class == IOPRIO_CLASS_NONE) {
+               return IOPRIO_AS_DEFAULT;
+       } else {
+               WARN_ON(1);
+               return IOPRIO_AS_DEFAULT;
+       }
 }

 static int
@@ -1205,11 +1385,15 @@ as_merge(struct request_queue *q, struct
        struct as_data *ad = q->elevator->elevator_data;
        sector_t rb_key = bio->bi_sector + bio_sectors(bio);
        struct request *__rq;
+       unsigned short ioprio;
+
+       ioprio = IOPRIO_PRIO_DATA(as_mapped_priority(bio_prio(bio)));

        /*
         * check for front merge
         */
-       __rq = elv_rb_find(&ad->sort_list[bio_data_dir(bio)], rb_key);
+       __rq = elv_rb_find(&ad->prio_q[ioprio].sort_list[bio_data_dir(bio)],
+                                                                rb_key);
        if (__rq && elv_rq_merge_ok(__rq, bio)) {
                *req = __rq;
                return ELEVATOR_FRONT_MERGE;
@@ -1307,12 +1491,13 @@ static int as_may_queue(struct request_q
 static void as_exit_queue(elevator_t *e)
 {
        struct as_data *ad = e->elevator_data;
+       int ioprio;

        del_timer_sync(&ad->antic_timer);
        kblockd_flush_work(&ad->antic_work);

-       BUG_ON(!list_empty(&ad->fifo_list[REQ_SYNC]));
-       BUG_ON(!list_empty(&ad->fifo_list[REQ_ASYNC]));
+       for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++)
+               BUG_ON(as_has_request_at_priority(ad, ioprio));

        put_io_context(ad->io_context);
        kfree(ad);
@@ -1324,6 +1509,7 @@ static void as_exit_queue(elevator_t *e)
 static void *as_init_queue(struct request_queue *q)
 {
        struct as_data *ad;
+       int i;

        ad = kmalloc_node(sizeof(*ad), GFP_KERNEL | __GFP_ZERO, q->node);
        if (!ad)
@@ -1336,16 +1522,35 @@ static void *as_init_queue(struct reques
        ad->antic_timer.data = (unsigned long)q;
        init_timer(&ad->antic_timer);
        INIT_WORK(&ad->antic_work, as_work_handler);
+       ad->bw_timer.function = bw_timer_timeout;
+       ad->bw_timer.data = (unsigned long)q;
+       init_timer(&ad->bw_timer);
+
+       for (i = IOPRIO_AS_MAX - 1; i >= 0; i--) {
+               INIT_LIST_HEAD(&ad->prio_q[i].fifo_list[REQ_SYNC]);
+               INIT_LIST_HEAD(&ad->prio_q[i].fifo_list[REQ_ASYNC]);
+               ad->prio_q[i].sort_list[REQ_SYNC] = RB_ROOT;
+               ad->prio_q[i].sort_list[REQ_ASYNC] = RB_ROOT;
+               ad->prio_q[i].serviced = 0;
+               if (i == 0)
+                       ad->prio_q[i].ioprio_wt =
+                               (ad->bandwidth_scheduling?6291456:5);
+               else if (i == 1)
+                       ad->prio_q[i].ioprio_wt =
+                               (ad->bandwidth_scheduling?4194304:5);
+               else
+                       ad->prio_q[i].ioprio_wt =
+                               (ad->bandwidth_scheduling?1048576:5);
+       }

-       INIT_LIST_HEAD(&ad->fifo_list[REQ_SYNC]);
-       INIT_LIST_HEAD(&ad->fifo_list[REQ_ASYNC]);
-       ad->sort_list[REQ_SYNC] = RB_ROOT;
-       ad->sort_list[REQ_ASYNC] = RB_ROOT;
        ad->fifo_expire[REQ_SYNC] = default_read_expire;
        ad->fifo_expire[REQ_ASYNC] = default_write_expire;
        ad->antic_expire = default_antic_expire;
        ad->batch_expire[REQ_SYNC] = default_read_batch_expire;
        ad->batch_expire[REQ_ASYNC] = default_write_batch_expire;
+       ad->bandwidth_scheduling = default_bandwidth_scheduling;
+       ad->bw_timer_on = 0;
+       ad->bw_timer_expire = msecs_to_jiffies(default_bw_timer_expire);

        ad->current_batch_expires = jiffies + ad->batch_expire[REQ_SYNC];
        ad->write_batch_count = ad->batch_expire[REQ_ASYNC] / 10;
@@ -1391,6 +1596,82 @@ static ssize_t est_time_show(elevator_t
        return pos;
 }

+static ssize_t as_priority_weights_show(elevator_t *e, char *page)
+{
+       struct as_data *ad = e->elevator_data;
+       int i, pos = 0;
+
+       for (i = 0; i < IOPRIO_AS_MAX; i++)
+               pos += sprintf(page + pos, "%lu ", ad->prio_q[i].ioprio_wt);
+
+       pos += sprintf(page + pos, "\n");
+
+       return pos;
+}
+
+static ssize_t as_priority_weights_store(elevator_t *e, const char *page,
+                                                       size_t count)
+{
+       struct as_data *ad = e->elevator_data;
+       char *prev_p, *p = (char *)page;
+       unsigned long val;
+       int i = 0, j, tcount = count;
+       unsigned long ioprio_wt[IOPRIO_AS_MAX];
+
+       while(tcount && i < IOPRIO_AS_MAX) {
+               prev_p = p;
+               /* Initial whitespace ignored by the next while loop. */
+               val = simple_strtoul(p, &p, 10);
+               tcount -= (p - prev_p);
+               /* Don't terminate on seeing whitespace. */
+               if ((p - prev_p) && (val == 0))
+                       goto err;
+               while (tcount && isspace(*p)) {
+                       p++;
+                       tcount--;
+               }
+               /* If not whitespace and value > 0, it is valid input. */
+               if (val > 0)
+                       ioprio_wt[i++] = val;
+               if (tcount && !isdigit(*p))
+                       goto err;
+       }
+
+       if (i == IOPRIO_AS_MAX && !tcount)
+               for (j = 0; j < IOPRIO_AS_MAX; j++)
+                       ad->prio_q[j].ioprio_wt = ioprio_wt[j];
+
+       return count;
+err:
+       return -EINVAL;
+}
+
+static ssize_t as_bandwidth_scheduling_store(elevator_t *e, const char *page,
+                                                       size_t count)
+{
+       struct as_data *ad = e->elevator_data;
+       int ret = as_var_store(&ad->bandwidth_scheduling, page, count);
+       int i;
+
+       if (ad->bandwidth_scheduling < 0)
+               ad->bandwidth_scheduling = 0;
+       else if (ad->bandwidth_scheduling > INT_MAX)
+               ad->bandwidth_scheduling = INT_MAX;
+
+       for (i = IOPRIO_AS_MAX - 1; i >= 0; i--) {
+               if (i == 0)
+                       ad->prio_q[i].ioprio_wt =
+                               (ad->bandwidth_scheduling?6291456:5);
+               else if (i == 1)
+                       ad->prio_q[i].ioprio_wt =
+                               (ad->bandwidth_scheduling?4194304:5);
+               else
+                       ad->prio_q[i].ioprio_wt =
+                               (ad->bandwidth_scheduling?1048576:5);
+       }
+       return ret;
+}
+
 #define SHOW_FUNCTION(__FUNC, __VAR)                           \
 static ssize_t __FUNC(elevator_t *e, char *page)               \
 {                                                              \
@@ -1402,6 +1683,8 @@ SHOW_FUNCTION(as_write_expire_show, ad->
 SHOW_FUNCTION(as_antic_expire_show, ad->antic_expire);
 SHOW_FUNCTION(as_read_batch_expire_show, ad->batch_expire[REQ_SYNC]);
 SHOW_FUNCTION(as_write_batch_expire_show, ad->batch_expire[REQ_ASYNC]);
+SHOW_FUNCTION(as_bandwidth_scheduling_show, ad->bandwidth_scheduling);
+SHOW_FUNCTION(as_bw_timer_expire_show, ad->bw_timer_expire);
 #undef SHOW_FUNCTION

 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX)
         \
@@ -1423,6 +1706,8 @@ STORE_FUNCTION(as_read_batch_expire_stor
                        &ad->batch_expire[REQ_SYNC], 0, INT_MAX);
 STORE_FUNCTION(as_write_batch_expire_store,
                        &ad->batch_expire[REQ_ASYNC], 0, INT_MAX);
+STORE_FUNCTION(as_bw_timer_expire_store,
+                       &ad->bw_timer_expire, 0, INT_MAX);
 #undef STORE_FUNCTION

 #define AS_ATTR(name) \
@@ -1435,11 +1720,24 @@ static struct elv_fs_entry as_attrs[] =
        AS_ATTR(antic_expire),
        AS_ATTR(read_batch_expire),
        AS_ATTR(write_batch_expire),
+       AS_ATTR(priority_weights),
+       AS_ATTR(bandwidth_scheduling),
+       AS_ATTR(bw_timer_expire),
        __ATTR_NULL
 };

+static int as_allow_merge(struct request_queue *q, struct request *rq,
+                               struct bio *bio)
+{
+       if (as_mapped_priority(rq->ioprio) !=
+                               as_mapped_priority(bio_prio(bio)))
+               return 0;
+       return 1;
+}
+
 static struct elevator_type iosched_as = {
        .ops = {
+               .elevator_allow_merge_fn =      as_allow_merge,
                .elevator_merge_fn =            as_merge,
                .elevator_merged_fn =           as_merged_request,
                .elevator_merge_req_fn =        as_merged_requests,
Index: linux-2.6.24/include/linux/bio.h
===================================================================
--- linux-2.6.24.orig/include/linux/bio.h       2008-01-24
14:58:37.000000000 -0800
+++ linux-2.6.24/include/linux/bio.h    2008-01-27 11:50:53.000000000 -0800
@@ -161,7 +161,6 @@ struct bio {
 #define bio_prio_valid(bio)    ioprio_valid(bio_prio(bio))

 #define bio_set_prio(bio, prio)                do {                    \
-       WARN_ON(prio >= (1 << IOPRIO_BITS));                    \
        (bio)->bi_rw &= ((1UL << BIO_PRIO_SHIFT) - 1);          \
        (bio)->bi_rw |= ((unsigned long) (prio) << BIO_PRIO_SHIFT);     \
 } while (0)
Index: linux-2.6.24/include/linux/ioprio.h
===================================================================
--- linux-2.6.24.orig/include/linux/ioprio.h    2008-01-24
14:58:37.000000000 -0800
+++ linux-2.6.24/include/linux/ioprio.h 2008-01-27 11:54:11.000000000 -0800
@@ -34,6 +34,10 @@ enum {
  */
 #define IOPRIO_BE_NR   (8)

+#define IOPRIO_AS_MAX  CONFIG_IOPRIO_AS_MAX
+
+#define IOPRIO_AS_DEFAULT      IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 2)
+
 enum {
        IOPRIO_WHO_PROCESS = 1,
        IOPRIO_WHO_PGRP,

--
