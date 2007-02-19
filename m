Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXBSSp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXBSSp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbXBSSp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:45:58 -0500
Received: from nef2.ens.fr ([129.199.96.40]:3303 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463AbXBSSp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:45:57 -0500
X-Greylist: delayed 2414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 13:45:57 EST
Date: Mon, 19 Feb 2007 19:05:41 +0100
From: David Madore <david.madore@ens.fr>
To: linux-kernel@vger.kernel.org
Subject: setsystz utility: set the kernel's system time zone
Message-ID: <20070219180541.GA20634@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Mon, 19 Feb 2007 19:05:42 +0100 (CET)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.9 (nef2.ens.fr [129.199.96.32]); Mon, 19 Feb 2007 19:05:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

// Hi.  I felt the need to write the following little utility (which
// is mostly comments, really), to prevent my digital camera's image
// files to have incorrect modification when I mount them under Linux.
// Comments are welcome.

// Enjoy!

/// cut after ///
/* setsystz: set the Linux kernel's idea of the time zone */
/* David A. Madore <david.madore@ens.fr>, 2007-02-19.  Public Domain */

/* Rationale: the Linux kernel needs to have some idea of time zone,
   notably because some filesystems (e.g. FAT) store file
   modification/access times in local time rather than UTC(=GMT)
   (which Unix uses internally for all timestamps).  This kernel
   (system) time zone is set through the settimeofday() system call;
   unfortunately, there does not seem to be a practical way to do it,
   and some (all?) Linux distributions get it wrong: e.g., simply
   because my CMOS clock is set to GMT (as recommended), my Debian
   init scripts apparently assume that any FAT filesystems I'll be
   mounting will have GMT timestamps (uh?).  Note: IMHO, the whole
   idea of having a per-system global time zone is probably wrong, and
   FAT mounts should probably better use an adhoc option to specify
   GMT offset (defaulting to the libc time zone for the mount
   process), and CMOS clock thingies should be kept separate. */

/* What this does: called without arguments, setsystz sets the
   kernel's time zone to the userland's time zone (typically from the
   /etc/localtime file, overridden by the TZ environment variable if
   it exists).  With an explicit argument, setsystz sets the kernel's
   time zone to that many minutes west of GMT (see settimeofday(2) man
   page for explanations).  This program takes care _not_ to
   change/warp the system clock while changing the time zone: see
   comments on avoid_linux_braindeadness() below. */

/* How to use: probably just call "setsystz" (as root) before mounting
   a FAT filesystem, if the files it contains are in your usual system
   time zone.  If they are, e.g., from the Shanghai time zone, then
   use "TZ=Asia/Shanghai setsystz" before mounting.  Note: it's
   probably wiser not to do this while there are existing mounted FAT
   filesystems. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>

int
auto_minutes (void)
     /* Determine localtime GMT offset and return it in minutes west
	of GMT (as expected by a struct timezone).  This will
	typically use the TZ environment variable if it is defined or,
	as a fallback, the contents of /etc/localtime (see libc
	documentation for more details). */
{
  time_t now = time(NULL);
  struct tm *lt = localtime (&now);
  long int gmtoff = lt->tm_gmtoff;
  fprintf (stderr, "GMT offset=%lds\n", gmtoff);
  if ( gmtoff%60 )
    fprintf (stderr, "warning: GMT offset %lds "
	     "is not an integer number of minutes\n", gmtoff);
  gmtoff /= 60;
  return -gmtoff;
}

void
avoid_linux_braindeadness (void)
     /* We ___DO NOT___ want to change the system time, only the
	system time zone!  Since Linux does something special
	(warp_clock() semantics) the very first time settimeofday() is
	called with tz!=NULL, we call it once with tz pointing to a
	GMT-filled structure, i.e., tz->tz_minuteswest==0 (so the
	clock won't be warped).  The settimeofday(2) man page claims
	that tz->tz_minuteswest==0 will not count toward cancelling
	the warp_clock() semantics, i.e., that our trick does not
	work: fortunately, it is wrong (at least under 2.6.19 and
	whereabouts) and our trick works.  Note however that this
	still resets the time interpolator the first time:
	unfortunately there does not seem to be a way around this
	problem.  See /usr/src/linux/kernel/time.c for details
	about the whole mess.  -- David A. Madore 2007-02-19 */
{
  struct timezone tz;
  memset (&tz, 0, sizeof(struct timezone));
  tz.tz_minuteswest = 0;
  tz.tz_dsttime = 0;
  settimeofday (NULL, &tz);
}

int
main (int argc, char *argv[])
{
  int minuteswest;
  if ( argc == 1 )
    minuteswest = auto_minutes();
  else if ( argc == 2 )
    {
      if ( sscanf (argv[1], "%d", &minuteswest) != 1 )
	{
	  fprintf (stderr, "invalid argument: %s\n", argv[1]);
	  exit (2);
	}
    }
  else
    {
      fprintf (stderr, "wrong number or arguments\n");
      exit (2);
    }
  struct timezone tz;
  memset (&tz, 0, sizeof(struct timezone));
  tz.tz_minuteswest = minuteswest;
  tz.tz_dsttime = 0;
  fprintf (stderr, "setting system time zone to tz_minuteswest=%d\n",
	   minuteswest);
#if 1
  avoid_linux_braindeadness ();
  if ( settimeofday (NULL, &tz) == -1 )
    {
      perror ("settimeofday()");
      exit (EXIT_FAILURE);
    }
#endif
  return 0;
}
/// cut before ///
