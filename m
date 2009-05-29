Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZE2VWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZE2VWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZE2VWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:22:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbZE2VWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:22:03 -0400
Date: Fri, 29 May 2009 23:17:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, rusty@rustcorp.com.au, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] cpuhotplug: use rw_semaphore for cpu_hotplug
Message-ID: <20090529211734.GA13868@redhat.com>
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090529132328.99e7cae3.akpm@linux-foundation.org> <20090529210748.GA13449@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529210748.GA13449@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29, Oleg Nesterov wrote:
>
> On 05/29, Andrew Morton wrote:
> >
> > On Fri, 29 May 2009 16:29:30 +0800
> > Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> >
> > >
> > > Current get_online_cpus()/put_online_cpus() re-implement
> > > a rw_semaphore,
> > > so it is converted to a real rw_semaphore in this fix.
> > > It simplifies codes, and is good for read.
> >
> > >  static struct {
> > > -	struct task_struct *active_writer;
> > > -	struct mutex lock; /* Synchronizes accesses to refcount, */
> > >  	/*
> > > -	 * Also blocks the new readers during
> > > -	 * an ongoing cpu hotplug operation.
> > > +	 * active_writer makes get_online_cpus()/put_online_cpus() are allowd
> > > +	 * to be nested in cpu_hotplug_begin()/cpu_hotplug_done().
> > > +	 *
> > > +	 * Thus, get_online_cpus()/put_online_cpus() can be called in
> > > +	 * CPU notifiers.
> > >  	 */
> > > -	int refcount;
> > > +	struct task_struct *active_writer;
> > > +	struct rw_semaphore rwlock;
> > >  } cpu_hotplug;
>
> But, afaics, down_write() blocks new readers.
>
> This means that with this patch get_online_cpus() is not recursive, no?

And please note that the current code drops mutex when get_online_cpus()
succeeds. With your patch (if I read it correctly) the code under get_()
runs with cpu_hotplug->rwlock held for reading. I'm afraid this creates
the new possibilities for deadlocks.

Oleg.

