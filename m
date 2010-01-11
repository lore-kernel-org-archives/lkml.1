Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008Ab0AKGmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0AKGmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853Ab0AKGmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:42:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59859
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab0AKGmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:42:44 -0500
Date: Sun, 10 Jan 2010 22:42:53 -0800 (PST)
Message-Id: <20100110.224253.00558907.davem@davemloft.net>
To: jengelh@medozas.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fstat seems broken on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LSU.2.01.1001102347280.23052@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1001082355250.20848@obet.zrqbmnf.qr>
	<20100110.131158.242584083.davem@davemloft.net>
	<alpine.LSU.2.01.1001102347280.23052@obet.zrqbmnf.qr>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Mon, 11 Jan 2010 00:15:17 +0100 (CET)

> On Sunday 2010-01-10 22:11, David Miller wrote:
>>
>>> libc6   2.10.2-4
>>
>>Perfect, now you just have to audit what changed between the -2 and
>>the -4 package to find the bug :-)
> 
> I really do not believe you when you say your glibc is not affected.

Why not :-)

davem@sunset:~$ dpkg-query -W | grep libc6-sparc64
libc6-sparc64	2.10.2-2
davem@sunset:~$ cat fstat_test.c
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	struct stat sb;
	int fd = open("foo", O_RDWR | O_CREAT, 0666);

	if (fd < 0)
		abort();
	if (fstat(fd, &sb) < 0)
		abort();
	printf("%lu.%lu\n", sb.st_mtim.tv_sec, sb.st_mtim.tv_nsec);
	if (stat("foo", &sb) < 0)
		abort();
	printf("%lu.%lu\n", sb.st_mtim.tv_sec, sb.st_mtim.tv_nsec);
	if (fstatat(AT_FDCWD, "foo", &sb, 0) < 0)
		abort();
	printf("%lu.%lu\n", sb.st_mtim.tv_sec, sb.st_mtim.tv_nsec);
	return 0;
}
davem@sunset:~$ gcc -m64 -o fstat_test fstat_test.c
davem@sunset:~$ ./fstat_test
1261510364.0
1261510364.0
1261510364.0
davem@sunset:~$ 

But, indeed when I run it under strace64 it goes:

open("foo", O_RDWR|O_CREAT, 0666)       = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 2), ...}) = 0

I wonder why I get a sane output from the test program even though
it's not using fstat64.

>  - I now found and fixed the problem, here is the patch for
>    you to study (as code speaks louder)
> 
> Index: glibc-2.10.1/sysdeps/unix/sysv/linux/sparc/sparc64/fxstat.c
> ===================================================================
> --- glibc-2.10.1.orig/sysdeps/unix/sysv/linux/sparc/sparc64/fxstat.c
> +++ glibc-2.10.1/sysdeps/unix/sysv/linux/sparc/sparc64/fxstat.c
> @@ -1 +1 @@
> -#include "../../fxstat.c"
> +#include "../../i386/fxstat.c"
> 
> (Hint: Compare with sparc64/lxstat.c

Thanks a lot!

Please submit this to the glibc/eglibc folks for inclusion!
