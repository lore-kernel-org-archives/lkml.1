Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZG0TvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZG0TvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZG0TvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:51:00 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:43145 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZG0Tu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:50:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
Date: Tue, 28 Jul 2009 04:28:59 +0900
In-Reply-To: <20090727171213.GB4233@skywalker> (Aneesh Kumar K. V.'s message
	of "Mon, 27 Jul 2009 22:42:14 +0530")
Message-ID: <87skgikjr8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> On Mon, Jul 27, 2009 at 05:42:52PM +0100, Alan Cox wrote:
>> 
>> > > -			if (count > tty->receive_room) {
>> > > +			if (count > tty->receive_room)
>> > >  				count = tty->receive_room;
>> > > -				done = 0;
>> > > -			}
>> > >  			char_buf = head->char_buf_ptr + head->read;
>> > >  			flag_buf = head->flag_buf_ptr + head->read;
>> > >  			head->read += count;
>> > > _
>> > 
>> > 
>> > I still have the "compile in emacs" bug. So this patch along with
>> > http://article.gmane.org/gmane.linux.kernel/869824 doesn't fix the
>> > bug for me.
>> 
>> Can you stick some printk calls in and debug it further then because at
>> with the fixes Ogawa provided I'm finding it impossible to reproduce even
>> on an 8 way x86.
>> 
>> What hardware are you using ?
>
> My T60p lenovo laptop. If you can send me a debug prink patch i can redo the
> test with the patches. I don't know what data i should start collecting so
> that it make sense. This is the patch i tried

If I read that part of emacs correctly, it seems to be assuming the data
was already sent to master side if the child process was exited.

And if it's right, unfortunately, I guess we can't return -EAGAIN in
this case to preserve behavior.

Aneesh, can you get the log of strace of emacs error case?

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

	{
		int on = 1;
		ioctl(master, FIONBIO, &on);
	}

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
				printf("some app doesn't expect EAGAIN\n");
				break;
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
