Return-Path: <linux-kernel-owner+w=401wt.eu-S1761037AbXIZDoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761037AbXIZDoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbXIZDoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:44:00 -0400
Received: from host721684293.hns-noc-rev-lu.com ([72.168.93.42]:41397 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbXIZDn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:43:59 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: signals dropped when proc. run as daemon, but not when in the foreground
Date: Tue, 25 Sep 2007 20:43:41 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709252043.41319.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm writing a system app. that becomes a daemon by the usual fork() -> 
setsid() -> fork() method.

It then registers a signal handler for SIGCHLD via sigaction (SA_SIGINFO 
style).

    chldAction.sa_sigaction = sigChld;
    sigemptyset(&(chldAction.sa_mask));
    chldAction.sa_flags = SA_SIGINFO;
    rc = sigaction(SIGCHLD, &chldAction, NULL);

Its a network service server, so it does the usual 
socket->bind->listen->select->accept->fork sequence to handle a new 
connection.

The child processes the connection, then exits.  This should generate 
the standard SIGCHLD signal to the parent, which catches it via the 
sigaction with the following handler:

static void
sigChld(int signum, siginfo_t * siginfo, void * ucontext)
{
    int childStat;

    log_dbg("received signal %d\n", signum);

    if (signum != SIGCHLD)     /* technically can't happen here... */
        return;                          /* but ignore it if it does */

    if (waitpid(siginfo->si_pid, &childStat, 0) > 0)
    {
        if (WIFEXITED(childStat))
            log_dbg("child %d WIFEXITED with childStat %d\n",
                    siginfo->si_pid, WEXITSTATUS(childStat));

        if (WIFSIGNALED(childStat))
        {
            log_dbg("child %d WIFSIGNALED with childStat %d\n",
                    siginfo->si_pid, WTERMSIG(childStat));
        }
    }

    return;
}

Here's the problem:  when run as a daemon, as above, I don't get the 
SIGCHLD.  I've instrumented it to show the child exiting, and it does, 
and it even becomes defunct (on account of the lack of waitpid from the 
signal handler).

HOWEVER, if I run the program in the foreground, without 
fork()->setsid()->fork() sequence, EVERYTHING is FINE!

I am going insane?  This is on a 2.6.20.6 kernel, and I just can't see 
that this would be a kernel bug, but I don't know if/what I'm doing 
wrong myself?

Is there something I could do to test something...I've been at this for 
a few days now and I'm out of ideas...

Thanks,
John

