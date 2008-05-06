Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYEFBnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYEFBnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYEFBnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:43:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbYEFBnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:43:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] do_wait reorganization
In-Reply-To: Linus Torvalds's message of  Monday, 5 May 2008 17:54:49 -0700 <alpine.LFD.1.10.0805051742370.32269@woody.linux-foundation.org>
References: <20080506003239.43FF026FA20@magilla.localdomain>
	<alpine.LFD.1.10.0805051742370.32269@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
Message-Id: <20080506014235.3905626FA20@magilla.localdomain>
Date: Mon,  5 May 2008 18:42:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I absolutely detest your propensity for multiple return values. You have 
> "int ret" for the return value, and then you *also* have a "int *retval" 
> for the return value.
> 
> Which is what, and why?

The "int ret" (actual return value of wait_consider_task and wait_task_*)
is the nonzero return value if this task produced the final result.  The
"int *retval" is the return value of last resort if there turns out to be
no task with a final result.

> I'm pretty sure it should be possible to return a positive value for 
> "eligible but not available" and make do with just one return value, but 
> if that is just not possible or too complicated, 

It's not possible and would be too complicated.  (A positive value
already means the pid for a successful result, and the task_struct has been
freed by then so the pid for the syscall return value can't be gotten later.)

> at least don't call it "retval" and have totally different semantics from
> the return value we return?

A better name would be "notask_error".  It is the error to return when there
is no task with status to return.  The error is zero if there were matches,
since we'll return zero for WNHOHANG or we will block.

> So for example, maybe it could just be count of eligible children, and we 
> call could it "int *eligible", and then rather than initialize to -ECHILD, 

There is no use for a count, but there is a use for the error value.  In
patch 3/3, we restore the old behavior of keeping track of the error value
other than -ECHILD if there was one (like -EACCES due to bad selinux policy).

I agree the name of the parameter and variable should not be "retval".
A change beyond that just for the sake of making it not be something
like looks like it might the syscall's return value seems gratuitous and
obfuscating, and will complicate the code (since it really is a value
we're keeping around that might be the return value for the syscall).


Thanks,
Roland
