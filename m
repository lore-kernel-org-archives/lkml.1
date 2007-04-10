Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXDJOQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXDJOQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXDJOQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:16:18 -0400
Received: from mail128.messagelabs.com ([216.82.250.131]:55182 "HELO
	mail128.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753863AbXDJOQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:16:15 -0400
X-VirusChecked: Checked
X-Env-Sender: Steve.Hawkes@motorola.com
X-Msg-Ref: server-4.tower-128.messagelabs.com!1176214573!14537775!1
X-StarScan-Version: 5.5.10.7.1; banners=-,-,-
X-Originating-IP: [129.188.136.8]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: TIF_SIGPENDING set, but signals not being serviced
Date: Tue, 10 Apr 2007 09:16:11 -0500
Message-ID: <7BFDACCD6948EF4D8FE8F4888A91596AA7DFA0@tx14exm60.ds.mot.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: TIF_SIGPENDING set, but signals not being serviced
Thread-Index: Acd7esox9ZcczmJzSvWRi/ophiKEGw==
From: "Hawkes Steve-FSH016" <Steve.Hawkes@motorola.com>
To: <linux-kernel@vger.kernel.org>
X-Vontu: Pass
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running into an issue where processing of signals appears to be
misbehaving at the kernel level. One or more multithreaded processes are
ending up in a state where a signal is pending for the process, the
signal is blocked at the application level in all threads in the
process, and that one thread has the signal temporarily unblocked in the
kernel since it is in a sigwaitinfo() call, but that thread is not being
awakened to process the signal. Eventually the signal queue limit is hit
as more realtime signals are delivered to the process.

The kernel being used is 2.6.10-based on a PPC 8548 target
(unfortunately, I'm not able to move to a later kernel revision
currently, but I have not found changes in the latest kernel that appear
to be related to this issue).
 
Here is an example of 'ps' output in the failure scenario.
 
ps -emwo pid,tid,sig_pend,sig_block,sig_ignore,sig_catch,stat,wchan
 
  PID   TID           SIGNAL          BLOCKED          IGNORED
CATCHED STAT WCHAN
 1652     - 2000000000000000                -                -
- -    -
    -  1652 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1653 0000000000000000 4000000000000000 0000000000001004
9ffffff0fff8accb Sl   rt_sigtimedwait
    -  1654 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1655 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1656 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1657 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1658 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1659 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   select
    -  1660 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1661 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   select
    -  1662 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1663 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1664 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   nanosleep
    -  1665 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1667 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  1668 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  2178 0000000000000000 6000000000000000 0000000000001004
9ffffff0fff8accb Sl   futex_poll
    -  2410 0000000000000000 ffffffbf7ffbf235 0000000000001004
9ffffff0fff8accb Sl   futex_poll

The signal is pending for the process, as shown by the second line, and
the signal is unblocked in thread 1653, but that thread is not being
awakened.
 
I wrote a kernel module which displays more internal signal
information--as shown below--and it confirms that thread 1653 has the
signal temporarily unblocked and shared_pending has the signal pending
for the process. Oddly enough, it also shows the TIF_SIGPENDING flag is
set for multiple threads in the process (the column labeled "info") even
though those threads do not have and have never had the signal
unblocked.
 
  pid:  tgid stat info           pending #pnd   shared pending #shpnd
blocked     real blocked
 1652:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1653:  1652    2    4  0000000000000000    0 2000000000000000      2
4000000000000000 6000000000000000
 1654:  1652    2    4  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1655:  1652    2    4  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1656:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1657:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1658:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1659:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1660:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1661:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1662:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1663:  1652    2    4  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1664:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1665:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1667:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 1668:  1652    2    4  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 2178:  1652    2    0  0000000000000000    0 2000000000000000      2
6000000000000000 0000000000000000
 2410:  1652    2    0  0000000000000000    0 2000000000000000      2
ffffffbf7ffbf235 0000000000000000

The problem is difficult to analyze because analysis tools are causing
changes in the behavior, but some of the tests I've performed seem to
indicate that TIF_SIGPENDING is being left set on several threads which
do not have the signal unblocked before the system ends up in the state
where the signal in question is left as pending for the process.

I've tried using LTT and kernel instrumentation to determine how the
system gets in this state, but have not been successful so far. Note
that the problem seems to be timing related since even small changes
such as one more custom LTT event or running LTT while the system is
going through the phase where the problem normally appears can cause the
problem to not occur or to occur in a different process after the LTT
trace daemon terminates. The problem is difficult to isolate because we
only see it during the complex initialization sequence of our system and
it does not always occur in the same process.

I'm stumped.
Steve
