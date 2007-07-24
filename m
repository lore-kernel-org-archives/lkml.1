Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbXGXSv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbXGXSv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXGXSvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:51:23 -0400
Received: from [83.222.144.183] ([83.222.144.183]:48454 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbXGXSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:51:22 -0400
Message-ID: <46A64984.1070808@colorfullife.com>
Date: Tue, 24 Jul 2007 20:48:36 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       "Agarwal, Lomesh" <lomesh.agarwal@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: which signal is sent to freeze process?
References: <46A506F8.2020206@colorfullife.com> <200707232211.15543.rjw@sisk.pl> <46A50AF0.70305@colorfullife.com>
In-Reply-To: <46A50AF0.70305@colorfullife.com>
Content-Type: multipart/mixed;
 boundary="------------070705050403000203070102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070705050403000203070102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

> Hi!
>
> Can you generate small testcase that demonstrates the problem?
>
> > Then what would be the correct way to handle resume process. The other
> > way of course is to make all the applications check the errno in case of
> > failure. But that seems more more problematic then system call checking.
> > What do you say?
>
> Hmm, does that testcase behave correctly over SIGSTOP/SIGCONT? I'm not
> saying kernel behaves nicely here, but perhaps fixing the apps to
> check errno properly is the right thing to do? :-)
Perhaps the kernel should use ERESTARTNOHAND instead of EINTR?
The current code is more than odd:
- select() and sys_ppoll() both use ERESTARTNOHAND (i.e.: 
the functions do not return to user space with SIGSTOP/SIGCONT or freezer())

- sys_poll() uses EINTR (i.e.: SIGSTOP/SIGCONT/freezer() return to user space)

Attached is a patch that switches sys_poll to ERESTARTNOHAND and a poll test app.
Boot tested with FC6.

What do you think? With ERESTARTNOHAND, poll would only return to user space if the app has a SIGCONT handler installed.

--
	Manfred


--------------070705050403000203070102
Content-Type: text/plain;
 name="patch-poll-ERESTARTNOHAND"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-poll-ERESTARTNOHAND"

--- 2.6/fs/select.c	2007-05-20 09:52:32.000000000 +0200
+++ build-2.6/fs/select.c	2007-07-23 22:10:21.000000000 +0200
@@ -723,7 +723,7 @@
   	}
 	err = fdcount;
 	if (!fdcount && signal_pending(current))
-		err = -EINTR;
+		err = -ERESTARTNOHAND;
 out_fds:
 	walk = head;
 	while(walk!=NULL) {
@@ -794,7 +794,7 @@
 	ret = do_sys_poll(ufds, nfds, &timeout);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR) {
+	if (ret == -ERESTARTNOHAND) {
 		/*
 		 * Don't restore the signal mask yet. Let do_signal() deliver
 		 * the signal on the way back to userspace, before the signal
@@ -805,7 +805,6 @@
 					sizeof(sigsaved));
 			set_thread_flag(TIF_RESTORE_SIGMASK);
 		}
-		ret = -ERESTARTNOHAND;
 	} else if (sigmask)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 

--------------070705050403000203070102
Content-Type: text/x-c++src;
 name="sp.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sp.cpp"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/poll.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <errno.h>

int main(int argc, char **argv)
{
	int delay, ret;
	struct pollfd pfd;
	int pipesfd[2];

	printf("sp <delay>\n");

	if (argc != 2)
		return 1;
	delay = atoi(argv[1]);
	printf("delay %d.\n", delay);
	if (delay < 0 || delay > 1000)
		return 2;

	if (pipe(pipesfd) != 0) {
		fprintf(stderr, "pipe failed with errno %d.\n", errno);
		return 3;
	}
	pfd.fd = pipesfd[0];
	pfd.events = POLLIN;

	if (!fork()) {
		sleep(delay);
		write(pipesfd[1], "", 1);;
		return 0;
	}
	sleep(1);
	ret = poll(&pfd, 1, -1);
	printf("poll returned %d.\n", ret);

	if (pfd.revents)
		printf("   events %8xh revents %8xh.\n", pfd.events, pfd.revents);

	return 0;
}

--------------070705050403000203070102--
