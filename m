Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbZEQBXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbZEQBXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 21:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZEQBXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 21:23:06 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53179 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZEQBXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 21:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sLqvIgTxSKkiFQY7vys19Bt4h4g+QXSndU6Nmus4q9emoal/TJohXzf32X0rQhp7ID
         ThKBWsSjqMCbX18FsXWmwN6BY2kTtMayv7b8ysCafRvvxEMhXraX8YdPGEV85Yptky6r
         kxsXJf+H4pwIPpp2vAUXtOSDx8XaLO7WsLCzQ=
Date: Sun, 17 May 2009 03:23:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.30-rc kills my box hard - and lockdep chains
Message-ID: <20090517012300.GA5512@nowhere>
References: <20090514094951.36fd7333@bike.lwn.net> <20090516161419.62c45c2b.akpm@linux-foundation.org> <20090517003837.GA4640@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090517003837.GA4640@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 02:38:39AM +0200, Frederic Weisbecker wrote:
> On Sat, May 16, 2009 at 04:14:19PM -0700, Andrew Morton wrote:
> > On Thu, 14 May 2009 09:49:51 -0600 Jonathan Corbet <corbet@lwn.net> wrote:
> > 
> > > So...every now and then I return to my system (a dual-core 64-bit
> > > x86 box) only to find it totally dead.  Lights are on but there's no
> > > disk activity, no ping responses, no alternative to simply pulling the
> > > plug.  It happens fairly reliably about once a day with the 2.6.30-rc
> > > kernels; it does not happen with 2.6.29.
> > > 
> > > I'm at a bit of a loss for how to try to track this one down.  "System
> > > disappears without a trace" isn't much to go on.  I can't reproduce it
> > > at will; even the "maintain an unsaved editor buffer with hours' worth
> > > of work" trick doesn't seem to work this time.  
> > > 
> > > One clue might be found here, perhaps: I didn't have lockdep enabled but I do
> > > now.
> > 
> > So the lockup isn't due to lockdep.
> > 
> > Did you try all the usual sysrq-P, nmi-watchdog stuff?
> > 
> > Is netconsole enabled, to see if it squawked as it died?
> > 
> > > May 14 01:06:55 bike kernel: [38730.804833] BUG: MAX_LOCKDEP_CHAINS too low!
> > > May 14 01:06:55 bike kernel: [38730.804838] turning off the locking correctness validator.
> > > May 14 01:06:55 bike kernel: [38730.804843] Pid: 5321, comm: tar Tainted: G        W  2.6.30-rc5 #11
> > > May 14 01:06:55 bike kernel: [38730.804846] Call Trace:
> > > May 14 01:06:55 bike kernel: [38730.804854]  [<ffffffff8025df59>] __lock_acquire+0x57f/0xbc9
> > > May 14 01:06:55 bike kernel: [38730.804860]  [<ffffffff8020f3a9>] ? print_context_stack+0xfa/0x119
> > > May 14 01:06:55 bike kernel: [38730.804866]  [<ffffffff80394da9>] ? get_hash_bucket+0x28/0x34
> > >
> > > ...
> > >
> > > May 14 01:06:55 bike kernel: [38730.805340]  [<ffffffff802c2741>] ? filldir+0x0/0xc4
> > > May 14 01:06:55 bike kernel: [38730.805344]  [<ffffffff802c293d>] vfs_readdir+0x79/0xb6
> > > May 14 01:06:55 bike kernel: [38730.805348]  [<ffffffff802c2ac3>] sys_getdents+0x81/0xd1
> > > May 14 01:06:55 bike kernel: [38730.805353]  [<ffffffff8020bcdb>] system_call_fastpath+0x16/0x1b
> > > 
> > > That's quite the call stack...  and, evidently, a lot of lock chains...  
> > 
> > It is a deep stack trace.
> > 
> > And unfortunately
> > 
> > a) that diagnostic didn't print the stack pointer value, from which
> >    we can often work out if we're looking at a stack overflow.
> > 
> > b) I regularly think it would be useful if that stack backtrace were
> >    to print out the actual stack address, so we could see how much
> >    stack each function is using.
> > 
> >    I just went in to hack these things up, but the x86 stacktrace
> >    code which I used to understand has become stupidly complex so I
> >    gave up.
> > 
> > What tools do we have to diagnose a possible kernel stack overflow? 
> > There's CONFIG_DEBUG_STACK_USAGE but that's unlikely to be much use.
> 
> 
> I think about CONFIG_STACK_TRACER. Currently this tracer
> dumps the max stack footprint backtrace through a file in debugfs.
> Then it's not that much useful to debug a stack overflow.
> 
> I'm trying to hack around a printk dump for each max stack footprint
> encountered. Hopefully it could help to debug this.
> 
> Frederic.
> 

Jonathan, could you try the following patch?
It will dump a stack trace each time it becomes the new max one.
If it's about a stack overflow it can be helpful to track the last
max stack usage before the crash.

You'll need CONFIG_STACK_TRACER, the "stacktrace" boot parameter
and some luck...

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index c750f65..fbbe312 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -67,6 +67,9 @@ static inline void check_stack(void)
 
 	save_stack_trace(&max_stack_trace);
 
+	printk("New max stack usage:\n");
+	print_stack_trace(&max_stack_trace, 1);
+
 	/*
 	 * Now find where in the stack these are.
 	 */


