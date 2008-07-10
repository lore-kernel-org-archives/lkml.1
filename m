Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYGJIPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYGJIPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYGJIOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:14:51 -0400
Received: from nebensachen.de ([195.34.83.29]:51361 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYGJIOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:14:50 -0400
X-Hashcash: 1:20:080710:mingo@elte.hu::RPjBE6k3zKKlfZHW:00003rvB
X-Hashcash: 1:20:080710:linux-kernel@vger.kernel.org::rYbxv9KaKGPqmtrF:00000000000000000000000000000000013rU
From: Elias Oltmanns <eo@nebensachen.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Scheduling issue with signal handling
Date: Thu, 10 Jul 2008 10:14:42 +0200
Message-ID: <87wsju88b1.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

in another thread [1] we've discussed something which, after some
testing, I now believe to be a problem related to scheduling /
preemption.

Here is the problem: If there is heavy disk I/O in the background,
signals sent to an I/O related process interactively by pressing Ctrl+Z
or Ctrl+C are sometimes processed quite sluggishly. I can pretty
reliably reproduce this using a test case provided by the original
reporter [1] (on a uniprocessor if that's of any consequence). The
problem has been verified to exist at least since 2.6.19 but it's become
much easier to observe and thus attracted attention since 2.6.25 because
pressing Ctrl+Z or Ctrl+C is now acknowledged by printing ^Z or ^C to
the terminal, respectively. As a result, the user gets slightly
irritated and possibly impatient when pressing Ctrl+Z repeatedly or just
holding down these keys generates a string like
^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z
but the shell prompt doesn't appear for up to a few seconds.

By sprinkling some printk()s all over the place, I've managed to
establish the following sequence of events taking place in the event of
delayed signal handling as described above:
The first Ctrl+Z event enqueues a SIGTSTP signal which eventually
results in a call to kick_process(). For some reason though, the signal
isn't handled straight away but remains on the queue for some time.
Consequently, subsequent Ctrl+Z events result in echoing another ^Z to
the terminal but everything related to sending a signal is skipped (and
rightly so) because the kernel detects that a SIGTSTP is still pending.
Eventually, get_signal_to_deliver() dequeues the SIGTSTP signal and the
shell propt appears.

My question is this: Even under high disk I/O pressure, the threads
dealing with I/O to the terminal evidently still get their turn as
indicated by the sequence of ^Z appearing on screen. Why is it then,
that the threads which are meant to process the SIGTSTP or SIGINT signals
aren't scheduled for some seconds and is there a way to change this?

Please let me know if there is anything I can try to investigate this
any further or if you need further information.

Thanks in advance,

Elias

[1] http://lkml.org/lkml/2008/6/28/50
