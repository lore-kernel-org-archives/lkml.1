Return-Path: <linux-kernel-owner+w=401wt.eu-S1765781AbYDOVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765781AbYDOVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYDOVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:09:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:58363 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYDOVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QULrhbL3M5QmF+7pQafKBRVlujO7z6RftQ841TxQ3DIRnFBXGrj4/ikdTzk87G8m667cTf4hhKqx0la0aVZWMxehucweViDN49DTMGVaN1Ed5cVRL8eBUhZik3YR6+axRcXgDgsESgffYj4R3g+P4Acgw7H858OiHFPCfkaQ6iE=
Message-ID: <cfd18e0f0804151409q178addf4t4c6cba683bd0bff4@mail.gmail.com>
Date: Tue, 15 Apr 2008 23:09:45 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: ak@suse.de
Subject: core_pattern piping strangeness
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Petr Gajdos" <pgajdos@suse.cz>, michael.kerrisk@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

In 2.6.19 you added the pipiing syntax
(http://lwn.net/Articles/195310/) to core_pattern.  Petr pointed out
that this is not yet documented in core(5), so I set to testing it.

The change log has the text:

    The core dump proces will run with the privileges and in the name space
    of the process that caused the core dump.

This appears not to be true (as tested on 2.6.25-rc8).  Instead the
pipe program is run as root.  I'm not sure what "in the name space of
the process that caused the core dump" means -- I wondered if it might
mean that the current working directory of the program would be the
same as that of the process that caused the core dump.  However that
is not so: the current directory for the pipe program is the root
directory.

Can you comment?  Am I misunderstanding something?

Test program and shell session shown below.

Cheers,

Michael


$ cat core_pattern_test.c
/* core_pattern_test.c */

#define _GNU_SOURCE
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUF_SIZE 1024

int
main(int argc, char *argv[])
{
    int fd, tot;
    ssize_t numRead;
    char buf[BUF_SIZE];
    FILE *fp;

    fd = open(argv[1], O_CREAT | O_WRONLY | O_TRUNC, 0666);

    fp = fdopen(fd, "a");
    fprintf(fp, "PID=%ld\n", (long) getpid());
    fprintf(fp, "cwd=%s\n", get_current_dir_name());
    fprintf(fp, "UID=%ld; EUID=%ld\n", (long) getuid(), (long) geteuid());

    /* Count bytes in standard input */

    tot = 0;
    while ((numRead = read(STDIN_FILENO, buf, BUF_SIZE)) > 0)
        tot += numRead;
    fprintf(fp, "Total bytes in core dump: %d\n", tot);

    exit(EXIT_SUCCESS);
}

$ cc core_pattern_test.c
$ su
Password:
# echo "|$PWD/a.out $PWD/core.log" > /proc/sys/kernel/core_pattern
# exit
$ sleep 100 &
[1] 5637
$ kill -QUIT %1
[1]+  Quit                    (core dumped) sleep 100
$ cat core.log
PID=5638
cwd=/
UID=0; EUID=0
Total bytes in core dump: 282624
