Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbXF3HmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbXF3HmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 03:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXF3HmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 03:42:11 -0400
Received: from pcls2.std.com ([192.74.137.142]:55536 "EHLO TheWorld.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752229AbXF3HmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 03:42:10 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jun 2007 03:42:10 EDT
From: Alan Curry <pacman@TheWorld.com>
Message-Id: <200706300735.l5U7Z72L191585@shell01.TheWorld.com>
Subject: tty O_NONBLOCK spooky action at a distance
To: linux-kernel@vger.kernel.org
Date: Sat, 30 Jun 2007 03:35:07 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Short version: writing to a tty with O_NONBLOCK will block if there is
another, unrelated process already blocking inside a write() to the same tty.

Long version:

Take this test program, nbhello.c

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
  int fd;

  if(argc!=2) {
    fprintf(stderr, "Usage: %s tty\n", argv[0]);
    return 2;
  }
  fd=open(argv[1], O_WRONLY|O_NONBLOCK);
  if(fd<0) {
    perror("open");
    return 1;
  }
  if(write(fd, "hello world\n", 12)<0) {
    perror("write");
    return 1;
  }
  return 0;
}

Open a tty for testing purposes; I do this by logging in on tty11, but
starting a new xterm works just as well. Press ^S on the test tty to block
output. Back on your original tty:

$ cc nbhello.c -o nbhello
$ ./nbhello /dev/tty11
This will report an EAGAIN, as it should.

$ echo block > /dev/tty11
This will block, as it should. ^C to kill it.

$ echo block > /dev/tty11 &
$ ./nbhello /dev/tty11
With a background process blocking in an attempt to write() on the tty, the
non-blocking write also blocks! If you kill the background process first, the
"non-blocking" write will wake up and return EAGAIN.

I've been surprised before by the way O_NONBLOCK propagates from a forked
child back up to the parent's file descriptors, but this not the same thing.
The file descriptors involved here have come from 2 completely separate
open()s.

(Real-world impact of this bug: wall(1) uses O_NONBLOCK to avoid getting
stuck if a user has paused a tty with ^S, but the kernel doesn't respect the
flag and wall gets stuck anyway. When the user finally hits ^Q -- hours,
days, or weeks later -- he gets the message and so does everyone who was
after him in utmp.)

-- 
Alan Curry
pacman@world.std.com
