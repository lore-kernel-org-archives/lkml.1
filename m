Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYKYVqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYKYVqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbYKYVol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:44:41 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40644 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbYKYVoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:44:39 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC 0/6] chargeback accounting patches
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar.sarma@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 13:44:37 -0800
Message-ID: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've taken Vaidy's patches to implement charge-back accounting and modified
them a bit.  The end result is still mostly the same--scaled utime and stime
via taskstats--but hopefully done in a less invasive way.  The point of these
patches is for a computer utilization accounting system to be able to determine
that a particular process was not completely CPU bound, at which point it could
try to determine if the process was memory-bound for (perhaps) more optimal
scheduling later.  Or put discounts on the bill.

For sure, this is not to be used as a sole method for measuring processing
capacity. :)

There are six patches in this series.  Allow me to summarize them:

1. First, there are accounting bugs in the cpufreq_stats code that will
   be exposed by a later patch because someone assumed that cputime =
   jiffies.

2. The second patch moves the APERF/MPERF access code into a separate
   file so that both the chargeback accounting code and the acpi-cpufreq
   driver can both access those MSRs without stepping on each other.

3. Next, we create a VIRT_CPU_ACCOUNTING config option.  This enables us
   to delegate timeslice accounting out of the generic kernel code into
   arch-specific areas.  In the arch-specific code, we can then use the
   APERF/MPERF ratio to calculate the scaled utime/stime values.  The
   approach used is similar to what is done in arch/powerpc/ to scale
   utime/stime values via SPURR/PURR.

4. Currently, x86 assumes that cputime = jiffies.  However, this is an
   integer counter, which means that fractional jiffies, such as what we
   might get when trying to scale for CPU frequency, don't work.  If
   we change the cputime units to nanoseconds, however, we can accomplish
   this without having to muck around with the taskstats code.

5. Convert the acpi-cpufreq driver to use the functions defined in patch 2
   to access APERF/MPERF.  Previously the acpi-cpufreq driver would zero
   the MSRs after accessing them; however, this doesn't play well with
   multiple accessors.  Luckily, on a practical level the register is
   wide enough that overflow won't happen for a long time.

6. Modify getdelays.c to report utime/stime/scaled_utime/scaled_stime.

Let me know what you think of the patchset.  It's been tested with assorted
heavy/moderate loads and looks ok, though YMMV.  I'm curious to see what
you all think... for one thing, this patchset doesn't stray too far away from
the notion that we charge 1 tick to the non-scaled utime/stime depending on
whichever space (user/system) we were in at the time of the tick.  On one
hand that's still fairly close to the way we do things in x86 right now; on
the other hand, it's not terribly precise.

--D
