Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYKTKRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYKTKRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 05:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYKTKQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 05:16:52 -0500
Received: from mail.pcs.de ([145.253.69.50]:30372 "EHLO mail.pcs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbYKTKQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 05:16:51 -0500
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2008 05:16:50 EST
Date: Thu, 20 Nov 2008 11:06:19 +0100 (CET)
From: Thomas Pfaff <tpfaff@pcs.com>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: linux-kernel@vger.kernel.org
Subject: Question about TTY_DO_WRITE_WAKEUP
Message-ID: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 20 Nov 2008 10:06:19.0965 (UTC) FILETIME=[A273DED0:01C94AF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have written a program that reads and writes data to the serial uart using 
async io.
Unfortunately it does not work properly because a SIGIO is never gerated when 
output becomes possible, the reason is that TTY_DO_WRITE_WAKEUP is not set for 
most of the tty drivers. After i set the bit in serial_core.c the program works 
as expected.
Now i wonder why TTY_DO_WRITE_WAKEUP is almost always disabled ?

Below is a test case.

Thank you in advance,

Thomas

#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#include <sys/fcntl.h>
#include <termios.h>
#include <errno.h>

static const char outbuf [] = "01234567890abcdef\n";

static void sigio_handler (int sig __attribute__((unused)))
{
}

static int sigact (int sig, void (*handler)(int))
{	
	struct sigaction sa;

	memset (&sa, 0, sizeof (sa));

	sa.sa_flags = SA_NOCLDWAIT | SA_NOCLDSTOP;
	sigfillset (&sa.sa_mask);
	sa.sa_handler = handler;

	return sigaction (sig, &sa, NULL);
}

static int uart_set_termio (int fd)
{
	struct termios term;

	if (tcgetattr (fd, &term) == -1)
		return -1;

	term.c_cflag = B19200 | CS8 | CREAD | CLOCAL;
	term.c_iflag = IGNPAR;
	term.c_oflag = 0;
	term.c_lflag = 0;

	term.c_cc [VTIME] = 0;
	term.c_cc [VMIN] = 0;

	return tcsetattr (fd, TCSAFLUSH, &term);
}

static int uart_fd_init (int fd)
{
	if (fcntl (fd, F_SETSIG, 0) == -1 ||
			fcntl (fd, F_SETOWN, getpid ()) == -1)
		return -1;

	return fcntl (fd, F_SETFL, fcntl (fd, F_GETFL) | O_ASYNC | O_NONBLOCK);
}

static int uart_sig_init (void)
{
	sigset_t sigset;

	if (sigact (SIGIO, sigio_handler) == -1)
		return -1;

	if (sigemptyset (&sigset) == -1 ||
			sigaddset (&sigset, SIGIO) == -1)
		return -1;

	return sigprocmask (SIG_BLOCK, &sigset, NULL);
}

int main (int argc, char *argv [])
{
	int uart_fd;
	sigset_t sigmask;
	const int outbuflen = strlen (outbuf);
	const char *dev = "/dev/ttyS0";

	if (argc > 1)
		dev = argv [1];

	if (uart_sig_init () == -1)
		return EXIT_FAILURE;

	uart_fd = open (dev, O_RDWR | O_NOCTTY | O_NONBLOCK);
	if (uart_fd == -1)
		return EXIT_FAILURE;

	if (uart_set_termio (uart_fd) == -1 ||
			uart_fd_init (uart_fd) == -1)
		return EXIT_FAILURE;

	if (sigprocmask (SIG_SETMASK, NULL, &sigmask) == -1 ||
			sigdelset (&sigmask, SIGIO) == -1)
		return EXIT_FAILURE;

	while (1)
	{
		int written;
		int towrite = outbuflen;
		const char *buf = outbuf;

		while (towrite)
		{
			written = write (uart_fd, buf, towrite);
			if (written == -1)
			{
				if (errno == EAGAIN)
				{
					sigsuspend (&sigmask);
					continue;
				}
				else
					return EXIT_FAILURE;
			}

			buf += written;
			towrite -= written;
		}
	}

	return EXIT_SUCCESS;
}
