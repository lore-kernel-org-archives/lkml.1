Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXJ2Wge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXJ2Wge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXJ2WgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:36:23 -0400
Received: from rtr.ca ([76.10.145.34]:2343 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbXJ2WgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:36:22 -0400
Message-ID: <47266064.9030306@rtr.ca>
Date: Mon, 29 Oct 2007 18:36:20 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Marc Lehmann <linux-kernel@tst.eu>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll design problems with common fork/exec patterns
References: <20071027062236.GA12476@schmorp.de> <4722F575.8080204@cosmosbay.com> <20071027085125.GC12326@schmorp.de> <Pine.LNX.4.64.0710270950170.12127@alien.or.mcafeemobile.com> <20071027173828.GY10199@1wt.eu>
In-Reply-To: <20071027173828.GY10199@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
>> On Sat, 27 Oct 2007, Marc Lehmann wrote:
>>
>>>> Please provide some code to illustrate one exact problem you have.
>>>    // assume there is an open epoll set that listens for events on fd 5
>>>    if (fork () = 0)
>>>      {
>>>        close (5);
>>>        // fd 5 is now removed from the epoll set of the parent.
>>>        _exit (0);
>>>      }
..
> from what I understand, Marc is not asking for the code above to remove
> the fd from the epoll set, but he's in fact complaining that he *observed*
> that the fd was removed from the epoll set in the *parent* process when
> the child closes it, which is of course not expected at all. As strange
> as it looks like, this might need investigation. It is possible that there
> is some strange bug somewhere in some kernel versions.
> 
> Marc, I think that if you indicate the last kernel version on which you
> observed this and provide a very short and easy reproducer, it would
> help everyone investigating this. Basically something which reports "OK"
> or "KO".

That's how I read it, too.
So basically, a program like this, perhaps.
Except that, here running 2.6.23.1, it works just fine (no removal bug).

#include <sys/epoll.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/socket.h>

static int del_from_epoll_set (int efd, int fd, const char *msg)
{
	struct epoll_event e;

	memset(&e, 0, sizeof(e));
	e.data.fd = fd;
	if (epoll_ctl(efd, EPOLL_CTL_DEL, fd, &e) == -1) {
		int err = errno;
		fprintf(stderr, "epoll_ctl(DEL) failed (%s): %s\n", msg, strerror(err));
		return -1;
	}
	return 0;
}

static int add_to_epoll_set (int efd, int fd, __uint32_t events, const char *msg)
{
	struct epoll_event e;

	memset(&e, 0, sizeof(e));
	e.events = events;
	e.data.fd = fd;
	if (epoll_ctl(efd, EPOLL_CTL_ADD, fd, &e) == -1) {
		int err = errno;
		fprintf(stderr, "epoll_ctl(ADD) failed (%s): %s\n", msg, strerror(err));
		return -1;
	}
	return 0;
}

int main (int argc, char **argv)
{
	int	efd, sd, fds[2];
	pid_t	cpid;

	if (pipe(fds) == -1) {
		perror("pipe()");
		exit(1);
	}
	sd = socket(PF_INET, SOCK_STREAM, 0);
	if (sd == -1) {
		perror("socket");
		exit(1);
	}

	efd = epoll_create(5);
	if (efd == -1) {
		perror("epoll_create");
		exit(1);
	}

	if (add_to_epoll_set(efd, fileno(stdin), EPOLLIN, "stdin"))
		exit(1);
	if (add_to_epoll_set(efd, fileno(stdout), EPOLLOUT, "stdout"))
		exit(1);
	if (add_to_epoll_set(efd, fds[0], EPOLLIN, "pipe_read"))
		exit(1);
	if (add_to_epoll_set(efd, fds[1], EPOLLOUT, "pipe_write"))
		exit(1);
	if (add_to_epoll_set(efd, sd, EPOLLIN|EPOLLOUT, "socket"))
		exit(1);

	// assume there is an open epoll set that listens for events on fd 5
	cpid = fork();
	if (cpid == 0) {
		close(fileno(stdin));
		close(fileno(stdout));
		close(fds[0]);
		close(fds[1]);
		close(sd);
		exit(0);
	}
	waitpid(cpid, NULL, 0);

	// now test whether the fd's are still in the epoll set:
	add_to_epoll_set(efd, sd, EPOLLIN|EPOLLOUT, "sd");
	add_to_epoll_set(efd, fds[0], EPOLLIN,  "fds[0]");
	add_to_epoll_set(efd, fds[1], EPOLLOUT, "fds[1]");
	add_to_epoll_set(efd, fileno(stdin),  EPOLLIN,  "fileno(stdin)");
	add_to_epoll_set(efd, fileno(stdout), EPOLLOUT, "fileno(stdout)");

	del_from_epoll_set(efd, sd, "sd");
	del_from_epoll_set(efd, fds[0], "fds[0]");
	del_from_epoll_set(efd, fds[1], "fds[1]");
	del_from_epoll_set(efd, fileno(stdin), "fileno(stdin)");
	del_from_epoll_set(efd, fileno(stdout), "fileno(stdout)");

	printf("Done.\n");
	exit(0);
}

