Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbXEGB1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbXEGB1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXEGB1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:27:03 -0400
Received: from ozlabs.org ([203.10.76.45]:40400 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbXEGB1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:27:01 -0400
Subject: Re: get_user_pages vs mmap MAP_FIXED bug
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1178434876.12284.175.camel@localhost.localdomain>
References: <1178434876.12284.175.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 07 May 2007 11:26:44 +1000
Message-Id: <1178501204.7731.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-06 at 17:01 +1000, Rusty Russell wrote:
> This bug is in 2.6.21-rc7-mm2, but not 2.6.21.  Haven't tested
> 2.6.21-mm1 yet.

OK, 2.6.21-mm1 fails too.  2.6.21-git6 ... is fine.

Here's a standalone test using ptrace.  No kernel module req'd.

	rusty@debussy:~/linux-2.6.21-mm1$ ../examiner 
	ptrace says 0, child says 0x464c457f

Any clues Andrew?  Or should I take your patches and do a binary search?

Cheers,
Rusty.

/* Make with gcc -o examine_mmap examine_mmap.c */
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ptrace.h>
#include <signal.h>
#include <err.h>
#include <errno.h>

/* Compare ptrace (ie. get_user_pages()) result with what process
 * actually sees. */
int main(int argc, char *argv[])
{
	long int *p, res1, res2;
	int fd, child;
	int child2parent[2], parent2child[2];
	char c = 0;

	pipe(child2parent);
	pipe(parent2child);

	if ((child = fork()) == 0) {

		/* Grab some file to mmap. */
		fd = open(argv[0], O_RDONLY);
		if (fd < 0)
			err(1, "open");

		/* Map one page of it at 4096 */
		p = (void *)4096;
		if (mmap(p, 4096, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED, fd, 0) != p)
			err(1, "mmap");

		/* This makes it work. */
		if (argc > 1 && strcmp(argv[1], "--touch") == 0)
			printf("Before: %p == %li\n", p, *p);

		/* Allow parent to trace me. */
		if (ptrace(PTRACE_TRACEME, 0, 0, 0) != 0)
			err(1, "PTRACE_TRACEME");

		/* Tell parent to look at memory, and wait for response. */
		write(child2parent[1], &c, 1);
		read(parent2child[0], &c, 1);

		/* Write what we see to pipe */
		write(child2parent[1], p, sizeof(*p));
		exit(0);
	}

	/* Wait for child to be ready. */
	read(child2parent[0], &c, 1);

	/* Child needs to be stopped.  What a POS. */
	kill(child, SIGSTOP);
	sleep(1);

	/* Get ptrace to tell us what the kernel thinks the value is */
	res1 = ptrace(PTRACE_PEEKDATA, child, (void *)4096, NULL);

	/* Continue the child. */
	ptrace(PTRACE_DETACH, child, NULL, NULL);

	/* Tell the child to continue. */
	write(parent2child[1], &c, 1);

	/* Get the child's opinion of what the value is. */
	read(child2parent[0], &res2, sizeof(res2));

	printf("ptrace says %#lx, child says %#lx\n", res1, res2);
	exit(res1 == res2 ? 0 : 1);
}


