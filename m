Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZDOXcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZDOXcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZDOXck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:32:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661AbZDOXcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:32:39 -0400
Date: Wed, 15 Apr 2009 16:27:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Trond.Myklebust@netapp.com, dhowells@redhat.com, serue@us.ibm.com,
       steved@redhat.com, viro@zeniv.linux.org.uk, Daire.Byrne@framestore.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Message-Id: <20090415162712.342d4c07.akpm@linux-foundation.org>
In-Reply-To: <20090413222451.GA2758@redhat.com>
References: <1239649429.16771.9.camel@heimdal.trondhjem.org>
	<20090413181733.GA10424@redhat.com>
	<32260.1239658818@redhat.com>
	<20090413214852.GA1127@redhat.com>
	<1239659841.16771.26.camel@heimdal.trondhjem.org>
	<20090413222451.GA2758@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 00:24:51 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/13, Trond Myklebust wrote:
> >
> > On Mon, 2009-04-13 at 23:48 +0200, Oleg Nesterov wrote:
> > > On 04/13, David Howells wrote:
> > > >
> > > > Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> > > >
> > > > > Should that really be TASK_INTERRUPTIBLE? I don't see anything obvious
> > > > > in the enclosing for(;;) loop that checks for or handles signals...
> > > >
> > > > If it were TASK_UNINTERRUPTIBLE, it would sit there in the D-state when not
> > > > doing anything.  I must admit, I thought I was calling daemonize(), but that
> > > > seems to have got lost somewhere.
> > >
> > > daemonize() is not needed, kthread_create() creates the kernel thread which
> > > ignores all signals. So it doesn't matter which state we use to sleep,
> > > TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE.
> >
> > Yes, but that is precisely why it is cleaner to use
> > TASK_UNINTERRUPTIBLE. It documents the fact that signal handling isn't
> > needed (whether or not the thread is blocking them).
> 
> Agreed. But TASK_UNINTERRUPTIBLE can confuse a user which does
> "cat /proc/loadavg" on the idle machine...
> 
> Note that, for example, worker_thread() uses TASK_INTERRUPTIBLE too, and I
> think for the same reason.
> 

Yup.  It's a very common pattern for kernel threads to sleep in state
TASK_INTERRUPTIBLE.  It is "well known" (lol) that kernel threads don't
accept signals, and having a kernel thread sleep in state
TASK_UNINTERRUPTIBLE will indeed contribute to load average and we get
distressed emails quite promptly when we do that.

The patch itself is a little worrisome.  The wake-all semantics are
very good at covering up little race bugs.  And switching to wake-once
is a great way of exposing hitherto-unsuspected races.

<looks for races>

Nothing immediately leaps out, but you know how these things are.

I wonder if slow_work_cull_timeout() should have some sort of barrier,
so the write is suitably visible to the woken thread.  Bearing in mind
that the thread might _already_ have been woken by someone else?


off-topic: afacit the code will cull a maximum of one thread per five
seconds.  But the rate of thread _creation_ is, afacit, unbound.  Are
there scenarios in which we can get a runaway thread count?



