Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZA3IQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZA3IQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZA3IQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:16:41 -0500
Received: from mout.perfora.net ([74.208.4.195]:60335 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZA3IQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:16:40 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Nathanael Hoyle <nhoyle@hoyletech.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1233302349.17301.27.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
	 <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
	 <1233297635.17301.11.camel@localhost>
	 <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>
	 <1233302349.17301.27.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 03:16:36 -0500
Message-Id: <1233303396.17301.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18KEGLO92KWImHjk9spXGCHTgiwJ7zWtjoU0W+
 XAjNn8vevuA9kt5F5MNX+A5eCO+Knk0LD8j6eAzWt7VOLDc3Wq
 TSTVoxVph3nhkjYuA+M4FGCl2L6gfga
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 02:59 -0500, Nathanael Hoyle wrote:
> On Fri, 2009-01-30 at 08:21 +0100, Jan Engelhardt wrote:
> > On Friday 2009-01-30 07:40, Nathanael Hoyle wrote:
> > >On Fri, 2009-01-30 at 07:16 +0100, Jan Engelhardt wrote:
> > >
> > >The one discussion I saw referencing SCHED_BATCH seemed to imply that it
> > >was a non-standard kernel patch by Con Kolivas in one of his -ck
> > >variants that never made it into mainline and is not being maintained.
> > >Is this inaccurate?
> > 
> > The presence of SCHED_BATCH in linux/sched.h tells me it is available
> > (on the other hand, SCHED_ISO, also from -ck, is only listed as a comment.)
> > 
> 
> Fair enough. I should have re-checked recent sources after your mention
> rather than going on the old thread I found.
> 
> > >I was unfamiliar with SCHED_IDLE. Having done a little Googling now, I
> > >finally find reference to the man page for sched_setscheduler(2). This
> > >appears that it is likely what I wanted.
> > >
> > >I think the information I had been able to find was somehwat out of
> > >date.
> > 
> > The manpage does say it, but if your local distro does not 
> > mention SCHED_BATCH/SCHED_IDLE, then that's a pretty sad distro.
> > 
> > The doc in sched_setschedule seems complete to me as of man-pages 3.13.
> > 
> > >Is there currently a standardized userspace tool to use to run a command
> > >in order to alter its scheduling class? Obviously writing one would be
> > >trivial, but didn't know if something like:
> > 
> > man chrt
> 
> The latest version of man chrt that I can find implies that it handles
> SCHED_BATCH but not SCHED_IDLE. To that end, if anyone else is
> interested, I have thrown together the above-suggested 'runidle' which
> will invoke the passed command using the SCHED_IDLE scheduler; it's
> nothing fancy.
> 
> I am running foldingathome under it at the moment, and it seems to be
> improving the situation somewhat, but I still need/want to test with
> Mike's referenced patches.
> 

<snipped old version, because of a fixed goof, and this has better
formatting for mail client>


#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sched.h>
#include <linux/sched.h>

extern char **environ;

int
main(int argc, char **argv) {
  struct sched_param sp;
  sp.sched_priority = 0;

  if(argc<2) {
    perror("Must specify at least one argument: the path to " \
      "the program to execute. Additional arguments may be " \
      "specified which will be passed to the called program.");
    return EXIT_FAILURE;
  }

  if(sched_setscheduler(0, SCHED_IDLE, &sp) == -1) {
    perror("Failed to alter scheduling class!");
    return EXIT_FAILURE;
  }

  if(argc==2) {
    if(execve(argv[1], NULL, environ) == -1) {
      perror("Failed to execve target!");
    }
  } else {
    if(execve(argv[1], argv+1, environ) == -1) {
      perror("Failed to execve target!");
    }
  }

  /* should be unreachable */
  return EXIT_FAILURE;
}

> -Nathanael

