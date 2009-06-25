Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZFYNZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZFYNZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbZFYNZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:25:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60026 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbZFYNZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:25:08 -0400
Subject: Re: Infrastructure for tracking driver performance events
From: Mark Wielaard <mjw@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org,
       "Stone, Joshua I" <joshua.i.stone@intel.com>,
       Rober Richter <robert.richter@amd.com>, anil.s.keshavamurthy@intel.com,
       ananth@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com,
       SystemTap <systemtap@sources.redhat.com>, Eric Anholt <eric@anholt.net>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       intel-gfx@lists.freedesktop.org
In-Reply-To: <alpine.DEB.2.00.0906241549170.15398@gandalf.stny.rr.com>
References: <20090624172912.GB5565@ben-laptop>
	 <alpine.DEB.2.00.0906241549170.15398@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 15:24:39 +0200
Message-Id: <1245936279.2677.11.camel@hermans.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-06-25 at 08:55 -0400, Steven Rostedt wrote:
> On Wed, 24 Jun 2009, Ben Gamari wrote:
> > 3) A large amount of usermode support is necessary (which will likely be
> >    the case for any option; listed here for completeness)
> > 
> > Another option seems to be systemtap. It has already been documented[3]
> > that this option could provide both user-mode and kernel-mode
> > backtraces. The driver could provide a kernel marker at every potential
> > wait point (or a single marker in a function called at each wait point,
> > for that matter) which would be picked up by systemtap and processed in
> > usermode, calling ptrace to acquire a usermode backtrace. This approach
> > seems slightly cleaner as it doesn't require the tracing on the entire
> > machine to catch what should be reasonably rare events (hopefully).
> 
> Enabling the userstacktrace will give userspace stack traces at event
> trace points. The thing is that the userspace utility must be built with 
> frame pointers.

This isn't true for Systemtap. It can unwind through anything since it
contains a dwarf-unwinder that can do backtraces as long as unwind
tables are available for the modules (executables, vdso, shared
libraries, etc.) one wants to unwind through. Systemtap currently gets
these in its "translation" phase and you do need to list them explicitly
atm. There is work underway to make this more flexible and automatic.
Also cross kernel-user-space backtraces need some work (systemtap can
use the dwarf unwinder also in-kernel, but some kernel parts are missing
unwind tables).

Some systemtap bugs to track if you are interested in extending this
functionality:

= Prerequirements for more ubiquitous backtracing
sw#6961 backtrace from non-pt_regs probe context
http://sourceware.org/bugzilla/show_bug.cgi?id=6961
sw#10080 track vdso for process symbols/backtrace
http://sourceware.org/bugzilla/show_bug.cgi?id=10080
sw#10208 Support probing glibc synthesized syscall wrappers
http://sourceware.org/bugzilla/show_bug.cgi?id=10208

NOTE: the above still won't make cross kernel-to-userspace backtracing
fully work since we cannot easily unwind through the kernel-entry/exit
assembly code that doesn't have dwarf unwind tables.

= Make user backtraces more convenient
sw#10228 Add more vma-tracking for user space symbol/backtraces
http://sourceware.org/bugzilla/show_bug.cgi?id=10228
sw#6580 revamp backtrace-related tapset functions
http://sourceware.org/bugzilla/show_bug.cgi?id=6580

Cheers,

Mark

