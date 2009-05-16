Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZEPXOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZEPXOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZEPXOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:14:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbZEPXOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:14:20 -0400
Date: Sat, 16 May 2009 16:14:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc kills my box hard - and lockdep chains
Message-Id: <20090516161419.62c45c2b.akpm@linux-foundation.org>
In-Reply-To: <20090514094951.36fd7333@bike.lwn.net>
References: <20090514094951.36fd7333@bike.lwn.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 09:49:51 -0600 Jonathan Corbet <corbet@lwn.net> wrote:

> So...every now and then I return to my system (a dual-core 64-bit
> x86 box) only to find it totally dead.  Lights are on but there's no
> disk activity, no ping responses, no alternative to simply pulling the
> plug.  It happens fairly reliably about once a day with the 2.6.30-rc
> kernels; it does not happen with 2.6.29.
> 
> I'm at a bit of a loss for how to try to track this one down.  "System
> disappears without a trace" isn't much to go on.  I can't reproduce it
> at will; even the "maintain an unsaved editor buffer with hours' worth
> of work" trick doesn't seem to work this time.  
> 
> One clue might be found here, perhaps: I didn't have lockdep enabled but I do
> now.

So the lockup isn't due to lockdep.

Did you try all the usual sysrq-P, nmi-watchdog stuff?

Is netconsole enabled, to see if it squawked as it died?

> May 14 01:06:55 bike kernel: [38730.804833] BUG: MAX_LOCKDEP_CHAINS too low!
> May 14 01:06:55 bike kernel: [38730.804838] turning off the locking correctness validator.
> May 14 01:06:55 bike kernel: [38730.804843] Pid: 5321, comm: tar Tainted: G        W  2.6.30-rc5 #11
> May 14 01:06:55 bike kernel: [38730.804846] Call Trace:
> May 14 01:06:55 bike kernel: [38730.804854]  [<ffffffff8025df59>] __lock_acquire+0x57f/0xbc9
> May 14 01:06:55 bike kernel: [38730.804860]  [<ffffffff8020f3a9>] ? print_context_stack+0xfa/0x119
> May 14 01:06:55 bike kernel: [38730.804866]  [<ffffffff80394da9>] ? get_hash_bucket+0x28/0x34
>
> ...
>
> May 14 01:06:55 bike kernel: [38730.805340]  [<ffffffff802c2741>] ? filldir+0x0/0xc4
> May 14 01:06:55 bike kernel: [38730.805344]  [<ffffffff802c293d>] vfs_readdir+0x79/0xb6
> May 14 01:06:55 bike kernel: [38730.805348]  [<ffffffff802c2ac3>] sys_getdents+0x81/0xd1
> May 14 01:06:55 bike kernel: [38730.805353]  [<ffffffff8020bcdb>] system_call_fastpath+0x16/0x1b
> 
> That's quite the call stack...  and, evidently, a lot of lock chains...  

It is a deep stack trace.

And unfortunately

a) that diagnostic didn't print the stack pointer value, from which
   we can often work out if we're looking at a stack overflow.

b) I regularly think it would be useful if that stack backtrace were
   to print out the actual stack address, so we could see how much
   stack each function is using.

   I just went in to hack these things up, but the x86 stacktrace
   code which I used to understand has become stupidly complex so I
   gave up.

What tools do we have to diagnose a possible kernel stack overflow? 
There's CONFIG_DEBUG_STACK_USAGE but that's unlikely to be much use.
