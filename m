Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbZADTEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbZADTEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbZADTEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:04:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52944 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZADTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:04:10 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up kernel boot
From: Andi Kleen <andi@firstfloor.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092857.5fbf6b2d@infradead.org>
Date: Sun, 04 Jan 2009 20:05:26 +0100
In-Reply-To: <20090104092857.5fbf6b2d@infradead.org> (Arjan van de Ven's message of "Sun, 4 Jan 2009 09:28:57 -0800")
Message-ID: <87k59aops9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
> +static int async_manager_thread(void *unused)
> +{
> +	int max_threads;
> +	DECLARE_WAITQUEUE(wq, current);
> +	add_wait_queue(&async_new, &wq);
> +
> +	while (!kthread_should_stop()) {
> +		int tc, ec;
> +
> +		/*
> +		 * Maximum number of worker threads.
> +		 * Even on the smallest machine we want 8
> +		 * Scaling by 4 per logical CPU
> +		 * But no more than 256 to not overload stuff too much
> +		 * (and yes these are magic numbers that might need tuning)
> +		 * Calculated dynamic because early on the nr of online cpus
> +		 * is 1...
> +		 */
> +		max_threads = 4 + 4 * num_online_cpus();
> +		if (max_threads > 256)
> +			max_threads = 256;
> +
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +
> +		tc = atomic_read(&thread_count);
> +		rmb();
> +		ec = atomic_read(&entry_count);
> +
> +		while (tc < ec && tc < max_threads) {
> +			kthread_run(async_thread, NULL, "async/%i", tc);
> +			atomic_inc(&thread_count);
> +			tc++;
> +		}
> +
> +		schedule();

Surely the thread should die again boot up? On module load
synchronisity is usually not a problem.

Personally I think it would be better to make this more generic.
Various subsystems have thread pool implementations now, and this
is just another variant that except for the sequence stuff
isn't all that much different. So it would be better to have 
a generic worker thread manager that just supports these
barriers too.

-andi

-- 
ak@linux.intel.com
