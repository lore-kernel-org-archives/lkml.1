Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbYETDpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbYETDpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 23:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYETDo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 23:44:56 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:62423 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbYETDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 23:44:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQFAN/lMUhMROPA/2dsb2JhbACBVawk
Date: Mon, 19 May 2008 23:44:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
Message-ID: <20080520034453.GA21313@Krystal>
References: <20080504134838.GA21487@Krystal> <20080505065559.GD3350@elte.hu> <20080505105915.GA26444@Krystal> <20080505111029.GA9948@elte.hu> <20080505113057.GA28070@Krystal> <20080505122835.GA1523@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080505122835.GA1523@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:23:45 up 80 days, 23:34,  5 users,  load average: 3.11, 3.16,
	3.05
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Ideally, I'd like to have this kind of high-level information :
> > 
> > event name : kernel syscall
> > syscall name : open
> > arg1 (%s) : "somefile"    <-----
> > arg2 (%d) : flags
> > arg3 (%d) : mode
> > 
> > However, "somefile" has to be read from userspace. With the protection 
> > involved, it would cause a performance impact to read it a second time 
> > rather than tracing the string once it's been copied to kernel-space.
> 
> performance is a secondary issue here, and copies are fast anyway _if_ 
> someone wants to trace a syscall. (because the first copy brings the 
> cacheline into the cache, subsequent copies are almost for free compared 
> to the first copy)
> 
> 	Ingo

Hrm, a quick benchmark on my pentium 4 comparing a normal open() system
call executed in a loop to a modified open() syscall which executes the
lines added in the following patch adds 450 cycles to each open() system
call. I added a putname/getname on purpose to see the cost of a second
userspace copy and it's not exactly free.

The normal getname correctly nested, re-using the string previously
copied, should not suffer from that kind of performance hit. Also, given
that the string would be copied only once from userspace, it would
eliminate race scenarios where multithreaded applications could change
the string underneath, so the kernel would trace a different string than
the one being really used for the system call.

However, strings are not the only userspace arguments passed to system
calls. For all these other arguments, performance could be an issue as
well as racy user-level data modification which would let the kernel
trace a different paramenter than the one being used in the system call.

For those two reasons, I think extracting these parameters could be
faster/cleaner/safer if done in the system call function, where the
parameters are already copied in kernel space.

Mathieu


Index: linux-2.6-lttng/fs/open.c
===================================================================
--- linux-2.6-lttng.orig/fs/open.c	2008-05-19 22:51:16.000000000 -0400
+++ linux-2.6-lttng/fs/open.c	2008-05-19 23:11:07.000000000 -0400
@@ -1043,6 +1043,8 @@ long do_sys_open(int dfd, const char __u
 	int fd = PTR_ERR(tmp);
 
 	if (!IS_ERR(tmp)) {
+		putname(tmp);
+		tmp = getname(filename);
 		fd = get_unused_fd_flags(flags);
 		if (fd >= 0) {
 			struct file *f = do_filp_open(dfd, tmp, flags, mode);


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
