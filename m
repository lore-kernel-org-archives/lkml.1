Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0BSMRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:17:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59370 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0BSMRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:17:40 -0500
Date: Fri, 19 Feb 2010 13:17:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
	on PCI
Message-ID: <20100219121734.GA8300@basil.fritz.box>
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com> <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I would appreciate if you could read the whole email
and ideally the references too before replying. I apologize for the length,
but this is a complicated topic.

> and integrate it
> into perf as the suitable event logging mechanism.

The main reason I didn't react to that proposal is
I don't see a clear path to make perf a good error mechanism.

I know there's a tendency that if you're working on something
that you think is cool, to try to force everything else
you're seeing into that model too (I occasionally have such tendencies
too :-) 

But if you take a step back and look at the requirements with a sceptical
eye that's not always the best thing to do.

Requirements for error handling are very different from performance monitoring.

Let me walk you through some of these differences:

USER TOOLS:

The current perf user tools are not suitable for errors: they are not
"always on running in the background" like you need for errors.

They are aimed at a interactive user model which is fine
for performance monitoring (well at least some forms of performance
monitoring), but not for errors.
 
Yes they could be probably reworked for a "always on" daemon model, but the 
result would be

a) completely different than what you have today in terms of interface
(it would be a lot more like you have with oprofile, and as I understand
one of the main motivations for perf was wide spread dislike of the oprofile
daemon model)
b) likely worse for performance monitoring (unless you fork them into two)
The requirements are simply very different.
c) a lot like what mcelog is today. mcelog today is a always on 
error daemon optimized for error handling, nothing else.

There's no associated error oriented infrastructure like triggers etc.
in perf Yes that could be all implemented, but (b) and (c) above apply.

So yes it could be probably done, but I suspect the result would
not make you happy for performance monitoring.

EVENT INTERFACE I:

The perf interface is aimed at a specific way of filtering events, which 
is not the right interface for errors, because you need usually 
all errors in most (not all) cases. Basically in performance
monitoring typically most events are off and you sometimes
turn them on, in error handling it's exactly the other way around.

Also errors tend to have different behavior from performance
counters, for example a model for a error on a object
is more the "leaky bucket", which is not a good fit for performance.

(I have more details on this in http://halobates.de/plumbers-error.pdf)

OVERHEAD:

The perf subsystem has relatively high overhead today (in terms
of memory size and code size overhead) and is IMHO not suitable
to be always active because of this. 

Errors are very fundamental and error reporting
mechanisms have to be always active, so it's extremely important
that they have very low overhead by default. That's not what
perf's model is: it trades memory size and code size for more
performance. That is fine for optional monitoring (if you
can afford it), but not the right model for an fundamental
"always on" mechanism. For "always on" infrastructure it's better
to be slim.

That said I suspect perf events could be likely put on a serious diet, but it's
unclear if the result would work as well as it does today 
for performance monitoring. You would likely lose some features
optimized for it at least.

EVENT INTERFACE II:

Partly that's because it has a lot of functionality that are not needed 
for errors anyways.  For example error just needs some very simple error 
buffers that can be straight forwardly implemented using kfifos (I did
that already in fact). That's just a few lines, all the functionality
in kernel/perf/* is not really needed.

There's no good way to throttle events per source, like it's needed
for errors.

EVENT INTERFACE III:

Then one of the current issues with mcelog is that it's not straight forward
to add variable length record types with typing etc. This isn't too
big a problem for MCEs (although the DIMM error reporting would have been
slightly nicer with it) but for some other types of errors it's a bigger
issue.

Now the funny thing is (and I keep waiting for Ingo to figure that out :-): 
the perf record format has exactly the same problem as mcelog in this regard. 
It's a untyped binary format where it's only possible to add something
at the end, not a fully extensible typed format with sub records etc. 
 
A better match would be either netlink with its sub record
(although for various reasons other I don't think it's the best model either) 
or the ASCII based udev sysfs interfaces.

In fact that is what Ingo asked for some time ago (before he
moved to the "everything must be perf" model). He wanted an ASCII
interface (so more like the udev model).  I'm not completely happy with 
that either, but it's probably still one of the better models and could be made
to work. 

It's definitely not perf though.

> year. You are refusing to work with other people on a well designed

First I work with a lot of people on error handling, even if you're
not always in Cc.

We would need to agree to disagree on EDAC being a "well designed
solution) IMHO it has a lot of problems (not just in my opinion
if you read some of the mails e.g. from Borislav he's stating the same)
and it's definitely not the general frame work you're asking for 
In fact in many ways EDAC far more specialized to some specific subset of 
errors than mcelog.

A generic error frame work (that would be neither EDAC nor perf nor
mcelog on the interface level) could be probably done and I have 
some ideas on how to do that properly (e.g. see the link below), 
but it's not a short term project. It needs a lot of design
work to be done properly and also would likely need to evolve
for some time. It would also need a suitable user level infrastructure,
which is actually a larger project than the kernel interfaces.

The patch above was simply intended to solve a specific problem on a specific 
chip.  I don't claim the interface is the best I ever did (definitely not), 
but at least it solves an existing problem in a relatively straight forward
way and I claim there's no clear better solution with today's infrastructure.

How are you suggesting to solve the DIMM error reporting in the short
term (let's say 2.6.34/35 time frame, without major redesigns) ?

-Andi

References:
- Thoughts on future error handling model:
http://halobates.de/plumbers-error.pdf
- mcelog kernel and userland design today:
http://halobates.de/mce-lc09-2.pdf

-- 
ak@linux.intel.com -- Speaking for myself only.
