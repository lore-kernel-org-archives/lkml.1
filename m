Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbXHZOjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbXHZOjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 10:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXHZOjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 10:39:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:29839 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXHZOjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 10:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JqVjzK+EYdy+p/uggbLb2lR5edgHn5uo0EBzxZ+5Pz4Y4PDDPhmQ19XC7JGLL+BKAMtAvVybj9vzDRDgtC4whykwbPljqNJUQXxGPorkdtCw+FWUMbDAKq1FxLPW2lUJGy2+yRlBqb+pmsrJko4EkWIHSk4v8cdxRPLNK0zvrnc=
Message-ID: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
Date: Sun, 26 Aug 2007 10:39:11 -0400
From: "Fred Tyler" <fredty8@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Slow, persistent memory leak in 2.6.20
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think I've come across a memory leak in 2.6.20. I've upgraded to the
latest 2.6.20.17, but it didn't seem to help.

A little background: I saw something exactly like this many months ago
with a 2.6.12 kernel. However, by 2.6.16.x the leak had apparently
been fixed, so I didn't pursue it. I just assumed it had been fixed.
But either it remains in 2.6.20 or else a new leak has appeared.

FWIW, this is an x86_64 machine, but I also saw nearly the same
behavior on a i386 machine running 2.6.12. (Links to graphs showing
long-term memory usage are at the bottom of this email if you want to
skip all the text stats in the middle.)

Immediately after booting the system, I shut down all services to get
a baseline for comparison. Here is the output of top and vmstat with
virtually nothing running:

=========== top =============

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  754 root      15   0 16948 2368 1732 R  0.0  0.3   0:00.01 sshd
  757 root      15   0  5620 1440 1124 S  0.0  0.2   0:00.00 bash
 1195 root      15   0  6300 1116  880 R  0.3  0.1   0:00.02 top
 1196 root      18   0  3880  628  516 S  0.0  0.1   0:00.00 agetty
    1 root      18   0  3888  516  412 S  0.0  0.1   0:00.26 init
  741 root      18   0  3880  508  412 S  0.0  0.1   0:00.00 agetty
  742 root      18   0  3876  504  412 S  0.0  0.1   0:00.00 agetty
  743 root      18   0  3876  504  412 S  0.0  0.1   0:00.00 agetty
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0
    3 root      34  19     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/0
    4 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 events/0
    5 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 khelper
    6 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 kthread
   57 root      10  -5     0    0    0 S  0.0  0.0   0:00.02 kblockd/0
   58 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 ata/0
   59 root      20  -5     0    0    0 S  0.0  0.0   0:00.00 ata_aux
   62 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 khubd
   64 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 kseriod
  121 root      25   0     0    0    0 S  0.0  0.0   0:00.00 pdflush
  122 root      15   0     0    0    0 S  0.0  0.0   0:00.00 pdflush
  123 root      20  -5     0    0    0 S  0.0  0.0   0:00.00 kswapd0
  124 root      19  -5     0    0    0 S  0.0  0.0   0:00.00 aio/0
  220 root      13  -5     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_0
  221 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_1
  245 root      11  -5     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_2
  246 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 usb-storage
  256 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 reiserfs/0

=========== free ============

             total       used       free     shared    buffers     cached
Mem:        899408      96824     802584          0      12604      70064
-/+ buffers/cache:      14156     885252
Swap:        65528          0      65528


=========== vmstat ==============

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 802152  13008  70096    0    0   402   184  282   87  2  1 88  9


=========== vmstat -s ===============

       899408  total memory
        97248  used memory
        50352  active memory
        34368  inactive memory
       802160  free memory
        13080  buffer memory
        70104  swap cache
        65528  total swap
            0  used swap
        65528  free swap
          349 non-nice user cpu ticks
            0 nice user cpu ticks
          172 system cpu ticks
        15743 idle cpu ticks
         1522 IO-wait cpu ticks
            0 IRQ cpu ticks
           10 softirq cpu ticks
            0 stolen cpu ticks
        69682 pages paged in
        32228 pages paged out
            0 pages swapped in
            0 pages swapped out
        50228 interrupts
        15207 CPU context switches
   1188132534 boot time
         1213 forks

==================================



Ok, now I start back up all services and let the system run for about
12 hours. At the end of this time, I shut down all services again so
that virtually nothing is running. Here are the stats:



