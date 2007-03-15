Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbXCOK2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbXCOK2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbXCOK2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:28:42 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:47373 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbXCOK2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:28:40 -0400
Date: Thu, 15 Mar 2007 11:29:12 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Message-ID: <20070315102912.GV3802@enneenne.com>
References: <20070314093146.GE24556@enneenne.com> <20070314131934.GL22464@csclub.uwaterloo.ca> <20070314140623.GF3802@enneenne.com> <20070314141253.GM22464@csclub.uwaterloo.ca> <20070314142710.GJ3802@enneenne.com> <20070314144251.GN22464@csclub.uwaterloo.ca> <20070314145239.GK3802@enneenne.com> <20070314153705.GP22464@csclub.uwaterloo.ca> <20070314154732.GP3802@enneenne.com> <20070314205732.GI22466@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GFHULmA0mO3kKGOo"
Content-Disposition: inline
In-Reply-To: <20070314205732.GI22466@csclub.uwaterloo.ca>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--GFHULmA0mO3kKGOo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 14, 2007 at 04:57:32PM -0400, Lennart Sorensen wrote:
> 
> Well it does work for our GPS receiver at least.  Of course I have to
> change the baud rate in the driver since our unit doens't use the NNEA
> standard 4800.  And the configure script for ntp doesn't recognize the
> v2 PPSAPI, so I have to manually explain to it that I have the PPS API
> and it should actually include it.

Can you please provide a little help about it? A patch against current
wiki wuold be great! ;)

> Here is my utility for enabling PPS on my serial port now.  Seems less
> of a pain that patching setserial and including that (with 256MB flash
> space, setserial seems wasteful).

I modify your code add inquiry functionality. Can you please test it?

See http://ftp.enneenne.com/pub/misc/linuxpps/test/ and the wiki at
http://wiki.enneenne.com/index.php/LinuxPPS_support#Compiling_the_code.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

--GFHULmA0mO3kKGOo
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="ppsctl.c"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <linux/serial.h>

void usage(char *name)
{
        fprintf(stderr, "usage: %s <ttyS> [enable|disable]\n", name);

	exit(EXIT_FAILURE);
}

int main(int argc, char *argv[])
{
	int fd, ret;
	struct serial_struct  ss;

	if (argc < 2)
		usage(argv[0]);

        fd = open(argv[1], O_RDWR);
        if (fd < 0) {
                perror("open");
		exit(EXIT_FAILURE);
	}

       	ret = ioctl(fd, TIOCGSERIAL, &ss);
	if (ret < 0 ) {
		perror("ioctl(TIOCGSERIAL)");
		exit(EXIT_FAILURE);
	}

	if (argc < 3) {		/* just read PPS status */
		printf("PPS is %sabled\n",
			ss.flags & ASYNC_HARDPPS_CD ? "en" : "dis");
		exit(EXIT_SUCCESS);
	}

	if (argv[2][0] == 'e' || argv[2][0] == '1')
		ss.flags |= ASYNC_HARDPPS_CD;
	else if (argv[2][0] == 'd' || argv[2][0] == '0')
		ss.flags &= ~ASYNC_HARDPPS_CD;
	else {
		fprintf(stderr, "invalid state argument \"%s\"\n", argv[2]);
		exit(EXIT_FAILURE);
	} 

	ret = ioctl(fd, TIOCSSERIAL, &ss);
	if (ret < 0) {
		perror("ioctl(TIOCSSERIAL)");
		exit(EXIT_FAILURE);
	}

        return 0;
}

--GFHULmA0mO3kKGOo--
