Return-Path: <linux-kernel-owner+w=401wt.eu-S933422AbZDINBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbZDINBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934301AbZDINA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:00:57 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:42132 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137AbZDINAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ovc9WPstP9dnqBir8LOY4oujViTxk+5tBYDenG0YgzlVozQcSrBVFcffoGHe5S6Kkx
         dTQkj6fmauojst15hgwPklfIXQpzkMqf5+oa5NAhQIinNpQx2xIMTqKPk02n7UJqOVvf
         3bHj5eIsngD3JJ7udfRdyPxtBsKUn06k6koWs=
MIME-Version: 1.0
Date: Thu, 9 Apr 2009 18:30:53 +0530
Message-ID: <9debc4410904090600k3250cc9y5c713c1b0ef6d16b@mail.gmail.com>
Subject: [PATCH] cacheflush system call not returning -EINVAL
From: Maxin John <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, ralf@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

cacheflush man page states that cacheflush() will set  EINVAL if cache
parameter is not one of ICACHE, DCACHE, or BCACHE.
In order to confirm this behavior, I have executed the below listed
program (cacheflush_check.c) in Toshiba RBTX4937 board (MIPS) with
2.6.29.1 kernel.

=================================================================
 /*
  *  cacheflush_check.c
  *
  *  Description:
  * Tests EINVAL error of cacheflush system call
  *
  *  Expected behaviour:
  * cacheflush() should return -EINVAL when cache parameter is not one
of ICACHE, DCACHE, or BCACHE.
  *
  */

#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#if defined __mips__
#include <asm/cachectl.h>

int cacheflush(char *addr, int nbytes, int cache)
{
        return syscall(__NR_cacheflush, addr, nbytes, cache);
}
#endif /* __mips__ */


int main()
{
        /* cacheflush man page states that cacheflush() is only
applicable to MIPS architecture */

        char *addr = NULL;

        /* Create some user address range */
        addr = malloc(getpagesize());
        if (addr == NULL) {
                printf("Malloc error\n");
                exit(-1);
        }

        /* Invokes cacheflush() with proper parameters */
        cacheflush(addr, getpagesize(), ICACHE);
        cacheflush(addr, getpagesize(), DCACHE);
        cacheflush(addr, getpagesize(), BCACHE);

       /* Tests whether cacheflush() returns -EINVAL */
        if (cacheflush(addr, getpagesize(), 0) < 0) {
                if (errno == EINVAL) {
                        printf("cacheflush EINVAL : TEST PASS\n");
                        exit(0);
                } else {
                        printf("cacheflush EINVAL : TEST FAIL\n");
                }
        }
        printf("cacheflush EINVAL : TEST FAIL\n");
        return -1;
}
=======================================================

I have observed that the test failed when executed in target board.

-bash-3.2# ./cacheflush_err_check
cacheflush EINVAL : TEST FAIL

I have checked the 'arch/mips/mm/cache.c' and observed that the
cacheflush() implementation is not setting EINVAL.
So, I have modified this file by including these two lines for EINVAL.
 if ( (cache != ICACHE) && (cache != DCACHE) && (cache != BCACHE) )
            return -EINVAL;

After this modification, I have straced the cacheflush_check program
with the modified kernel:
strace ./cacheflush_check
....
set_thread_area(0x2aacd3e0)             = 0
mprotect(0x2ac1a000, 28672, PROT_READ)  = 0
mprotect(0x2aad4000, 4096, PROT_READ)   = 0
brk(0)                                  = 0x411000
brk(0x432000)                           = 0x432000
syscall(0x1033, 0x411050, 0x1000, 0x1, 0x418e90, 0x2aac5280, 0x418e90,
0x2aad4ef0) = 0
syscall(0x1033, 0x411050, 0x1000, 0x2, 0x418e90, 0x2aac5280, 0x418e90,
0x2aad4ef0) = 0
syscall(0x1033, 0x411050, 0x1000, 0x3, 0x418e90, 0x2aac5280, 0x418e90,
0x2aad4ef0) = 0
syscall(0x1033, 0x411050, 0x1000, 0, 0x418e90, 0x2aac5280, 0x418e90,
0x2aad4ef0) = -1 EINVAL (Invalid argument)
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0
old_mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x2ac2a000
....

The test passes when executed in the modified kernel.I have tested
this patch and seen no adverse effects.
Cheers,

Signed-off-by: Maxin B. John <maxinbjohn@gmail.com>

--------
diff -uNr linux-2.6.29.1/arch/mips/mm/cache.c
linux-2.6.29.1-a/arch/mips/mm/cache.c
--- linux-2.6.29.1/arch/mips/mm/cache.c 2009-04-03 02:25:27.000000000 +0530
+++ linux-2.6.29.1-a/arch/mips/mm/cache.c       2009-04-09
18:24:50.000000000 +0530
@@ -64,6 +64,10 @@
 {
        if (bytes == 0)
                return 0;
+
+       if ( (cache != ICACHE) && (cache != DCACHE) && (cache != BCACHE) )
+                return -EINVAL;
+
        if (!access_ok(VERIFY_WRITE, (void __user *) addr, bytes))
                return -EFAULT;

----------
