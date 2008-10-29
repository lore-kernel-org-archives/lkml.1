Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbYJ2Eat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbYJ2Eat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 00:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYJ2Eal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 00:30:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:20880 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYJ2Eak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 00:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=wcP+RqNJth2WjTcdY4Zqrm5L8KGjUeQ0PWpGcTtnTyB4lMr5cozeecq2wKPQoJ012+
         7NaDHeNgqNWJf43Dgd/fathG6CrKf9ubWo7EtxrwkvGOS1g7r+KTb2Mbxo8P0iSeyQxr
         Vy8+pjs15Wuxl+zdmfM4wQn/zQ9u0aBQCjg0s=
Message-ID: <4907E6B9.8080700@gmail.com>
Date: Tue, 28 Oct 2008 23:29:45 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bert Wesarg <bert.wesarg@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Strange stop-signal behavior in multithreaded program with defunct
 main
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg described a scenario that I quickly replicated on
2.6.28-rc2 (and 2.6.25 -- it's not a regression in 2.6.28-rc)
using the program below: if we have a multithreaded process
with a defunct main thread running on a tty, and that
process is sent a stop signal (either ^Z (SIGTSTP) or a stop
signal sent from another terminal using kill(1)), then:

a) the terminal is locked up; and

b) the program is unresponsive to any other signal, except SIGKILL
or SIGCONT.

An example run:
$ ./pthreads_zombie_main 1      # Creates one thread besides main
0:  0
0:  1
0:  2
^Z

At this point, no shell prompt appears, and typing ^C (or ^\) has no
effect.  The process can be killed (and the terminal restored) by sending
SIGKILL from another terminal.  (If one instead types ^C at the terminal,
and then sends SIGCONT from another terminal, then the terminal is restored
and the program can be seen (via $?) to have terminated because of
SIGINT.)

I'm (wildly) guessing that there is some problem in the terminal driver's
understanding of the state and identify of the foreground job, but am not
sure how to analyze this further.  (I couldn't find a bug report or LKML
thread that seemed to describe exactly this problem.)  Ideas?

Cheers,

Michael

/* pthreads_zombie_main.c */

#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <assert.h>

#define errExitEN(en, msg)      { errno = en; perror(msg); \
                                   exit(EXIT_FAILURE); }

static void *
thread_start(void *arg)
{
     int tnum = (int) arg;
     int j;

     for (j = 0; ; j++) {
         sleep(3);
         printf("%d:  %d\n", tnum, j);
     }
}

int
main(int argc, char *argv[])
{
     int s, tnum;
     pthread_t thr;

     if (argc != 2) {
         fprintf(stderr, "Usage: %s <num-threads>\n", argv[0]);
         exit(EXIT_SUCCESS);
     }

     for (tnum = 0; tnum < atoi(argv[1]); tnum++) {
         s = pthread_create(&thr, NULL, &thread_start, (void *) tnum);
         if (s != 0)
             errExitEN(s, "pthread_create");
     }

     pthread_exit(NULL);
}


