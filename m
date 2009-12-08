Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZLHSnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZLHSnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbZLHSnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:43:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104AbZLHSni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:43:38 -0500
Date: Tue, 8 Dec 2009 19:37:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091208183758.GA20507@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop> <20091201220847.GA25400@redhat.com> <1260210877.3935.594.camel@laptop> <20091208150417.GA11883@redhat.com> <1260286163.3935.1497.camel@laptop> <20091208163131.GA14815@redhat.com> <1260296378.17334.21.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260296378.17334.21.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08, Peter Zijlstra wrote:
>
> On Tue, 2009-12-08 at 17:31 +0100, Oleg Nesterov wrote:
>
> > > If you take a task ref you can write the much saner:
> > >
> > > utrace_control()
> > > {
> > >   ...
> > >   spin_lock(&utrace->lock);
> > >   ...
> > >   if (reset)
> > >     utrace_reset(utrace);
> > >
> > >   spin_unlock(&utrace->lock);
> > > }
> >
> > No, get_task_struct() in utrace_reset() can't help, we should move
> > it into utrace_control() then. And in this case it becomes even more
> > subtle: it is needed because ->utrace_flags may be cleared inside
> > utrace_reset() and after that utrace_control()->spin_unlock() becomes
> > unsafe.
>
> The task->utrace pointer is cleaned up on
> free_task()->tracehook_free_task()->utrace_free_task(), so by holding a
> ref on the task, we ensure ->utrace stays around, and we can do
> spin_unlock(), right?

Yes. That is why utrace_control() (which does unlock) should take the ref,
not utrace_reset().

> > Also. utrace_reset() drops utrace->lock to call put_detached_list()
> > lockless. If we want to avoid the assymetric locking, every caller
> > should pass "struct list_head *detached" to utrace_reset(), drop
> > utrace->lock, and call put_detached_list().
>
> All that seems to do is call ->release() and kmem_cache_free()s the
> utrace_engine thing, why can't that be done with utrace->lock held?

We can, but then ->release() will be called in atomic context. Utrace
tries hard to not "restrict" the module writers.

> But yeah, passing that list along does seem like a better solution.

Well, it has multiple callers, everyone will be complicated.

Oleg.

