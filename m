Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYLPSTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYLPSTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYLPSTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:19:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYLPSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:19:14 -0500
Date: Tue, 16 Dec 2008 10:18:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Markus Metzger <markus.t.metzger@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com
Subject: Re: [rfc] x86, ptrace: memory accounting for branch tracing
Message-Id: <20081216101804.eccda780.akpm@linux-foundation.org>
In-Reply-To: <20081216173059.GD11683@elte.hu>
References: <20081216162424.A30209@sedona.ch.intel.com>
	<20081216173059.GD11683@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 18:30:59 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Markus Metzger <markus.t.metzger@intel.com> wrote:
> 
> > Account memory allocated for the BTS buffer to the traced task's 
> > total_vm and locked_vm.
> 
> Andrew, is this the right (and preferred) way to attach BTS buffer 
> allocation overhead to the RLIMIT_MEMLOCK bucket:

Close.  I suspect we could refactor mlock.c to avoid all the code
duplication we have there.

There's (almost) nothing BTS-specific in this code, and it would be
better if it lived in mm/mlock.c.  Hopefully in a
usable-by-other-parts-of-mlock.c fashion.

> > +static int ptrace_bts_allocate_buffer(struct task_struct *child, size_t size)
> > +{
> > +	unsigned long rlim, vm, pgsz;
> > +	int error = -ENOMEM;
> > +
> > +	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
> > +
> > +	down_write(&child->mm->mmap_sem);
> > +
> > +	rlim = child->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
> > +	vm   = child->mm->total_vm + pgsz;
> > +	if (rlim < vm)

This is off-by-one, I think.  Should be

	if (vm > rmlim)

> > +		goto out;
> > +
> > +	rlim = child->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
> > +	vm   = child->mm->locked_vm + pgsz;
> > +	if (rlim < vm)

ditto

> > +		goto out;
> > +
> > +	child->bts_buffer = kzalloc(size, GFP_KERNEL);
> > +	if (!child->bts_buffer)
> > +		goto out;
> > +
> > +	child->bts_size = size;
> > +
> > +	child->mm->total_vm  += pgsz;
> > +	child->mm->locked_vm += pgsz;
> > +
> > +	error = 0;
> > + out:
> > +	up_write(&child->mm->mmap_sem);
> > +	return error;
> 
> ?
> 
> 	Ingo
