Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZBWMU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZBWMU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZBWMUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:20:50 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52285 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753657AbZBWMUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:20:49 -0500
Subject: Re: How to analyze kmemleak message?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
In-Reply-To: <200902232029.HGI04666.FLOOFSVFJtHQMO@I-love.SAKURA.ne.jp>
References: <200902230824.n1N8OV3P015018@www262.sakura.ne.jp>
	 <84144f020902230140v83e153cr3a0c8195aab1b835@mail.gmail.com>
	 <1235385947.14987.41.camel@pc1117.cambridge.arm.com>
	 <200902232029.HGI04666.FLOOFSVFJtHQMO@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 23 Feb 2009 12:20:34 +0000
Message-Id: <1235391634.14987.61.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2009 12:20:42.0200 (UTC) FILETIME=[25298D80:01C995B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 20:29 +0900, Tetsuo Handa wrote:
> Catalin Marinas wrote:
> > This object can no longer be found to be referred by other objects or
> > from the data section, hence it is assumed to be a leak (it could, as
> > well, be a false positive, transient or not).
> Kmemleak scans all data section for addresses returned by kmalloc() etc.
> 
>   void *p1;
>   
>   void foo(void)
>   {
>       void *p2 = kmalloc(1, GFP_KERNEL);
>       p1 = kmalloc(1, GFP_KERNEL);
>   }
> 
> "p1" will be reported by default.

p1 won't be reported as a leak because it is a global variable and the
data section is scanned.

> To report "p2", we need to write "stack=on" to /sys/kernel/debug/kmemleak .

It's the opposite - p2 will be reported as leak by default (stack=off)
unless you enable the stack scanning (stack=on). Note that in the above
case, even if you scan the stacks, once foo() finished the data on the
stack may be overridden by other function calls and p2 will be reported
as a leak.

> > Basically, you need check
> > where the pointer returned by kmalloc/kmem_cache_alloc etc. should be
> > stored and whether it can still be referred from that place (or a
> > different one) later.
> > 
> > Kmemleak tries to avoid the reporting of transient leaks by only
> > reporting objects with a life time of more than 5 seconds.
> kjournald's commit interval (default to 5 sec?) + a few seconds
> might be better. (No reason. Just my feeling.)

I don't think it will make any difference but I may try to increase this
if I get too many transient leaks reported.

> I have a question. My module uses kmalloc(PATH_MAX, GFP_KERNEL) which
> won't be released by kfree(). I count up how many bytes are allocated but
> I don't want kmemleak to report such memory as memory leaks.
> Can I do so by
> 
>   void bar(void)
>   {
>       static void *p;
>       if (!p) {
>           p = kmalloc(PATH_MAX, GFP_KERNEL);
>           kmemleak_not_leak(p);
>       }
>       ...
>   }
> 
> (or kmemleak_ignore() (which one to use and how to use))?

I don't think you need to do anything here. Since p is a static local
variable, isn't it placed in a data section somewhere (and automatically
scanned by kmemleak)?

FYI, kmemleak_ignore() is meant for objects which aren't leaks and which
don't need to be scanned for pointers to other objects (i.e. the code
sections in a module). kmemleak_not_leak() is meant for objects which
are reported as leaks but are known not to be (i.e. the pointer is
stored in a place that kmemleak doesn't scan or the pointer value is
modified before storing or reading) and they should be scanned for
pointers to other objects.

-- 
Catalin

