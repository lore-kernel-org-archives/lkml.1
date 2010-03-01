Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0CATmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:42:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39304 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab0CATmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:42:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=MrHG-AeuP_8A:10 a=7U3hwN5JcxgA:10 a=ZF6r0PCSlgtr4ur4QT4A:9 a=TFUMAWVKflMrNdRPP_76l_ZeR6wA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003010843050.3616@localhost.localdomain>
References: <20100227150942.GA6394@elte.hu>
	 <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain>
	 <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain>
	 <20100301080058.GA8049@elte.hu> <20100301131701.GA5562@nowhere>
	 <alpine.LFD.2.00.1003010843050.3616@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Mar 2010 14:42:02 -0500
Message-ID: <1267472522.10871.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 08:47 -0800, Linus Torvalds wrote:

> Both of you seemed to miss the fact that it's not cpu7 that is 
> particularly slow. See the original email from me in this thread: the jump 
> was at some random point:
> 
>         [    0.245179] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
>         [    0.265332]  #2
>         [    0.353185] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
>         [    0.373328]  #3
>         [    2.193277] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
>         [    2.213379]  #4
> 
> and the reason I grepped for "CPU 7" was that it's the _last_ CPU on this 
> machine, so what I was grepping for was basically "how long did it take to 
> bring up all CPU's".
> 
> So that particular really bad case apparently happened for CPU#3, but the 
> two other slow cases happened for CPU#4.
> 
> Also, it seems to happen only about every fifth boot or so. Suggestions 
> for something simple that can trace things like that?

As Frederic has said you can use 'ftrace=function_graph' on the kernel
command line. It will be initialized in early_initcall (which I believe
is before CPUs are set up. Then add a tracing_off() after the trouble
code. You can make the trace buffers bigger with the kernel command
line:

	trace_buf_size=10000000

The above will make the trace buffer 10Meg per CPU. Unlike the
"buffer_size_kb" file, this number is in bytes, even though it will
round to the nearest page. (I probably should make this into kb, and
rename it to trace_buf_size_kb, and deprecate trace_buf_size).

Then you can cat out /debug/tracing/trace, and search for large
latencies in the timestamps.

-- Steve



