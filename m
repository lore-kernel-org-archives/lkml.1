Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZDGDUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZDGDUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZDGDU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:20:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50827 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZDGDU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:20:26 -0400
Date: Tue, 7 Apr 2009 13:19:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: [PATCH] powerpc: wire up preadv and pwritev
Message-Id: <20090407131950.9ab4430b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/systbl.h |    2 ++
 arch/powerpc/include/asm/unistd.h |    4 +++-
 2 files changed, 5 insertions(+), 1 deletions(-)

Tested on pseries_defconfig (verified using strace{,64} and inspecting
the files).  Test program (modified from the original because the API and
ABI changed and I added a test with larger offsets):

#if 0
set -x
gcc -Wall -O2 -m32 -o preadv $0
gcc -Wall -O2 -m32 -D_FILE_OFFSET_BITS=64 -DLARGE_TEST -o preadv32 $0
gcc -Wall -O2 -m64 -DLARGE_TEST -o preadv64 $0
./preadv
./preadv32
./preadv64
exit 0
#endif
/*
 * preadv demo / test
 *
 * (c) 2008 Gerd Hoffmann <kraxel@redhat.com>
 * Modified for new ABI and large offset test by Stephen Rothwell
 *
 * build with "sh $thisfile"
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <inttypes.h>
#include <sys/uio.h>

/* ----------------------------------------------------------------- */
/* syscall windup                                                    */

#include <sys/syscall.h>
#if 1
/* WARNING: Be sure you know what you are doing if you enable this.
 * linux syscall code isn't upstream yet, syscall numbers are subject
 * to change */
# ifndef __NR_preadv
#  ifdef __i386__
#   define __NR_preadv  333
#   define __NR_pwritev 334
#  endif
#  ifdef __x86_64__
#   define __NR_preadv  295
#   define __NR_pwritev 296
#  endif
#  ifdef __powerpc__
#   define __NR_preadv	319
#   define __NR_pwritev	320
#  endif
# endif
#endif
#ifndef __NR_preadv
# error preadv/pwritev syscall numbers are unknown
#endif

#define HALF_BITS (sizeof(unsigned long)*4)

static ssize_t preadv(int fd, const struct iovec *iov, int iovcnt,
		      off_t offset)
{
	return syscall(__NR_preadv, fd, iov, iovcnt,
		       (unsigned long)offset,
		       (unsigned long)((offset >> HALF_BITS) >> HALF_BITS));
}

static ssize_t pwritev(int fd, const struct iovec *iov, int iovcnt,
		       off_t offset)
{
	return syscall(__NR_pwritev, fd, iov, iovcnt,
		       (unsigned long)offset,
		       (unsigned long)((offset >> HALF_BITS) >> HALF_BITS));
}

/* ----------------------------------------------------------------- */
/* demo/test app                                                     */

static char filename[] = "/tmp/preadv-XXXXXX";
static char outbuf[11] = "0123456789";
static char inbuf[11]  = "----------";

static struct iovec ovec[2] = {{
		.iov_base = outbuf + 5,
		.iov_len  = 5,
	},{
		.iov_base = outbuf + 0,
		.iov_len  = 5,
	}};

static struct iovec ivec[3] = {{
		.iov_base = inbuf + 6,
		.iov_len  = 2,
	},{
		.iov_base = inbuf + 4,
		.iov_len  = 2,
	},{
		.iov_base = inbuf + 2,
		.iov_len  = 2,
	}};

void cleanup(void)
{
	unlink(filename);
}

int main(int argc, char **argv)
{
	int fd, rc;

	fd = mkstemp(filename);
	if (-1 == fd) {
		perror("mkstemp");
		exit(1);
	}
	atexit(cleanup);

	/* write to file: "56789-01234" */
	rc = pwritev(fd, ovec, 2, 0);
	if (rc < 0) {
		perror("pwritev");
		exit(1);
	}

	/* read from file: "78-90-12" */
	rc = preadv(fd, ivec, 3, 2);
	if (rc < 0) {
		perror("preadv");
		exit(1);
	}

	printf("result  : %s\n", inbuf);
	printf("expected: %s\n", "--129078--");

#ifdef LARGE_TEST

	/* write to file: "56789-01234" */
	rc = pwritev(fd, ovec, 2, 0x300000000ULL);
	if (rc < 0) {
		perror("pwritev");
		exit(1);
	}

	/* read from file: "78-90-12" */
	rc = preadv(fd, ivec, 3, 0x300000000ULL + 2);
	if (rc < 0) {
		perror("preadv");
		exit(1);
	}

	printf("result  : %s\n", inbuf);
	printf("expected: %s\n", "--129078--");

#endif

	exit(0);
}


diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index fe16649..3fb6d9e 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -322,3 +322,5 @@ SYSCALL_SPU(epoll_create1)
 SYSCALL_SPU(dup3)
 SYSCALL_SPU(pipe2)
 SYSCALL(inotify_init1)
+COMPAT_SYS_SPU(preadv)
+COMPAT_SYS_SPU(pwritev)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index e07d0c7..7e03ebe 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -341,10 +341,12 @@
 #define __NR_dup3		316
 #define __NR_pipe2		317
 #define __NR_inotify_init1	318
+#define __NR_preadv		319
+#define __NR_pwritev		320
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		319
+#define __NR_syscalls		321
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
-- 
1.6.2.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
