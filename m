Return-Path: <linux-kernel-owner+w=401wt.eu-S965378AbXBFT6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378AbXBFT6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965391AbXBFT6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:58:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55427 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965378AbXBFT6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:58:08 -0500
Date: Tue, 6 Feb 2007 14:58:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: <20070206042153.66AB418005D@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0702061430520.2664-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Roland McGrath wrote:

> Sorry I've been slow in giving you feedback on kwatch.

No problem (I have plenty of other things to work on!), and thanks for the 
detailed reply.

> > I'll be happy to move this over to the utrace setting, once it is merged.  
> > Do you think it would be better to include the current version of kwatch 
> > now or to wait for utrace?
> > 
> > Roland, is there a schedule for when you plan to get utrace into -mm?
> 
> Since you've asked, I'll mention that I've been discussing this with Andrew
> lately and we plan to work on merging it into -mm as soon as we can manage.
> 
> The kwatch implementation is pretty much orthogonal to the utrace patch as
> it is so far.  As you've noted, it doesn't change the nature of the setting
> of the debug registers; it only moves around the existing code for setting
> them in raw form.  Hence it doesn't much matter which order the work is
> merged at this stage.  There's no reason to withhold kwatch waiting for utrace.

That's good.  So I'll assume an updated version of kwatch can be submitted 
without regard to the progress of utrace (other than minor conflicts over 
the exact location of the ptrace code to change).

> I do have a problem with kwatch, however.  The existing user ABI includes
> setting all of the debug registers, and this interface has never before
> expressed a situation where you can set some but not all of them.  Having
> ptrace suddenly fail with EBUSY when it never did before is not OK.  No
> well-behaved kernel-mode tracing/debugging facility should perturb the user
> experience in this way.  It is certainly understandable that one will
> sometimes want to do invasive kernel-mode debugging and on special
> occasions choose to be ill-behaved in this way (you might know your
> userland work load doesn't include running gdb with watchpoints).  
> But kwatch as it stands does not even make it possible to write a
> well-behaved facility.

Right.  I had been thinking in terms of a developer using kwatch to track 
down some particularly nasty problem, something that would happen rather 
infrequently, where one wouldn't care about side effects on user programs.  
But of course those side effects might alter an important aspect of the 
kernel problem being debugged...

It's also true that the current kwatch version affects the user experience
even when no kernel debugging is going on, as it forcibly prevents ptrace
calls from setting the Global-Enable bits in dr7.  That at least can be
fixed quite easily.  (On the other hand, userspace should never do 
anything other than a Local Enable.)

> I am all in favor of a facility to manage shared use of the debug
> registers, such as your debugreg.h additions.  I just think it needs to be
> a little more flexible.  An unobtrusive kernel facility has to get out of
> the way when user-mode decides to use all its debug registers.  It's not
> immediately important what it's going to about it when contention arises,
> but there has to be a way for the user-mode facilities to say they need to
> allocate debugregs with priority and evict other squatters.  So, something
> like code allocating a debugreg can supply a callback that's made when its
> allocation has to taken by something with higher priority.  

How about a pair of callbacks: One to notify whenever the watchpoint is 
enabled and one to notify whenever it is disabled?

> Even after utrace, there will always be the possibility of a traditional
> uncoordinated user of the raw debug registers, if nothing else ptrace
> compatibility will always be there for old users.  So anything new and
> fancy needs to be prepared to back out of the way gracefully.  In the case
> of kwatch, it can just have a handler function given by the caller to start
> with.  It's OK if individual callers can specially declare "I am not
> well-behaved" and eat debugregs so that well-behaved high-priority users
> like ptrace just have to lose (breaking compatibility).  But no
> well-behaved caller of kwatch will do that.  

No doubt the future userspace API will include some sort of priority 
facility.  For now, though, ptrace doesn't have anything like it.  We just 
have to assign it an arbitrary intermediate priority.

So for the sake of argument, let's assume that debug registers can be 
assigned with priority values ranging from 0 to 7 (overkill, but who 
cares?).  By fiat, ptrace assignments use priority 4.  Then kwatch callers 
can request whatever priority they like.  The well-behaved cases you've 
been discussing will use priority 0, and the invasive cases can use 
priority 7.  (With appropriate symbolic names instead of raw numeric 
values, naturally.)

Or maybe that's too complicated.  Perhaps all userspace assignments should 
always use the same priority level.  After all, it's possible for multiple 
tasks to allocate the same debug register at the same time -- if they had 
differing priorities that would make it much more difficult to keep things 
straight.  Then there would be only three effective priority levels: 0 = 
well-behaved kernel, 1 = all userspace, and 2 = invasive kernel.

> As a later improvement, kwatch could try a thing or two to stave off giving
> up and telling its caller the watchpoint couldn't stay for the current
> task.  For example, if a watchpoint is in kernel memory, you could switch
> in your debugreg settings on entering the kernel and restore the user
> watchpoints before returning to user mode.  Then you'd need to make
> get_user et al somehow observe the user-mode watchpoints.  But it could be
> investigated if the need arises.

For now I would prefer to avoid that.  It's true that kwatch is intended
_only_ for kernelspace watchpoints, not userspace.  But I'd rather leave
the complications up to someone else.

>  Note that you can already silently do
> something simple like juggling your kwatch debugreg assignments around if
> the higher-priority consumer evicting you has left some other debugregs unused.

Yes, I might add that in.

> I certainly intend for later features based on utrace to include
> higher-level treatment of watchpoints so that user debugging facilities can
> also become responsive to debugreg allocation pressure.  (Eventually, the
> user facilities might have easier ways of falling back to other methods and
> getting out of the way of kernel debugreg consumers, than can be done for
> the kernel-mode-tracing facilities.)  To that end, I'd like to see a clear
> and robust interface for debugreg sharing, below the level of kwatch.  I'd
> also like to see a thin layer on that giving a machine-independent kernel
> source API for talking about watchpoints, which you pretty much have rolled
> into the kwatch interface now.  But these are further refinements, not
> barriers to including kwatch.

It seems likely that the interfaces added by kwatch will need to be
generalized in various ways in order to handle the requirements of other
architectures.  However I don't know what those requirements might be, so
it seems best to start out small with x86 only and leave more refinements
for the future.

> Also, an unrelated minor point.  I think it's error-prone to have an
> integer argument to unregister_kwatch.  I think it makes most sense to have
> the caller provide the space and call register/unregister with a pointer,
> in the style of kprobes.

In fact, something like that would be necessary if the debug register 
assignment could be changed silently as need arises.

If I update the patch, adding a priority level and the callback 
notifications, do you think it would then be acceptable?

Alan Stern

