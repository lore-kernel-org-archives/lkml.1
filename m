Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbZFXR3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbZFXR3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZFXR3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:29:18 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:55113 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZFXR3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=JHJREr51qy0uD736dCMOKmrcRIQ0CU0XBSE16BLzOzNnK0kyb+J2n+ifLa2fQoMojB
         hSApnyqNioheNboTCJZkQ4TNWYTs7qKB6OO2cZj1muks0TC5uncaNrPVnL6B2wII1DIN
         +v9L7c/CZiKNvdPRoch4ugbIki1U0wnuhFdIk=
Date: Wed, 24 Jun 2009 13:29:12 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Stone, Joshua I" <joshua.i.stone@intel.com>,
       Rober Richter <robert.richter@amd.com>, anil.s.keshavamurthy@intel.com,
       ananth@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com
Cc: SystemTap <systemtap@sources.redhat.com>, Eric Anholt <eric@anholt.net>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       intel-gfx@lists.freedesktop.org
Subject: Infrastructure for tracking driver performance events
Message-ID: <20090624172912.GB5565@ben-laptop>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	"Stone, Joshua I" <joshua.i.stone@intel.com>,
	Rober Richter <robert.richter@amd.com>,
	anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
	davem@davemloft.net, mhiramat@redhat.com,
	SystemTap <systemtap@sources.redhat.com>,
	Eric Anholt <eric@anholt.net>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I apologize profusely to those of you who recieve this twice. Sorry about that]


Hey all,

Now since GEM has been implemented and is beginning to stabilize for the
Intel graphics driver, work has begun on trying to optimize the driver
and its usage of the hardware. While finding cpu-bound operations can be
easily done with a profiler, identifying GPU stalls has been
substantially more difficult.

One class of GPU stalls that can be easily identified occurs when the
driver needs to wait for the GPU to complete some work before proceeding
(waiting for the chip to free a hardware resource --- e.g. a fence
register for configuring tiling --- or complete some other type of
transaction --- e.g. flush caches). In order to debug these stalls, it is
useful to know both what is causing the stall (i.e. call path) and why
the driver had to wait (e.g. waiting for GEM domain change, waiting for
fence, waiting for cache flush, etc.)

I recently wrote a very simple patch to add accounting for these types
of stalls to the i915 driver[1], exposing a list of wait-event counts to
userspace through debugfs. While this is useful for giving a general
overview of the drivers' performance, it does very little to expose
individual bottlenecks in the driver or userland components. It has been
suggested[2] that this wait-event tracking functionality would be far more
useful if we could provide stack backtraces all the way into user space
for each wait event.

I am investigating how this might be accomplished with existing kernel
infrastructure. At first, ftrace looked like a promising option, as the
sysprof profiler is driven by ftrace and provides exactly the type of
full system backtraces we need. We could probably even accomplish an
approximation of our desired result by calling a function when we begin
and another when we end waiting and using a script to look for these
events. I haven't looked into how we could get a usermode trace with
this approach, but it seems possible as sysprof already does it.

While this approach would work, it has a few shortcomings:
1) Function graph tracing must be enabled on the entire machine to debug
   stalls
2) It is difficult to extract the kernel mode callgraph with no natural
   way to capture the usermode callgraph
3) A large amount of usermode support is necessary (which will likely be
   the case for any option; listed here for completeness)

Another option seems to be systemtap. It has already been documented[3]
that this option could provide both user-mode and kernel-mode
backtraces. The driver could provide a kernel marker at every potential
wait point (or a single marker in a function called at each wait point,
for that matter) which would be picked up by systemtap and processed in
usermode, calling ptrace to acquire a usermode backtrace. This approach
seems slightly cleaner as it doesn't require the tracing on the entire
machine to catch what should be reasonably rare events (hopefully).

Unfortunately, the systemtap approach described in [3] requires that
each process have an associated "driver" process to get a usermode
backtrace. It would be nice to avoid this requirement as there are
generally far more gpu clients than just the X server (i.e. direct
rendering clients) and tracking them all could get tricky.

These are the two options I have seen thusfar. It seems like getting
this sort of information will be increasingly important as more and more
drivers move into kernel-space and it is likely that the intel
implementation will be a model for future drivers, so it would be nice
to implement it correctly the first time. Does anyone see an option
which I have missed?  Are there any thoughts on any new generic services
that the kernel might provide that might make this task easier? Any
comments, questions, or complaints would be greatly appreciated.

Thanks,

- Ben


[1] http://lists.freedesktop.org/archives/intel-gfx/2009-June/002938.html
[2] http://lists.freedesktop.org/archives/intel-gfx/2009-June/002979.html
[3] http://sourceware.org/ml/systemtap/2006-q4/msg00198.html

