Return-Path: <linux-kernel-owner+w=401wt.eu-S1946371AbXBCHKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946371AbXBCHKS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 02:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946372AbXBCHKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 02:10:18 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39503 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946371AbXBCHKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 02:10:17 -0500
Date: Sat, 3 Feb 2007 12:45:34 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070203071533.GA14816@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org> <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 04:56:22PM -0800, Linus Torvalds wrote:
> 
> On Sat, 3 Feb 2007, Ingo Molnar wrote:
> > 
> > Well, in my picture, 'only if you block' is a pure thread utilization 
> > decision: bounce a piece of work to another thread if this thread cannot 
> > complete it. (if the kernel is lucky enough that the user context told 
> > it "it's fine to do that".)
> 
> Sure, you can do it that way too. But at that point, your argument that we 
> shouldn't do it with fibrils is wrong: you'd still need basically the 
> exact same setup that Zach does in his fibril stuff, and the exact same 
> hook in the scheduler, testing the exact same value ("do we have a pending 
> queue of work").
> 
> So at that point, you really are arguing about a rather small detail in 
> the implementation, I think.
> 
> Which is fair enough. 
> 
> But I actually think the *bigger* argument and problems are elsewhere, 
> namely in the interface details. Notably, I think the *real* issues end up 
> how we handle synchronization, and how we handle signalling. Those are in 
> many ways (I think) more important than whether we actually can schedule 
> these trivial things on multiple CPU's concurrently or not.
> 
> For example, I think serialization is potentially a much more expensive 
> issue. Could we, for example, allow users to serialize with these things 
> *without* having to go through the expense of doing a system call? Again, 
> I'm thinking of the case of no IO happening, in which case there also 
> won't be any actual threading taking place, in which case it's a total 
> waste of time to do a system call at all.
> 
> And trying to do that actually has implications for the interfaces (like 
> possibly returning a zero cookie for the async() system call if it was 
> doable totally synchronously?)

This would be useful - the application wouldn't have to set up state
to remember for handling completions for operations that complete synchronously
I know Samba folks would like that.

The laio_syscall implementation (Lazy asynchronous IO) seems to have
experimented with such an interface
http://www.usenix.org/events/usenix04/tech/general/elmeleegy.html

Regards
Suparna

> 
> Signal handling is similar: I actually think that a "async()" system call 
> should be interruptible within the context of the caller, since we would 
> want to *try* to execute it synchronously. That automatically means that 
> we have semantic meaning for fibrils and signal handling.
> 
> Finally, can we actually get POSIX aio semantics with this? Can we 
> implement the current aio_xyzzy() system calls using this same feature? 
> And most importantly - does it perform well enough that we really can do 
> that?
> 
> THOSE are to me bigger questions than what happens inside the kernel, and 
> whether we actually end up using another thread if we end up doing it 
> non-synchronously.
> 
> 					Linus
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

