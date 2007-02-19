Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXBSGOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXBSGOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 01:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbXBSGOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 01:14:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58489 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbXBSGOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 01:14:16 -0500
Date: Mon, 19 Feb 2007 15:13:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Qeustion][Maybe BUG?] simaltaneous wait and SIGCHLD handling
Message-Id: <20070219151337.d2594811.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>From SUSv3, I expected SIGCHLD from dead processes (already reaped by wait(2))
should be cleared. But it seems that such situation is not handled in Linux.

Here is a test program. set sigchld handler and call waitpid() in main().

==
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>

int sigchld_handler(int sig,siginfo_t *info, void *uc)
{
        fprintf(stderr,"Letter from the hell...(%d)\n",info->si_pid);
}

int main(int argc, char *argv)
{
        struct sigaction act;
        sigset_t block;
        int status;
        pid_t pid;

        sigemptyset(&block);
        sigaddset(&block, SIGCHLD);
        act.sa_sigaction = sigchld_handler;
        act.sa_mask = block;
        act.sa_flags = SA_SIGINFO|SA_RESTART;
        sigaction(SIGCHLD,&act,NULL);

        pid = fork();
        if (!pid) {
                sleep(3);
                exit(0);
        }
        sigprocmask(SIG_BLOCK, &block, NULL);
        pid = waitpid(pid, &status, 0);
        fprintf(stderr,"wait end -> %d\n",pid);
        sigprocmask(SIG_UNBLOCK, &block, NULL);
        exit(0);
}
==
Result is here
==
[kamezawa@casares ~]$ ./waittest
wait end -> 5841
Letter from the hell...(5841)
==

Is this an expected result ? I think SIGCHLD shouldn't be delivered.

-Kame

