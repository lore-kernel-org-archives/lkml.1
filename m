Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408Ab0ANBp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0ANBp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197Ab0ANBp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:45:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:36442 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab0ANBp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:45:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=N2w/hH+AE8qhNvsY0LStYw/lvpCHIvy99Wi0WJNkJCz2lnHmR+Slnrp2E4No4RCavw
         L1d1S2v9JbROCqW/SRq0mJVea0iMUWj0db6Cp4ahzmyAESmm+K+30Bw3iVa0Z/oNBw+/
         B11ror7LkUBNYlOK4J8OQO9A/Utvj81Dz7VPI=
MIME-Version: 1.0
Date: Wed, 13 Jan 2010 17:45:55 -0800
Message-ID: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
Subject: HW breakpoints perf_events request
From: Joshua Pincus <joshua.pincus@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a request for an additional feature to be included
in the recent hardware breakpoints work soon to be delivered
in kernel 2.6.33.

Frederic Weisbecker, Prasad Krishnan and I have shared an ongoing
private discussion on this topic.  Frederic recommended that we take
the discussion to a wider audience.  Hence this email.  I would like
to thank both
of those two engineers for their patience, quick response,
and help in this process.  They've been stellar.

I work for a company which would like to make heavy use
of the new HW breakpoints perf_event work.  Essentially,
we need to be able to do the following:

1) When executed, a user-land application must be able to program 4
pinned hardware
breakpoint registers.  I need 1 byte granularity (address length
specificity) and the ability
to set RWX event triggers.

2) All calls to clone() or fork() will propagate the
debug register settings from parent to child(ren).

3) When a breakpoint is triggered, the application
thread currently running which triggered the breakpoint
immediately stops execution and is sent a SIGTRAP.

4) The thread transitions from the PC that triggered the breakpoint to
the signal handler for SIGTRAP.

5) The signal handler does some work.  (This "work" is outside the
scope of my request, but you may have some insights.  I need to be
able to change the PC and nPC for the thread that triggered a
breakpoint such that when it
returns from the signal handler it doesn't return to the instruction
that triggered the breakpoint but to the one after it.  If I were
using ptrace(8), I would just have the parent
process use the ptrace(8) syscall to modify the PC and
nPC of the child.  I'm not using ptrace(8).)

6) The signal handler returns and the thread returns to normal
execution at the new
PC and nPC.

>From my discussions with Frederic and Prasad, I know
that requirements (1) and (2), as described above,
are already being met by the current work.  I can use
the perf_event_attr structure and the perf_event syscall
to program breakpoints for a thread in exactly
the way I've specified AND be able to have debug
settings inherited from parent to child in the case of a
fork() or clone().

However, there's nothing yet in place to allow a
signal to be sent to the thread when a breakpoint
has been hit.  Put another way, there's nothing here
which affects execution flow of the user-app when the CPU
traps due to a HW breakpoint.

Currently, the perf events infrastructure allows me
to mmap() a block of memory and to poll() on it, waiting
and watching for events to be described in that mmap'd
buffer.  That will not be sufficient for what we need
to do.  We need to have the ability to specify that
execution of the thread should be interrupted, just as it
would under ptrace(), and have a signal be delivered.
Delivery of the signal must be received and processed
by the application before the thread will be allowed to
proceed to the nPC after the PC which caused the
HW breakpoint event.

Is this possible?  Can we architect this feature into
the perf_events infrastructure?

At first glance, it would seem that this is a fairly
easy thing to do.  Right now, these same HW breakpoints
triggers under ptrace() merely call a previously registered
user handler which modifies the debug registers to
record the event and to propagate a signal to the child
process being traced.  We want to do something similar
w/o using ptrace.  Perhaps it is as simple as providing a
perf_event_attr setting which indicates that SIGTRAP signals
should be sent to the thread which triggered the breakpoint
exception.

Thanks in advance for your help,
JP
