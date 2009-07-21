Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZGUHWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZGUHWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZGUHWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:22:08 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:43383 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZGUHWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kGXr833EH4t6dEvz474lY9of4LyiJf6+D/BVsPW0ioR77tCijCs/F4SCMYD1Ve33QW
         QHe+s4MSNHH41lyIX6B6c5pJ83YJmpaloIOy36j3eXsi37XTcV13Ty281xi1hRfR189R
         azKI/dvVzGS62EjoEnzu6mnND2TAYtNWTpilM=
Subject: Re: [PATCH v2] tracing/filters: Improve subsystem filter
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A656194.50700@cn.fujitsu.com>
References: <4A63D485.7030703@cn.fujitsu.com>
	 <1248154585.6323.26.camel@tropicana>  <4A656194.50700@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 02:22:03 -0500
Message-Id: <1248160924.6323.57.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 14:35 +0800, Li Zefan wrote:
> Tom Zanussi wrote:
> > Hi,
> > 
> > On Mon, 2009-07-20 at 10:20 +0800, Li Zefan wrote:
> >> Currently a subsystem filter should be applicable to all events
> >> under the subsystem, and if it failed, all the event filters
> >> will be cleared. Those behaviors make subsys filter much less
> >> useful:
> >>
> >>   # echo 'vec == 1' > irq/softirq_entry/filter
> >>   # echo 'irq == 5' > irq/filter
> >>   bash: echo: write error: Invalid argument
> >>   # cat irq/softirq_entry/filter
> >>   none
> >>
> >> I'd expect it set the filter for irq_handler_entry/exit, and
> >> not touch softirq_entry/exit.
> >>
> >> The basic idea is, try to see if the filter can be applied
> >> to which events, and then just apply to the those events:
> >>
> >>   # echo 'vec == 1' > softirq_entry/filter
> >>   # echo 'irq == 5' > filter
> >>   # cat irq_handler_entry/filter
> >>   irq == 5
> >>   # cat softirq_entry/filter
> >>   vec == 1
> >>
> > 
> > It looks like it accomplishes the goal, but I wonder if you could
> > simplify it by getting rid of the no_reset flag and all the state-saving
> > while keeping the dry_run param on filter_add_pred to use from
> > filter_add_subsysystem_pred() e.g. something like this:
> > 
> > filter_add_subsystem_pred(...)
> > {
> > 	...
> > 	list_for_each_entry(call, &ftrace_events, list) {
> > 		err = filter_add_pred(ps, call, pred, dry_run = 1);
> > 		if (!err)
> > 			filter_add_pred(ps, call, pred, dry_run = 0);
> 
> This is the same with just call "filter_add_pred(ps, call, pred)"
> 
> > 		...
> > 	}
> > }
> > 
> > IIRC the state-saving was necessary if the idea was to back out of (or
> > avoid setting) all the filters if one failed, but the new model is to
> > set whichever apply while leaving the rest alone.  I think the simpler
> > approach above accomplishes that, but I may be missing something or have
> > forgotten the original motivation for doing it this way.
> > 
> 
> This won't work as expected. The state-saving is necessary, because
> if any pred is not appliable for an event, the whole operation should
> fail for that event.
> 
> What this patch does is apply the filter to those events that the
> filter is appliable, but not apply parts of the filter to each event.
> 

Yeah, you're right - I was confusing preds with filters when reading
this.

Acked-by: Tom Zanussi <tzanussi@gmail.com>


> Imaging the result for those filters with the above code:
> 
>   # echo 'irq == 5 && vec == 1' > filter
>   # echo 'irq == 5 || vec == 1' > filter
>   # echo 'irq == 5 || foo == bar' > fitler
>   # echo '(irq == 5 && vec == 1) || irq == 2' > filter
> 

