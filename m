Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab0BDPmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:42:36 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:35848 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab0BDPme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:42:34 -0500
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 for child processes
From: Kay Sievers <kay.sievers@vrfy.org>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100202120457.GA19605@omega>
References: <20100202120457.GA19605@omega>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 16:42:55 +0100
Message-ID: <1265298175.24100.8.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 13:04 +0100, Lennart Poettering wrote:
> Right now, if a process dies all its children are reparented to init.
> This logic has good uses, i.e. for double forking when daemonizing.
> However it also allows child processes to "escape" their parents,
> which
> is a problem for software like session managers (such as
> gnome-session)
> or other process supervisors.
> 
> This patch adds a simple flag for each process that marks it as an
> "anchor" process for all its children and grandchildren. If a child of
> such an anchor dies all its children will not be reparented to init,
> but instead to this anchor, escaping this anchor process is not possible.
> A task with this flag set hence acts is little "sub-init".
> 
> Anchors are fully recursive: if an anchor dies, all its children are
> reparented to next higher anchor in the process tree.
> 
> This is orthogonal to PID namespaces. PID namespaces virtualize the
> actual IDs in addition to introducing "sub-inits". This patch
> introduces
> "sub-inits" inside the same PID namespace.

Sounds good to me. And seems useful for all sorts of session tracking
and "prettifying ps". :)

It seems to work fine here. With a double-fork, the child gets the
intermediate-fork pid as the parent, and when this dies, it get
re-parented to the anchor pid instead of directly to pid 1. Only when
the anchor pid dies, it will be re-parented to pid 1.

Thanks,
Kay

$ ./sub-init 1
[26209] main: anchor=1
[26209] main: forked 'help' 26210
[26209] main: wait for 'help' to exit 26210
[26210] help: has parent 26209
[26210] help: forked 'child' 26211, sleep
[26211] child: has parent 26210, sleep
[26211] child: has parent 26210, sleep
[26210] help: exit
[26209] main: 'help' 26210 returned, sleep
[26211] child: has parent 26209, sleep
[26211] child: has parent 26209, sleep
[26209] main: exit
[26211] child: has parent 1, sleep
[26211] child: has parent 1, sleep
[26211] child: has parent 1, sleep
[26211] child: has parent 1, sleep
[26211] child: has parent 1, sleep
[26211] child: has parent 1, sleep
[26211] child: exit



#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/prctl.h>
#include <sys/wait.h>

#define PR_SET_ANCHOR 35
#define PR_GET_ANCHOR 36

int main(int argc, char *argv[])
{
	int is_anch;
	pid_t pid;

	if (argc > 1)
		prctl(PR_SET_ANCHOR, 1);
	prctl(PR_GET_ANCHOR, &is_anch);
	printf("[%i] main: anchor=%i\n", getpid(), is_anch);

	pid = fork();
	if (pid == 0) {
		pid_t pid2;

		printf("[%i] help: has parent %i\n", getpid(), getppid());
		pid2 = fork();
		if (pid2 == 0) {
			int i;

			for (i = 0; i < 30; i += 3) {
				printf("[%i] child: has parent %i, sleep\n", getpid(), getppid());
				sleep(1);
			}
			printf("[%i] child: exit\n", getpid());
		} else {
			printf("[%i] help: forked 'child' %i, sleep\n", getpid(), pid2);
			sleep(2);
			printf("[%i] help: exit\n", getpid());
			return 0;
		}
	} else {
		printf("[%i] main: forked 'help' %i\n", getpid(), pid);
		printf("[%i] main: wait for 'help' to exit %i\n", getpid(), pid);
		waitpid(pid, NULL, 0);
		printf("[%i] main: 'help' %i returned, sleep\n", getpid(), pid);
		sleep(2);
		printf("[%i] main: exit\n", getpid());
	}

	return 0;
}

