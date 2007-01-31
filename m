Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXAaCqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXAaCqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932443AbXAaCqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:46:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34481 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbXAaCqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:46:39 -0500
Date: Tue, 30 Jan 2007 18:46:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <1170209044.26655.364.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <1170209044.26655.364.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Jan 2007, Benjamin Herrenschmidt wrote:

> > - We would now have some measure of task_struct concurrency.  Read that twice,
> > it's scary.  As two fibrils execute and block in turn they'll each be
> > referencing current->.  It means that we need to audit task_struct to make sure
> > that paths can handle racing as its scheduled away.  The current implementation
> > *does not* let preemption trigger a fibril switch.  So one only has to worry
> > about racing with voluntary scheduling of the fibril paths.  This can mean
> > moving some task_struct members under an accessor that hides them in a struct
> > in task_struct so they're switched along with the fibril.  I think this is a
> > manageable burden.
> 
> That's the one scaring me in fact ... Maybe it will end up being an easy
> one but I don't feel too comfortable...

We actually have almost zero "interesting" data in the task-struct.

All the real meat of a task has long since been split up into structures 
that can be shared for threading anyway (ie signal/files/mm/etc).

Which is why I'm personally very comfy with just re-using task_struct 
as-is.

NOTE! This is with the understanding that we *never* do any preemption. 
The whole point of the microthreading as far as I'm concerned is exactly 
that it is cooperative. It's not preemptive, and it's emphatically *not* 
concurrent (ie you'd never have two fibrils running at the same time on 
separate CPU's).

If you want preemptive of concurrent CPU usage, you use separate threads. 
The point of AIO scheduling is very much inherent in its name: it's for 
filling up CPU's when there's IO.

So the theory (and largely practice) is that you want to use real threads 
to fill your CPU's, but then *within* those threads you use AIO to make 
sure that each thread actually uses the CPU efficiently and doesn't just 
block with nothing to do.

So with the understanding that this is neither CPU-concurrent nor 
preemptive (*within* a fibril group - obviously the thread itself gets 
both preempted and concurrently run with other threads), I don't worry at 
all about sharing "struct task_struct".

Does that mean that we might not have some cases where we'd need to make 
sure we do things differently? Of course not. Something migt show up. But 
this actually makes it very clear what the difference between "struct 
thread_struct" and "struct task_struct" are. One is shared between 
fibrils, the other isn't.

			Linus
