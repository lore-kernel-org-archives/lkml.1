Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZBSSHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZBSSHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZBSSHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:07:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48092 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZBSSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:07:24 -0500
Date: Thu, 19 Feb 2009 13:07:21 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [git pull] tip updates for 2.6.29
In-Reply-To: <20090219091943.GB2354@elte.hu>
Message-ID: <alpine.DEB.1.10.0902191300420.30122@gandalf.stny.rr.com>
References: <20090219033531.360862326@goodmis.org> <20090219091943.GB2354@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 Feb 2009, Ingo Molnar wrote:
> > 
> > So, what happens?  The dynamic function tracer self test will call
> > the test routine while the tracer is still on. The self test will
> > start consuming all the cpu ring buffers to test them, and will not
> > end until they are all finished. But you also have RCU_TORTURE selected.
> > The RCU torture test will run, filling up the ring buffer on other
> > CPUS. The consumer will never catch up, and we run forever!
> 
> Can this problem hit other types of consumers - the 
> /debug/tracing/ ones?

No, because the consumer is just a process, and can be preempted. In fact, 
this is normal producer/consumer behavior. This was a bug because it was 
during self tests. The self test is at boot up and will not continue boot 
up processing until it is finished. It's a special case because it is a 
"reader" in the boot up code.  All other readers are done by user tasks. 
The only other kernel reader is ftrace_dump, but it disables all of ftrace 
(ring buffers and all) before dumping, and only on crashes anyway.


> 
> > Both of these are true bugs that have been in ftrace for a long time.
> > I think they are candidates for getting in 29, even this late in
> > the game. You never know what other config combination can hit these
> > bugs.
> > 
> > The fixes are simple. One is to simply disable the ring buffer
> > while the consumer runs. This prevents any producer from keeping
> > the consumer from finishing. The other is to make the function
> > tracer select KALLSYMS.
> > 
> > And yes, this was a bitch to debug. This was all I did today :-(
> 
> Looks quite subtle indeed.
> 
> It might be a safer approach to switch the self-test to 
> excercise the actual /debug/tracing paths, instead of having its 
> own home-brewn access methods. That way we debug all those 
> facilities too - beyond having a self-test - and will avoid bugs 
> like this too perhaps.


We could think of ways to redesign the self tests. But for now, they have
helped ups find bugs. Again, I'm not sure if we can change things much,
because the bug that caused this was because the reading was running 
during boot up time, and expected to finish. Where as, the /debug/tracing 
code is accessed by user tasks that can run for as long as they want.

-- Steve

