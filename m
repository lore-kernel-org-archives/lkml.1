Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbXGJSKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbXGJSKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763827AbXGJSJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:09:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:57843 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763789AbXGJSJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EoRLc0iLwJQYaJ0ZFIvGe+fJ2oZ+0Mg3MAelLtDW5MnS4K5bbIQ8rcOz+npyH1E47RLfzQCQBPG4yJL7+xVkCQdtLec62gTHCiEUW5ccjBmcCWOJPejuoJbI4hVfkg/N+xQ5menXwenJdCcMQ0fo4uVCxJVQGz2XcB3LaAiQ1Wo=
Message-ID: <4693CB1B.8070301@gmail.com>
Date: Wed, 11 Jul 2007 03:08:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
References: <Pine.LNX.4.44L0.0707101303320.2706-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707101303320.2706-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Stern wrote:
>> When a bus device is being woken up and rescanning the bus, all
>> prerequisites for the bus should have been resumed already.  As long as
>> the newly added device is placed after the bus device itself, things
>> should be safe.  Well, that's the theory at least.
> 
> What actually happened in practice was that a device send a wakeup
> request and hence was resumed without the PM core's knowledge.  As a
> result it was still on the "suspended" list when its new child was
> added to the end of the "resumed" list.  Then when the PM core got
> around to the parent, the parent was placed after the child.  Since the 
> "resumed" list is iterated in reverse order for suspending, you see the 
> problem.
> 
> If the PM core had been holding the parent's semaphore this wouldn't 
> have occurred.  But it does illustrate the pitfalls of adding a device 
> during resume.

Oh I see.  Considering such cases, I guess what's needed is allowing
"addition of devices hanging off of resumed or resuming bus during
system resume".

>>> I had envisioned using SRCU to synchronize existing device additions
>>> with the beginning of a suspend.  down_read_trylock should work just as
>>> well (aside from cacheline bouncing).
>> How high performance device addition/removal should be?  Wouldn't rwlock
>> be enough?
> 
> rwlock is a type of spinlock, right?  Hence it can't sleep and can't be
> used for device addition/removal.  Also rwlocks aren't fair and are
> subject to livelock.

rwsem of course.  Sorry about the confusion.  Fairness doesn't matter
here.  The synchronization is suspend vs. addition with priority on
suspend (suspend does down_write, removal does down_read_trylock).

>> Hmmm... locking all device mutexes sounds scary to me but I tend to be a
>> chicken and lockdep is great, so it might just work.  :-)
> 
> These aren't mutexes; they are semaphores (although they are used as 
> mutexes).  I speculate that part of the reason they have never been 
> converted to mutexes is because of potential lockdep issues.
> 
> The order of locking isn't a problem.  The list itself defines the 
> correct order.

I'm still not a big fan of locking (or downing) all device semaphores
when the same effect can be achieved with a rwsem.  One thing I like
about rwsem approach is that it can never cause a deadlock because one
side uses trylock exclusively.

If you lock all the device sems, failing addition becomes more difficult
(can be done but then you need something like the rwsem anyway).
Without special handling of dev->sem, when a driver screws up (try to
add a child device from ->suspend), it will deadlock while suspend is in
progress, which isn't pretty.

Please also note that currently dev->sem does not protect against adding
children.  It says it does in the comment on the definition of the field
but it's never acquired during device_add().

>> Why is that necessary?  What happens if there's some long-running
>> read/write operation using bin attr?
> 
> That is certainly a possible problem.  I don't know if there are any 
> such long-running operations.
> 
> Is it necessary?  No.  But it would make things easier if suspend 
> handling could be localized in one place (the sysfs core) instead of 
> spread out among a bunch of attribute methods.

Yeah, I'm all for centralizing things.  I just didn't see what could be
simplified in LLDs by freezing sysfs access.  Can you point me to any
example node which can benefit from such thing?

> Using a freezable workqueue for the callbacks would also localize the 
> suspend handling.

But the freezable workqueue thing isn't really necessary if any of the
discussed solutions is implemented, right?

Thanks.

-- 
tejun
