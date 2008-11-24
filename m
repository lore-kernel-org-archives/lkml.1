Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYKXRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYKXRVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYKXRVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:21:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYKXRVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:21:42 -0500
Date: Mon, 24 Nov 2008 12:21:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Human readable output for function return tracer
In-Reply-To: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811241202060.20122@gandalf.stny.rr.com>
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 24 Nov 2008, Fr?d?ric Weisbecker wrote:

> Hi,
> 
> I'm planning to apply an idea proposed by Ingo to make the output on
> the function return tracer
> more "eyes-parsable".
> The idea consists on a trace which has flow similar to C code:
> 
> func1() {
>     func2() {
>         func3() {
>         }
>     }
>     func4() {
>     }
> }

A little off topic, but how do you handle collapsed returns?

  func1() {
	[...]
	func2();
	return;
  }

Instead of using call *func2, gcc may decide to collapse it. That is,
since it is the last thing done on func1, it may pop func1's frame all the 
way to func1's return address, and then do a "jmp" to func2. func2 will 
still call mcount, but on its return, it will jump to the func1 return 
address.

Perhaps this is OK. The call to func1's mcount will store the original 
return address and replace it with the function return code. The call to 
func2 will store that return address and replace it with the func2 
function return code. And both of them will still be processed.

OK, I think I answered my own question, but I'm keeping it in this post 
just to make sure I understand it correctly.

	
> 
> (With time of execution added on closing braces).
> 
> The problem is that the traces arrive in the reverse order, according
> to the fact that functions
> are traced on return.
> The order corresponding to the above example would be as the following:
> 
> func3, func2, func4, func1
> 
> Oh and we have the parent in a return trace, so we would actually have:
> 
> func2->func3
> func1->func4
> ....    ->func1
> 
> This trace flow doesn't make the things easy to produce our C like code.
> 
> So I found only one solution which have both pros and cons.
> I could send a "pre-trace" to the ring-buffer to signal that function
> x with depth y is beeing called
> (when we enter the function).
> 
> The pros:
> 
> _ It will be easy to draw our C 'like trace, without any special
> pre-output work.
> _ The name could be definetly full-function-tracer with this new pre-trace :-)
> _ Automatic trace parsing, tree of calls building will be more easy....
> 
> The cons:
> 
> _ The function-return-tracer slows down the system.
>    It will be worst with a new insertion in the ring-buffer. But if it is mostly
>    used with dynamic ftrace and a good set of filtered functions, I
> don't think that will be
>    an issue.
> 
> If you think about an other solution, don't hesitate to tell me :-)
> Thanks....

Do you have a record that you store when you make the first mcount call. 
In this record, could you save the depth of the parent there too. I do not 
remember the code exactly, so I might be off here ;-)

-- Steve

