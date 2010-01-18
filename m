Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621Ab0ARA72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0ARA72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303Ab0ARA7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:59:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:50228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab0ARA7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:59:22 -0500
Message-ID: <4B53B376.1080001@kernel.org>
Date: Mon, 18 Jan 2010 10:03:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: perf-wq.c used to generate synthetic workload
References: <1263776272-382-1-git-send-email-tj@kernel.org>
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080100090700070300060406"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:57:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080100090700070300060406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached.

Thanks.

-- 
tejun

--------------080100090700070300060406
Content-Type: text/x-csrc;
 name="perf-wq.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf-wq.c"

#include <linux/module.h>
#include <linux/workqueue.h>
#include <linux/jiffies.h>
#include <linux/delay.h>
#include <linux/sched.h>
#include <linux/wait.h>
#include <linux/cpu.h>
#include <linux/kthread.h>
#include <linux/random.h>
#include <linux/completion.h>

#define MAX_TEST_SECS			300

struct workload_spec {
	const char			*name;
	unsigned int			burn_usecs;
	unsigned int			mean_sleep_msecs;
	unsigned int			mean_resched_msecs;
	unsigned int			factor;
};

struct test_spec {
	const struct workload_spec	*workload;
	unsigned int			wq_id;
	unsigned int			nr_works;
};

struct test_run {
	char				name[64];
	struct delayed_work		dwork;
	struct workqueue_struct		*wq;
	const struct workload_spec	*spec;
	unsigned int			cycles_left;
	unsigned long			start;
	unsigned long			end;
	struct completion		done;
};

static const struct workload_spec workload_short = {
	.name				= "sht",
	.burn_usecs			= 50,
	.mean_sleep_msecs		= 1,
	.mean_resched_msecs		= 10,
	.factor				= 3,
};

static const struct workload_spec workload_medium = {
	.name				= "med",
	.burn_usecs			= 50,
	.mean_sleep_msecs		= 10,
	.mean_resched_msecs		= 50,
	.factor				= 2,
};

static const struct workload_spec workload_long = {
	.name				= "lng",
	.burn_usecs			= 50,
	.mean_sleep_msecs		= 100,
	.mean_resched_msecs		= 250,
	.factor				= 1,
};

static const struct test_spec test_specs[] = {
	/*       workload     wq_id  nr_works */
	{ &workload_short,        0,        4 },
	{ &workload_short,        1,        4 },
	{ &workload_short,        2,        4 },
	{ &workload_short,        3,        4 },

	{ &workload_short,        4,        2 },
	{ &workload_medium,       4,        2 },
	{ &workload_short,        5,        2 },
	{ &workload_medium,       5,        2 },

	{ &workload_medium,       6,        2 },
	{ &workload_long,         6,        1 },
	{ &workload_medium,       7,        2 },
	{ &workload_long,         7,        1 },
	{ &workload_medium,       8,        2 },
	{ &workload_long,         8,        1 },
	{ &workload_medium,       9,        2 },
	{ &workload_long,         9,        1 },

	{ &workload_long,	 10,        1 },
	{ &workload_long,	 11,        1 },
	{ &workload_long,        12,        1 },
	{ &workload_long,        13,        1 },
	{ &workload_long,	 14,        1 },
	{ &workload_long,	 15,        1 },
	{ &workload_long,        16,        1 },
	{ &workload_long,        17,        1 },

	{ &workload_short,       18,        4 },
	{ &workload_short,	 19,        4 },
	{ &workload_short,	 20,        4 },
	{ &workload_short,	 21,        4 },
	{ &workload_short,       22,        4 },
	{ &workload_short,	 23,        4 },
	{ &workload_short,	 24,        4 },
	{ &workload_short,	 25,        4 },
};

static const int nr_test_specs = ARRAY_SIZE(test_specs);

static unsigned int nr_wqs;
static unsigned int nr_test_runs;

static struct workqueue_struct **wqs;
static struct test_run *test_runs;

