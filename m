Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZGYPQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZGYPQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 11:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZGYPP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 11:15:59 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:43742 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZGYPP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 11:15:59 -0400
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
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
	<20090725150510.35e8854d@lxorguk.ukuu.org.uk>
Date: Sat, 25 Jul 2009 23:55:39 +0900
In-Reply-To: <20090725150510.35e8854d@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Sat, 25 Jul 2009 15:05:10 +0100")
Message-ID: <87ab2sx15g.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> Actually try this:

Thanks. This patch improved situation. However, if slave writes big data
to buffer, it seems we still have the problem.

> +	tty_flip_buffer_push(tty->link);

This is handling the pending buffer, but in flush_to_ldisc(), if
!tty->receive_room, it seems still delay the ->receive_buf().

>  	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
>  	wake_up_interruptible(&tty->link->read_wait);
>  	wake_up_interruptible(&tty->link->write_wait);

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


#define _GNU_SOURCE
#define BIG_BUF
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

#ifdef BIG_BUF
	{
		char buf[4096];
		size_t size;

		memset(buf, '-', sizeof(buf));
		size = 0;
		while (size < 8192) {
			ssize_t r = write(STDOUT_FILENO, buf, sizeof(buf));
			if (r < 0)
				error(1, errno, "%s: write", __func__);
			size += r;
		}
	}
#else
		printf("1-----------------------------------------------\n");
		printf("2-----------------------------------------------\n");
		printf("3-----------------------------------------------\n");
		printf("4-----------------------------------------------\n");
		printf("5-----------------------------------------------\n");
		printf("6-----------------------------------------------\n");
		printf("7-----------------------------------------------\n");
		printf("8-----------------------------------------------\n");
		printf("9-----------------------------------------------\n");
#endif
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
#ifdef BIG_BUF
		printf("size %zd\n", size);
#else
		write(STDOUT_FILENO, buf, size);
#endif
	}
	
	return 0;
}
