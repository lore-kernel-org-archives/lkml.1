Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXJaApq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXJaApq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXJaAph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:45:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:14291 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbXJaApg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=sd2by20Y3QdPIpO94unY4tnLekGUOwEYEFACweROcW9sMkv3yCA8arTrBbhQbR4Vt/xq14Y3yyB/ZqQ7i+KDJZRwqRco4v6POhlk8nHnxG6+bPiZNkp867DhPmGWqTZ2JbD85weOoYsytO/CEblDRz9e9OUeh2YQSQIYX49g6/M=
Message-ID: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
Date: Wed, 31 Oct 2007 00:45:35 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Cc: "Nick Piggin" <npiggin@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 5dd1cb949e030ba2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing a memory mapped region past the last page containing a valid
file mapping produces a SIGBUS fault (as it should). Running a program
that does this under gdb, then accessing the invalid memory from gdb,
causes it to start consuming 100% CPU and become unkillable. Once in
that state, SysRq-T doesn't show a stack trace for gdb, although it is
shown as running and stack traces are dumped for other tasks.

2.6.22 does not have this bug (gdb just prints '\0' as the contents,
although arguably that is also a bug, and it should instead report the
SIGBUS).

Bisection indicates the problem was introduced by:

54cb8821de07f2ffcd28c380ce9b93d5784b40d7
"mm: merge populate and nopage into fault (fixes nonlinear)"

The following program demonstrates the issue:

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>

int main(int argc, char *argv[])
{
        int fd;
        struct stat buf;

        if (argc != 2) {
                fprintf(stderr, "usage: %s <filename>\n", argv[0]);
                exit(1);
        }

        fd = open(argv[1], O_RDONLY);
        fstat(fd, &buf);
        int count = buf.st_size + sysconf(_SC_PAGE_SIZE);
        char *file = (char *) mmap(NULL, count, PROT_READ, MAP_PRIVATE, fd, 0);
        if (file == MAP_FAILED) {
                fprintf(stderr, "mmap failed: %s\n", strerror(errno));
        } else {
                char ch;
                fprintf(stderr, "using offset %d\n", (count - 1));
                ch = file[count - 1];
                munmap(file, count);
        }
        close(fd);
        return 0;
}

To reproduce the bug, run it under gdb, go up a couple of frames to
the main function, then access invalid memory, for e.g. with: "print
file[4095]", or whatever offset was reported.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
