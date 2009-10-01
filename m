Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZJAQ1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZJAQ1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZJAQ1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:27:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:56071 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbZJAQ07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:26:59 -0400
Message-ID: <4AC4D80D.2070304@kernel.org>
Date: Fri, 02 Oct 2009 01:25:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed	workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001082439.GN14918@kernel.dk>
In-Reply-To: <20091001082439.GN14918@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050808020009000900030300"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 16:25:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050808020009000900030300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Thu, Oct 01 2009, Tejun Heo wrote:
>> I'm attaching test-wq source and Makefile which I used to verify each
>> aspect of the new workqueue.  It's pretty easy to write new test
>> scenarios using the module so if you're interested in how this
>> actually work, it is quite useful.
> 
> BTW, you forgot to attach the test-wq source.
> 

Oooh... right, here they are.

-- 
tejun

--------------050808020009000900030300
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Makefile"

obj-m := test-wq.o

--------------050808020009000900030300
Content-Type: text/x-csrc;
 name="test-wq.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test-wq.c"

#include <linux/module.h>
#include <linux/workqueue.h>
#include <linux/jiffies.h>
#include <linux/delay.h>
#include <linux/sched.h>
#include <linux/wait.h>
#include <linux/cpu.h>
#include <linux/kthread.h>

#define MAX_WQ_NAME		64
#define MAX_WQS			64
#define MAX_WORKS		64

struct wq_spec {
	int			id;	/* -1 terminates */
	unsigned int		flags;
};

enum action {
	ACT_TERM,			/* end */
	ACT_LOG,			/* const char * */
	ACT_BURN,			/* ulong duration_msecs */
	ACT_SLEEP,			/* ulong duration_msecs */
	ACT_WAKEUP,			/* ulong work_id */
	ACT_REQUEUE,			/* ulong delay_msecs */
	ACT_FLUSH,			/* ulong work_id */
	ACT_FLUSH_WQ,			/* ulong workqueue_id */
	ACT_CANCEL,			/* ulong work_id */
};

struct work_action {
	enum action		action;	/* ACT_TERM terminates */
	union {
		unsigned long	v;
		const char	*s;
	};
};

struct work_spec {
	int			id;		/* -1 terminates */
	int			wq_id;
	int			requeue_cnt;
	unsigned int		cpu;
	unsigned long		initial_delay;	/* msecs */

	const struct work_action *actions;
};

struct test_scenario {
	const struct wq_spec	*wq_spec;
	const struct work_spec	**work_spec;	/* NULL terminated */
};

static const struct wq_spec dfl_wq_spec[] = {
	{
		.id		= 0,
		.flags		= 0,
	},
	{
		.id		= 1,
		.flags		= 0,
	},
	{
		.id		= 2,
		.flags		= WQ_RESCUER,
	},
	{
		.id		= 3,
		.flags		= WQ_FREEZEABLE,
	},
	{ .id = -1 },
};

/*
 * Scenario 0.  All are on cpu0.  work16 and 17 burn cpus for 10 and
 * 5msecs respectively and requeue themselves.  18 sleeps 2 secs and
 * cancel both.
 */
