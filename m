Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYGLFHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYGLFHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 01:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYGLFHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 01:07:46 -0400
Received: from ozlabs.org ([203.10.76.45]:48697 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYGLFHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 01:07:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Date: Sat, 12 Jul 2008 15:07:31 +1000
User-Agent: KMail/1.9.9
Cc: Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807111751.14728.rusty@rustcorp.com.au> <20080711131220.GA7589@Krystal>
In-Reply-To: <20080711131220.GA7589@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807121507.31640.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 23:12:21 Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > On Thursday 10 July 2008 10:30:37 Max Krasnyansky wrote:
> > > You mentioned (in private conversation) that you were going to add some
> > > logic that checks whether CPU is running user-space code and not
> > > holding any locks to avoid scheduling stop_machine thread on it. 
> >
> > Will play with it again and report,
> > Rusty.
>
> Hrm, I must be missing something, but using the fact that other CPUs are
> running in userspace as a guarantee that they are not running within
> critical kernel sections seems kind of.. racy ? I'd like to have a look
> at this experimental patch : does it inhibit interrupts somehow and/or
> does it take control of userspace processes doing system calls at that
> precise moment ?

The idea was to try this ipi-to-all-cpus  and fall back on the current thread
method if it doesn't work.  I suspect it will succeed in the vast majority of
cases (with CONFIG_PREEMPT, we can also let the function execute if in-kernel
but preemptible).  Something like this:

+struct ipi_data {
+	atomic_t acked;
+	atomic_t failed;
+	unsigned int cpu;
+	int fnret;
+	int (*fn)(void *data);
+	void *data;
+};
+
+static void ipi_func(void *info)
+{
+	struct ipi_data *ipi = info;
+	bool ok = false;
+
+	printk("get_irq_regs(%i) = %p\n", smp_processor_id(), get_irq_regs());
+	goto fail;
+
+	if (user_mode(get_irq_regs()))
+		ok = true;
+	else {
+#ifdef CONFIG_PREEMPT
+		/* We're in an interrupt, ok, but were we preemptible
+		 * before that? */
+		if ((hardirq_count() >> HARDIRQ_SHIFT) == 1) {
+			int prev = preempt_count() & ~HARDIRQ_MASK;
+			if ((prev & ~PREEMPT_ACTIVE) == PREEMPT_INATOMIC_BASE)
+				ok = true;
+		}
+#endif
+	}
+
+fail:
+	if (!ok) {
+		/* Mark our failure before acking. */
+		atomic_inc(&ipi->failed);
+		wmb();
+	}
+
+	if (smp_processor_id() != ipi->cpu) {
+		/* Wait for cpu to call function (last to ack). */
+		atomic_inc(&ipi->acked);
+		while (atomic_read(&ipi->acked) != num_online_cpus())
+			cpu_relax();
+	} else {
+		while (atomic_read(&ipi->acked) != num_online_cpus() - 1)
+			cpu_relax();
+		/* Must read acked before failed. */
+		rmb();
+
+		/* Call function if noone failed. */
+		if (atomic_read(&ipi->failed) == 0)
+			ipi->fnret = ipi->fn(ipi->data);
+		atomic_inc(&ipi->acked);
+	}
+}
+
+static bool try_ipi_stop(int (*fn)(void *), void *data, unsigned int cpu,
+			 int *ret)
+{
+	struct ipi_data ipi;
+
+	/* If they don't care which cpu fn runs on, just pick one. */
+	if (cpu == NR_CPUS)
+		ipi.cpu = any_online_cpu(cpu_online_map);
+	else
+		ipi.cpu = cpu;
+
+	atomic_set(&ipi.acked, 0);
+	atomic_set(&ipi.failed, 0);
+	ipi.fn = fn;
+	ipi.data = data;
+	ipi.fnret = 0;
+
+	smp_call_function(ipi_func, &ipi, 0, 1);
+
+	printk("stop_machine: ipi acked %u failed %u\n",
+	       atomic_read(&ipi.acked), atomic_read(&ipi.failed));
+	*ret = ipi.fnret;
+	return (atomic_read(&ipi.failed) == 0);
+}

Hope that clarifies!
Rusty.

