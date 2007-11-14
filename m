Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbXKNH5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbXKNH5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbXKNH5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:57:42 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:45158 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXKNH5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:57:41 -0500
Message-ID: <473AAA75.2050900@in.ibm.com>
Date: Wed, 14 Nov 2007 13:27:41 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: linux-kernel@vger.kernel.org, prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
References: <47389BEB.1000901@gmail.com> <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com> <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
In-Reply-To: <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Sagar wrote:
> On Nov 13, 2007 12:09 AM, Abhishek Sagar <sagar.abhishek@gmail.com> wrote:
>> Whoops...sry for the repeated email..emailer trouble.
> 
> Expecting this one to makes it to the list. Summary again:
> 
> This patch introduces a provision to specify a user-defined callback
> to run at function entry to complement the return handler in
> kretprobes. Currently, whenever a kretprobe is registered, a user can
> specify a callback (return-handler) to be run each time the target
> function returns. This is also not guaranteed and is limited by the
> number of concurrently pending return instances of the target function
> in the current process's context.
> 
> This patch will now allow registration of another user defined handler
> which is guaranteed to run each time the current return instance is
> allocated and the return handler is set-up. Conversely, if the
> entry-handler returns an error, it'll cause the current return
> instance to be dropped and the return handler will also not run. The
> purpose is to provide flexibility to do certain kinds of function
> level profiling using kretprobes. By being able to register function
> entry and return handlers, kretprobes will now be able to reduce an
> extra probe registration (and associated race) for scenarios where an
> entry handler is required to capture the function call/entry event
> along with the corresponding function exit event.
> 

If I understand your intentions(to capture information on function call/entry and corresponding function exit) cleary, I have few concerns on this.

1) How do you map the entry_handler(which gets executed when a process enters the function) with each instance of return probe handler.
I accept that entry_handler() will execute each time process enters the function, but to  calculate time, one needs to know corresponding instance of return probe handler(there should be a map for each return handler). 

  Let me explain briefly.
Suppose in a SMP system, 4 processes  enter the same function at almost sametime(by executing entry_hanlder()) and returns from 4 different locations by executing the return handler.  Now how do I match entry_handler() with corresponding instance of return handler for calculating time.

Sometime back, Even I was interested in calculating the  function execution time, but I used approach a) .

Now What I think is, there could be 2 solutions to these problem.

a) Collect the entry time and exit time and put it in that kretprobe_instance structure and fetch it before freeing that instance.

b) Or pass ri(kretprobe_instance address to entry_handler) and match it with return probe handler.
