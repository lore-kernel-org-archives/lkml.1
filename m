Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbXJaSzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbXJaSzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 14:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbXJaSzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 14:55:24 -0400
Received: from host06.cybernetics.com ([206.246.200.22]:3375 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXJaSzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 14:55:23 -0400
X-Greylist: delayed 1791 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 14:55:23 EDT
Message-ID: <4728C89E.6040402@cybernetics.com>
Date: Wed, 31 Oct 2007 14:25:34 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: BUG? task->nsproxy == NULL after main calls pthread_exit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After the main thread in a multi-threaded program calls pthread_exit()
while other threads are still running, attempting to open files in /proc
(like /proc/mounts) fails because get_proc_task(inode)->nsproxy == NULL
(see fs/proc/base.c::mounts_open).  I tested kernel 2.6.12 + glibc 2.3.5
and kernel 2.6.23 + glibc 2.6.1 with the same results.  Here is a
program to illustrate:

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

static void *thread_func(void *x)
{
   for (;;)
      {
      int fd;

      fd = open("/proc/mounts", O_RDONLY);
      if (fd == -1)
         {
         perror("open /proc/mounts");
         abort();
         }
      close(fd);

      printf("/proc/mounts still accessible\n");

      sleep(1);
      }

   return NULL;
}

int main(int argc, char *argv[])
{
   pthread_t thr;
   pthread_attr_t thread_attr;

   pthread_attr_init(&thread_attr);
   pthread_attr_setdetachstate(&thread_attr, PTHREAD_CREATE_DETACHED);
   pthread_create(&thr, &thread_attr, &thread_func, NULL);
   sleep(5);
   printf("main thread calling pthread_exit...\n");
   pthread_exit(NULL);

   return 0;
}

Compile with "-D_REENTRANT -lpthread".  Output:

/proc/mounts still accessible
/proc/mounts still accessible
/proc/mounts still accessible
/proc/mounts still accessible
/proc/mounts still accessible
main thread calling pthread_exit...
open /proc/mounts: Invalid argument
Aborted

If it is valid for main() to call pthread_exit() while leaving other
threads running, then this is a bug.  If it is not valid, then this
problem can be ignored, but let me know if that is the case.  AFAIK,
everything else seems to work in this situation; problems opening files
in /proc being the only exception that I have encountered so far.

Thanks,
Tony Battersby

