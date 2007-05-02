Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbXEBKCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbXEBKCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbXEBKCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:02:21 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:44923 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbXEBKCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:02:20 -0400
Date: Wed, 2 May 2007 12:02:16 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [RFC] splice() and readahead interaction
Message-Id: <20070502120216.7350691c.dada1@cosmosbay.com>
In-Reply-To: <377550217.31149@ustc.edu.cn>
References: <377506695.54393@ustc.edu.cn>
	<p73odlc34ga.fsf@bingen.suse.de>
	<20070425160400.GA27954@mail.ustc.edu.cn>
	<20070425160844.GA30132@one.firstfloor.org>
	<377550217.31149@ustc.edu.cn>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu

Since you work on readahead, could you please find the reason following program triggers a problem in splice() syscall ?

Description :

I tried to use splice(SPLICE_F_NONBLOCK) in a non blocking environnement, in an attempt to implement cheap AIO, and zero-copy splice() feature.

I quicky found that readahead in splice() is not really working.

To demonstrate the problem, just compile the attached program, and use it to pipe a big file (not yet in cache) to /dev/null :

$ gcc -o spliceout spliceout.c
$ spliceout -d BIGFILE  | cat >/dev/null
offset=49152 ret=49152
offset=65536 ret=16384
offset=131072 ret=65536
...no more progress...   (splice() returns -1 and EAGAIN)

reading splice(SPLICE_F_NONBLOCK) syscall implementation, I expected to exploit its ability to call readahead(), and do some progress if pages are ready in cache.

But apparently, even on an idle machine, it is not working as expected.

Thank you

/*
 * Usage :
 *          spliceout [-d] file | some_other_program
 */
#ifndef _LARGEFILE64_SOURCE
# define _LARGEFILE64_SOURCE 1
#endif
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/poll.h>

#ifndef __do_splice_syscall_h__
#define __do_splice_syscall_h__

#include <sys/syscall.h>
#include <unistd.h>

#if defined(__i386__)

/* From kernel tree include/asm-i386/unistd.h
*/
#ifndef __NR_splice
#define __NR_splice 313
#endif
#ifndef __NR_vmsplice
#define __NR_vmsplice 316
#endif

#elif defined(__x86_64__)

/* From kernel tree include/asm-x86_64/unistd.h
*/
#ifndef __NR_splice
#define __NR_splice 275
#endif
#ifndef __NR_vmsplice
#define __NR_vmsplice 278
#endif

#else
#error unsupported architecture
#endif

/* From kernel tree include/linux/pipe_fs_i.h
*/
#define SPLICE_F_MOVE (0x01) /* move pages instead of copying */
#define SPLICE_F_NONBLOCK (0x02) /* don't block on the pipe splicing
(but */
/* we may still block on the fd we splice */
/* from/to, of course */
#define SPLICE_F_MORE (0x04) /* expect more data */
#define SPLICE_F_GIFT (0x08) /* pages passed in are a gift */

#ifndef SYS_splice
#define SYS_splice __NR_splice
#endif
#ifndef SYS_vmsplice
#define SYS_vmsplice __NR_vmsplice
#endif


static inline
int splice(int fd_in, off64_t *off_in, int fd_out, off64_t *off_out,
	   size_t len, unsigned int flags)
{
	return syscall(SYS_splice, fd_in, off_in, fd_out, off_out, len, flags);
}

struct iovec;

static inline
int vmsplice(int fd, const struct iovec *iov,
	     unsigned long nr_segs, unsigned int flags)
{
return syscall(SYS_vmsplice, fd, iov, nr_segs, flags);
}


#endif /* __do_splice_syscall_h__ */


void usage(int code)
{
	fprintf(stderr, "Usage : spliceout [-d] file\n");
	exit(code);
}

int main(int argc, char *argv[])
{
	int ret;
	int opt;
	int fd_in;
	int dflg = 0;
	loff_t offset = 0;
	loff_t lastoffset = ~0;
	struct stat st;

	while ((opt = getopt(argc, argv, "d")) != EOF) {
		if (opt == 'd')
			dflg++;
	}
	if (optind == argc)
		usage(1);
	if (fstat(1, &st) == -1)
		usage(1);
	if (!S_ISFIFO(st.st_mode)) {
		fprintf(stderr, "stdout is not a pipe\n");
		exit(1);
	}
	fd_in = open(argv[optind], O_RDONLY);
	if (fd_in == -1) {
		perror(argv[optind]);
		exit(1);
	}
	for (;;) {
		struct pollfd pfd;
		pfd.fd = fd_in;
		pfd.events = POLLIN;
		poll(&pfd, 1, -1); /* just in case we support poll() on this file to avoid a loop */
		ret = splice(fd_in, &offset,
			     1, NULL,
			     16*4096, SPLICE_F_NONBLOCK);
		if (ret == 0)
			break;
		if (dflg && lastoffset != offset) {
			fprintf(stderr, "offset=%lu ret=%d\n", (unsigned long)offset, ret);
			lastoffset = offset;
		}
	}
	return 0;
}

