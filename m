Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYJUAnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYJUAnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYJUAni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:43:38 -0400
Received: from mail.lang.hm ([64.81.33.126]:41530 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbYJUAni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:43:38 -0400
Date: Mon, 20 Oct 2008 17:44:02 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "David M. Lloyd" <dmlloyd@flurg.com>
cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield() options
In-Reply-To: <48FD19E9.8010807@flurg.com>
Message-ID: <alpine.DEB.1.10.0810201733000.21749@asgard.lang.hm>
References: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm> <20081020225318.GA10352@ghostprotocols.net> <alpine.DEB.1.10.0810201603510.21749@asgard.lang.hm> <48FD19E9.8010807@flurg.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, David M. Lloyd wrote:

> On 10/20/2008 06:08 PM, david@lang.hm wrote:
>> in the case I'm looking at there are two (or more) threads running with one 
>> message queue in the center.
>> 
>> 'input threads' are grabbing the lock to add messages to the queue
>> 
>> 'output threads' are grabbing the lock to remove messages from the queue
>> 
>> the programmer is doing a pthread_yield() after each message is processed 
>> in an attempt to help fairness (he initially added it in when he started 
>> seeing starvation on single-core systems)
>> 
>> what should he be doing instead?
>
> If you're seeing starvation, to me that's a good indicator that the 
> granularity of queue items are too small... probably there'd be an overall 
> benefit of grabbing more things at once from the queue.
>
> To make a silly metaphor out of it - imagine you've got a bunch of office 
> interns (threads) whose jobs are to fill out PQ9-12b forms.  An intern has to 
> wait in line before they can get to the desk where the secretary is handing 
> out the forms to be filled out, one by one.  An intern can fill out the form 
> just as fast as the secretary hands it to them; if they do so, then one 
> intern ends up doing all the work while the others just wait in line.
>
> But in order to make everyone equally busy (by injecting sched_yield()) 
> you're making the interns take the paper, walk back to their desk, fill it 
> out, and then get back in line, which takes somewhat more time overall, 
> despite making the interns look much busier.  A better solution would be to 
> give each intern a big stack of forms so that they spend a greater proportion 
> of time filling them out rather than waiting in line; perhaps if each intern 
> is kept busy enough, the line will always be empty, which would be the best 
> situation of all.

I've suggested that, but the changes nessasary to support that mode of 
operation are very invasive, and so not an option in the near/medium term.

in the meantime is there something better than sched_yield() that should 
be happening

clarifying the situation a bit

in this case you have two sets of interns, and a secretary maintaining a 
stack of pending messages

one set of interns are listening to the phone and scribbling notes, then 
delivering them to the secretary

the other set of interns are picking up the papers from the secretary
and delivering them to their destination.

each set of interns has it's own line, but they are both very pushy and 
instead of moving back and forth between the two lines reasonably fairly 
the secretary spends too much time servicing one line, and the other set 
of interns end up all queued up and unable to do anything, so the total 
number of messages plummets.

the sched_yield is an attempt to have the secretary pause once in a while 
and check to see if the other line has someone waiting.

from looking at the software running, it doesn't seem to work very well. 
I've also suggested investigating lockless algorithms for the queue, but 
that is also a lot of high-risk (but high-reward) work. what else can be 
done to make a mutex more fair?

David Lang
