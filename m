Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZEHMB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZEHMB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZEHMBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:01:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:32843 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZEHMBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:01:18 -0400
Date: Fri, 8 May 2009 08:01:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: clean up for
 ftrace_set_clr_event()
In-Reply-To: <4A041478.5070401@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905080750460.28378@gandalf.stny.rr.com>
References: <4A03998E.3020503@cn.fujitsu.com> <20090508105013.GA6417@nowhere> <4A041478.5070401@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 May 2009, Li Zefan wrote:

> Frederic Weisbecker wrote:
> > On Fri, May 08, 2009 at 10:31:42AM +0800, Li Zefan wrote:
> >> Add a helper function __ftrace_set_clr_event(), and replace some
> >> ftrace_set_clr_event() calls with this helper, thus we don't need any
> >> kstrdup() or kmalloc().
> >>
> >> As a side effect, this patch fixes an issue in self tests code, which is
> >> similar to the one fixed in commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96
> >> ("tracing: append ":*" to internal setting of system events")

Actually, what does this patch solve that the above mentioned commit does 
not?

> >>
> >> It's a small issue and won't cause any bug in fact, but we should do things
> >> right anyway.
> >>
> >> [ Impact: clean up ]
> > 
> > If this fixes an issue like you described, then it's more than a cleanup :)
> > 
> 
> That issue causes no bug, and that's why I call it a cleanup.
> 
> How about (mainly stealed from commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96):
> 
> [ Impact: prevent accidental enabling of events with same name as a system in self tests ]
> 
> But it excceeds 80 char..
> 
> I sometimes feel it hard to write Impact line (one of the reason is my limit
> English skill). I've explained the impact of this patch in detail, but I'm
> still required to add a one-line summary. :(

I find the Impact line much easier to write when I think of it as the 
reason for the patch (think, why am I writing this). Here I would have 
written:

[ Impact: remove use of kmalloc and kstrdup with cleaner code ]

> 
> > 
> ...
> >> +		if (event && strcmp(event, call->name) != 0)
> >> +			continue;
> > 
> > 
> > Neat: You can simply use !strcmp(...)
> > 
> 
> Actually it's arguable which is better, and both styles are used in kernel code.
> 
> And that 'if (!ptr)' vs 'if (ptr == NULL)'..
> 

I preferer if (!ptr) over if (ptr == NULL), but this has nothing to do 
with the reason for the "strcmp(...) != 0". It is totally different, and 
it fooled you too ;-)

As I mentioned to Frederic, !strcmp() actually means "these strings 
match". Which fools the human brain all too easy. Thus we see,
"strcmp(...) == 0" as "is a match" and "strcmp(...) != 0" as not a match, 
because our brain focuses on the "==" and the "!=". Those that program in 
C, default "!" as not.

Note, strcmp being 0 for match has nothing to do with the C convention of 
0 being non error. But because it is used in sorting algorithms. strcmp 
will return > 0 if it deems str1 > str2, or it will return < 0 if it deems 
str1 < str2, and of course it returns 0 on match.

-- Steve

