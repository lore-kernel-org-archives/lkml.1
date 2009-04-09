Return-Path: <linux-kernel-owner+w=401wt.eu-S936413AbZDIUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936413AbZDIUur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936772AbZDIUue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:50:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55985 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S936684AbZDIUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:50:33 -0400
Date: Thu, 9 Apr 2009 16:50:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
In-Reply-To: <20090407082224.GA22500@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0904091634150.4094-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, K.Prasad wrote:

> A slight change though...writes to DR0-DR3 may fail if the address is
> invalid. This behaviour is true even in existing implementation of
> ptrace_set_debugreg().

That's okay.

> > > 
> > > 	/* Lazy debug register switching */
> > > 	if (per_cpu(last_debugged_task, get_cpu()) != current) {
> > > 		switch_to_none_hw_breakpoint();
> > > 		put_cpu_no_resched();
> > > 	}
> > 
> > I just noticed that the lines saving DR7 and setting it to 0 need to
> > come here.  Otherwise switch_to_none_hw_breakpoint() might set DR7 back
> > to a nonzero value, and it might not match the value stored in dr7.
> > 
> 
> arch_uninstall_thread_hw_breakpoint()<--switch_to_none_hw_breakpoint()
> will store 'kdr7' (which contains all kernel-space breakpoints in
> encoded format) to DR7 physical register. Given that the current()
> process should not have TIF_DEBUG() set (if it were set,
> switch_to_thread_hw_breakpoint() would have been invoked to set
> last_debugged_task), we will wipe out all user-space breakpoints and
> store only kdr7.

No, you don't understand.  The code looks like this:

> +	get_debugreg(dr7, 7);
> +
> +	/* Disable breakpoints during exception handling */
> +	set_debugreg(0UL, 7);
...
> +	/* Lazy debug register switching */
> +	if (per_cpu(last_debugged_task, get_cpu()) != current) {
> +		switch_to_none_hw_breakpoint();
> +		put_cpu_no_resched();
> +	}
...
> +	set_debugreg(dr7, 7);
> +	return rc;

The first few lines will set dr7 to a value which includes the user
breakpoints and will set DR7 to 0.  The next few lines will set DR7 to
kdr7, which might be non-zero.  This is wrong; we need DR7 to be 0.  
Then the second-to-last line will set DR7 back to dr7, which is also
wrong -- it should be set to kdr7.

> > For each breakpoint where we decide it's a case of lazy DR switching or
> > we invoke a "triggered" callback, the corresponding bit in dr6 should
> > be cleared.  This is a way of indicating to do_debug() that the handler 
> > has taken care of these causes of the exception.
> > 
> > Similarly, the kprobe routine should clear the single-step bit in dr6 
> > when it handles a single-step exception.  When the notifier chain 
> > completes, the only bits remaining in dr6 should be for events that 
> > still need to be handled.
> > 
> > Alan Stern
> >
> 
> This does sound like good design, but unfortunately there are pieces in
> do_debug() which rely upon bits in dr6 being set even after the actual
> breakpoint is handled (the get_si_code() is one such example).

If necessary, do_debug() can keep two copies of dr6: the original 
version read from DR6 and the version modified by the notification 
handlers.

> Do we go about changing them to use thread->debugreg6 instead of dr6? If
> yes, wouldn't that be better done outside the HW Breakpoint patches as a
> part of some cleanup initiative?

Should they use thread->debugreg6?  If they should, then change them.  
And no, the change should not be in a separate patch; it should be part 
of your series.  Otherwise there would be intermediate kernels that 
behaved incorrectly.

Alan Stern



