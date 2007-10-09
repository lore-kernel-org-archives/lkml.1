Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbXJIVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbXJIVby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXJIVbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:31:46 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57453 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXJIVbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:31:45 -0400
Date: Tue, 9 Oct 2007 14:17:38 -0700
From: mike kravetz <kravetz@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, pmorreale@novell.com,
       sdietrich@novell.com
Subject: Re: [RFC PATCH RT] push waiting rt tasks to cpus with lower prios.
Message-ID: <20071009211738.GC23388@monkey.ibm.com>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net> <Pine.LNX.4.58.0710091054430.21404@gandalf.stny.rr.com> <1191944024.4281.72.camel@ghaskins-t60p.haskins.net> <1191952777.23198.8.camel@localhost.localdomain> <20071009203936.GB23388@monkey.ibm.com> <Pine.LNX.4.58.0710091645110.25406@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0710091645110.25406@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 04:50:47PM -0400, Steven Rostedt wrote:
> > I did something like this a while ago for another scheduling project.
> > A couple 'possible' optimizations to think about are:
> > 1) Only scan the remote runqueues once and keep a local copy of the
> >    remote priorities for subsequent 'scans'.  Accessing the remote
> >    runqueus (CPU specific cache lines) can be expensive.
> 
> You mean to keep the copy for the next two tries?

Yes.  But with #2 below, your next try is the runqueue/CPU that is the
next best candidate (after the trylock fails).  The 'hope' is that there
is more than one candidate CPU to push the task to.  Of course, you
always want to try and find the 'best' candidate.  My thoughts were that
if you could find ANY cpu to take the task that would be better than
sending the IPI everywhere.  With multiple runqueues/locks there is no
way you can be guaranteed of making the 'best' placement.  So, a good
placement may be enough.

> > 2) When verifying priorities, just perform spin_trylock() on the remote
> >    runqueue.  If you can immediately get it great.  If not, it implies
> >    someone else is messing with the runqueue and there is a good chance
> >    the data you pre-fetched (curr->Priority) is invalid.  In this case
> >    it might be faster to just 'move on' to the next candidate runqueue/CPU.
> >    i.e. The next highest priority that the new task can preempt.

-- 
Mike
