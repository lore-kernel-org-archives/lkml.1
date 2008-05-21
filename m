Return-Path: <linux-kernel-owner+w=401wt.eu-S936867AbYEUTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936867AbYEUTOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYEUTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:14:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35818 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbYEUTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:14:14 -0400
Date: Wed, 21 May 2008 15:14:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Subject: Re: Compile warning rtmutex code on 2.6.24.7-rt8 (CC:LKML added)
In-Reply-To: <3efb10970805211135k422a0153i28613e74d42d1ed2@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0805211504430.19141@gandalf.stny.rr.com>
References: <3efb10970805201356x4552859bof5f3f4f56f2ba676@mail.gmail.com> 
 <Pine.LNX.4.58.0805201718530.21440@gandalf.stny.rr.com>
 <3efb10970805211135k422a0153i28613e74d42d1ed2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 21 May 2008, Remy Bohmer wrote:

> Now I understood your hint in some other mail, and I am going to take
> a look at ftrace for ARM. Just for the fun of it...
> I hope it is not too intrusive for these ARM cores (old implementation
> was...), these Atmel cores are just not that fast as the common X86's.

If you feel brave, take a crack at the DYNAMIC_FTRACE. It's been done for
x86 (both 32 and 64 bit), PPC (also both 32 and 64 bit) as well as
Sparc64.

The dynamic ftrace is self modifying code, that will start off having
mcount simply call a nop. Then later it will change that to call a
"record_ip" function. A daemon is kicked off to change all the IPs that
are called into NOPs. When tracing is enabled, all the NOPs are converted
into calls to the trace function.

Dynamic ftrace also adds a "set_filter_function" in the /debugfs/tracing
directory that lets you echo in function names, and only those functions
will enable have tracing enabled.

All this helps tremendously in tracing performance and normal bootup. One
thing that you need to understand though. That daemon needs to call
kstop_machine to do the modifications. The daemon wakes up once a second,
checks to see if there is any new functions that have been recorded. If
not, then it simply goes back to sleep. But if there are new functions,
then it calls kstopmachine. This daemon stops when tracing is enabled, but
can cause unsuspecting latencies when tracing is disabled.

I'll probably add a something to disable the daemon just before firing off
init if PREEMPT_RT is enabled.

Any questions on porting ftrace, feel free to ask.

Cheers,

-- Steve

