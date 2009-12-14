Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbZLNXL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbZLNXL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbZLNXL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:11:56 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbZLNXLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:11:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=iao0DEVpMRmQCx4nP87xPKMbUC4Re2YM1oB37QjytESFjzoAaKZac6JR9QON4uDH6
	d1EskbCeB6SbUHNc7wp1w==
MIME-Version: 1.0
Date: Mon, 14 Dec 2009 15:11:47 -0800
Message-ID: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
Subject: RFC: A proposal for power capping through forced idle in the Linux 
	Kernel
From: Salman Qazi <sqazi@google.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Google is implementing power capping, a technology that improves the
power efficiency of data centers. There are also some interesting
applications of this technology for laptops and cell phones.  Google
aims to send most of its Linux technology upstream. So, how can we get
this feature into the mainline kernel?

Overview:

Data centers are typically statically and pessimistically populated
based on the limitations of the power infrastructure in them.  Peak
power consumption of machines is determined, and based on this, the
number of machines and their placement in the hierarchy is limited to
not exceed the available power in the worst case.  Google is looking
at moving away from this static allocation of power to machines, to a
more dynamic model.  A key component of this model is power capping
done in software.

The idea is to place more machines in the data center than there is
power available to support (when all machines are operating at peak)
and then running the machines with a power cap.  The aim of the
project is to utilize more of the available power in the data center
than possible with static provisioning.  As the amount of work
available changes through the day, the power caps on various machines
are changed as well, while staying within the infrastructure
constraints.  Power can be moved from the more idle parts of the data
center to the busier ones.

Since not all of our existing hardware is able to provide good power
measurements to the software running on it, we have decided to model
power in terms of CPU usage [0].

Current Interface used by Google:

The component of the kernel that we have built to implement software
power capping is called the "Idle Cycle Injector".

It has the following inputs, provided through procfs:

Forced Idle Percentage: This is the minimum percentage of time the CPU
is promised to be idle over the enforcement interval.

Enforcement interval: This is the length of time over which the power
cap is promised.

Aside from this, every cgroup has a new quantity added to the CPU
component called "Power Capping Priority".  This quantity indicates
the order in which the scheduler attributes the time spent injecting
idle cycles to specific processes.  This allows us to discriminate
among processes when it comes to accounting for the injected idle
time.  There is also an indication of interactivity versus batch for
the cgroup provided in the CPU component of the cgroup.

Basic Algorithm:

Rather than blindly blasting the machine with the minimum required
idle cycles, our implementation keeps track of naturally occurring
idle cycles as follows:

0.  Set a timer (hrtimer API is used) for the earliest of: the end of
the enforcement interval (clock time constraint) and the expected time
when we run out of allowed busy cycles if the CPU was entirely busy
from now on (cpu time constraint).
1.  When this timer expires, determine which constraint has been reached.
          a) If it is the clock time constraint, then we must start
with a new interval and go back to step 0.
          b) If it is the CPU time constraint, then rest of the
enforcement interval must be spent idling.
              Continue to step 2.
2.  Set up a timer for the end of the enforcement interval and start
calling the idle function in a loop.   In our current implementation
we wake up a real time kernel thread to do this.  Once finished,
account any injected idle time in the vruntime of processes taken in
the order of power capping priority.  Finally, go back to step 0 and
start a new interval.

Eager Injection:

An interactive task may be prevented from running sufficiently early
by presence of a batch task and end up wanting to run in the capped
portion of the interval.  But, since it cannot run in the capped
portion, it sees a severe latency hiccup.  To counter this, we
discriminate between the two classes through the concept of eager
injection.  The idea is that while we are below our desired minimum
idle quota, we do not let batch tasks run, but instead idle the CPU.
However, during this time, we let interactive tasks run (should it
happen to be runnable).  Once we are past the minimum idle quota,
everyone is free to run.  If the interactive tasks are abusive and
exhaust the CPU time, then idle cycles have to be injected to avoid
exceeding the quota.

Known Limitations of Current Implementation:

0.  The major limitation of injecting in the thread context is that we
cannot prevent soft IRQ handlers from running and using up power.

1.  Sufficiently high forced idle percentages, the Idle Cycle Injector
starts working against itself.  In such cases, it is better to use
other means to make the CPU idle.

2.  Needs some work for SMT support.


Why not use voltage and frequency scaling?

Forced Idle Injection is more effective[1] and more widely available.
Even with voltage and frequency scaling, interpolation is needed
between the available settings.  So, if we did use voltage and
frequency scaling, we would still have to use a timer to take
measurements every so often and adjust the settings.  It would save us
on having to take over the CPU and actively inject though.

Application to Laptops and Cellphones:

Imagine being in a tent in Death Valley with a laptop.  You are bored,
and you want to watch a movie.  However, you also want to do your best
to make the battery last and watch as much of the movie as possible.
Forced idle power capping is a solution.  If your machine has a knob
that allows you to control the available power, you can turn that knob
until your video starts getting choppy.  And then, turn the knob back
a little bit.  Now, you have your video playing just as you like it,
with the minimal amount of power available to the machine.  With eager
injection and the power capping priority, your machine should spend
power on work that you care about, rather than background processes.

What does this have to do with mainline Linux?

We'd like to get as much of our stuff upstream as we can.  Given that
this is a somewhat sizable chunk of work, it would be impolite of me
to just send out a bunch of patches without hearing the concerns of
the community.  What are your thoughts on our design and what do we
need to change to get this to be more acceptable to the community?  I
also would like to know if there are any existing pieces of
infrastructure that this can utilize.

Relevant papers:

[0]. http://research.google.com/pubs/pub32980.html
[1]. http://www.cs.cmu.edu/~anshulg/weed2009.pdf
[2]. http://www.springerlink.com/index/D6287205272LK822.pdf

Regards,

Salman Qazi.
