Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYJRAhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYJRAhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 20:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYJRAhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 20:37:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbYJRAhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 20:37:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: prasad@linux.vnet.ibm.com
X-Fcc: ~/Mail/linus
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, avi@qumranet.com,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint
	handler interfaces
In-Reply-To: K.Prasad's message of  Thursday, 16 October 2008 09:15:30 +0530 <20081016034530.GA6175@in.ibm.com>
References: <20081008192044.GA4510@in.ibm.com>
	<20081008192300.GA4989@in.ibm.com>
	<20081016024956.602C61544CB@magilla.localdomain>
	<20081016034530.GA6175@in.ibm.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20081018003409.1E1461544CB@magilla.localdomain>
Date: Fri, 17 Oct 2008 17:34:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree with you that single-stepping and enablement of a post_handler
> for instruction breakpoints in x86 provides a 'feature' over what the
> underlying processor provides. There may be corner-case issues to it
> (and I'd be glad to hear if somebody has discovered any).

I'm pretty well positive I can come up with several.  But my point is that
the whole subject is hairy and that I want to separate the concerns
properly and deal with all that later, rather than clutter up the initial
review and integration of hw_breakpoint with all that.

> However, I'm afraid if the addition of such a feature in a layer above
> the hw_breakpoint can be done entirely without modifying code that is
> much closer to the hardware - say do_debug().

I didn't say that sorting out single-step wouldn't involve changes to
do_debug.  It probably will.  But that is still quite separate from
hw_breakpoint and I don't agree at all that such later work will have to
(or want to) be rolled into the hw_breakpoint API itself.

> Yet, given that there's sufficient interest to see hw_breakpoint layer
> as one that provides pure wrappers around processor functionality i.e.
> devoid of the overloading of single-stepping function, I will submit my
> next iteration of patches with a single pointer called triggered() as a
> callback function.

Great.

> It's my understanding that Data Breakpoints, set by DABR fire the Data
> Storage Interrupt in PPC only after the data access operation is done
> (except for store operations on atomic writes). Exceptions resulting due
> to a match with IABR (for instructions) is trigger-before.

Ok, I wasn't really trying to be right about PPC at the moment.  The point
is just to expose the true behavior of the hardware in a coherent way.
When working on each arch port, one of course has to be careful to know the
correct details.

> Are you suggesting that the post_handler_supported() in i386/x86_64 be
> modified to return, say UNSUPPORTED_DUE_TO_RF instead of just
> UNSUPPORTED to indicate that post_handler() may be supported if
> single-stepping is used to step-over the instructions rather than use
> RF bit?

I wasn't proposing the exact API details.  I think the API that makes sense
to describe the true hardware functionality uses somewhat different terms,
so "post_handler_supported" doesn't especially make sense.  What I think
makes sense is to say a given hw_breakpoint type "triggers before" or
"triggers after" (since there really is only one event to possibly have a
handler, not two).  The further possibilities of what kind of "triggers
before" it is are that the handler can request completing the instruction
without a re-trigger, or it can't (and just has to disable the breakpoint).
Probably a couple of Boolean-valued inlines covers it most clearly.


Thanks,
Roland
