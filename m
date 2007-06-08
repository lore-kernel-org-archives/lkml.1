Return-Path: <linux-kernel-owner+w=401wt.eu-S970134AbXFHQLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970134AbXFHQLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969333AbXFHQLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:11:24 -0400
Received: from [198.99.130.12] ([198.99.130.12]:37410 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S967044AbXFHQLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:11:22 -0400
Date: Fri, 8 Jun 2007 12:10:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Syslets - Fix cachemiss_thread return value
Message-ID: <20070608161048.GA8147@c2.user-mode-linux.org>
References: <20070531181923.GA9904@c2.user-mode-linux.org> <20070607232733.GM17082@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607232733.GM17082@mami.zabbo.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:27:33PM -0700, Zach Brown wrote:
> On Thu, May 31, 2007 at 02:19:23PM -0400, Jeff Dike wrote:
> > cachemiss_thread should explicitly return 0 or error instead of
> > task_ret_reg(current) (which is -ENOSYS anyway) because
> > async_thread_helper is careful to put the return value in eax anyway.
> 
> Here's the fix I came up with for this.  Untested (my test boxes are
> busy doing some aio+syslet perf runs :)).  What do you guys think?

I don't like it :-)

It's better though.  With the test below (a hacked up version of
aio-read.c), I still get -ENOSYS leaking out of sys_async_exec when it
tries an async setuid.

I haven't started looking into this yet.

				Jeff

-- 
Work email - jdike at linux dot intel dot com


#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <linux/unistd.h>
#include <sys/fcntl.h>
#include <sys/stat.h>
#include "sys.h"

/*
 * Set up a syslet atom:
 */
static void
init_atom(struct syslet_uatom *atom, int nr,
	  void *arg_ptr0, void *arg_ptr1, void *arg_ptr2,
	  void *arg_ptr3, void *arg_ptr4, void *arg_ptr5,
	  void *ret_ptr, unsigned long flags, struct syslet_uatom *next)
{
	atom->nr = nr;
	atom->arg_ptr[0] = (u64)(unsigned long)arg_ptr0;
	atom->arg_ptr[1] = (u64)(unsigned long)arg_ptr1;
	atom->arg_ptr[2] = (u64)(unsigned long)arg_ptr2;
	atom->arg_ptr[3] = (u64)(unsigned long)arg_ptr3;
	atom->arg_ptr[4] = (u64)(unsigned long)arg_ptr4;
	atom->arg_ptr[5] = (u64)(unsigned long)arg_ptr5;
	atom->ret_ptr = (u64)(unsigned long)ret_ptr;
	atom->flags = flags;
	atom->next = (u64)(unsigned long)next;
}

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))

static int collect_status(void)
{
	int n = 0;

	sys_async_wait(1, async_head.user_ring_idx, &async_head);
	while(completion_ring[async_head.user_ring_idx] != 0){
		completion_ring[async_head.user_ring_idx++] = 0;
		async_head.user_ring_idx %= ARRAY_SIZE(completion_ring);
		n++;
	}

	return n;
}

int oneshot(struct syslet_uatom *atom, int syscall)
{
	struct syslet_uatom *done;
	int err = -1;

	init_atom(atom, __NR_getuid, NULL, NULL, NULL, NULL, NULL, NULL,
		  &err, SYSLET_ASYNC, NULL);
	if(async_head.new_thread_stack == 0)
		async_head.new_thread_stack = thread_stack_alloc();
	done = sys_async_exec(atom, &async_head);
	if(done == atom)
		printf("setuid was synchronous\n");
	else if(done == NULL){
		collect_status();
	}
	else {
		perror("async setuid");
		exit(1);
	}

	return err;
}

int main(int argc, char *argv[])
{
	struct syslet_uatom *atoms, *done;
	struct stat stbuf;
	char *file, *buf;
	int fd, err, npages, i, len, async, sync;

	if(argc < 2){
		fprintf(stderr, "Usage : aio-read file\n");
		exit(1);
	}

	file = argv[1];
	fd = open(file, O_RDONLY);
	if(fd < 0){
		perror("open");
		exit(1);
	}

	err = fstat(fd, &stbuf);
	if(err < 0){
		perror("stat");
		exit(1);
	}

	buf = malloc(stbuf.st_size);
	if(buf == NULL){
		perror("malloc");
		exit(1);
	}

	len = getpagesize();
	npages = (stbuf.st_size + len - 1) / len;
	atoms = malloc(npages * sizeof(struct syslet_uatom));
	if(atoms == NULL){
		perror("malloc atoms");
		exit(1);
	}

	async_head_init();
	async = 0;
	sync = 0;
	printf("head pid = %d, uid = %d\n", getpid(), getuid());
	for(i = 0; i < npages; i++){
		char *ptr = &buf[i * len];
		init_atom(&atoms[i], __NR_sys_read, &fd, &ptr, &len,
			  NULL, NULL, NULL, NULL, 0, NULL);
		if(async_head.new_thread_stack == 0)
			async_head.new_thread_stack = thread_stack_alloc();
		done = sys_async_exec(&atoms[i], &async_head);
		if(done == &atoms[i]){
			sync++;
			continue;
		}
		else if(done < 0)
			perror("sys_async_exec");

		async++;
		printf("async = %d, pid = %ld\n", async, syscall(__NR_gettid));
		if(async < ARRAY_SIZE(completion_ring))
			continue;

		async -= collect_status();
	}

	while(async)
		async -= collect_status();

	if(setuid(500) < 0){
		perror("setuid");
		exit(1);
	}

	err = oneshot(&atoms[0], __NR_getuid);
	printf("uid1 = %d\n", err);
	printf("current uid1 = %d\n", getuid());
	
	err = oneshot(&atoms[0], __NR_getuid);
	printf("uid2 = %d\n", err);
	printf("current uid2 = %d\n", getuid());

	err = oneshot(&atoms[0], __NR_getuid);
	printf("uid3 = %d\n", err);
	printf("current uid3 = %d\n", getuid());

	pause();

	return 0;
}
