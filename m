Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbXLMEoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbXLMEoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXLMEoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:44:05 -0500
Received: from smtpoutm.mac.com ([17.148.16.79]:51510 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbXLMEoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:44:03 -0500
In-Reply-To: <9a8748490712121439u34863df9r6ff8d4eadb39705f@mail.gmail.com>
References: <20071001173159.GB2492@elte.hu> <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com> <20071002064620.GA26638@elte.hu> <9a8748490712121439u34863df9r6ff8d4eadb39705f@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <54633429-AF8F-4A9F-9141-B70B74A8359E@mac.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Schwartz <davids@webmaster.com>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: yield API
Date: Wed, 12 Dec 2007 23:43:51 -0500
To: Jesper Juhl <jesper.juhl@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007, at 17:39:15, Jesper Juhl wrote:
> On 02/10/2007, Ingo Molnar <mingo@elte.hu> wrote:
>> sched_yield() has been around for a decade (about three times  
>> longer than futexes were around), so if it's useful, it sure  
>> should have grown some 'crown jewel' app that uses it and shows  
>> off its advantages, compared to other locking approaches, right?
>
> I have one example of sched_yield() use in a real app.  
> Unfortunately it's proprietary so I can't show you the source, but  
> I can tell you how it's used.
>
> The case is this:  Process A forks process B. Process B does some  
> work that takes aproximately between 50 and 1000ms to complete  
> (varies), then it creates a file and continues to do other work.   
> Process A needs to wait for the file B creates before it can  
> continue. Process A *could* immediately go into some kind of "check  
> for file; sleep n ms" loop, but instead it starts off by calling  
> sched_yield() to give process B a chance to run and hopefully get  
> to the point where it has created the file before process A is  
> again scheduled and starts to look for it - after the single sched  
> yield call, process A does indeed go into a "check for file; sleep  
> 250ms;" loop, but most of the time the initial sched_yield() call  
> actually results in the file being present without having to loop  
> like that.

That is a *terrible* disgusting way to use yield.  Better options:
   (1) inotify/dnotify
   (2) create a "foo.lock" file and put the mutex in that
   (3) just start with the check-file-and-sleep loop.


> Now is this the best way to handle this situation? No.  Does it  
> work better than just doing the wait loop from the start? Yes.

It works better than doing the wait-loop from the start?  What  
evidence do you provide to support this assertion?  Specifically, in  
the first case you tell the kernel "I'm waiting for something but I  
don't know what it is or how long it will take"; while in the second  
case you tell the kernel "I'm waiting for something that will take  
exactly X milliseconds, even though I don't know what it is.  If you  
really want something similar to the old behavior then just replace  
the "sched_yield()" call with a proper sleep for the estimated time  
it will take the program to create the file.


> Is this a good way to use sched_yield()? Maybe, maybe not.  But it  
> *is* an actual use of the API in a real app.

We weren't looking for "actual uses", especially not in binary-only  
apps.  What we are looking for is optimal uses of sched_yield(); ones  
where that is the best alternative.  This... certainly isn't.

Cheers,
Kyle Moffett

