Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbYFLJvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbYFLJvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYFLJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:51:29 -0400
Received: from kz-easy.com ([85.214.25.173]:53610 "EHLO almaty.kz-easy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYFLJv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:51:29 -0400
X-Greylist: delayed 876 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 05:51:28 EDT
Message-ID: <40326.192.35.17.30.1213263410.squirrel@admin.kz-easy.com>
Date: Thu, 12 Jun 2008 15:36:50 +0600 (ALMT)
Subject: EOF from the N_TTY ldisc intended?
From: ibr@kz-easy.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20080612153650_71682"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20080612153650_71682
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hello,

I have a program reading multiple bytes one by one after a select from a
serial port opened in non-blocking mode. If I send one byte to that port,
the first read delivers it, and the second one returns zero. The program
treats this as the end of file and exits. Is this behavior of the default
line discipline intended? I would expect it to return -EAGAIN if there is
no more data in the receive queue.

I'm attaching a sample program.

Please CC to me, I'm not subscribed.

Thanks in advance,
-- 
Baurzhan Ismagulov
http://www.kz-easy.com/

------=_20080612153650_71682
Content-Type: text/x-csrc; name="b.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="b.c"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>


static int
dev_init(int fd)
{
	struct termios t;
	t.c_iflag = IGNBRK | IGNPAR | INPCK;
	t.c_oflag = 0;
	t.c_cflag = B57600 | CLOCAL | CREAD | CS8 | PARENB;
	t.c_lflag = 0;
	memset(t.c_cc, _POSIX_VDISABLE, NCCS);
	t.c_cc[VMIN] = 0;
	t.c_cc[VTIME] = 0;
	if (tcsetattr(fd, TCSANOW, &t) == -1) {
		perror("tcsetattr");
		exit(2);
	}
	return 0;
}

static int
dev_open(const char *name)
{
	int fd = open(name, O_RDWR | O_NONBLOCK);
	if (fd == -1) {
		perror("open");
		exit(2);
	}
	return fd;
}

static ssize_t
dev_read(int fd, void *buf, size_t count)
{
	ssize_t ret = read(fd, buf, count);
	if (ret == -1) {
		perror("read");
		exit(2);
	}
	printf("%s: %d\n", __FUNCTION__, ret);
	return ret;
}

int
main(void)
{
	int fd = dev_open("/dev/ttyS0");
	dev_init(fd);

	fd_set rfds;
	FD_ZERO(&rfds);
	FD_SET(fd, &rfds);
	if (select(fd + 1, &rfds, NULL, NULL, NULL) == -1) {
		perror("select");
		exit(2);
	}

	char buf;
	dev_read(fd, &buf, 1);
	dev_read(fd, &buf, 1);

	return 0;
}
------=_20080612153650_71682--


