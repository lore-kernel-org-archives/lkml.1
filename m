Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbXCEUFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbXCEUFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXCEUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:05:46 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:62416 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbXCEUFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:05:45 -0500
Date: Mon, 5 Mar 2007 12:05:23 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, tony.luck@intel.com
Subject: Re: debug registers and fork
Message-ID: <20070305200523.GB9468@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070226235154.GB19630@frankl.hpl.hp.com> <200703051825.16473.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703051825.16473.ak@suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Mon, Mar 05, 2007 at 06:25:16PM +0100, Andi Kleen wrote:
> On Tuesday 27 February 2007 00:51, Stephane Eranian wrote:
> > 
> > I have come across an issue with a monitoring using the
> > hardware debug registers on ia64/i386/x86-64.
> > 
> > It seems that the way debug registers are inherited across fork
> > differs between ia-64 and i386/x86-64. On ia-64, the debug registers
> > are NEVER inherited in the child. The copy_thread() routine clears
> > the necessary thread flags to avoid reloading the debug registers in
> > the child.
> > 
> > Now, on x86-64, it appears that the TIF_DEBUG flag is inherited via
> > setup_thread_stack(). By virtue of dup_task_struct() the debug registers
> > get copied into the child task on fork. So the child has active breakpoints,
> > unless I am mistaken somewhere.
> > 
> > Given the way the ptrace() interface works, I would tend to
> > think that the ia-64 way is the correct one. Any comment?
> 
> IA64 is probably correct, but changing this might break existing programs.

This could only break programs using the hardware debug registers and following
across clone.

> Would that be worth the change? What advantage would you have from it.
> 
It would be nice to have a uniform behavior across architectures on this.
this is purely on OS policy descision. As I said, there is enough support
in ptrace (and probably in utrace) to catch the clone event and setup the
breakpoints in the new task if requested.

The reason I detected this is because the pfmon tool was entering some
infinite loop on SIGTRAP searching for breakpoints it had not set on a
child process. The pfmon tool was designed on IA-64, so it did not assume
breakpoints were systematically inherited quite the contrary as it provides
an option to explicitely inherit them.

> > Furthermore, on i386/x86-64, when switching out from a task with TIF_DEBUG
> > enabled to another which does not, it seems we do not clear the debug
> > registers (at least dr7) so they become inactive.
> 
> You mean they leak? Perhaps they should be cleared.
> 
Well, a ptrace expert pointed out to me that there is a controlled
leak to the next thread. That leak is terminated in traps.c by noticing
that you get a breakpoint trap but in a task which has debugreg[7]=0.
In that case, the kernel simply clears dr7 to shut down any subsequent
breakpoint traps. That kind of lazy stop, saves having to clear dr7 in
__switch_to() when switching from a task using the debug registers to
one which does not. i still have to convince myself this works in all cases,
especially if that task suddenly starts using the debug registers and program
the other debug registers BEFORE dr7 (assuming it was zero).

-- 
-Stephane
