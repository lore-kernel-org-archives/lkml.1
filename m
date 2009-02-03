Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZBCDH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZBCDH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZBCDHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:07:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56501 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbZBCDHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:07:46 -0500
Message-ID: <4987B46D.2070500@cn.fujitsu.com>
Date: Tue, 03 Feb 2009 11:05:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
References: <4976D77C.3020107@cn.fujitsu.com> <6599ad830901210241y1fe96d93x462e23d9883e7ab5@mail.gmail.com>
In-Reply-To: <6599ad830901210241y1fe96d93x462e23d9883e7ab5@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040001070407080704090609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040001070407080704090609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

on 2009-1-21 18:41 Paul Menage wrote:
> On Wed, Jan 21, 2009 at 12:06 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> The task still allocated the page caches on old node after modifying its
>> cpuset's mems when 'memory_spread_page' was set, it is caused by the old
>> mem_allowed_list of the task, the current kernel doesn't updates it unless some
>> function invokes cpuset_update_task_memory_state(), it is too late sometimes.
> 
> Can you give a more concrete example of how the current code can break?

I'm sorry for replying late.

A test program which reproduces the problem on current kernel is attached.
This program just repeats reading the file "DATAFILE" after receiving SIGUSR1
and exits after receiving SIGINT.
	Test Task
	  sigsuspend();
	  while(!end) {
		read DATAFILE;
		sigsuspend();
	  }

Steps to reproduce:
# mkdir /dev/cpuset
# mount -t cpuset xxx /dev/cpuset
# mkdir /dev/cpuset/0
# echo 0 > /dev/cpuset/0/cpus
# echo 1-2 > /dev/cpuset/0/mems
# echo 1 > /dev/cpuset/0/memory_spread_page
# dd if=/dev/zero of=DATAFILE bs=4096 count=20480	<- create a 80M file
# ./mem-hog &
# tst_pid=$!
# cat /proc/$tst_pid/status
...
Mems_allowed:   00000000,00000007
Mems_allowed_list:      0-2
...
# echo $tst_pid > /dev/cpuset/0/tasks
# echo 3 > /proc/sys/vm/drop_caches
# find /sys/devices/system/node/ -name "meminfo" -exec cat {} + | grep "FilePages"
Node 0 FilePages:         15488 kB
Node 1 FilePages:             0 kB
Node 2 FilePages:             0 kB
# cat /proc/$tst_pid/status
...
Mems_allowed:   00000000,00000007		<- old memory list
Mems_allowed_list:      0-2
...
# kill -s sigusr1 $tst_pid

	...wait a moment...

# find /sys/devices/system/node/ -name "meminfo" -exec cat {} + | grep "FilePages"
Node 0 FilePages:         97548 kB
Node 1 FilePages:             0 kB
Node 2 FilePages:             0 kB
# cat /proc/$tst_pid/status
...
Mems_allowed:   00000000,00000007               <- old memory list
Mems_allowed_list:      0-2
...

>> We must update the mem_allowed_list of the tasks in time.
> 
> This is a fairly fundamental change to the way that mems_allowed is
> handled - it dates back to fairly early in cpusets' history.

I found Mr. Paul Jackson had discussed it with somebody:

  http://lkml.org/lkml/2004/8/11/211

According to what Mr. Paul Jackson said, my patch has a serious bug.
Maybe we fix this bug just by choosing a good callsite for
cpuset_update_task_memory_state().

Thanks!
Miao

>> - * The task_struct fields mems_allowed and mems_generation may only
>> - * be accessed in the context of that task, so require no locks.
>> + * The task_struct fields mems_allowed may only be accessed in the context
>> + * of that task, so require no locks.
> 
> This comment is no longer true, since mems_allowed is now being
> updated by other processes.
> 
> What's to stop a task reading current->mems_allowed and racing with an
> update from update_tasks_nodemask() ? Or else, why can that not lead
> to badness?
> 
> Paul
> 
> 
> 


--------------040001070407080704090609
Content-Type: text/x-csrc;
 name="mem-hog.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mem-hog.c"

/* gcc mem-hog.c -g -o mem-hog -Wall -Wextra */

#include <stdio.h>
#include <unistd.h>
#include <err.h>
#include <signal.h>
#include <fcntl.h>

#define UNUSED __attribute__ ((unused))
#define BUFFER_SIZE 1024

volatile int end;

void sighandler1(UNUSED int signo)
{
}

void sigint(UNUSED int signo)
{
	end = 1;
}

int page_cache_hog(void)
{
	int fd = -1;
	char buff[BUFFER_SIZE];
	char path[BUFFER_SIZE];
	int ret = 0;

	sprintf(path, "%s", "DATAFILE");
	fd = open(path, O_RDONLY);
	if (fd == -1) {
		warn("open %s failed", path);
		return -1;
	}

	while ((ret = read(fd, buff, sizeof(buff))) > 0);
	if (ret == -1)
		warn("read %s failed", path);

	close(fd);
	return ret;
}

int mem_hog(void)
{
	sigset_t sigset;
	int ret = 0;

	if (sigemptyset(&sigset) < 0)
		err(1, "sigemptyset()");
	sigsuspend(&sigset);

	while (!end) {
		ret = page_cache_hog();

		sigsuspend(&sigset);
	}

	return ret;
}

int main(UNUSED int argc, UNUSED char *argv[])
{
	struct sigaction sa1, sa2;

	sa1.sa_handler = sighandler1;
	if (sigemptyset(&sa1.sa_mask) < 0)
		err(1, "sigemptyset()");

	sa1.sa_flags = 0;
	if (sigaction(SIGUSR1, &sa1, NULL) < 0)
		err(1, "sigaction()");

	sa2.sa_handler = sigint;
	if (sigemptyset(&sa2.sa_mask) < 0)
		err(1, "sigemptyset()");

	sa2.sa_flags = 0;
	if (sigaction(SIGINT, &sa2, NULL) < 0)
		err(1, "sigaction()");

	return mem_hog();
}

--------------040001070407080704090609--

