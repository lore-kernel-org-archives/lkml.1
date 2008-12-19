Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbYLSMyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbYLSMyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 07:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYLSMyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 07:54:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYLSMyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 07:54:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081218231511.d9201464.akpm@linux-foundation.org>
References: <20081218231511.d9201464.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for doing very slow work items [ver #41]
Date: Fri, 19 Dec 2008 12:54:02 +0000
Message-ID: <10865.1229691242@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> This may be the most skilfully commented kernel code I've ever seen.

Thanks.  I like useful comments as I may need to re-understand the code I've
written should I have to fix it in five years time.

> > +static unsigned slow_work_min_threads = 2;
> > +static unsigned slow_work_max_threads = (NR_CPUS > 4) ? NR_CPUS : 4;
> 
> I suspect there will be a requirement to tune this at runtime.

Yes.  See:

	[PATCH 03/45] Make the slow work pool configurable [ver #41]

> Using num_possible_cpus() would be more accurate here.  One could
> easily envisage NR_CPUS=1024 on a 2-way machine.  Generally any use
> of NR_CPUS is a red flag.  In fact there's a checkpatch warning about
> it now.

This has been fixed in ver #42, which is what is in the GIT trees.  I can post
that as patches if you like.  Well #43, I've just noticed a bug:-(.

> > +#define slow_work_available(vsmax) \
> > +	(!list_empty(&slow_work_queue) || \
> > +	 (!list_empty(&vslow_work_queue) && \
> > +	  atomic_read(&vslow_work_executing_count) < (vsmax)))
> 
> This could be a regular C function?

I suppose so.

> > +			p = kthread_create(slow_work_thread, NULL,
> > +					   "kslow%Xd", loop);
> > +			if (!p)
> > +				goto error;
> > +			wake_up_process(p);
> 
> The above reimplements kthread_run().

And wrongly.  I should use IS_ERR(p) not !p.

David
