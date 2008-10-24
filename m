Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYJXAQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYJXAQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYJXAQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:16:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33965 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbYJXAQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:16:28 -0400
Date: Thu, 23 Oct 2008 20:16:26 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: systemtap@sources.redhat.com, linux-kernel@vger.kernel.org
Subject: notes for linux plumbers conference talk on systemtap
Message-ID: <20081024001626.GI3277@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

Several folks asked for some written notes for the brief talk we gave
at the linux plumbers conference, tracing "miniconf", a month ago.
Here are the questions as listed in the abstract, plus some answers.



    We will cover usage issues:

    * Who needs and uses this type of tool?

Any user who needs debugger-level but non-intrusive introspection of
kernel- and/or user-space code.  The phrase "debugger-level" means
several things:
- Identifying arbitrary points of interest in code by several means,
  up to source-code-level information.
- Identifying arbitrary data of interest at each point, up to
  source-code-level variables/expressions.
- Generating high-quality backtraces.
- And doing this dynamically on a live running machine.

Someone who needs more data from the kernel- or user-space
applications than their built-in diagnostics happen to provide.

Someone who needs to integrate the tracing/probing data from multiple
separate sources, including preexisting hooks and simple tracing
mechanisms.

Someone who needs a tool to take action "in situ", beyond just dumping
raw data to userspace: from calculating statistics and reports, up to
manipulating live state.

Solaris etc. users with dtrace experience.


    * What essential requirements exist?

Other than meeting the needs above, ...

It needs to be reliable so it doesn't crash the machine.  (We are
working on characterizing the causes for the occasional crashes we do
see.)

It needs to be non-intrusive, so heisenbugs are not created nor
destroyed, and performance measurements are not grossly distorted by
probe effect.

