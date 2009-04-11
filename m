Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZDKR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZDKR6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbZDKR6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 13:58:43 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:60570 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbZDKR6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 13:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CPvTYjQYmie/aL/gJb21JGpBzm8WYN5X0jnOhT37IMBGi2jOMp4pd0VwQtvOgU498T
         Ft8DSGikwvnByp7WBJubI0AIBOL8pKueE4evKCDe70HiL0i7tWoxrgWFuLRU5jji8man
         Rnam0IQx7ENhIVGCH0aBVNTKanrWedVNW3cTY=
Subject: Re: [PATCH 0/7] tracing: bug fixes for tracing/filters
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
In-Reply-To: <20090411144823.GB5977@nowhere>
References: <49E04C22.4040608@cn.fujitsu.com>
	 <1239442248.8793.65.camel@tropicana>  <20090411144823.GB5977@nowhere>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 12:58:41 -0500
Message-Id: <1239472721.11255.17.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-11 at 16:48 +0200, Frederic Weisbecker wrote:
> On Sat, Apr 11, 2009 at 04:30:48AM -0500, Tom Zanussi wrote:
> > Hi,
> > 
> > On Sat, 2009-04-11 at 15:52 +0800, Li Zefan wrote:
> > > This patchset fixes some bugs in tracing/filters. Most of the change
> > > goes to the last patch, and others are small ones.
> > > 
> > 
> > At first glance, they look good and fix real problems - thanks for
> > fixing them.  Re patch 7, there's been some discussion about using rcu
> > for this.  See:
> > 
> > http://lkml.org/lkml/2009/4/5/46
> > 
> > >From that discussion, it seems some non-trivial changes to rcu would be
> > needed for this.  I'm playing around with a different idea now to
> > hopefully avoid the need for that, or the other approach mentioned, of
> > temporarily stopping tracing while removing/changing the filters.
> > 
> > Basically my thought is to avoid the problem by not allocating or
> > destroying the preds when removing filters but instead switch out the
> > pred->fns with a nop version while keeping the fields intact for awhile.
> > I think that will work for removing filters, but I still need to think
> > about how it would (or would not) work for replacing them.
> >  
> > Tom
> 
> 
> 
> It would be sort of reinventing rcu :-)
> Well, Paul proposed something recently, hmm I should double check
> this discussion.
> 

Well, if so, the resemblance would be only superficial e.g. the
difference between a cheap parlor trick and David Copperfield. ;-)  Mine
would be much simpler and local to the filter code.  Also, I think I'm
overstating the 'keeping the fields intact for awhile' part - it should
be possible to not deal with that at all at the cost of a small
possibility of a false positive or negative while switching filters.

I'll run it up the flagpole and see if it flies, and hopefully post a
patch for it, sometime this weekend...

Tom

> Anyway, the fixes from Li (other than 4 and 7 for which we have comments)
> look very good!
> 
> Frederic.
> 
> 
> 
> > 
> > > Maybe 3rd to 6th patches can be regarded as small enhancements instead
> > > of bug fixes? But they are behavioural changes.
> > > 
> > > 
> > > [PATCH 1/7] tracing/filters: NUL-terminate user input filter
> > > [PATCH 2/7] tracing/filters: fix NULL pointer dereference
> > > [PATCH 3/7] tracing/filters: allow user input integer to be oct or hex
> > > [PATCH 4/7] tracing/filters: allow user to specify a filter val to be string
> > > [PATCH 5/7] tracing/filters: disallow newline as delimeter
> > > [PATCH 6/7] tracing/filters: return proper error code when writing filter file
> > > [PATCH 7/7] tracing/filters: make filter preds RCU safe
> > > 
> > >  kernel/trace/trace.h                |    6 +-
> > >  kernel/trace/trace_events.c         |   16 +++--
> > >  kernel/trace/trace_events_filter.c  |  131 ++++++++++++++++++++++++++---------
> > >  kernel/trace/trace_events_stage_3.h |   10 +++-
> > >  4 files changed, 121 insertions(+), 42 deletions(-)
> > > ---
> > 
> 

