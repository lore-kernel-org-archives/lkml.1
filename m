Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXIVSWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXIVSWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 14:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXIVSW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 14:22:29 -0400
Received: from host721684293.hns-noc-rev-lu.com ([72.168.93.42]:46105 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbXIVSW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 14:22:29 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Should parent's WIFSIGNALED(siginfo->si_status) be true EVEN IF the SIGNAL was caught by the child?
Date: Sat, 22 Sep 2007 11:22:09 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709221122.09523.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It is unclear from the various documentions in the kernel and glibc what 
the proper behaviour should be for the case when a child process 
catches a SIGNAL (say for instance, SIGTERM), and then calls exit() 
from within its caught SIGNAL handler.

Since the exit() will cause a SIGCHLD to the parent, and the parent 
(let's say) has a SIGCHLD sigaction (SA_SIGINFO sa_flags set), should 
the parent's WIFSIGNALED(siginfo->si_status) be true?

To recap, the WIFSIGNALED section of the waitpid() manpage says:

WIFSIGNALED(status)
    returns true if the child process was terminated by a signal.

So the dilemna:  the child caught the signal, so it wasn't terminated by 
a signal, but rather its signal handler (let's say) called exit.

Furthermore:

WTERMSIG(status)
    returns the number of the signal that caused the  child  process
    to  terminate. This macro should only be employed if WIFSIGNALED
    returned true.

Observered behaviour with 2.6.20.6 is that is WIFSIGNALED(status) 
returns true (possibly incorrect), and furthermore, WTERMSIG(status) 
returns the exit(VALUE) VALUE from the child's exit() call, and not the 
SIGNAL (let's say SIGTERM that the child caught).  This may be correct, 
since the siginfo_t * si_status member is:

int      si_status; /* Exit value or signal */

but there's no clarity on which:  exit value or signal.  Since the child 
exited, I'm likely to assume exit status, which is current observed 
behaviour, but then, WIFSIGNALED(status) should be FALSE, which its not 
(observed with 2.6.20.6).

So could someone clarify the kernel's intent?

I can provide a short C program to illustrate above behaviour, if 
needed.  It also could be that I'm just misinterpreting the intent, 
which is why I'm not calling this a bug, despite a possible 
inconsistency in behaviour.

Thanks,
John


