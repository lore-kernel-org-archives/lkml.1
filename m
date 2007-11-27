Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbXK0Sx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbXK0Sx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbXK0Sxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:53:46 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:36649 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbXK0Sxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:53:45 -0500
Date: Tue, 27 Nov 2007 13:53:21 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: tcsetattr(fd, TCSAFLUSH) on an O_ASYNC pts device always fails
Message-ID: <20071127185321.GA8546@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tcsetattr(fd, TCSAFLUSH) will always return -EINTR on a pts device
when O_ASYNC has been set.  This is demonstrated by the test program
below - just compile and follow the instructions.  You'll get an
infinite stream of SIGIOs and -EINTRs.

The underlying reason is that the pty driver keeps its TTY_THROTTLED
flag set all the time:

static void check_unthrottle(struct tty_struct * tty)
{
	if (tty->count &&
	    test_and_clear_bit(TTY_THROTTLED, &tty->flags) && 
	    tty->driver->unthrottle)
		tty->driver->unthrottle(tty);
}

tty->driver->unthrottle is pty_unthrottle in this case:

static void pty_unthrottle(struct tty_struct * tty)
{
	...
	tty_wakeup(o_tty);
	set_bit(TTY_THROTTLED, &tty->flags);
}

tty_wakeup naturally wakes up any processes sleeping on the device
and also queues a SIGIO to any processes wanting async I/O
notifications.  However, the fact that a SIGIO is queued means that
the ioctl underneath tcsetattr returns -EINTR.  When userspace sees
this and retries the call, we go around the same loop:
	make sure that output is flushed
	call the unthrottle routine because TTY_THROTTLED is set
	deliver another SIGIO
	set TTY_THROTTLED
	return -EINTR

The call stack looks like this:

	kill_fasync
	tty_wakeup
	pty_unthrottle
	check_unthrottle
	n_tty_flush_buffer
	set_termios
	n_tty_ioctl
	tty_ioctl

I'd love to get rid of the set_bit(TTY_THROTTLED, &tty->flags) in
pty_unthrottle, but it's protected by this comment:

/* For PTY's, the TTY_THROTTLED
 * flag is always set, to force the line discipline to always call the
 * unthrottle routine when there are fewer than TTY_THRESHOLD_UNTHROTTLE 
 * characters in the queue.  This is necessary since each time this
 * happens, we need to wake up any sleeping processes that could be
 * (1) trying to send data to the pty, or (2) waiting in wait_until_sent()
 * for the pty buffer to be drained.
 */

Failing that, there should be a relevant state change in the device
before it will deliver a SIGIO.  I just have no idea where to put it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com


#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#define __USE_GNU /* Needed to get F_SETSIG */
#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <termios.h>

int pts_fd;

void sigio(int sig)
{
	struct pollfd fd;
	int err;

	printf("SIGIO\n");

	fd.fd = pts_fd;
	fd.events = POLLIN | POLLPRI | POLLOUT | POLLERR | POLLHUP | POLLNVAL;
	fd.revents = 0;

	err = poll(&fd, 1, 0);
	if (err < 0) {
		perror("poll");
		exit(1);
	}

	printf("poll returns revents = 0x%x\n", fd.revents);
}

int main(int argc, char **argv)
{
	struct termios save;
	int err;
	char c;

	pts_fd = open("/dev/ptmx", O_RDWR);
	if (pts_fd < 0) {
		perror("Opening /dev/ptmx");
		exit(1);
	}

	err = grantpt(pts_fd);
	if (err) {
		perror("grantpt");
		exit(1);
	}

	if (unlockpt(pts_fd) < 0) {
		perror("unlockpt");
		exit(1);
	}

	if((fcntl(pts_fd, F_SETFL, O_ASYNC | O_NONBLOCK) < 0) ||
	   (fcntl(pts_fd, F_SETSIG, SIGIO) < 0) ||
	   (fcntl(pts_fd, F_SETOWN, getpid()) < 0)){
		perror("F_SETFL, F_SETSIG, or F_SETOWN");
		exit(1);
	}

	signal(SIGIO, sigio);

	err = tcgetattr(pts_fd, &save);
	if (err) {
		perror("tcgetattr");
		exit(1);
	}

	printf("Attach screen to %s and hit return here\n", ptsname(pts_fd));

	read(0, &c, 1);

	do {
		err = tcsetattr(pts_fd, TCSAFLUSH, &save);
		if (!err)
			break;
		err = errno;
		perror("tcsetattr");
	} while(err == EINTR);
}
