Return-Path: <linux-kernel-owner+w=401wt.eu-S1761459AbYBFBYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761459AbYBFBYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbYBFBXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:23:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbYBFBXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:23:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper (bisected)
Date: Wed, 6 Feb 2008 02:21:20 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <200802010237.59320.rjw@sisk.pl> <200802020040.05519.rjw@sisk.pl> <b647ffbd0802051346k563a44f7t42739515c130124b@mail.gmail.com>
In-Reply-To: <b647ffbd0802051346k563a44f7t42739515c130124b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060221.21824.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 of February 2008, Dmitry Adamushko wrote:
> Rafael, any progress with this issue? (a few questions below).
> 
> > >
> > > Does this artsmessage thing also run with RT priority?
> >
> > Well, it's in a strange state (after it's broken).  From top:
> >
> > PR = -51
> > NI = 0
> > S = R
> > %CPU = 0.0
> > %MEM = 0.0
> 
> cat /proc/$PID/stat ; sleep 3; cat /proc/$PID/stat ?
> cat /proc/sched_debug; sleep 3 ; cat /proc/sched_debug

Well, instead please find appended a test program that allows me to trigger
the issue.

To reproduce it do:

$ gcc -o break_scheduler break_scheduler.c
$ su -
[...]
# chown root.root $PATH_TO_BINARY/break_scheduler
# chmod u+s $PATH_TO_BINARY/break_scheduler
^D
$ ./break_scheduler

It behaves normally if run directly by root and it also behaves normally if
the execv() at the end is removed.

Hope that helps to understand what the problem is.

Thanks,
Rafael

---
#include <stdio.h>
#include <sys/stat.h>
#include <sys/resource.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>
#include <sched.h>

#define EXECUTE "/bin/ls"

void adjust_priority()
{
	int sched = sched_getscheduler(0);

	if(sched == SCHED_FIFO || sched == SCHED_RR) {
		puts(">> non-standard scheduling policy");
	} else {
		struct sched_param sp;
		long int priority = (sched_get_priority_max(SCHED_FIFO) +
			             sched_get_priority_min(SCHED_FIFO))/2;
		
		sp.sched_priority = priority;

		if (sched_setscheduler(0, SCHED_FIFO, &sp) != -1) {
			printf(">> running as realtime process now "
				"(priority %ld)\n", priority);
		} else {
			/* can't set realtime priority */
			puts(">> could not set realtime priority");
		}
	}
}

int main(int argc, char **argv)
{
	adjust_priority();

	/* drop root privileges if running setuid root
	   (due to realtime priority stuff) */
	if (geteuid() != getuid()) {
		seteuid(getuid());
		if (geteuid() != getuid()) {
			perror("setuid()");
			return 2;
		}
	}

	puts("OK");

	if(argc == 0)
		return 1;

	argv[0] = EXECUTE;
	execv(EXECUTE, argv);
	perror(EXECUTE);

	return 0;
}
