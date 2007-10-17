Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXJQG70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXJQG70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXJQG7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:59:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58941 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbXJQG7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:59:16 -0400
Date: Wed, 17 Oct 2007 16:01:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-mm1
Message-Id: <20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__17_Oct_2007_16_01_01_+0900_alsMh6..TTAreir4"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__17_Oct_2007_16_01_01_+0900_alsMh6..TTAreir4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

I noticed 32bit binary on x86_64 behavior is changed on 2.6.23-mm1.

This is a result of pmap after process returns -ENOMEM.(see attached program)
== on 2.6.23 ==
errno 12
3531:   ./malloc
0000000000001000   6272K -----    [ anon ]
0000000000621000    100K r-x--  /lib/ld-2.5.so
000000000063a000      4K r----  /lib/ld-2.5.so
000000000063b000      4K rw---  /lib/ld-2.5.so
000000000063c000      8K -----    [ anon ]
000000000063e000   1244K r-x--  /lib/libc-2.5.so
0000000000775000      8K r----  /lib/libc-2.5.so
0000000000777000      4K rw---  /lib/libc-2.5.so
0000000000778000     12K rw---    [ anon ]
000000000077b000 123700K -----    [ anon ]
0000000008048000      4K r-x--  /home/kamezawa/malloc
0000000008049000      4K rw---  /home/kamezawa/malloc
000000000804a000 3929824K -----    [ anon ]
00000000f7f02000      8K rw---    [ anon ]
00000000f7f04000    100K -----    [ anon ]
00000000f7f1d000      4K rw---    [ anon ]
00000000f7f1e000 131812K -----    [ anon ]
00000000fffd7000     84K rw---    [ stack ]
00000000fffec000     72K -----    [ anon ]
00000000ffffe000      4K r-x--    [ anon ]
 total          4193272K
==

== on 2.6.23-mm1==
errno 12
3504:   ./malloc
0000000000621000    100K r-x--  /lib/ld-2.5.so
000000000063a000      4K r----  /lib/ld-2.5.so
000000000063b000      4K rw---  /lib/ld-2.5.so
000000000063e000   1244K r-x--  /lib/libc-2.5.so
0000000000775000      8K r----  /lib/libc-2.5.so
0000000000777000      4K rw---  /lib/libc-2.5.so
0000000000778000     12K rw---    [ anon ]
0000000008048000      4K r-x--  /home/kamezawa/malloc
0000000008049000      4K rw---  /home/kamezawa/malloc
0000000055555000      4K rw---    [ anon ]
0000000055556000    100K -----    [ anon ]
000000005556f000      8K rw---    [ anon ]
0000000055671000 2789016K -----    [ anon ]
00000000ffa17000     84K rw---    [ stack ]
00000000ffa2c000   5960K -----    [ anon ]
00000000ffffe000      4K r-x--    [ anon ]
 total          2796560K
==

Maybe get_unmapped_area() had some change.
Is this intended ?

Thanks,
-Kame

--Multipart=_Wed__17_Oct_2007_16_01_01_+0900_alsMh6..TTAreir4
Content-Type: text/x-csrc;
 name="malloc.c"
Content-Disposition: attachment;
 filename="malloc.c"
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>



#define PAGESIZE (4096)

int main(int argc, char *argv[])
{
	char *c,*safe;
	pid_t pid;
	char buffer[256];
	int err;
	pid = getpid();
	sprintf(buffer,"/usr/bin/pmap %d", pid);
	safe = malloc(1024*1024);
	while (1) {
		c = mmap(NULL, PAGESIZE, PROT_NONE, MAP_ANON | MAP_PRIVATE, 0, 0);
		if (c == MAP_FAILED) {
			err = errno;
			break;
		}
	}
	free(safe);
	printf("errno %d\n",err);
	system(buffer);
}

--Multipart=_Wed__17_Oct_2007_16_01_01_+0900_alsMh6..TTAreir4--

