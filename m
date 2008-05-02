Return-Path: <linux-kernel-owner+w=401wt.eu-S965917AbYEBP6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965917AbYEBP6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964878AbYEBPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:53:00 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19552 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345AbYEBPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:52:59 -0400
Message-ID: <481B38D8.7080905@hp.com>
Date: Fri, 02 May 2008 11:52:56 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: More io-cpu-affinity results: queue_affinity + rq_affinity
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing to evaluate the potential benefits of the various I/O & CPU
affinity options proposed in Jens' origin/io-cpu-affinity branch...

Executive summary (due to the rather long-winded nature of this post):

We again see rq_affinity has positive potential, but not (yet) able to
see much benefit to adjusting queue_affinity.

========================================================

In this round I was trying to see if I could 'prove' the worth of the
queue_affinity tunable. Taking a purposefully mis-setup 16-way IA64 box:

o  4 cells w/ 4 CPUs per cell, total of 64GiB of RAM

o  6 HBAs all put in cell 0, each HBA has 2 ports, each port is
connected to one HP MSA1000 that exports 2 FC disks. [Thus, 24 FC disks
being used.]

o  It is important to note that for these tests we set the IRQ for each
port to be handled on one of the CPUs in cell 0. [So, each CPU will be
fielding 6 interrupts from storage I/O.]

o  Running Jens origin/io-cpu-affinity kernel [2.6.25+ based]

o  I used FIO to generate streams of 4KiB sequential synchronous I/Os
(standard read/write). Each data point discussed below was from iostat
output gathered over a 2 minute period during the run.

The system is "mis-setup' with regards to the fact that /all/ the I/O is
placed in the first cell - processes issuing I/O on other cells will
have to interact with adapters placed off-cell.

This allows us to vary the following two key variables (the picture @
http://free.linux.hp.com/~adb/jens/CellDiagram.png may help - it
illustrates a single device & I/O generator):

o  Where the I/O originates from:

(1) I/O generator on the CPU handling the IRQ for that device ("IO on");

(2) I/O generator on a CPU in cell 0, but /not/ on the CPU handling the
IRQ for the device ("IO near");

(3) I/O generator in cell 1 ("IO far").

o  The queue_affinity value for the device being interacted with:

(1) On the CPU handling the IRQ for that device ("QAF on");

(2) In cell 0, but /not/ on the CPU handling the IRQ for the device
("QAF near");

(3) In cell 1 ("QAF far")

In all cases the loads are spread out - meaning: when I/Os are being
generated in cell 1, each of the 4 CPUs will have 6 tasks pegged onto it
(using the FIO cpus_allowed option), and likewise for queue_affinity
settings when not "near". [There is plenty of idle in the system, the
overhead for the I/O generating tasks is minimal...]

=====================================================

The idea was hopefully to see that when I/Os were being generated on a
"far" cpu, but the queue_affinity was set to "on" (and possibly "near"),
we'd see better performance. That rationale being that locality to the
hardware device would bring improvements.


The good news is that there may be /some/ small benefit (seeing on the
order of about 0.5% better throughput and >2% less %system), need to
perform a lot more tests to see if this holds over a number of runs.

/But/ (there's always a but): Due to the fact that I wasn't seeing a lot
of improvement I added in one more variable: rq_affinity, and it appears
that the benefits induced by setting rq_affinity to 1 dwarfs anything
that we've seen with the queue_affinity tunable (in fact, it wipes out
the aforementioned 0.5% better throughput & >2% less % system when
queue_affinity is set when rq_affinity=1).

The data below shows data w/ rq_affinity = 0 and 1 as well. Note that
whilst not setting out to (re-)prove the worth of that configurable, for
this test we are seeing a tremendous improvement in performance when
that is set properly.

=====================================================

Looking at I/O performance (reads per second - see the graph at
http://free.linux.hp.com/~adb/jens/r_s.png for a visual representation):

With the I/O generator /on/ the CPU handling the IRQ there's not much
difference in any of the values - most interesting with respect to
setting queue_affinity to far. One would expect that routing the I/Os
away and having the lower part of the I/O stack operating remotely from
the device would have a larger impact. My /guess/ is that the benefit of
offloading the work from the busy cell offsets this to a certain extent.

r/s     QAF on  QAF near   QAF far
      --------  --------  --------
rq=0    73,281    73,828    73,755
rq=1    73,734    73,757    73,734

=====================================================

With the I/O generator /near/ to the CPU handling the IRQ we see a huge
benefit to having rq_affinity=1 (on the order of 12%), but not much
difference in the queue_affinity settings impact.

r/s     QAF on   QAF near   QAF far
      --------  --------  --------
rq=0    61,690    61,802    61,806
rq=1    69,112    69,147    69,188

=====================================================

With the I/O generator /far/ from the CPU handling the IRQ we see again
a large difference with rq_affinity=1 (on the order of 5.5%), but again
not much difference due to the various queue_affinity settings. As noted
above, we do see a slight win between QAF far and on w/ rq=0 (0.56%).

r/s     QAF on   QAF near   QAF far
      --------  --------  --------
rq=0    65,399    65,054    65,035
rq=1    69,012    69,071    69,083

=====================================================

Looking at the %system taken to do the work, I'll just illustrate the
I/O generator == /far/ case (see
http://free.linux.hp.com/~adb/jens/p_system.png for the complete picture).

Again a huge disparity with respect to %system (lower being better, of
course) - we're seeing around 52% /fewer/ system cycles when rq_affinity
is set.

There appears to be a small, but noticeable positive impact when
queue_affinity pushes the I/Os onto the CPU managing the IRQ for the
device - 2.6% when rq_affinity = 0, but that benefit gets wiped out when
rq_affinity is set to 1. Probably just another indication that
queue_affinity may just be in the noise?


%sys    QAF on   QAF near   QAF far
      --------  --------  --------
rq=0    27.43%    28.03%    28.17%
rq=1    13.35%    13.41%    13.30%

=====================================================

As noted above, I'm going to do a series of runs to make sure this data
holds over a larger data set (in particular the case where I/O is far -
looking at QAF on & far to see if the 0.56% is truly representative).
Suggestions for other tests to try and show/determine queue_affinity
benefits are very welcome.

Alan D. Brunelle
HP Open Source & Linux Organization's Scalability & Performance Group
