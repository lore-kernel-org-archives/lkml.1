Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbZCYNBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbZCYNBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZCYNBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:01:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46294 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZCYNBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:01:41 -0400
Date: Wed, 25 Mar 2009 14:01:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] blktrace: fix original blktrace
Message-ID: <20090325130138.GO27476@kernel.dk>
References: <49C99BD2.9090503@cn.fujitsu.com> <20090325070726.GD27476@kernel.dk> <49C9DC75.9080301@cn.fujitsu.com> <20090325072704.GF27476@kernel.dk> <20090325125231.GE30755@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325125231.GE30755@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Mar 25 2009, Li Zefan wrote:
> > > Jens Axboe wrote:
> > > > On Wed, Mar 25 2009, Li Zefan wrote:
> > > >> I'm wondering what we are going to do with the original blktrace which
> > > >> is using relay and is used via ioctl.
> > > >>
> > > >> The problem is currently it's totally broken. You can use ftrace to see
> > > >> the output of blktrace, but user-space blktrace is unusable.
> > > >>
> > > >> With this patch, both ioctl and ftrace can be used, but of course you
> > > >> can't use both of them at the same time.
> > > > 
> > > > Even if ftrace was as fast as storing huge amounts of data as blktrace,
> > > > it's still of utmost importance that nothing is broken there. There are
> > > 
> > > agreed
> > > 
> > > > people actually USING this tracing to do real work, it's not a
> > > > playground.
> > > > 
> > > 
> > > and we are using blktrace to test the cgroup-based io controller
> > > 
> > > > I appreciate the efforts to unify and improve our tracing, but we must
> > > > not be breaking blktrace along the way. Otherwise the whole thing goes
> > > 
> > > this patch fixes it.
> > > 
> > > it's broken by "blktrace: add ftrace plugin"
> > > (c71a896154119f4ca9e89d6078f5f63ad60ef199)
> > > 
> > > @@ -131,13 +162,14 @@ static void __blk_add_trace()
> > > - 	if (unlikely(bt->trace_state != Blktrace_running))
> > > + 	if (unlikely(bt->trace_state != Blktrace_running || !blk_tracer_enabled))
> > >  		return;
> > 
> > Good, as long as it still works with blktrace, that's all I care 
> > about (for now, at least).
> 
> Sorry about that. I've applied Li's fixes and double checked 
> blktrace+blktrace functionality and pushed out a new tracing
> tree to linux-next.
> 
> Btw., blktrace could be updated in the future to make use the
> new per CPU buffering and sys_splice() code available in ftrace
> plugin. [ splice is cool! =B-) ]
> 
> Plus blktrace could make use of built-in event filtering 
> capabilities - for example to only trace events in a specific
> sector range on the disk. Or to trace all IO of a given PID only.
> 
> But that is a different project that needs changes both on the 
> kernel side and on the user-space side (.31-ish for sure) and the 
> relayfs+ioctl method must work fine in any case.

Don't get me wrong, I completely agree with the unification idea, it'll
be awesome to have a single stream of info for several event types. My
worry was just if it was going too fast, I just don't want a broken
blktrace before the dust has even settled. And moving blktrace from
relay to per-cpu buffering and splice definitely sounds like a good
longer term direction.

-- 
Jens Axboe

