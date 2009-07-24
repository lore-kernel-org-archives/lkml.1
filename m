Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524AbZGXAZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbZGXAZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZGXAZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:25:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZGXAZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:25:27 -0400
Date: Thu, 23 Jul 2009 20:25:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roland Dreier <rdreier@cisco.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jsquyres@cisco.com
Subject: Re: [PATCH/RFC] ummunot: Userspace support for MMU notifications
In-Reply-To: <adak51z40cv.fsf@cisco.com>
Message-ID: <alpine.DEB.2.00.0907232017370.8469@gandalf.stny.rr.com>
References: <ada3a8oobis.fsf@cisco.com> <20090722111538.58a126e3.akpm@linux-foundation.org> <adad47smsb5.fsf@cisco.com> <20090722124208.97d7d9d7.akpm@linux-foundation.org> <alpine.DEB.2.00.0907221606360.1059@gandalf.stny.rr.com> <adak51z40cv.fsf@cisco.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Jul 2009, Roland Dreier wrote:

> 
>  > > >  > >  3. mmap() one page at offset 0 to map a kernel page that contains a
>  > > >  > >     generation counter that is incremented each time an event is
>  > > >  > >     generated.  This allows userspace to have a fast path that checks
>  > > >  > >     that no events have occurred without a system call.
> 
>  > Looks like a vsyscall to me.
> 
> Yes, in a way, although it is quite a bit simpler in the sense that it
> doesn't require any arch-specific code (or indeed any code mapped from
> the kernel) and is automatically available in a portable way.
> Implementing this as a vsyscall seems as if it would add a lot of
> complexity to the kernel side without much simplification on the
> userspace side (in fact, hooking up the vsyscall is probably more code
> than just doing mmap() + dereferencing a pointer).

Just making an observation, not really suggesting that we convert this to 
a vsyscall.

> 
>  > # mount -t debugfs nodev /sys/kernel/debug
>  > # ls /sys/kernel/debug/tracing
> 
> The use case I have in mind is for unprivileged user applications to use
> this.  So requiring debugfs to be mounted hurts (since that isn't done
> by default), and using the files in tracing really hurts, since they're
> currently created with mode 0644 and so tracing can't be controlled by
> unprivileged users.

Ah, allowing unprivileged users is a big commitment. That is, everything
that you handle must be considered untrusted in all accounts. The thing 
about tracing inside the kernel, is that enabling it, may affect everyone. 
Thus we can not simply allow unprivileged users to go messing with the 
performance of others.

> 
> [ASIDE: why is trace_marker created with the strange permission of 0220
> when it is owned by root:root -- is there any reason for the group write
> permission, or should it just be 0200 permission?]

Good question. Probably just an oversite. debugfs is kind of funny with 
its permissions.

> 
> In fact the whole model of ftrace seems to be a single privileged user
> controlling a single context; the use case for ummunotify is that a lot
> of processes running unprivileged (and possibly as multiple different
> users) each want to get events for parts of their own address space.
> 
> So
> 
>  > # echo "ptr > 0xffffffff81100000 && ptr < 0xffffffff8113000" > events/kmem/kmalloc/filter 
> 
> is very cool; but what I would want is for a given process to be able to
> say "please give me events for ptr in the following 100 ranges A..B,
> C..D, ..." and "oh and add this range X..Y" and "oh don't give me events
> for C..D anymore".  And that process should only get events about its
> own address range; and 10 other (unprivileged) processes should be able
> to do the same thing simultaneously.
> 
> Also is there a raw format for setting the filters that lets userspace
> swap them atomically (ie change from filter A to filter B with a
> guarantee that filter A is in effect right up to the time filter B is in
> effect with no window where eg no filter is in effect).
> 
>  > Well, if you need to add hooks, definitely at least use tracepoints. (see 
>  > the TRACE_EVENT code in include/trace/events/*.h)
> 
> I don't think I'm adding hooks -- the mmu notifier infrastructure
> already suits me perfectly.  The only thing I'm doing is forwarding the
> events delivered by mmu notifiers up to userspace, but not really in a
> way that's very close to what ftrace does (I don't think).

OK, I didn't look at the code enough to know.

> 
> It seems handling multiple unprivileged contexts accessing different
> streams of trace events is going to require pretty huge ftrace changes.
> And ummunotify is currently about 400 lines of code total (+ 300 lines
> of comments :) so we're not going to simplify that code dramatically.
> The hope I guess would be that a common interface would make things
> conceptually simpler, but I don't see how to slot ftrace and ummunotify
> together very cleanly.

I agree, what you are doing is out of the scope of ftrace. But perhaps 
someday this may change. Currently because of security issues, we keep 
ftrace a privileged user function. But we've been discussing changing this 
someday. But any change would need to be scrutinized for security sake. 
Ftrace gives a user a peak into what is going on inside the kernel. And 
with that, it theoretically, gives a way to get around kernel security 
measures.

-- Steve