It needs to be easy to install.  Among other things, this means that
it must not have unreasonable prerequisites, like patching your kernel
or compiler.  It must work on multiple distributions.  (There exist
uncomfortable prequisites such as installing debugging information and
a compiler, but we're working on easing that pain.)

It needs to be easy to use.  Among other things, this means that it
must not require reboots to gather data; it must support many
concurrent users/sessions, each doing their thing.  (There exist
unfortunate requirements to run the tool as "root", but we're working
on that too.)


    * How to use it (a brief tutorial)?

This has been covered in many venues.  See
<http://sourceware.org/systemtap/wiki>.  

The gist of it is a compact scripting language that names abstract
events ("function X has returned within kernel module Y", "statement
foo.c:222 in program /bin/ls has run", "profiling timer interrupt",
"marker Z fired").  Then one attaches handlers ("compute average of
local variable A", "print all function parameters", "trace values B,
C, D in a packed binary form", "enumerate shared libraries within that
stack traceback") with each.

An arbitrary collection of such events and handlers may be listed in a
single script to perform an integrated analysis.  All this is
expressed in a little scripting language program that systemtap runs
against a live system.


    * What are its current features and limitations?

Support of kernel versions 2.6.13ish and up.

Support of kernel-space symbolic probing (dependent on
CONFIG_KPROBES).

Support of user-space symbolic probing (limited to some kernel
versions, dependent on presence of utrace and uprobes code).

Interfacing to trace_mark() kernel markers.

Cross- and remote-compilation of instrumentation.

Some mildly outdated generalities in
<http://sourceware.org/systemtap/wiki/SystemtapDtraceComparison>.

There are a number of limitations, some of them deliberately imposed
upon the script program in order to minimize safety concerns.


    We will attempt to explain and justify a variety of design decisions:

    * Why does it run instrumentation inside the kernel?

Performing kernel instrumentation in user space is obviously
impractical.  Running user instrumentation in user space may sound
initially appealing, but it doesn't appear possible to function with
sufficient capability, performance, and non-intrusiveness.


    * Why is this done by compiling kernel modules?

Because other options were not available.  The reasoning goes
something like this:
(a) We need a richly programmable engine to pull out arbitrary data
and perform arbitrary computations specified at system run time.
(b) Upstream linux has repeatedly vetoed the inclusion of something
like a bytecode interpreter.
(c) So we have to generate native code and load it on the fly.


    * Why is it out-of-tree?

Some of this is expediency, some of it novelty.  Systemtap is unique
amongst software in the linux area in that it dynamically generates
kernel modules.  These modules are not like filesystems or device
drivers, with a fixed body of code that naturally lives with its peers
in the kernel tree.  Rather, except for some common boilerplate
runtime code that we ship with systemtap, the C source code itself is
created anew each time.

So, what could go into the main linux tree?  Some of tha boilerplate
code could move over.  A piece would be a good candidate if (a) it
could provide kernel services of such usefulness that it would have
non-systemtap uses, and/or (b) it represented code that is so fragile
and so coupled to particular kernel versions that offloading its
maintanance to lkml would help a great deal.  It turns out that there
is some, but not that much code in either of these two classes.


    We will discuss ways in which the community could work together
    better, and finally bridge the instrumentation feature gap:

    * How could linux kernel maintainers help?

As discussed at the 2008 kernel summit and well before, the most
broad, direct, and lasting contribution would be to add comprehensive
static markup to the mainline kernel, in the form of markers or
tracepoints or some analogous facility.  Progress from lttng and
several other groups needs to be nurtured.

We have specifically *not* asked for any systemtap-specific support
code in the kernel.  All of our interfacing to the kernel goes through
official module APIs.  New APIs that we have expressed support for
always have some non-systemtap use case, in order to appeal to those
who do not wish to assist/rely on systemtap.

We continue to remind future instrumentation/tracing type kernel
facilities to also provide module-facing kernel APIs so that people
can use the code via systemtap (as well as whatever native interfaces
the developer deem appropriate).


    * How to motivate the community to help?

This is an ongoing challenge, and we are looking for advice on this.
We are making some improvements to the systemtap workflow to make it
more immediately usable by kernel developers.


    * How do other tracing projects relate?

It is not hard to see how many of the requirements listed above cannot
be met by other linux facilities.  In some ways, they go beyond dtrace
too.

With respect to kprobes, we have been a consumer of kprobe events
since the beginning, as it is the most low-level way of inserting
probes into arbitrary spots in the kernel.  (Corresponding user-space
APIs - utrace and uprobes - are on their way upstream, and their
prototypes underlie our user-space probing support.)

With respect to markers, we have been a consumer since the beginning,
including presenting parameter values.

With respect to tracepoints, we have started sketching out a design
for interfacing directly to these.  Using kernel-resident hard-coded
"conversion modules" that expose tracepoints as markers works today.

With respect to lttng, we are happy to exist in parallel, sharing the
instrumentation hooks and perhaps more.  lttng is designed for bulk
trace data transfer to userspace, where it may be analyzed with
sophisticated viewing tools.  Chances are that systemtap users will
eventually want to generate data for consumption by that same lttv.

With respect to ftrace, several of its individual compiled-in "tracing
engines" compute interesting reports.  The kernel side of latencytop
is another example of this sort of thing.  Each one corresponds
conceptually to one systemtap script (often a short one).  So, there
is not much there for us interface with; rather, being "siblings" by
piggybacking on the same event/data sources can work.

With respect to dyn-ftrace, we hope to interface to that as an event
source, so that systemtap users can intercept selected kernel function
entries using this relatively efficient mechanism (as compared to
kprobes).

With respect to the current lkml efforts on unifying trace buffers, as
discussed at summit and at LPC, systemtap would happily use it, both
as a data sink *and* source.  The easy side of that is that systemtap
scripts should be able to print data to such buffers, as we already do
to relayfs and in-core flight-recorder buffers and others.  The hard
side is that systemtap-consumable callbacks should be generated when
some other kernel piece sends data to their trace buffer.  There was
agreement on this at LPC but details have not yet started to be worked
out.

With respect to oprofile / perfmon, we hope to become an in-kernel
consumer of hardware performance counter (overflow) event data,
assuming a proper in-kernel management API is included.  This could
allow systemtap scripts to supplant the old oprofile text user
interfaces.


It is gratifying to see the instrumentation topic finally becoming
mainstream, and code flowing aplenty.  It is not our intent to
displace kernel tracing-related code.  Their self-sufficiency
(control/data access via /debug files) is attractive and enough many
simple uses.

Systemtap can scale "down" to that too, but it is also designed to
fill in the considerable functionality gap between such single-purpose
kernel-tracing and a general system-wide probing/analysis a la dtrace
and beyond.  It would be a disservice to the wider linux community to
imagine away the existence or importance of this gap.

 
    * What possibilities exist for merging / interfacing code?

As mentioned above re. "why is it out-of-tree?", some of the
boilerplate runtime code could be merged into the kernel proper.

There was less but >0 enthusiasm for shipping systemtap "tapset"
scripts that map markers or kprobes or whatnot to higher-level
synthetic events.  These are most useful & necessary for subsystems
whose maintainers have opted not to build in useful instrumentation.

As mentioned immediately above re. "other tracing projects", we
already interface to a variety of tracing-related subsystems, and
would like to do more.

