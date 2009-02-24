Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbZBXR00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbZBXR00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbZBXRZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:25:58 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:1623 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567AbZBXRZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:25:57 -0500
Message-ID: <49A42DA2.5080101@cybernetics.com>
Date: Tue, 24 Feb 2009 12:25:54 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] epoll fixes and cleanups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[forgot to CC linux-kernel]

Patch #1 fixes an important bug where epoll_wait can incorrectly
return events for closed fds.  Below is a test program that can
reliably test for the problem.  This bug has the potential to confuse
or crash userspace programs, so I consider it to be high-priority.
For example, a program could crash if it closes a fd, frees the
associated event.data.ptr, calls epoll_wait, and then gets back an
event with the freed event.data.ptr.

The test program uses a thread blocked in read() to keep the struct
file refcount from dropping to 0.  Then a different thread does close()
and then epoll_wait(), and epoll_wait() incorrectly returns an event
on the closed fd.  There are many more ways to trigger the bug with
a multi-threaded userspace program.  A single-threaded userspace
program may also trigger the bug if the kernel ever calls fput() from
outside a system call (e.g. from keventd or some other kernel thread).
It is difficult to know all the potential ways that the bug could be
triggered without doing an audit of a lot of kernel code.

Patches #2 and #3 fix some minor issues; the rest are just cleanups.

I would like to have patch #1 included in 2.6.29 and -stable.
Assuming that everyone agrees that the patch is indeed important,
it will unfortunately conflict with some of the patches currently
in -mm and linux-next that are queued for 2.6.30.  Some of my other
5 patches also conflict with the epoll patches currently in -mm, but
they are lower priority and do not need to go into 2.6.29 or -stable.
So I will post two versions of my patchset - one against 2.6.29 and
one against the current epoll patches in -mm.  I will need some help
from the authors of the other patches in -mm to resolve the conflicts
against my patch #1; my patches #2 - #6 hopefully won't conflict if
you use the versions for -mm and apply after the other patches in -mm.
I have never handled this situation before, so my apologies if I am
stepping on anyone's toes.

Other things I noticed while auditing epoll code:

The following functions could use spin_lock_irq() instead
of spin_lock_irqsave(): ep_remove, ep_insert, ep_modify,
ep_scan_ready_list, and ep_poll.  One of my patches changes
ep_modify to use spin_lock_irq while making some other changes, but
I haven't done anything with the others.  Some people prefer to use
spin_lock_irqsave() always because it is harder to use incorrectly,
so it is just a matter of preference.

epoll uses wake_up_locked() instead of wake_up() for ep->wq although
it never uses eq->wq.lock; presumably ep->lock outside of the
wait_queue_head_t protects the wait queue internals, but I don't see
this documented anywhere.

---

/*
This program tests for a bug in the kernel's implementation of epoll where
epoll_wait can incorrectly return an event on a fd that has been closed.
You can work around the kernel bug by calling epoll_ctl(EPOLL_CTL_DEL) before
closing the fd.

Compile:
   gcc -D_REENTRANT -o epoll_wait_bug epoll_wait_bug.c -lpthread
*/

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>

#define EPOLL_DATA_MAGIC 0x1234567890123456ULL

static int fd[2];

static void *thread_func(void *arg)
{
   for (;;)
      {
      char ch;

      if (read(fd[0], &ch, sizeof(ch)) <= 0)
         {
         break;
         }
      }

   return NULL;
}

int main(int argc, char *argv[])
{
   pthread_attr_t detached_thread_attr;
   pthread_t thread;
   struct epoll_event evt;
   int epfd;
   int ret;
   int exit_status = EXIT_FAILURE;

   epfd = epoll_create(1);
   if (epfd == -1)
      {
      perror("epoll_create");
      exit(EXIT_FAILURE);
      }

   if (socketpair(AF_UNIX, SOCK_STREAM, 0, fd))
      {
      perror("socketpair");
      exit(EXIT_FAILURE);
      }

   evt.events   = EPOLLOUT;
   evt.data.u64 = EPOLL_DATA_MAGIC;
   if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd[0], &evt))
      {
      perror("epoll_ctl EPOLL_CTL_ADD");
      exit(EXIT_FAILURE);
      }

   pthread_attr_init(&detached_thread_attr);
   pthread_attr_setdetachstate(&detached_thread_attr,
                               PTHREAD_CREATE_DETACHED);
   if (pthread_create(&thread,
                      &detached_thread_attr,
                      &thread_func,
                      NULL))
      {
      perror("pthread_create");
      exit(EXIT_FAILURE);
      }

   sleep(1);

#if 0
   /* This works around the kernel bug. */
   if (epoll_ctl(epfd, EPOLL_CTL_DEL, fd[0], &evt))
      {
      perror("epoll_ctl EPOLL_CTL_DEL");
      exit(EXIT_FAILURE);
      }
#endif

   close(fd[0]);

   memset(&evt, 0, sizeof(evt));
   ret = epoll_wait(epfd, &evt, 1, 100);
   switch (ret)
      {
      case -1 :
         perror("epoll_wait");
         break;

      case 0 : /* timeout */
         printf("This kernel does not have the epoll_wait bug.\n");
         exit_status = EXIT_SUCCESS;
         break;

      case 1 :
         if (evt.data.u64 == EPOLL_DATA_MAGIC)
            {
            /* This is what happens for kernels with the bug. */
            printf("KERNEL BUG DETECTED: epoll_wait returned an event on a "
                   "closed fd\n");
            }
         else
            {
            printf("KERNEL BUG DETECTED: epoll_wait returned a bad event\n");
            }
         break;

      default :
         printf("KERNEL BUG DETECTED: epoll_wait returned unexpected value "
                "%d\n", ret);
      }

   return exit_status;
}



