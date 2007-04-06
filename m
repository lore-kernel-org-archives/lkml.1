Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXDFXhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXDFXhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXDFXhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:37:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38403 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933330AbXDFXhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:37:51 -0400
Message-ID: <4616D9C5.7020707@garzik.org>
Date: Fri, 06 Apr 2007 19:37:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <Pine.LNX.4.64.0704061546590.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704061546590.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 6 Apr 2007, Jeff Garzik wrote:
>> I would rather change the implementation under the hood to start per-CPU
>> threads on demand, similar to a thread-pool implementation.
>>
>> Boxes with $BigNum CPUs probably won't ever use half of those threads.
> 
> The counter-argument is that boxes with $BigNum CPU's really don't hurt 
> from it either, and having per-process data structures is often simpler 
> and more efficient than trying to have some thread pool.

Two points here:

* A lot of the users in the current kernel tree don't rely on the 
per-CPU qualities.  They just need multiple threads running.

* Even with per-CPU data structures and code, you don't necessarily have 
to keep a thread alive and running for each CPU.  Reap the ones that 
haven't been used in $TimeFrame, and add thread creation to the slow 
path that already exists in the bowels of schedule_work().

Or if some kernel hacker is really motivated, all workqueue users in the 
kernel would benefit from a "thread audit", looking at working 
conditions to decide if the new kthread APIs are more appropriate.


> IOW, once we get the processes off the global list, there just isn't any 
> downside from them. Sure, they use some memory, but people who buy 
> 1024-cpu machines won't care about a few kB per CPU..
> 
> So the *only* downside is literally the process list, and one suggested 
> patch already just removes kernel threads entirely from the parenthood 
> lists.
> 
> The other potential downside could be "ps is slow", but on the other hand, 
> having the things stick around and have things like CPU-time accumulate is 
> probably worth it - if there are some issues, they'd show up properly 
> accounted for in a way that process pools would have a hard time doing.

Regardless of how things are shuffled about internally, there will 
always be annoying overhead /somewhere/ when you have a metric ton of 
kernel threads.  I think that people should also be working on ways to 
make the kernel threads a bit more manageable for the average human.


> So I really don't think this is worth changing things over, apart from 
> literally removing them from process lists, which I think everybody agrees 
> we should just do - it just never even came up before!

I think there is a human downside.  For an admin you have to wade 
through a ton of processes on your machine, if you are attempting to 
evaluate the overall state of the machine.  Just google around for all 
the admins complaining about the explosion of kernel threads on 
production machines :)

	Jeff



