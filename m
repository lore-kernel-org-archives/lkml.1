Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbYLPRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbYLPRbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYLPRb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:31:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbYLPRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:31:27 -0500
Date: Tue, 16 Dec 2008 18:30:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com
Subject: Re: [rfc] x86, ptrace: memory accounting for branch tracing
Message-ID: <20081216173059.GD11683@elte.hu>
References: <20081216162424.A30209@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216162424.A30209@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Account memory allocated for the BTS buffer to the traced task's 
> total_vm and locked_vm.

Andrew, is this the right (and preferred) way to attach BTS buffer 
allocation overhead to the RLIMIT_MEMLOCK bucket:

> +static int ptrace_bts_allocate_buffer(struct task_struct *child, size_t size)
> +{
> +	unsigned long rlim, vm, pgsz;
> +	int error = -ENOMEM;
> +
> +	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +
> +	down_write(&child->mm->mmap_sem);
> +
> +	rlim = child->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
> +	vm   = child->mm->total_vm + pgsz;
> +	if (rlim < vm)
> +		goto out;
> +
> +	rlim = child->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
> +	vm   = child->mm->locked_vm + pgsz;
> +	if (rlim < vm)
> +		goto out;
> +
> +	child->bts_buffer = kzalloc(size, GFP_KERNEL);
> +	if (!child->bts_buffer)
> +		goto out;
> +
> +	child->bts_size = size;
> +
> +	child->mm->total_vm  += pgsz;
> +	child->mm->locked_vm += pgsz;
> +
> +	error = 0;
> + out:
> +	up_write(&child->mm->mmap_sem);
> +	return error;

?

	Ingo
