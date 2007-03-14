Return-Path: <linux-kernel-owner+w=401wt.eu-S1422658AbXCNU5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422658AbXCNU5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422660AbXCNU5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:57:34 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:50209 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422658AbXCNU5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:57:33 -0400
Date: Wed, 14 Mar 2007 16:57:32 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070314205732.GI22466@csclub.uwaterloo.ca>
References: <20070313224817.GF22466@csclub.uwaterloo.ca> <20070314093146.GE24556@enneenne.com> <20070314131934.GL22464@csclub.uwaterloo.ca> <20070314140623.GF3802@enneenne.com> <20070314141253.GM22464@csclub.uwaterloo.ca> <20070314142710.GJ3802@enneenne.com> <20070314144251.GN22464@csclub.uwaterloo.ca> <20070314145239.GK3802@enneenne.com> <20070314153705.GP22464@csclub.uwaterloo.ca> <20070314154732.GP3802@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314154732.GP3802@enneenne.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 04:47:32PM +0100, Rodolfo Giometti wrote:
> On Wed, Mar 14, 2007 at 11:37:05AM -0400, Lennart Sorensen wrote:
> > Well here is my current version of the refclock_nmea.c.patch for
> > LinuxPPS.  It now uses /dev/gps# for the nmea messages and /dev/pps# for
> > the PPS device (which in my case is of course the same device).  I am
> > running some more tests on it, but I think it is OK.
> 
> Thanks, published. :)

Well it does work for our GPS receiver at least.  Of course I have to
change the baud rate in the driver since our unit doens't use the NNEA
standard 4800.  And the configure script for ntp doesn't recognize the
v2 PPSAPI, so I have to manually explain to it that I have the PPS API
and it should actually include it.

Here is my utility for enabling PPS on my serial port now.  Seems less
of a pain that patching setserial and including that (with 256MB flash
space, setserial seems wasteful).

ppsctl.c
--------
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <linux/serial.h>

void usage(char *name) {
	fprintf(stderr,"Usage: %s /dev/port [0|1]\n",name);
	fprintf(stderr,"Where 0 means disable PPS and 1 means enable PPS\n");
}

int main(int argc, char *argv[]) {
	int fd;
	char *state;

	if(argc<3) {
		usage(argv[0]);
		return 1;
	}
	fd = open(argv[1],O_RDWR);
	if (fd>=0) {
		struct serial_struct  ss;
		if (ioctl(fd, TIOCGSERIAL, &ss) < 0 ) {
			perror("TIOCGSERIAL");
			return 1;
		} else {
			if(strcmp(argv[2],"1")==0) {
				ss.flags |= ASYNC_HARDPPS_CD;
				state="enabled";
			} else if(strcmp(argv[2],"0")==0) {
				ss.flags &= ~ASYNC_HARDPPS_CD;
				state="disabled";
			} else {
				fprintf(stderr,"Invalid state argument \"%s\"\n",argv[2]);
				return 1;
			}
			if (ioctl(fd, TIOCSSERIAL, &ss) < 0) {
				perror("TIOCSSERIAL");
			} else {
				fprintf(stderr,"PPS on %s is now %s\n",argv[1],state);
			}
		}
	} else {
		fprintf(stderr,"Can't open \"%s\":",argv[1]);
		perror("");
	}
	return 0;
}

/* vim:ts=4:shiftwidth=4:
 * */

--
Len Sorensen