static void perf_wq_func(struct work_struct *work)
{
	struct delayed_work *dwork = to_delayed_work(work);
	struct test_run *run = container_of(dwork, struct test_run, dwork);
	const struct workload_spec *spec = run->spec;
	unsigned int sleep, tmp, delay;

	sleep = (spec->mean_sleep_msecs * (random32() % 200)) / 100;
	tmp = sleep * (random32() % 100) / 100;
	msleep(tmp);
	sleep -= tmp;

	udelay(spec->burn_usecs);

	msleep(sleep);

	if (--run->cycles_left) {
		delay = (spec->mean_resched_msecs * (random32() % 200)) / 100;
		queue_delayed_work(run->wq, dwork, msecs_to_jiffies(delay));
	} else {
		run->end = jiffies;
		complete(&run->done);
	}
}

static int param_set_trigger(const char *val, struct kernel_param *kp)
{
	static DEFINE_MUTEX(mutex);
	int i, dur;

	if (!mutex_trylock(&mutex))
		return -EBUSY;

	dur = simple_strtoul(val, NULL, 0);
	if (dur <= 0 || dur > MAX_TEST_SECS) {
		pr_err("perf-wq: invalid duration %s\n", val);
		return -EINVAL;
	}

	pr_info("perf-wq: duration %d\n", dur);

	for (i = 0; i < nr_test_runs; i++) {
		struct test_run *run = &test_runs[i];
		const struct workload_spec *spec = run->spec;
		unsigned int cycle_msec =
			spec->mean_sleep_msecs + spec->mean_resched_msecs;

		run->start = jiffies;
		run->cycles_left = dur * 1000 / cycle_msec;
		if (spec->factor)
			run->cycles_left /= spec->factor;
		INIT_COMPLETION(run->done);
		queue_delayed_work(run->wq, &run->dwork, 0);
	}

	for (i = 0; i < nr_test_runs; i++) {
		struct test_run *run = &test_runs[i];

		wait_for_completion(&run->done);
		pr_info("perf-wq: test %s ran for %u msecs\n",
			run->name, jiffies_to_msecs(run->end - run->start));
	}

	mutex_unlock(&mutex);

	return 0;
}

module_param_call(trigger, param_set_trigger, NULL, NULL, 0600);

static int __init perf_wq_init(void)
{
	struct test_run *run;
	int i, j;

	for (i = 0; i < nr_test_specs; i++) {
		nr_wqs = max(nr_wqs, test_specs[i].wq_id + 1);
		nr_test_runs += test_specs[i].nr_works;
	}

	wqs = kzalloc(sizeof(wqs[0]) * nr_wqs, GFP_KERNEL);
	test_runs = kzalloc(sizeof(test_runs[0]) * nr_test_runs, GFP_KERNEL);

	if (!wqs || !test_runs) {
		pr_err("perf-wq: allocation failed\n");
		goto fail;
	}

	for (i = 0; i < nr_wqs; i++) {
		char buf[32];

		snprintf(buf, sizeof(buf), "pwq-%02d", i);
		wqs[i] = create_workqueue(buf);
		if (!wqs[i])
			goto fail;
	}

	run = test_runs;
	for (i = 0; i < nr_test_specs; i++) {
		const struct test_spec *spec = &test_specs[i];

		for (j = 0; j < spec->nr_works; j++) {
			snprintf(run->name, sizeof(run->name), "%s-%d:%d@%d",
				 spec->workload->name, i, j, spec->wq_id);
			INIT_DELAYED_WORK(&run->dwork, perf_wq_func);
			init_completion(&run->done);
			run->wq = wqs[spec->wq_id];
			run->spec = spec->workload;
			run++;
		}
	}

	pr_info("perf-wq initialized, echo duration in seconds to "
		"/sys/module/perf_wq/parameters/trigger to start test cycles\n");

	return 0;

fail:
	if (wqs)
		for (i = 0; i < nr_wqs; i++)
			if (wqs[i])
				destroy_workqueue(wqs[i]);
	kfree(wqs);
	kfree(test_runs);
	return -ENOMEM;
}

static void __exit perf_wq_exit(void)
{
	int i;

	for (i = 0; i < nr_wqs; i++)
		destroy_workqueue(wqs[i]);
	kfree(wqs);
	kfree(test_runs);
}

module_init(perf_wq_init);
module_exit(perf_wq_exit);
MODULE_LICENSE("GPL");

--------------080100090700070300060406--
