Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZGYG0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZGYG0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 02:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZGYG0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 02:26:00 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:50795 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZGYG0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 02:26:00 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
Date: Sat, 25 Jul 2009 15:04:06 +0900
In-Reply-To: <alpine.LFD.2.01.0907240930120.3960@localhost.localdomain> (Linus
	Torvalds's message of "Fri, 24 Jul 2009 09:34:35 -0700 (PDT)")
Message-ID: <87ws5xjo2x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>> I don't know where you got that idea from. Avoiding breaking user space
>> unneccessarily is good but if its buggy you often can't do anything about
>> it.
>
> Alan, he got that idea from me.
>
> We don't do regressions. If user space depended on old behavior, we don't 
> change behavior.
>
> And regardless of that, I do not think EIO is the right thing to return at 
> all. If the other side of a pty went away, return 0 and possibly send a 
> HUP, or whatever. What did we do before?

I also was seeing this. I hope the attached test code shows the problem.

The problem seems to be complex. And before change, write() seems to
send buffer to ldisc directly. After change, write() seems to send
buffer to tty buffer. With some debug, I'm not sure though, I guess the
following

          slave                                 master
     write()
         write to buffer
             tty_flip_buffer_push()
             schedule_delayed_work()
     close()
         set_bit(TTY_OTHER_CLOSED)
                                            read()
                                                input_available_p()
                                                # buffer was not received yet
                                                    test_bit(TTY_OTHER_CLOSED)
                                                        return -EIO

                                            flush_to_ldisc()
                                                ->receive_buf()

master is having the input data in tty->buf, but ->receive_buf() is not
called yet. So, it seems to return -EIO before handling input data in
tty->buf.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <error.h>
#include <limits.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/wait.h>
#include <unistd.h>

static char pts_name[PATH_MAX];

static int open_pty(void)
{
	int master;
	char *name;

	master = getpt();
	if (master < 0)
		return -1;

	if (grantpt(master) < 0 || unlockpt(master) < 0)
		goto close_master;
#if 0
	{
		int on = 1;
		ioctl(master, FIONBIO, &on);
	}
#endif
	name = ptsname(master);
	if (name == NULL)
		goto close_master;

	strcpy(pts_name, name);

	return master;

close_master:
	close(master);
	return -1;
}

static pid_t child(int master)
{
	pid_t pid;
	int slave;

	pid = fork();
	if (pid < 0)
		error(1, errno, "%s: fork", __func__);

	if (pid == 0) {
		slave = open(pts_name, O_RDWR);
		if (slave < 0)
			error(1, errno, "%s: open", __func__);

		close(master);
		dup2(slave, 0);
		dup2(slave, 1);
		dup2(slave, 2);
		close(slave);

		printf("1-----------------------------------------------\n");
		printf("2-----------------------------------------------\n");
		printf("3-----------------------------------------------\n");
		printf("4-----------------------------------------------\n");
		printf("5-----------------------------------------------\n");
		printf("6-----------------------------------------------\n");
		printf("7-----------------------------------------------\n");
		printf("8-----------------------------------------------\n");
		printf("9-----------------------------------------------\n");
		exit(0);
	}

	return pid;
}

int main()
{
	pid_t pid;
	int master;

	master = open_pty();
	if (master < 0)
		error(1, errno, "%s: open_pty", __func__);

	pid = child(master);

	waitpid(pid, NULL, 0);
	while (1) {
		char buf[4096];
		ssize_t size;

		size = read(master, buf, sizeof(buf));
		if (size < 0) {
			if (errno == EAGAIN) {
				printf("EAGAIN\n");
				continue;
			}
			error(1, errno, "%s: read", __func__);
		}
		if (size == 0)
			break;
		write(STDOUT_FILENO, buf, size);
	}
	
	return 0;
}
