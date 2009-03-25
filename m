Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZCYMxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZCYMxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZCYMwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:52:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZCYMwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:52:54 -0400
Date: Wed, 25 Mar 2009 13:52:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] blktrace: fix original blktrace
Message-ID: <20090325125231.GE30755@elte.hu>
References: <49C99BD2.9090503@cn.fujitsu.com> <20090325070726.GD27476@kernel.dk> <49C9DC75.9080301@cn.fujitsu.com> <20090325072704.GF27476@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325072704.GF27476@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Mar 25 2009, Li Zefan wrote:
> > Jens Axboe wrote:
> > > On Wed, Mar 25 2009, Li Zefan wrote:
> > >> I'm wondering what we are going to do with the original blktrace which
> > >> is using relay and is used via ioctl.
> > >>
> > >> The problem is currently it's totally broken. You can use ftrace to see
> > >> the output of blktrace, but user-space blktrace is unusable.
> > >>
> > >> With this patch, both ioctl and ftrace can be used, but of course you
> > >> can't use both of them at the same time.
> > > 
> > > Even if ftrace was as fast as storing huge amounts of data as blktrace,
> > > it's still of utmost importance that nothing is broken there. There are
> > 
> > agreed
> > 
> > > people actually USING this tracing to do real work, it's not a
> > > playground.
> > > 
> > 
> > and we are using blktrace to test the cgroup-based io controller
> > 
> > > I appreciate the efforts to unify and improve our tracing, but we must
> > > not be breaking blktrace along the way. Otherwise the whole thing goes
> > 
> > this patch fixes it.
> > 
> > it's broken by "blktrace: add ftrace plugin"
> > (c71a896154119f4ca9e89d6078f5f63ad60ef199)
> > 
> > @@ -131,13 +162,14 @@ static void __blk_add_trace()
> > - 	if (unlikely(bt->trace_state != Blktrace_running))
> > + 	if (unlikely(bt->trace_state != Blktrace_running || !blk_tracer_enabled))
> >  		return;
> 
> Good, as long as it still works with blktrace, that's all I care 
> about (for now, at least).

Sorry about that. I've applied Li's fixes and double checked 
blktrace+blktrace functionality and pushed out a new tracing
tree to linux-next.

Btw., blktrace could be updated in the future to make use the
new per CPU buffering and sys_splice() code available in ftrace
plugin. [ splice is cool! =B-) ]

Plus blktrace could make use of built-in event filtering 
capabilities - for example to only trace events in a specific
sector range on the disk. Or to trace all IO of a given PID only.

But that is a different project that needs changes both on the 
kernel side and on the user-space side (.31-ish for sure) and the 
relayfs+ioctl method must work fine in any case.

	Ingo
