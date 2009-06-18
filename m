Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbZFRDYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbZFRDYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZFRDYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:24:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZFRDYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:24:18 -0400
Date: Wed, 17 Jun 2009 23:24:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jake Edge <jake@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: problem with function_graph self-test?
In-Reply-To: <20090616122603.6a628097@chukar>
Message-ID: <alpine.DEB.2.00.0906172312450.6890@gandalf.stny.rr.com>
References: <20090616122603.6a628097@chukar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Jake Edge wrote:

> Hi Steve,
> 
> This has taken me a bit to track down ... I built a kernel from Linus's
> git tree (as of this morning: commit
> 03347e2592078a90df818670fddf97a33eec70fb) and when i boot it, it locks
> up hard giving me a cursor in the upper left (which seems to grow then
> shrink once, if that tells anyone anything) and no other output ... i
> started messing with kernel params (turning off quiet, rhgb, adding
> boot_delay and, eventually figuring out i needed lpj as well) to try
> and extract some info ... it seems to reliably fail in the
> function_graph tracer self-test with a variety of messages (I
> unfortunately don't have a serial console on the laptop that I am
> using) ... two of the messages that I got (possibly from different
> boots):
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000048
> BUG: Function graph tracer hang!
> 
> I can try and get more information, but I wanted to check first if you
> already know about this ... somehow i'll either need to type faster :)
> or reliably slow it down and take pictures, which I can do if you'd
> like ...
> 
> obviously, for my purposes, i can turn off the selftests and/or the
> function_graph tracer ...

Jake, when you find a bug, you really find a bug!

This is something that gcc is screwing with us. After spending all day 
today trying to figure out what is happening, I finally found it in the 
assembly.

In the timer_stats_update_stats function, I get this at the beginning:

00000327 <timer_stats_update_stats>:
 327:   57                      push   %edi
 328:   8d 7c 24 08             lea    0x8(%esp),%edi
 32c:   83 e4 e0                and    $0xffffffe0,%esp
 32f:   ff 77 fc                pushl  0xfffffffc(%edi)
 332:   55                      push   %ebp
 333:   89 e5                   mov    %esp,%ebp
 335:   57                      push   %edi
 336:   56                      push   %esi
 337:   53                      push   %ebx
 338:   81 ec 8c 00 00 00       sub    $0x8c,%esp
 33e:   e8 fc ff ff ff          call   33f <timer_stats_update_stats+0x18>
                        33f: R_386_PC32 mcount


And this at the end of the function:

 4f6:   8d 67 f8                lea    0xfffffff8(%edi),%esp
 4f9:   5f                      pop    %edi
 4fa:   c3                      ret    


The way the function graph tracer works, is that it will look at the frame 
pointer and replace the return address of the function with a hook to 
trace the exit of the function. Then that hook will jump back to the 
original return address.

The return address is stored in an internal stack for each process to know 
where to return from, as function calls act like a stack:

  func1() {
    func2() {
      func3() {
        [...]
      }
    }
  }

But the problem with the above code is that it gives us a fake return 
address location:

 +--------------------+
 | real return addr   |  <--- what we want
 +--------------------+
 | %edi               |
 +--------------------+
 | copy of return addr|  <--- what we get
 +--------------------+


We update the copy, but on return, this update is ignored, and we return 
back to the function that called us.

Now here's the problem, the function graph code has no idea this happened. 
When that parent function returns, we will think it is the function that 
duped us returning. And you guessed it! It will return back to where the 
parent called that function, instead of returning to the function that 
called the parent!

Grumble %@$%^##

Now we need to find out why gcc is doing this, and how to shut it off.

-- Steve

