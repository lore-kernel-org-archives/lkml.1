Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYK0RZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYK0RZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYK0RZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:25:30 -0500
Received: from www.tglx.de ([62.245.132.106]:35672 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYK0RZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:25:30 -0500
Date: Thu, 27 Nov 2008 18:24:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@googlemail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 02/24] perfmon: base code
In-Reply-To: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
Message-ID: <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain>
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, eranian@googlemail.com wrote:

> Index: o3/perfmon/perfmon_res.c

> +/*
> + * global information about all sessions
> + */
> +struct pfm_resources {
> +	cpumask_t sys_cpumask;     /* bitmask of used cpus */
> +	u32 thread_sessions; /* #num loaded per-thread sessions */
> +};

What's the purpose of this being a structure if it's just a single
instance ?

> +static struct pfm_resources pfm_res;
> +
> +static __cacheline_aligned_in_smp DEFINE_SPINLOCK(pfm_res_lock);

> +/**
> + * pfm_session_acquire - reserve a per-thread session
> + *
> + * return:
> + * 	 0    : success
> + * 	-EBUSY: if conflicting session exist

  Where ?

> + */
> +int pfm_session_acquire(void)
> +{
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	/*
> +	 * validy checks on cpu_mask have been done upstream
> +	 */

  How please ? pfm_res.sys_cpumask is local to this file and you want
  to check it under the lock and _before_ you increment
  thread_sessions blindly.

> +	spin_lock_irqsave(&pfm_res_lock, flags);
> +
> +	PFM_DBG("in  thread=%u",
> +		pfm_res.thread_sessions);
> +
> +	pfm_res.thread_sessions++;
> +
> +	PFM_DBG("out thread=%u ret=%d",
> +		pfm_res.thread_sessions,
> +		ret);
> +
> +	spin_unlock_irqrestore(&pfm_res_lock, flags);
> +
> +	return ret;
> +}
> +
> +/**
> + * pfm_session_release - release a per-thread session
> + *
> + * called from __pfm_unload_context()
> + */
> +void pfm_session_release(void)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pfm_res_lock, flags);
> +
> +	PFM_DBG("in thread=%u",
> +		pfm_res.thread_sessions);
> +
> +	pfm_res.thread_sessions--;
> +
> +	PFM_DBG("out thread=%u",
> +		pfm_res.thread_sessions);


 What's the value of these debugs ? Prove that the compiler managed to
 compile "pfm_res.thread_sessions--;" correctly ?

 A WARN_ON(!pfm_res.thread_sessions) instead of blindly decrementing
 would be way more useful.

> +	spin_unlock_irqrestore(&pfm_res_lock, flags);
> +}

<adding the bits from the oprofile patch, which belong here as they
are not x86 specific>

+
+/**
+ * pfm_session_allcpus_acquire - acquire per-cpu sessions on all available cpus
+ *
+ * currently used by Oprofile on X86
+ */
+int pfm_session_allcpus_acquire(void)

+	for_each_online_cpu(cpu) {
+		cpu_set(cpu, pfm_res.sys_cpumask);
+		nsys_cpus++;
+	}

 Sigh, why do we need a loop to copy a bitfield ?

+/**
+ * pfm_session_allcpus_release - relase per-cpu sessions on all cpus
+ *
+ * currently used by Oprofile code
+ */
+void pfm_session_allcpus_release(void)
+{
+	unsigned long flags;
+	u32 nsys_cpus, cpu;
+
+	spin_lock_irqsave(&pfm_res_lock, flags);
+
+	nsys_cpus = cpus_weight(pfm_res.sys_cpumask);
+
+	PFM_DBG("in  sys=%u task=%u",
+		nsys_cpus,
+		pfm_res.thread_sessions);
+
+	/*
+	 * XXX: could use __cpus_clear() with nbits
+	 */

	  __cpus_clear(pfm_res.sys_cpumask, nsys_cpus); ????

 That'd be real fun with a sparse mask.

+	for_each_online_cpu(cpu) {
+		cpu_clear(cpu, pfm_res.sys_cpumask);
+		nsys_cpus--;
+	}

 Yuck. cpus_clear() perhaps ?

+EXPORT_SYMBOL(pfm_session_allcpus_release);

All what that code should do (in fact it does not) is preventing the
mix of thread and system wide sessions.

It does neither need a cpumask nor tons of useless loops and debug
outputs with zero value.

static int global_session;
static int thread_sessions;
static DEFINE_SPINLOCK(session_lock);

int pfm_session_request(int global)
{
	unsigned long flags;
	int res = -EBUSY;

	spin_lock_irqsave(&session_lock, flags);

	if (!global && !global_session) {
	   	thread_sessions++;
		res = 0;
	}

	if (global && !thread_sessions && !global_session) {
	   	global_session = 1;
		res = 0;
	}

 	spin_unlock_irqrestore(&session_lock, flags);
	return res;
}

void pfm_session_release(int global)
{
	unsigned long flags;

	spin_lock_irqsave(&session_lock, flags);

	if (global) {
		WARN_ON(!global_session);
		global_session = 0;
	} else {
		if (!global_session && thread_sessions)
			thread_session--;
		else
			WARN();
	}

	spin_unlock_irqrestore(&session_lock, flags);
}

Would do it nicely including useful sanity checks and 70% less code.

Thanks,

	tglx
