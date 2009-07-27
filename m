Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZG0QvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZG0QvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZG0QvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:51:10 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:38547 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZG0QvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=Y3nNRkr+mS5pHaeGINbSnE8xdJTWkJ6EoN86O3TYrdJifbFZIaGgv3usMz5u1tvXcA
         Vfcy9TgzuXYA3/TYEHzj9GoIs0377BMUCC4ZQJ2J9Ro6NXgABW+SEM+8uv9NrmvDk2m1
         bp+RTPSa47ulgTZ5mQqpHdnbxu5VYG8hz6vmQ=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Mon, 27 Jul 2009 18:51:02 +0200
Message-ID: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
Subject: perf_counters issue with self-sampling threads
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I believe there is a problem with the current perf_counters (PCL)
code for self-sampling threads. The problem is related to sample
notifications via signal.

PCL (just like perfmon) is using SIGIO, an asynchronous signal,
to notify user applications of the availability of data in the event
buffer.

POSIX does not mandate that asynchronous signals be delivered
to the thread in which they originated. Any thread in the process
may process the signal, assuming it does not have the signal
blocked.

This is a serious problem with any self-sampling program such as
those built on top of PAPI. When sampling, you do want the signal
to be delivered to the thread in which the counter overflowed. This is
not just for convenience but it is required if the signal handler needs
to operate on the thread's machine state. Although, there is always
a possibility of forwarding the signal via tkill() to the right thread, I
do not think this is the right solution as it incurs additional latency
and therefore skid.

Looking at the kernel source code related to that, it seems that
kill_fasync() ends up calling group_send_sig_info(). This function
adds the signal to the process SHARED sigpending queue. Then,
it picks a thread to "wakeup". It first tries the thread in which the
signal originated with the following selection test (wants_signal):
   - signal is not blocked
   - thread is not exiting
   - no signal private pending for this thread

If that does not work, it iterates over the other threads of the process.

This explains why in trivial tests, the SIGIO is always delivered
to the right thread. However it the monitored thread is using any
other signals, e.g., SIGALRM, then the SIGIO signal can go to the
wrong thread. The problem also arises if the first SIGIO is not already
processed by the time a 2nd is pended.

For self-sampling, we want (and in fact require)  asynchronous notifications.
But we want the extra guarantee that the signal is ALWAYS delivered to
the thread in which the event occurred.

It seems like we could either create a different version of kill_fasync() or
pass an extra parameter to force this function to use specific_send_sig_info().
This would be only when self-monitoring. When a tool is monitoring another
thread, it is probably okay to have the signal delivered to any threads. Most
likely, the tool is setup such that threads not processing notifications have
the signal blocked.
