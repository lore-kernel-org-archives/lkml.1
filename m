Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZBOBA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZBOBA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 20:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZBOBAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 20:00:12 -0500
Received: from hot.fatooh.org ([208.78.103.127]:57049 "EHLO hot.fatooh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZBOBAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 20:00:10 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 20:00:10 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=fatooh.org; h=message-id:date
	:from:mime-version:to:subject:content-type; q=dns; s=domainkeys;
	 b=cgeTkcXDDZihJHtLe8gThyMjNObuADDjZKS5JsI3YYfPBn0+Y9X09d+Tyf9Ra
	ySVmq0FqJ3mRq9rbbJ6cpzufEdlPCHJZhslPMHDp8EJhAkFZ5meC7zdYXs+rCggc
	ls4f4wsOfxdIblTm2dHNGPSDXl93BmAYMAbxoHkpPtGBg4=
Message-ID: <4997672B.1000301@fatooh.org>
Date: Sat, 14 Feb 2009 16:51:55 -0800
From: Corey Hickey <bugfood-ml@fatooh.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RT scheduling and a way to make a process hang, unkillable
Content-Type: multipart/mixed;
 boundary="------------060409030800070608000806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060409030800070608000806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

I've encountered a bit of a problem in recent kernels that include
"Group scheduling for SCHED_RR/FIFO": it is possible for a process run
by root to hang itself and become unkillable--even by a 'kill -9'.

The following kernel options must be set:
CONFIG_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y

The procedure is for a program to:
1. run as root
2. set SCHED_FIFO
3. change UID to a user with no realtime CPU share allocated

I'm attaching a test program that does exactly this. Run it with no
arguments or examine the print_usage() function to see detailed
information. Briefly, though, it should be run as root with the path to
a program to exec, like:
# ./hangme /bin/bash

The program hangs in a "running" state, like this:
nobody  4357  0.0  0.0    904    16 pts/1    R+   16:09   0:00 /bin/bash

The only way to kill the program is to allocate the corresponding user
some realtime CPU share:
echo 10000 > /sys/kernel/uids/65534/cpu_rt_runtime


This may or may not actually be a bug, but I think it's at least
confusing and unexpected. I had a difficult time narrowing this down
from a problem I was having with Debian's slmodemd package. I think it
would be much nicer for setuid() to return an error if the process is
realtime and the target user doesn't have any CPU share allocated (if
that's feasible).


This problem is similar in principle to a bug reported by Rafael J.
Wysocki on 2008-02-01, and which was subsequently fixed:

http://lkml.org/lkml/2008/1/31/490
http://lkml.org/lkml/2008/2/4/332

If I understand correctly, that was a case in which a program would hang
by doing the following:
1. run setuid-root
2. set SCHED_FIFO
3. change effective UID to match real UID

The difference in my case is that the program is running with root's
real UID as well as effective UID, so, at the time SCHED_FIFO is set,
there's no reason to deny realtime priority. My program changes real UID
 _after_ setting SCHED_FIFO, and that's what causes the hang.


I've run my test program, with the same results, on the following kernels:
2.6.26
2.6.28
2.6.29-rc5

Warning! Under 2.6.28 it is impossible to allocate users CPU share, and
the program will not be killable:

http://lkml.org/lkml/2009/1/14/113


I'm also attaching my kernel configuration. Please let me know if you'd
like more information or for me to test a patch.

Thank you,
Corey

--------------060409030800070608000806
Content-Type: text/x-csrc;
 name="hangme.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hangme.c"

#include <stdio.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sched.h>
#include <errno.h>
#include <limits.h>

#define UID 65534

int adjust_priority() {
  struct sched_param sp;
  sp.sched_priority = sched_get_priority_max(SCHED_FIFO);
  if (sched_setscheduler(0, SCHED_FIFO, &sp) != -1) {
    printf("running as SCHED_FIFO, priority %d\n", sp.sched_priority);
    return 1;
  } else {
    puts("could not set SCHED_FIFO");
    return 0;
  }
}

int change_uid() {
  if (setuid(UID)) {
    int err = errno;
    printf("setuid() failed: %s\n", strerror(err));
    return 0;
  }
  printf("UID set to %d\n", UID);
  return 1;
}


void print_usage() {
  printf(
"This program attempts to illustrate a way by which a process can hang and\n"
"become unkillable:\n"
"1. run as root\n"
"2. set SCHED_FIFO\n"
"3. change to a user with no realtime CPU share allocated\n"
"\n"
"The following kernel options must be set:\n"
"CONFIG_GROUP_SCHED=y\n"
"CONFIG_RT_GROUP_SCHED=y\n"
"CONFIG_USER_SCHED=y\n"
"\n"
"Warning: do not try this under Linux 2.6.28. Due to a bug, you will not be\n"
"able to write to cpu_rt_runtime:\n"
"http://lkml.org/lkml/2009/1/14/113\n"
"This appears to have been fixed in 2.6.29-rc2, but not yet in 2.6.28.5\n"
"\n"
"If you're running a 2.6.29-rc kernel, you should lower root's\n"
"cpu_rt_runtime first:\n"
"# echo 900000 > /sys/kernel/uids/0/cpu_rt_runtime\n"
"\n"
"usage: ./hangme </path/to/executable> [arg1 ...]\n"
"example: ./hangme /bin/bash\n"
"\n"
"The executable specified should take some time to run, otherwise it may\n"
"complete and exit normally within the current time slice (I assume).\n"
"Running a shell is ideal.\n"
);
}

void print_msg() {
  printf(
"\n"
"I am now going to change my UID. See if I hang.\n"
"If I do, try to kill me:\n"
"# kill -9 %d\n"
"Once you're ready to make me unhang:\n"
"# echo 10000 > /sys/kernel/uids/%d/cpu_rt_runtime\n"
"\n"
"Note: if you get an \"Invalid argument\" error with 2.6.29-rc kernels,\n"
"try lowering root's runtime like this:\n"
"# echo 900000 > /sys/kernel/uids/0/cpu_rt_runtime\n"
"...but it doesn't seem to work once this program is running!\n"
"Is that another bug or do I misunderstand?\n"
"\n"
, getpid(), UID);
}

int main(int argc, char **argv)
{
  if (argc <= 1) {
    print_usage();
    return 2;
  }
  if (getuid()) {
    printf("this test only works when run as root\n");
    return 2;
  }
  if (!adjust_priority()) {
    return 1;
  }
  print_msg();
  if (! change_uid()) {
    return 1;
  }
  ++argv;
  printf("going to exec: %s\n", argv[0]);
  execv(argv[0], argv);
  printf("exec failed\n");
  return 1;
}

--------------060409030800070608000806
Content-Type: application/octet-stream;
 name="config-2.6.29-rc5.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="config-2.6.29-rc5.bz2"

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
hWE9KjRg/oXckU4UJBHvsxlA
--------------060409030800070608000806--
