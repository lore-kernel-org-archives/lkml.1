Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbXKORM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbXKORM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbXKORMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:12:19 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:38436 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbXKORMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:12:17 -0500
Date: Thu, 15 Nov 2007 20:12:17 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 1/3] cpu-hotplug: Refcount Based Cpu Hotplug implementation
Message-ID: <20071115171217.GA144@tv-sign.ru>
References: <20071115134924.GA15282@in.ibm.com> <20071115135108.GA15462@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115135108.GA15462@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15, Gautham R Shenoy wrote:
>
> +static struct {
> +	struct task_struct *active_writer;
> +	struct mutex lock; /* Synchronizes accesses to refcount, */
> +	/*
> +	 * Also blocks the new readers during
> +	 * an ongoing cpu hotplug operation.
> +	 */
> +	int refcount;
> +	wait_queue_head_t writer_queue;
> +} cpu_hotplug;
> ...
>  void unlock_cpu_hotplug(void)
>  {
> -	WARN_ON(recursive != current);
> -	if (recursive_depth) {
> -		recursive_depth--;
> +	if (cpu_hotplug.active_writer == current)
>  		return;
> -	}
> -	recursive = NULL;
> -	mutex_unlock(&cpu_bitmask_lock);
> +	mutex_lock(&cpu_hotplug.lock);
> +	cpu_hotplug.refcount--;
> +
> +	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
> +		wake_up(&cpu_hotplug.writer_queue);
> +
> +	mutex_unlock(&cpu_hotplug.lock);
> +
>  }
> ...
> +static void cpu_hotplug_begin(void)
> +{
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	mutex_lock(&cpu_hotplug.lock);
> +
> +	cpu_hotplug.active_writer = current;
> +	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
> +	while (cpu_hotplug.refcount) {
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		mutex_unlock(&cpu_hotplug.lock);
> +		schedule();
> +		mutex_lock(&cpu_hotplug.lock);
> +	}
> +	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
> +}

Perhaps we can simplify this a little bit? I don't think we really need
cpu_hotplug.writer_queue, afaics we can just do

	void unlock_cpu_hotplug(void)
	{
		if (cpu_hotplug.active_writer == current)
			return;
		mutex_lock(&cpu_hotplug.lock);
		if (!--cpu_hotplug.refcount && cpu_hotplug.active_writer)
			wake_up_process(cpu_hotplug.active_writer);
		mutex_unlock(&cpu_hotplug.lock);

	}

	static void cpu_hotplug_begin(void)
	{
		mutex_lock(&cpu_hotplug.lock);
		cpu_hotplug.active_writer = current;

		while (cpu_hotplug.refcount) {
			__set_current_state(TASK_UNINTERRUPTIBLE);
			mutex_unlock(&cpu_hotplug.lock);
			schedule();
			mutex_lock(&cpu_hotplug.lock);
		}
	}

(not that it matters, we can do this later even if I am right)

Oleg.

