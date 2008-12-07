Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYLGH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYLGH1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 02:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYLGH1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 02:27:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbYLGH1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 02:27:38 -0500
Date: Sat, 6 Dec 2008 23:27:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] export percpu cpuacct cgroup stats
Message-Id: <20081206232714.4b34b2fc.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0812051016q7912688dw2c663a77121a8f18@mail.gmail.com>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
	<49376BE3.1040909@cn.fujitsu.com>
	<6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>
	<b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com>
	<4938DE1C.6070608@cn.fujitsu.com>
	<b040c32a0812050030uff5ae65o417c599a792c800c@mail.gmail.com>
	<4938E7C1.9040102@cn.fujitsu.com>
	<20081205135253.GE27039@elte.hu>
	<b040c32a0812051016q7912688dw2c663a77121a8f18@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 10:16:30 -0800 Ken Chen <kenchen@google.com> wrote:

> +static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
> +				   struct seq_file *m)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgroup);
> +	u64 percpu;
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		spin_lock_irq(&cpu_rq(i)->lock);
> +		percpu = *percpu_ptr(ca->cpuusage, i);
> +		spin_unlock_irq(&cpu_rq(i)->lock);
> +		seq_printf(m, "%llu ", (unsigned long long) percpu);
> +	}
> +	seq_printf(m, "\n");
> +	return 0;
> +}

The locking is only needed for 32-bit, I assume?

The iteration across all possible CPUs seems a bit lame - that code
looks pretty easy to convert to hotplug goodness.

(All of which pertains to existing code, not to this patch).
