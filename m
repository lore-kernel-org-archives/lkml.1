Return-Path: <linux-kernel-owner+w=401wt.eu-S965273AbXBGC4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273AbXBGC4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 21:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965634AbXBGC4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 21:56:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965273AbXBGC4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 21:56:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: Alan Stern's message of  Tuesday, 6 February 2007 14:58:05 -0500 <Pine.LNX.4.44L0.0702061430520.2664-100000@iolanthe.rowland.org>
X-Fcc: ~/Mail/utrace
Message-Id: <20070207025631.3027E18005D@magilla.sf.frob.com>
Date: Tue,  6 Feb 2007 18:56:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That's good.  So I'll assume an updated version of kwatch can be submitted 
> without regard to the progress of utrace (other than minor conflicts over 
> the exact location of the ptrace code to change).

Indeed.

> Right.  I had been thinking in terms of a developer using kwatch to track 
> down some particularly nasty problem, something that would happen rather 
> infrequently, where one wouldn't care about side effects on user programs.  
> But of course those side effects might alter an important aspect of the 
> kernel problem being debugged...

This is indeed a way it might reasonably be used.  As I said, it's fine for
an individual use to be that way.  But think also of using it for
performance measurement (i.e. "how hot is this counter") in something like
systemtap, where you might have long-running instrumentation over arbitrary
workloads.

> It's also true that the current kwatch version affects the user experience
> even when no kernel debugging is going on, as it forcibly prevents ptrace
> calls from setting the Global-Enable bits in dr7.  That at least can be
> fixed quite easily.  (On the other hand, userspace should never do 
> anything other than a Local Enable.)

The distinction between local and global here never matters on Linux.  We
don't use hardware task switching at all, and if we did it would be part of
context switch, which already switches in debug register values.  

The local vs global distinction you have in debugreg allocation (when one
Linux task_struct is on the CPU vs always on every CPU) is a
machine-independent notion at the level of your debugreg sharing
abstraction, and has nothing to do with particular %dr7 bit values
(just with the allocation of all the bits in %dr7 that correspond to a
particular allocated %drN).

> How about a pair of callbacks: One to notify whenever the watchpoint is 
> enabled and one to notify whenever it is disabled?

That sounds fine.  You'll want to make sure it's structured so it doesn't
get too hairy when a caller wants to just give up and unregister when its
slot is unavailable (hopefully shouldn't lead to calling unregister from
the callback made inside the register call and such twists).

> So for the sake of argument, let's assume that debug registers can be 
> assigned with priority values ranging from 0 to 7 (overkill, but who 
> cares?).  By fiat, ptrace assignments use priority 4.  Then kwatch callers 
> can request whatever priority they like.  The well-behaved cases you've 
> been discussing will use priority 0, and the invasive cases can use 
> priority 7.  (With appropriate symbolic names instead of raw numeric 
> values, naturally.)

Sure.  Or make it signed with lower value wins, have ptrace use -1 and the
average bear use 0 or something especially unobtrusive use >0, and
something very obtrusive use -many.  Unless you are really going to pack it
into a few bits somewhere, I'd make it an arbitrary int rather than a
special small range; it's just for sort order comparison.  Bottom line, I
don't really care about the numerology.  Just so "break ptrace", "don't
break ptrace", and "readily get out of the way on demand" can be expressed.
We can always fine-tune it later as there are more concrete users.

> Or maybe that's too complicated.  Perhaps all userspace assignments should 
> always use the same priority level.  

No, I want priorities among user-mode watchpoint users too.  ptrace is
rigid, but newer facilities can coexist with ptrace on the same thread and
with kwatch, and do fancy new things to fall back when there is debugreg
allocation pressure.  Future user facilities might be able to do VM tricks
that are harder to make workable for kernel mode, for example.  

> For now I would prefer to avoid that.  It's true that kwatch is intended
> _only_ for kernelspace watchpoints, not userspace.  But I'd rather leave
> the complications up to someone else.

Understood.  If you constrain the kwatch interface so it cannot be used
with user addresses (checks < TASK_SIZE or whatever), then the problem will
be clearly defined as the slightly simpler one whenever someone does come
along in need of more complications.

> It seems likely that the interfaces added by kwatch will need to be
> generalized in various ways in order to handle the requirements of other
> architectures.  However I don't know what those requirements might be, so
> it seems best to start out small with x86 only and leave more refinements
> for the future.

Agreed, just to keep it in mind.  I think the features on other machines
are roughly similar except for not offering size choices other than
"anywhere in this aligned word".  

> If I update the patch, adding a priority level and the callback 
> notifications, do you think it would then be acceptable?

I expect so.


Thanks,
Roland