static const struct work_spec work_spec0[] = {
	{
		.id		= 16,
		.requeue_cnt	= 1024,
		.actions	= (const struct work_action[]) {
			{ ACT_BURN,	{ 10 }},
			{ ACT_REQUEUE,	{ 0 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 17,
		.requeue_cnt	= 1024,
		.actions	= (const struct work_action[]) {
			{ ACT_BURN,	{ 5 }},
			{ ACT_REQUEUE,	{ 0 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 18,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "will sleep 2s and cancel both" }},
			{ ACT_SLEEP,	{ 2000 }},
			{ ACT_CANCEL,	{ 16 }},
			{ ACT_CANCEL,	{ 17 }},
			{ ACT_TERM },
		},
	},
	{ .id = -1 },
};

static const struct test_scenario scenario0 = {
	.wq_spec		= dfl_wq_spec,
	.work_spec		=
	(const struct work_spec *[]) { work_spec0, NULL },
};

/*
 * Scenario 1.  All are on cpu0.  Work 0, 1 and 2 sleep for different
 * intervals but all three will terminate at around 30secs.  3 starts
 * at @28 and 4 at @33 and both sleep for five secs and then
 * terminate.  5 waits for 0, 1, 2 and then flush wq which by the time
 * should have 3 on it.  After 3 completes @32, 5 terminates too.
 * After 4 secs, 4 terminates and all test sequence is done.
 */
static const struct work_spec work_spec1[] = {
	{
		.id		= 0,
		.actions	= (const struct work_action[]) {
			{ ACT_BURN,	{ 3 }},	/* to cause sched activation */
			{ ACT_LOG,	{ .s = "will sleep 30s" }},
			{ ACT_SLEEP,	{ 30000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_BURN,	{ 5 }},
			{ ACT_LOG,	{ .s = "will sleep 10s and burn 5msec and repeat 3 times" }},
			{ ACT_SLEEP,	{ 10000 }},
			{ ACT_BURN,	{ 5 }},
			{ ACT_LOG,	{ .s = "@10s" }},
			{ ACT_SLEEP,	{ 10000 }},
			{ ACT_BURN,	{ 5 }},
			{ ACT_LOG,	{ .s = "@20s" }},
			{ ACT_SLEEP,	{ 10000 }},
			{ ACT_BURN,	{ 5 }},
			{ ACT_LOG,	{ .s = "@30s" }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 2,
		.actions	= (const struct work_action[]) {
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "will sleep 3s and burn 1msec and repeat 10 times" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@3s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@6s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@9s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@12s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@15s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@18s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@21s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@24s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@27s" }},
			{ ACT_SLEEP,	{ 3000 }},
			{ ACT_BURN,	{ 1 }},
			{ ACT_LOG,	{ .s = "@30s" }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 3,
		.initial_delay	= 29000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "started@28s, will sleep for 5s" }},
			{ ACT_SLEEP,	{ 5000 }},
			{ ACT_TERM },
		}
	},
	{
		.id		= 4,
		.initial_delay	= 33000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "started@33s, will sleep for 5s" }},
			{ ACT_SLEEP,	{ 5000 }},
			{ ACT_TERM },
		}
	},
	{
		.id		= 5,
		.wq_id		= 1,	/* can't flush self */
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "flushing 0, 1 and 2" }},
			{ ACT_FLUSH,	{ 0 }},
			{ ACT_FLUSH,	{ 1 }},
			{ ACT_FLUSH,	{ 2 }},
			{ ACT_FLUSH_WQ,	{ 0 }},
			{ ACT_TERM },
		},
	},
	{ .id = -1 },
};

static const struct test_scenario scenario1 = {
	.wq_spec		= dfl_wq_spec,
	.work_spec		=
	(const struct work_spec *[]) { work_spec1, NULL },
};

/*
 * Scenario 2.  Combination of scenario 0 and 1.
 */
static const struct test_scenario scenario2 = {
	.wq_spec		= dfl_wq_spec,
	.work_spec		=
	(const struct work_spec *[]) { work_spec0, work_spec1, NULL },
};

/*
 * Scenario 3.  More complex flushing.
 *
 *               2:burn 2s        3:4s
 *                <---->      <---------->
 *     0:4s                1:4s
 * <---------->      <..----------->
 *    ^               ^
 *    |               |
 *    |               |
 * 4:flush(cpu0)    flush_wq
 * 5:flush(cpu0)    flush
 * 6:flush(cpu1)    flush_wq
 * 7:flush(cpu1)    flush
 */