=========== top ================

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
17250 root      15   0 16952 2372 1732 R  0.0  0.3   0:00.09 sshd
17253 root      15   0  5624 1448 1124 S  0.0  0.2   0:00.01 bash
23409 root      15   0  6304 1124  884 R  0.0  0.1   0:00.00 top
23410 root      18   0  3880  628  516 S  0.0  0.1   0:00.00 agetty
    1 root      18   0  3884  516  412 S  0.0  0.1   0:00.56 init
  750 root      18   0  3880  508  412 S  0.0  0.1   0:00.00 agetty
  751 root      18   0  3880  508  412 S  0.0  0.1   0:00.00 agetty
  749 root      18   0  3876  504  412 S  0.0  0.1   0:00.00 agetty
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0
    3 root      34  19     0    0    0 S  0.0  0.0   0:00.01 ksoftirqd/0
    4 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 events/0
    5 root      20  -5     0    0    0 S  0.0  0.0   0:00.00 khelper
    6 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 kthread
   57 root      10  -5     0    0    0 S  0.0  0.0   0:00.31 kblockd/0
   58 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 ata/0
   59 root      20  -5     0    0    0 S  0.0  0.0   0:00.00 ata_aux
   62 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 khubd
   64 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 kseriod
  121 root      15   0     0    0    0 S  0.0  0.0   0:00.00 pdflush
  123 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 kswapd0
  124 root      20  -5     0    0    0 S  0.0  0.0   0:00.00 aio/0
  220 root      13  -5     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_0
  221 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_1
  245 root      11  -5     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_2
  246 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 usb-storage
  256 root      10  -5     0    0    0 S  0.0  0.0   0:00.02 reiserfs/0
17277 root      15   0     0    0    0 S  0.0  0.0   0:00.16 pdflush

============= free ===========

             total       used       free     shared    buffers     cached
Mem:        899408     747128     152280          0     166228     444540
-/+ buffers/cache:     136360     763048
Swap:        65528          0      65528


============= vmstat ==============

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 152288 166228 444564    0    0    10    30  255   29  0  0 99  0

============ vmstat -s ==============

       899408  total memory
       747248  used memory
       338700  active memory
       273736  inactive memory
       152160  free memory
       166228  buffer memory
       444660  swap cache
        65528  total swap
            0  used swap
        65528  free swap
         7522 non-nice user cpu ticks
          300 nice user cpu ticks
         4120 system cpu ticks
      3699397 idle cpu ticks
        13963 IO-wait cpu ticks
           49 IRQ cpu ticks
          146 softirq cpu ticks
            0 stolen cpu ticks
       355378 pages paged in
      1108508 pages paged out
            0 pages swapped in
            0 pages swapped out
      9505965 interrupts
      1095062 CPU context switches
   1188095217 boot time
        23440 forks

======================================


After 12 hours, you can see that when I shut down all of the services
there is a lot of memory being used. But where is it going?

I have compared this to a machine running i386 2.6.16.2x and when I
stop all services down to nothing but ssh, there is only a tiny amount
of RAM in use, as expected.

I can verify that this memory loss never stops: The lost memory keeps
increasing until eventually the machine goes into swap and will
eventually crash if left to its own devices. However, on machines with
big RAM, this process can take a month or more.

Here are links to three cacti graphs where you can see the effect over
the long term:

This graph is from a machine running 2.6.16.27/i386, which does not
have any memory loss. You can see the long-term memory line is flat:

    http://i239.photobucket.com/albums/ff117/fredty8/memory-a4.png

Now here is a graph from a machine running 2.6.12/i386, which clearly
shows a long-term memory loss. The points where the memory shoots back
up to its full level are when the machine had to be rebooted because
it was going into swap:

    http://i239.photobucket.com/albums/ff117/fredty8/memory-a2.png

And finally, here is a graph from a machine running 2.6.20.15/x86_64,
which shows a very similar memory loss as the 2.6.12 machine. (This
machine has only been up for a few weeks, which is why the graph is so
short. But it is clear that the graph is doing the same thing as
2.6.12):

    http://i239.photobucket.com/albums/ff117/fredty8/memory-b1.png


If you need any more information from me, I'll be happy to provide it.
Please CC me on replies.
