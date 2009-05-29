Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZE2CGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZE2CGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 22:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZE2CGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 22:06:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38616 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZE2CGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 22:06:04 -0400
Date: Fri, 29 May 2009 11:04:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [BUG?] pipe close v.s. poll() can cause hang.
Message-Id: <20090529110430.e962dd9f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, a user reporetd following issue.
==
  1. Assume there are 2 threads. Thread-A and Thread-B.
  2. Thread-A creats pipe() => fd-for-read and fd-for-write are created.
  3-a. Thread-A close fd-fow-write.
  3-b. Thread-B wait for fd-for-read via poll().
  4. Thread-A close fd-for-read.
  5. thread-B's poll() cannot be waken up by event "4", sometimes.
==
It seems 3-a and 3-b occurs in racy condition.

IIUC, following code
==
 638 static int
 639 pipe_release(struct inode *inode, int decr, int decw)
 640 {
 641         struct pipe_inode_info *pipe;
 642 
 643         mutex_lock(&inode->i_mutex);
 644         pipe = inode->i_pipe;
 645         pipe->readers -= decr;
 646         pipe->writers -= decw;
 647 
 648         if (!pipe->readers && !pipe->writers) {
 649                 free_pipe_info(inode);
 650         } else {
 651                 wake_up_interruptible_sync(&pipe->wait);
 652                 kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 653                 kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 654         }
 655         mutex_unlock(&inode->i_mutex);
 656 
 657         return 0;
 658 }
==
Doesn't call any wake_up() if readers==0 && writers==0 even if
there is a poll() waiter.

Eeasy test program is below. hang_thread() will hang soon on SMP.
This behavior seems to be from very old age...

strace of sample program is below.
==
[pid 21616] pipe([3, 4])                = 0
[pid 21616] futex(0x600cc0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
[pid 21617] <... futex resumed> )       = 0
[pid 21616] <... futex resumed> )       = 1
[pid 21617] write(2, "!"..., 1!)         = 1
[pid 21616] close(4 <unfinished ...>
[pid 21617] poll([{fd=3, events=POLLIN}], 1, -1 <unfinished ...>
[pid 21616] <... close resumed> )       = 0
[pid 21616] close(3)                    = 0
[pid 21616] write(2, "@"..., 1@)         = 1
[pid 21616] pipe([3, 4])                = 0
==
Thread-A as pid 21616
Thread-B as pid 21617 

fd=3 is reused but Thread-B just waits.


Thanks,
-Kame
==
#include <stdio.h>
#include <pthread.h>
#include <poll.h>
#include <unistd.h>
#include <pthread.h>
#include <errno.h>

int fds[2];
pthread_barrier_t barrier;

void *hang_thread(void*data)
{
        struct pollfd pollfds;
        int ret;
        char buf[32];

        while (1) {
                pthread_barrier_wait(&barrier);
                fprintf(stderr, "!");
                pollfds.fd = fds[0];
                pollfds.events = POLLIN;
                ret = poll(&pollfds, 1, -1);

                if (pollfds.revents & POLLIN) {
                        ret = read(fds[0], buf, sizeof(buf));
                }
        }
}

int main(int argc, char *argv[])
{
        pthread_t thread;
        char buf[20];

        pthread_barrier_init(&barrier, NULL, 2);
        pthread_create(&thread, NULL, hang_thread, NULL);

        while (1) {
                pipe(fds);
                pthread_barrier_wait(&barrier);
                close(fds[1]);
                close(fds[0]);
                fprintf(stderr, "@");
        }
}


