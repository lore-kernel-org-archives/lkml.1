Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYDRHcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYDRHcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYDRHcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:32:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYDRHcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:32:47 -0400
Date: Fri, 18 Apr 2008 00:32:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <bhutchings@solarflare.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] Add default CPU topology information
Message-Id: <20080418003217.94e25f2f.akpm@linux-foundation.org>
In-Reply-To: <20080418001024.7377c52d.akpm@linux-foundation.org>
References: <20080331114412.GH21637@solarflare.com>
	<20080418001024.7377c52d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 00:10:24 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 31 Mar 2008 12:44:13 +0100 Ben Hutchings <bhutchings@solarflare.com> wrote:
> 
> > Not all architectures and configurations define CPU topology information.
> > This can result in an empty topology directory in sysfs, and requires
> > in-kernel users to protect all uses with #ifdef - see
> > <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> > 
> > The documentation of CPU topology specifies what the defaults should be
> > if only partial information is available from the hardware.  So we can
> > provide these defaults as a fallback.
> > 
> > This patch:
> > 
> > - Adds default definitions of the 4 topology macros to
> >   include/asm-generic/topology.h.
> > - Changes include/asm-*/topology.h to include <asm-generic/topology.h>
> >   unconditionally.
> > - Changes drivers/base/topology.c to use the topology macros unconditionally
> >   and to cope with definitions that aren't lvalues.
> > - Updates documentation accordingly.
> 
> I get a huuuuuuuge crash early in boot on the t61p dual x86_64 laptop. 
> Before netconsole has started and it has no serial port, so all I have is a
> partially-scrolled-off jpg, sorry.
> 
> I'll drop the patch.
> 
> http://userweb.kernel.org/~akpm/p4175278.jpg
> http://userweb.kernel.org/~akpm/config-t61p.txt
> http://userweb.kernel.org/~akpm/dmesg-t61p.txt
> 
> 
> If I didn't have all that wrong crap on the stack we'd have a full
> trace here.  I have CONFIG_FRAME_POINTER=y, but that doesn't seem to
> have helped.
> 

ooh, I just discovered kstack=.  That should be hoisted up to core kernel
then pushed out to other architectures, not hidden in x86_64 code.

But first I guess it should be make to work - it fails miserably, because
only one of our seventy fix stack-dumping functions actually looks at it.


This:

--- a/arch/x86/kernel/traps_64.c~a
+++ a/arch/x86/kernel/traps_64.c
@@ -426,7 +426,7 @@ _show_stack(struct task_struct *tsk, str
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
-	show_trace(tsk, regs, sp, bp);
+//	show_trace(tsk, regs, sp, bp);
 }
 
 void show_stack(struct task_struct *tsk, unsigned long * sp)


works heaps better.

Here's the rest of your oops: http://userweb.kernel.org/~akpm/p4175279.jpg

I'd be suspecting startup ordering problems - maybe the page allocator
isn't ready yet.

otoh, it _should_ be ready by the time we run init_sched_domains().

