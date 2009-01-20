Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZATR0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZATR0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZATR0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:26:44 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28967 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbZATR0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:26:43 -0500
From: Vitaliy Gusev <vgusev@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] kthread: Don't looking for a task in create_kthread() #2
Date: Tue, 20 Jan 2009 20:19:56 +0300
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
References: <200901201345.42054.vgusev@openvz.org> <200901201716.34842.vgusev@openvz.org> <20090120150019.GA17399@redhat.com>
In-Reply-To: <20090120150019.GA17399@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901202019.56972.vgusev@openvz.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2009 18:00:19 Oleg Nesterov wrote:
> On 01/20, Vitaliy Gusev wrote:
> >
> > On 20 January 2009 15:06:42 Oleg Nesterov wrote:
> > >
> > > BTW. Perhaps it also makes sense to move sched_setscheduler/etc code
> > > from create_kthread() to kthread_create(), what do you think?
> >
> > I don't thinks so. create_kthread() is executed in kthreadd process and
> > sched_setscheduler/etc preparation things are reflected to kthreadd's CPU usage.
> > In other words it is a kthreadd matter, start and setup a thread.
> 
> can't understand...
> 
> Perhaps I missed something, but from the correctness pov it doesn't
> matter who does sched_setscheduler/etc (except _nocheck() would be
> better). However it does matter from the scalability pov, we should
> move as much as possible from create_kthread() because we have a
> single process with executes the "create" requests.

Ok, I understand you. You want to decrease kthreadd latency. In this case
your suggestion is right.

> 
> OK, please forget. This reminds me kthread.c needs a major rework
> anyway, hopefully I'll try to do this soon.

I also have intent to make kthread_run/kthread_create more easy used for
threads that exit himself on error.
For example, we create some thread THR, which does something but exits on error.
So in normal case we need to call kthread_stop() to stop thread THR, but on
error we don't. This is a problem, because we can't simple (without race) 
determine that THR was exited.
Simple workaround - do a sleeping loop in thread THR and don't exit until kthread_should_stop.
But it isn't a good for code reading/writing.

So my suggestion is: Move workaround sleeping logic from THR to low level
functions:
   wait for a kthread_should_stop in kthread() if THR was exited.
Of course don't wait if nobody cares about thread THR (nobody calls kthread_stop()
for this thread).

That do you think about it?

> 
> Oleg.
> 


-- 
Thank,
Vitaliy Gusev
