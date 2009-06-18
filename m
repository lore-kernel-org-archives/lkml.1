Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZFRXSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZFRXSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZFRXSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:18:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZFRXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:18:40 -0400
Date: Thu, 18 Jun 2009 19:18:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/filters: restore orignal filter when new
 filter isn't applicable
In-Reply-To: <1245304705.6207.78.camel@tropicana>
Message-ID: <alpine.DEB.2.00.0906181915350.6890@gandalf.stny.rr.com>
References: <4A38AD7F.2070408@cn.fujitsu.com> <1245304705.6207.78.camel@tropicana>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 18 Jun 2009, Tom Zanussi wrote:

> Hi,
> 
> On Wed, 2009-06-17 at 16:46 +0800, Li Zefan wrote:
> > | commit 7ce7e4249921d5073e764f7ff7ad83cfa9894bd7
> > | Author: Tom Zanussi <tzanussi@gmail.com>
> > | Date:   Sun Mar 22 03:31:04 2009 -0500
> > |
> > |     tracing: add per-event filtering
> > |     ...
> > |
> > |     Filters can also be set or cleared for a complete subsystem by writing
> > |     the same filter as would be written to an individual event to the
> > |     filter file at the root of the subsytem.  Note however, that if any
> > |     event in the subsystem lacks a field specified in the filter being
> > |     set, the set will fail and all filters in the subsytem are
> > |     automatically cleared.  This change from the previous version was made
> > |     because using only the fields that happen to exist for a given event
> > |     would most likely result in a meaningless filter.
> > 
> > I really don't like this change. It is inconvenient, and makes subsystem
> > filter much less useful:
> > 
> >   # echo 'vec == 1' > irq/softirq_entry/filter
> >   # echo 'irq == 5' > irq/filter
> >   bash: echo: write error: Invalid argument
> >   # cat irq/softirq_entry/filter
> >   none
> > 
> > I'd expect this will set the filter for irq_handler_entry and
> > irq_handler_exit, and won't touch softirq_entry and softirq_exit.
> > 
> > But it just failed, and what's worse, each event's filter was
> > cleared.
> > 
> 
> The idea behind the change was that after setting a subsystem filter,
> you'd be guaranteed that all or none of the events in the subsystem
> would have the same filter at that point, and not some mix of different
> filters depending on which ones failed or not, which to me seemed
> nonintuitive.
> 
> If I set a filter like "vec == 1 && irq == 5", which really has no
> overall meaning, I wouldn't expect softirq_entry to get "vec == 1" and
> irq_handler_entry to get "irq == 5" - I'd rather get an error, but
> that's just me.
> 
> So if it makes more sense to users to have subsystem filters propagate
> to whichever events will take them, this patch would be fine with me.
> 

I disagree. If a subsystem filter is set, it should be valid for all 
filters underneath, if it is not, it should error.

But Li has a point, if you get an error, it should not reset all filters 
underneath. That is, if the irq/filter setting took an error, then 
irq/softirq_entry/filter should still stay the same.

Perhaps you need to run through it twice. See if the setting of a filter 
is valid for all filters underneath, if it is not, then fail. If it is, 
then reset all of them, and assign the filter.

-- Steve

