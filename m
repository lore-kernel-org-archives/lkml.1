Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbXLCXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbXLCXYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXLCXYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:24:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:17452 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXLCXYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:24:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dX1TPLO5BJclcDbop248gQylwcvdfOk1m1aXq3XRLhzvN9HwgKbo8zA+WhoyD0+2pdcX2KiRlW4sOUeg/byKHspg6ttJXOvjYafcM6sDiZkoQErnEck7YRt2WXySu5YbyCxgDPZmaD9lnItmHMipvHy9uPHhl1bo3hWPjadi0/Y=
Message-ID: <4754907E.9060203@gmail.com>
Date: Tue, 04 Dec 2007 00:25:50 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Need lockdep help
References: <20071203103630.GB2429@ff.dom.local> <Pine.LNX.4.44L0.0712031000480.3630-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0712031000480.3630-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote, On 12/03/2007 04:08 PM:

> On Mon, 3 Dec 2007, Jarek Poplawski wrote:
> 
>>> System sleep start:
>>> 		down_read(notifier-chain rwsem);
>>> 		call the notifier routine
>>> 			down_write(&system_sleep_in_progress_rwsem);
>>> 		up_read(notifier-chain rwsem);
>>>
>>> System sleep end:
>>> 		down_read(notifier-chain rwsem);
>>> 		call the notifier routine
>>> 			up_write(&system_sleep_in_progress_rwsem);
>>> 		up_read(notifier-chain rwsem);
>>>
>>> This creates a lockdep violation; each rwsem in turn is locked while 
>>> the other is being held.  However the only way this could lead to 
>>> deadlock would be if there was already a bug in the system Power 
>>> Management code (overlapping notifications).
>> Actually, IMHO, there is no reason for any lockdep violation:
>>
>> thread #1: has down_read(A); waits for #2 to down_write(B)
>> thread #2: has down_write(B); never waits for #1 to down_read(A)
>>
>> So, deadlock isn't possible here. If lockdep reports something else it
>> should be fixed (and you'd be right to omit lockdep until this is
>> done).
> 
> I think the reasoning goes the way Arjan described.  Suppose in between
> #1 and #2 there is thread #3 trying to do down_write(A) and waiting for
> #1.  Then thread #2 doesn't have to wait for #1 directly, but it would
> have to wait for #3.


As a matter of fact I completely missed Arjan's point because I thought
you described these locks according to lockdep's report, and there is
an information about read or write... Since, you still seem to guess
above about possible scenario, maybe it would be easier to show this
report (and maybe a piece of this code if possible)?

Btw., if it were like you're suggesting, it still shouldn't make any
difference: if thread #3 is only waiting for the lock taken for reading,
then I can't see why thread #2 has to wait for anything. Probably more
dangerous, at least for lockdep, could look taking down_write(A) by
thread #1 in between, but if it all were possible only within one
thread, then still there should be no reason to change good program
only to please lockdep.
 

> In my case the simplest answer appears to be the replace the rwsem
> with something slightly more complicated (a mutex plus a boolean flag 
> -- the loss of concurrency won't matter much since it isn't on a hot 
> path).

I'm not sure I can understand your plan, but I doubt there should be
such problems with taking rwsem for sleeping, so maybe it would be
better to figure out what really scares lockdep, to fix the right place?

Jarek P.
