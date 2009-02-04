Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbZBDFqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbZBDFqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZBDFqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:46:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbZBDFqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:46:21 -0500
Date: Tue, 3 Feb 2009 21:46:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Negative values in /proc/latency_stats
Message-Id: <20090203214609.39c9c6b2.akpm@linux-foundation.org>
In-Reply-To: <20090203161648.361a924a@infradead.org>
References: <4e5e476b0901310542n796dafbem5c656da07a2f8a56@mail.gmail.com>
	<20090202205545.4e1a32ea.akpm@linux-foundation.org>
	<20090203161648.361a924a@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 16:16:48 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 2 Feb 2009 20:55:45 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 31 Jan 2009 14:42:20 +0100 Corrado Zoccolo
> > <czoccolo@gmail.com> wrote:
> > 
> > > Hello,
> > > I found negative numbers sometimes appear in /proc/latency_stats
> > > (vanilla kernel 2.6.29-rc3, on x86 cpu, configuration attached)
> > > 
> > > [corrado@localhost ~]$ while sleep 1; do grep --
> > > - /proc/latency_stats
> > > >> neg_stats; done
> > > ^Z
> > > [1]+  Stopped                 sleep 1
> > > [corrado@localhost ~]$ cat neg_stats
> > > 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> > > 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> > > 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> > > 
> > > 
> > > I suspect this can be the cause for
> > > https://bugs.launchpad.net/ubuntu/+source/latencytop/+bug/297776 ,
> > > as I saw it happening on my machine during a kernel recompilation.
> > > 
> > 
> > <discovers kernel/latencytop.c>
> 
> how about this?
> 

lavish ;)

> ...
>
> +/*
> + * CONFIG_LATENCYTOP enables a kernel latency tracking infrastructure that is
> + * used by the "latencytop" userspace tool. The latency that is tracked is not
> + * the 'traditional' interrupt latency (which is primarily caused by something
> + * else consuming CPU), but instead, it is the latency an application encounters
> + * because the kernel sleeps on its behalf for various reasons.
> + *
> + * This code tracks 2 levels of statistics:
> + * 1) System level latency
> + * 2) Per process latency
> + *
> + * The latency is stored in fixed sized datastructures in an accumulated form;
> + * if the "same" latency cause is hit twice, this will be tracked as one entry
> + * in the datastructure. Both the count, total accumulated latency and maximum
> + * latency are tracked in this data structure. When the fixed size structure is
> + * full, no new causes are tracked until the buffer is flushed by writing to
> + * the /proc file; the userspace tool does this on a regular basis.

s/datastructure/data structure/

> + * A latency cause is identified by a stringified backtrace at the point that
> + * the scheduler gets invoked. The userland tool will use this string to
> + * identify the cause of the latency in human readable form.
> + *
> + * The information is exported via /proc/latency_stats and /proc/<pid>/latency.
> + * These files look like this:
> + *
> + * Latency Top version : v0.1
> + * 70 59433 4897 i915_irq_wait drm_ioctl vfs_ioctl do_vfs_ioctl sys_ioctl
> + * |    |    |    |
> + * |    |    |    +----> the stringified backtrace
> + * |    |    +---------> The maximum latency for this entry in microseconds
> + * |    +--------------> The accumulated latency for this entry (microseconds)
> + * +-------------------> The number of times this entry is hit
> + *
> + * (note: the average latency is the acummulated latency deviced by the number
> + * of times)

I was surprised at this.  Is the stack backtracer sufficiently
reliable/repeatable for this to work?

> + * Negative latencies (caused by time going backwards) are also explicitly
> + * skipped.

Are we sure that this was the cause of the problem?

Which time source is the caller using here, and why is it going backwards?


