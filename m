Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753196AbYLQWG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYLQWG3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYLQWGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:06:18 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:44785 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbYLQWGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:06:17 -0500
Message-Id: <43FABC30-175B-4B17-9058-E8DFC250A36B@arcor.de>
From: XComp <xcomp@arcor.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Fwd: Problem with old context in signal handler function
Date: Wed, 17 Dec 2008 14:06:09 -0800
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Begin forwarded message:
> From: xcomp@arcor.de
> Date: 10. Dezember 2008 17:32:06 GMT-08:00
> To: linux-kernel@vger.kernel.org
> Subject: Problem with old context in signal handler function
>
> Hello everyone,
> I want to switch between user contexts using a signal handler  
> (something like a preemptive scheduler for userlevel threads). I've  
> found several sources, which say that it's not a good idea to use  
> setcontext or swapcontext in a signal handler. Nevertheless there  
> also exists at least one sample code of such an preemptive  
> scheduler, which seems to work well, at least on my machine (Ubuntu  
> 8.04 with linux kernel 2.6.24-22): www.seas.upenn.edu/~cse381/context_demo.c
>
> // [...]
> static ucontext_t thread_context;
> static ucontext_t scheduler_context;
>
> int thread_finished;
> int i;
>
> static void simple_function(void) {
> 	// do nothing but counting
> 	for (i = 0; i < 1000000000; ++i) { }
>
> 	if (i == 1000000000) {
> 		printf("\n[Thread Function]\t1st counting worked fine...");
> 	} else {
> 		printf("\n[Thread Function]\tError: Counting didn't finished  
> (%d)...", i);
> 	}
>
> 	thread_finished = 1;
> }
>
> static void other_function() {
> 	// thread_finished is a global variable, which is set to 1, if the  
> thread function is finished
> 	while(thread_finished != 1) { swapcontext(&scheduler_context,  
> &thread_context); }
> }
>
> static void signal_handler_function(int sig_nr, siginfo_t* info,  
> void *old_context) {
> 	if (sig_nr == SIGPROF) {
> 		// saves the thread context
> 		thread_context = *((ucontext_t*) context);
>
> 		// swaps back to scheduler context
> 		setcontext(&scheduler_context);
> 	}
> }
> // [...]
>
> I ran into the following problem which belongs to the code above. I  
> interrupted simple_function several times by using a ITimer. But the  
> for-loop doesn't finish successfully everytime. Often the if  
> condition is false. But it does not cancel after the first signal is  
> raised. I've found out that using the third parameter old_context  
> for storing the old context is the reason. But I don't know why. So  
> I thought there might be a problem in the kernel. Am I right? I was  
> afraid to post the whole code, so I hope that this code snippet is  
> enough.
> I would appreciate if someone can give me a comment whether this  
> strange behaviour is because of a wrong thinking of mine or because  
> of a error in the kernel which needs to be fixed.
>
> Thanks a lot!
> Matthias

Ok, I try to reduce the problem size. Is it valid to use the  
ucontext_t struct, which is passed through a extended signal handling  
function (3rd argument) in order to get back to this context using  
setcontext(). I think it should. But it causes into strange behaviour  
in some cases (one is explained below). I hope I could make it clear.  
Thanks for any help concerning this problem.

Best,
Matthias
