Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868Ab0AKJGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0AKJGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 04:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778Ab0AKJGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 04:06:47 -0500
Received: from borg.medozas.de ([188.40.89.202]:59418 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0AKJGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 04:06:47 -0500
Date: Mon, 11 Jan 2010 10:06:45 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fstat seems broken on sparc64
In-Reply-To: <20100110.224253.00558907.davem@davemloft.net>
Message-ID: <alpine.LSU.2.01.1001111000290.14377@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1001082355250.20848@obet.zrqbmnf.qr> <20100110.131158.242584083.davem@davemloft.net> <alpine.LSU.2.01.1001102347280.23052@obet.zrqbmnf.qr> <20100110.224253.00558907.davem@davemloft.net>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-01-11 07:42, David Miller wrote:
>> On Sunday 2010-01-10 22:11, David Miller wrote:
>>>
>>>> libc6   2.10.2-4
>>>
>>>Perfect, now you just have to audit what changed between the -2 and
>>>the -4 package to find the bug :-)
>> 
>> I really do not believe you when you say your glibc is not affected.
>
>Why not :-)
>
>davem@sunset:~$ dpkg-query -W | grep libc6-sparc64
>libc6-sparc64	2.10.2-2
>davem@sunset:~$ cat fstat_test.c
>#include <sys/stat.h>
>#include <fcntl.h>
>#include <stdio.h>
>#include <stdlib.h>
>
>int main(void)
>{
>	struct stat sb;
>	int fd = open("foo", O_RDWR | O_CREAT, 0666);
>
>	if (fd < 0)
>		abort();
>	if (fstat(fd, &sb) < 0)
>		abort();
>	printf("%lu.%lu\n", sb.st_mtim.tv_sec, sb.st_mtim.tv_nsec);
>	if (stat("foo", &sb) < 0)
>		abort();
>	printf("%lu.%lu\n", sb.st_mtim.tv_sec, sb.st_mtim.tv_nsec);
>	if (fstatat(AT_FDCWD, "foo", &sb, 0) < 0)
>		abort();
>	printf("%lu.%lu\n", sb.st_mtim.tv_sec, sb.st_mtim.tv_nsec);
>	return 0;
>}
>davem@sunset:~$ gcc -m64 -o fstat_test fstat_test.c
>davem@sunset:~$ ./fstat_test
>1261510364.0
>1261510364.0
>1261510364.0
>davem@sunset:~$ 
>But, indeed when I run it under strace64 it goes:
>
>open("foo", O_RDWR|O_CREAT, 0666)       = 3
>fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 2), ...}) = 0
>
>I wonder why I get a sane output from the test program even though
>it's not using fstat64.

I would recommend that you run the testcase on a filesystem that
supports and records subsecond timestamps, and that the file is
created at a moment where the subsecond part is not 0. When in doubt,
use touch(1) to apply some subseconds, but usually, just running it
will create it at a non-zero subsecond with a high probability.

>> ===================================================================
>> --- glibc-2.10.1.orig/sysdeps/unix/sysv/linux/sparc/sparc64/fxstat.c
>> +++ glibc-2.10.1/sysdeps/unix/sysv/linux/sparc/sparc64/fxstat.c
>> @@ -1 +1 @@
>> -#include "../../fxstat.c"
>> +#include "../../i386/fxstat.c"
>> 
>> (Hint: Compare with sparc64/lxstat.c
>
>Thanks a lot!
>
>Please submit this to the glibc/eglibc folks for inclusion!
>
http://sources.redhat.com/bugzilla/show_bug.cgi?id=11155
