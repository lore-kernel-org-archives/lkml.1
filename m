Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbZHXG4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbZHXG4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZHXG4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:56:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:37609 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZHXG4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:56:11 -0400
Subject: Re: system gets stuck in a lock during boot
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A922F82.9080000@cn.fujitsu.com>
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>
	 <20090818160911.GA21243@goodmis.org>
	 <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com>
	 <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>
	 <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com>
	 <4A8FA2BD.4030707@gmail.com>  <4A91FDED.9050801@cn.fujitsu.com>
	 <1251093523.7538.118.camel@twins>  <4A922F82.9080000@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 08:55:25 +0200
Message-Id: <1251096925.7538.121.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 14:13 +0800, Li Zefan wrote:
> Peter Zijlstra wrote:
> > On Mon, 2009-08-24 at 10:41 +0800, Li Zefan wrote:
> > 
> >>> @@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentr
> >>>                 entry = trace_create_file("enable", 0644, call->dir, call,
> >>>                                           enable);
> >>>
> >>> -       if (call->id)
> >>> +       if (call->id && call->profile_enable)
> >> We do an extra check on ->profile_enable, shouldn't cause bug..
> >>
> >>>                 entry = trace_create_file("id", 0444, call->dir, call,
> >>>                                           id);
> >> Any way, I don't think this commit does the right thing:
> >>
> >>   - If CONFIG_EVENT_PROFILE=y, we'll create events/<dir>/<event>/id,
> >>     except events/ftrace/<event>/id.
> >>
> >>   - if CONFIG_EVENT_PROFILE=n, there's no 'id' file at all!
> >>
> >> I think it's better to skip ftrace/ dir in perf tool code, instead of
> >> skipping creating id files in ftrace code.
> > 
> > No, it does do the right thing. Your patch breaks things because not all
> > tracepoints are created through TRACE_EVENT() and will thus not have
> > their profile_enable/disable hooks set.
> > 
> > By giving them an ID file, there is no way to distinguish good from bad
> > tracepoints.
> > 
> 
> But removing the id file from events/ftrace/ might break some ftrace
> binary parsers?
> 
> And this commit makes 'id' file disapeared with CONFIG_EVENT_PROFILE=n.

I introduced the id file for EVENT_PROFILE, tough luck if someone else
relies on it.

> > Expempting ftrace is no solid solution, suppose someone else does a
> > TRACE_EVENT_FORMAT() tracepoint, how would you know you could use it as
> > a profile event source?
> > 
> 
> Agree.
> 
> > The id files really must stay conditional.
> > 
> 
> I don't think it's a good idea to connect it with perfcounter
> this way. Wouldn't adding a 'profilable' file more intuitive?

its called: id ;-)