static const struct work_spec work_spec2[] = {
	{
		.id		= 0,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 4s" }},
			{ ACT_SLEEP,	{ 4000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 1,
		.initial_delay	= 6000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 4s" }},
			{ ACT_SLEEP,	{ 4000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 2,
		.initial_delay	= 5000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "burning 2s" }},
			{ ACT_BURN,	{ 2000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 3,
		.initial_delay	= 9000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 4s" }},
			{ ACT_SLEEP,	{ 4000 }},
			{ ACT_TERM },
		},
	},

	{
		.id		= 4,
		.wq_id		= 1,
		.initial_delay	= 1000,
		.actions	= (const struct work_action[]) {
			{ ACT_FLUSH,	{ 0 }},
			{ ACT_SLEEP,	{ 2500 }},
			{ ACT_FLUSH_WQ,	{ 0 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 5,
		.wq_id		= 1,
		.initial_delay	= 1000,
		.actions	= (const struct work_action[]) {
			{ ACT_FLUSH,	{ 0 }},
			{ ACT_SLEEP,	{ 2500 }},
			{ ACT_FLUSH,	{ 1 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 6,
		.wq_id		= 1,
		.cpu		= 1,
		.initial_delay	= 1000,
		.actions	= (const struct work_action[]) {
			{ ACT_FLUSH,	{ 0 }},
			{ ACT_SLEEP,	{ 2500 }},
			{ ACT_FLUSH_WQ,	{ 0 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 7,
		.wq_id		= 1,
		.cpu		= 1,
		.initial_delay	= 1000,
		.actions	= (const struct work_action[]) {
			{ ACT_FLUSH,	{ 0 }},
			{ ACT_SLEEP,	{ 2500 }},
			{ ACT_FLUSH,	{ 1 }},
			{ ACT_TERM },
		},
	},
	{ .id = -1 },
};

static const struct test_scenario scenario3 = {
	.wq_spec		= dfl_wq_spec,
	.work_spec		=
	(const struct work_spec *[]) { work_spec2, NULL },
};

/*
 * Scenario 4.  Mayday!  To be used with MAX_CPU_WORKERS_ORDER reduced
 * to 2.
 */
static const struct work_spec work_spec4[] = {
	{
		.id		= 0,
		.requeue_cnt	= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 5s" }},
			{ ACT_SLEEP,	{ 5000 }},
			{ ACT_REQUEUE,	{ 5000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 1,
		.requeue_cnt	= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 5s" }},
			{ ACT_SLEEP,	{ 5000 }},
			{ ACT_REQUEUE,	{ 5000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 2,
		.requeue_cnt	= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 5s" }},
			{ ACT_SLEEP,	{ 5000 }},
			{ ACT_REQUEUE,	{ 5000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 3,
		.requeue_cnt	= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 5s" }},
			{ ACT_SLEEP,	{ 5000 }},
			{ ACT_REQUEUE,	{ 5000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 4,
		.wq_id		= 2,
		.requeue_cnt	= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 1s" }},
			{ ACT_SLEEP,	{ 1000 }},
			{ ACT_REQUEUE,	{ 5000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 5,
		.wq_id		= 2,
		.requeue_cnt	= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 1s" }},
			{ ACT_SLEEP,	{ 1000 }},
			{ ACT_REQUEUE,	{ 5000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 6,
		.wq_id		= 2,
		.requeue_cnt	= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 1s" }},
			{ ACT_SLEEP,	{ 1000 }},
			{ ACT_REQUEUE,	{ 5000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 7,
		.wq_id		= 2,
		.requeue_cnt	= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 1s" }},
			{ ACT_SLEEP,	{ 1000 }},
			{ ACT_REQUEUE,	{ 5000 }},
			{ ACT_TERM },
		},
	},
	{ .id = -1 },
};

static const struct test_scenario scenario4 = {
	.wq_spec		= dfl_wq_spec,
	.work_spec		=
	(const struct work_spec *[]) { work_spec4, NULL },
};

/*
 * Scenario 5.  To test cpu off/onlining.  A bunch of long running
 * tasks on cpu1.  Gets interesting with various other conditions
 * applied together - lowered MAX_CPU_WORKERS_ORDER, induced failure
 * or delay during CPU_DOWN/UP_PREPARE and so on.
 */
static const struct work_spec work_spec5[] = {
	/* runs for 30 secs */
	{
		.id		= 0,
		.cpu		= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 30s" }},
			{ ACT_SLEEP,	{ 30000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 1,
		.cpu		= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 30s" }},
			{ ACT_SLEEP,	{ 30000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 2,
		.cpu		= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 30s" }},
			{ ACT_SLEEP,	{ 30000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 3,
		.cpu		= 1,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 30s" }},
			{ ACT_SLEEP,	{ 30000 }},
			{ ACT_TERM },
		},
	},

	/* kicks in @15 and runs for 15 from wq0 */
	{
		.id		= 4,
		.cpu		= 1,
		.initial_delay	= 15000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 15s" }},
			{ ACT_SLEEP,	{ 15000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 5,
		.cpu		= 1,
		.initial_delay	= 15000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 15s" }},
			{ ACT_SLEEP,	{ 15000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 6,
		.cpu		= 1,
		.initial_delay	= 15000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 15s" }},
			{ ACT_SLEEP,	{ 15000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 7,
		.cpu		= 1,
		.initial_delay	= 15000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 15s" }},
			{ ACT_SLEEP,	{ 15000 }},
			{ ACT_TERM },
		},
	},

	/* kicks in @15 and runs for 15 from wq2 */
	{
		.id		= 8,
		.wq_id		= 2,
		.cpu		= 1,
		.initial_delay	= 15000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 15s" }},
			{ ACT_SLEEP,	{ 15000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 9,
		.wq_id		= 2,
		.cpu		= 1,
		.initial_delay	= 15000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 15s" }},
			{ ACT_SLEEP,	{ 15000 }},
			{ ACT_TERM },
		},
	},

	/* kicks in @30 and runs for 15 */
	{
		.id		= 10,
		.cpu		= 1,
		.initial_delay	= 30000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 15s" }},
			{ ACT_SLEEP,	{ 15000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 11,
		.cpu		= 1,
		.initial_delay	= 30000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 15s" }},
			{ ACT_SLEEP,	{ 15000 }},
			{ ACT_TERM },
		},
	},

	{ .id = -1 },
};

static const struct test_scenario scenario5 = {
	.wq_spec		= dfl_wq_spec,
	.work_spec		=
	(const struct work_spec *[]) { work_spec5, NULL },
};

/*
 * Scenario 6.  Scenario to test freezeable workqueue.  User should
 * freeze the machine between 0s and 9s.
 *
 * 0,1:sleep 10s
 * <-------->
 *      <--freezing--><--frozen--><-thawed
 *         2,3: sleeps for 10s
 *          <.....................-------->
 *          <.....................-------->
 */
static const struct work_spec work_spec6[] = {
	/* two works which get queued @0s and sleeps for 10s */
	{
		.id		= 0,
		.wq_id		= 3,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 10s" }},
			{ ACT_SLEEP,	{ 10000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 1,
		.wq_id		= 3,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 10s" }},
			{ ACT_SLEEP,	{ 10000 }},
			{ ACT_TERM },
		},
	},
	/* two works which get queued @9s and sleeps for 10s */
	{
		.id		= 2,
		.wq_id		= 3,
		.initial_delay	= 9000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 10s" }},
			{ ACT_SLEEP,	{ 10000 }},
			{ ACT_TERM },
		},
	},
	{
		.id		= 3,
		.wq_id		= 3,
		.initial_delay	= 9000,
		.actions	= (const struct work_action[]) {
			{ ACT_LOG,	{ .s = "sleeping for 10s" }},
			{ ACT_SLEEP,	{ 10000 }},
			{ ACT_TERM },
		},
	},

	{ .id = -1 },
};

static const struct test_scenario scenario6 = {
	.wq_spec		= dfl_wq_spec,
	.work_spec		=
	(const struct work_spec *[]) { work_spec6, NULL },
};

static const struct test_scenario *scenarios[] = {
	&scenario0, &scenario1, &scenario2, &scenario3, &scenario4, &scenario5,
	&scenario6,
};

/*
 * Execute
 */
static struct task_struct *sequencer;
static char wq_names[MAX_WQS][MAX_WQ_NAME];
static struct workqueue_struct *wqs[MAX_WQS];
static struct delayed_work dworks[MAX_WORKS];
#ifdef CONFIG_LOCKDEP
static struct lock_class_key wq_lockdep_keys[MAX_WORKS];
static struct lock_class_key dwork_lockdep_keys[MAX_WORKS];
#endif
static const struct work_spec *work_specs[MAX_WORKS];
static bool sleeping[MAX_WORKS];
static wait_queue_head_t wait_heads[MAX_WORKS];
static int requeue_cnt[MAX_WORKS];

static void test_work_fn(struct work_struct *work)
{
	int id = to_delayed_work(work) - dworks;
	const struct work_spec *spec = work_specs[id];
	const struct work_action *act = spec->actions;
	int rc;

#define pd(lvl, fmt, args...)	\
	printk("w%02d/%04d@%d "lvl": "fmt"\n", id, current->pid, raw_smp_processor_id() , ##args);
#define plog(fmt, args...)	pd("LOG ", fmt , ##args)
#define pinfo(fmt, args...)	pd("INFO", fmt , ##args)
#define perr(fmt, args...)	pd("ERR ", fmt , ##args)
repeat:
	switch (act->action) {
	case ACT_TERM:
		pinfo("TERM");
		return;
	case ACT_LOG:
		plog("%s", act->s);
		break;
	case ACT_BURN:
		mdelay(act->v);
		break;
	case ACT_SLEEP:
		sleeping[id] = true;
		wait_event_timeout(wait_heads[id], !sleeping[id],
				   msecs_to_jiffies(act->v));
		if (!sleeping[id])
			pinfo("somebody woke me up");
		sleeping[id] = false;
		break;
	case ACT_WAKEUP:
		if (act->v < MAX_WORKS && sleeping[act->v]) {
			pinfo("waking %lu up", act->v);
			sleeping[act->v] = false;
			wake_up(&wait_heads[act->v]);
		} else
			perr("trying to wake up non-sleeping work %lu",
			     act->v);
		break;
	case ACT_REQUEUE:
		if (requeue_cnt[id] > 0 || requeue_cnt[id] < 0) {
			int cpu;

			get_online_cpus();

			if (spec->cpu < nr_cpu_ids && cpu_online(spec->cpu))
				cpu = spec->cpu;
			else
				cpu = raw_smp_processor_id();

			if (act->v)
				queue_delayed_work_on(cpu, wqs[spec->wq_id],
						      &dworks[id],
						      msecs_to_jiffies(act->v));
			else
				queue_work_on(cpu, wqs[spec->wq_id],
					      &dworks[id].work);

			pinfo("requeued on cpu%d delay=%lumsecs",
			      cpu, act->v);
			if (requeue_cnt[id] > 0)
				requeue_cnt[id]--;

			put_online_cpus();
		} else
			pinfo("requeue limit reached");

		break;
	case ACT_FLUSH:
		if (act->v < MAX_WORKS && work_specs[act->v]) {
			pinfo("flushing work %lu", act->v);
			rc = flush_work(&dworks[act->v].work);
			pinfo("flushed work %lu, rc=%d", act->v, rc);
		} else
			perr("trying to flush non-existent work %lu", act->v);
		break;
	case ACT_FLUSH_WQ:
		if (act->v < MAX_WQS && wqs[act->v]) {
			pinfo("flushing workqueue %lu", act->v);
			flush_workqueue(wqs[act->v]);
			pinfo("flushed workqueue %lu", act->v);
		} else
			perr("trying to flush non-existent workqueue %lu",
			     act->v);
		break;
	case ACT_CANCEL:
		if (act->v < MAX_WORKS && work_specs[act->v]) {
			pinfo("canceling work %lu", act->v);
			rc = cancel_delayed_work_sync(&dworks[act->v]);
			pinfo("canceled work %lu, rc=%d", act->v, rc);
		} else
			perr("trying to cancel non-existent work %lu", act->v);
		break;
	}
	act++;
	goto repeat;
}

#define for_each_work_spec(spec, i, scenario)				\
	for (i = 0, spec = scenario->work_spec[i]; spec;		\
	     spec = (spec + 1)->id >= 0 ? spec + 1 : scenario->work_spec[++i])

static int sequencer_thread(void *__scenario)
{
	const struct test_scenario *scenario = __scenario;
	const struct wq_spec *wq_spec;
	const struct work_spec *work_spec;
	int i, id;

	for (wq_spec = scenario->wq_spec; wq_spec->id >= 0; wq_spec++) {
		if (wq_spec->id >= MAX_WQS) {
			printk("ERR : wq id %d too high\n", wq_spec->id);
			goto err;
		}

		if (wqs[wq_spec->id]) {
			printk("ERR : wq %d already occupied\n", wq_spec->id);
			goto err;
		}

		snprintf(wq_names[wq_spec->id], MAX_WQ_NAME, "test-wq-%02d",
			 wq_spec->id);
		wqs[wq_spec->id] = __create_workqueue_key(wq_names[wq_spec->id],
						wq_spec->flags,
						&wq_lockdep_keys[wq_spec->id],
						wq_names[wq_spec->id]);
		if (!wqs[wq_spec->id]) {
			printk("ERR : failed create wq %d\n", wq_spec->id);
			goto err;
		}
	}

	for_each_work_spec(work_spec, i, scenario) {
		struct delayed_work *dwork = &dworks[work_spec->id];
		struct workqueue_struct *wq = wqs[work_spec->wq_id];

		if (work_spec->id >= MAX_WORKS) {
			printk("ERR : work id %d too high\n", work_spec->id);
			goto err;
		}

		if (!wq) {
			printk("ERR : work %d references non-existent wq %d\n",
			       work_spec->id, work_spec->wq_id);
			goto err;
		}

		if (work_specs[work_spec->id]) {
			printk("ERR : work %d already initialized\n",
			       work_spec->id);
			goto err;
		}
		INIT_DELAYED_WORK(dwork, test_work_fn);
#ifdef CONFIG_LOCKDEP
		lockdep_init_map(&dwork->work.lockdep_map, "test-dwork",
				 &dwork_lockdep_keys[work_spec->id], 0);
#endif
		work_specs[work_spec->id] = work_spec;
		init_waitqueue_head(&wait_heads[work_spec->id]);
		requeue_cnt[work_spec->id] = work_spec->requeue_cnt ?: -1;
	}

	for_each_work_spec(work_spec, i, scenario) {
		struct delayed_work *dwork = &dworks[work_spec->id];
		struct workqueue_struct *wq = wqs[work_spec->wq_id];
		int cpu;

		get_online_cpus();

		if (work_spec->cpu < nr_cpu_ids && cpu_online(work_spec->cpu))
			cpu = work_spec->cpu;
		else
			cpu = raw_smp_processor_id();

		if (work_spec->initial_delay)
			queue_delayed_work_on(cpu, wq, dwork,
				msecs_to_jiffies(work_spec->initial_delay));
		else
			queue_work_on(cpu, wq, &dwork->work);

		put_online_cpus();
	}

	set_current_state(TASK_INTERRUPTIBLE);
	while (!kthread_should_stop()) {
		schedule();
		set_current_state(TASK_INTERRUPTIBLE);
	}
	set_current_state(TASK_RUNNING);

err:
	for (id = 0; id < MAX_WORKS; id++)
		if (work_specs[id])
			cancel_delayed_work_sync(&dworks[id]);
	for (id = 0; id < MAX_WQS; id++)
		if (wqs[id])
			destroy_workqueue(wqs[id]);

	set_current_state(TASK_INTERRUPTIBLE);
	while (!kthread_should_stop()) {
		schedule();
		set_current_state(TASK_INTERRUPTIBLE);
	}

	return 0;
}

static int scenario_switch = -1;
module_param_named(scenario, scenario_switch, int, 0444);

static int __init test_init(void)
{
	if (scenario_switch < 0 || scenario_switch >= ARRAY_SIZE(scenarios)) {
		printk("TEST WQ - no such scenario\n");
		return -EINVAL;
	}

	printk("TEST WQ - executing scenario %d\n", scenario_switch);
	sequencer = kthread_run(sequencer_thread,
				(void *)scenarios[scenario_switch],
				"test-wq-sequencer");
	if (IS_ERR(sequencer))
		return PTR_ERR(sequencer);
	return 0;
}

static void __exit test_exit(void)
{
	kthread_stop(sequencer);
}

module_init(test_init);
module_exit(test_exit);
MODULE_LICENSE("GPL");

--------------050808020009000900030300--
