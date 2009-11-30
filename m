Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZK3VVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZK3VVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZK3VVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:21:48 -0500
Received: from 207-172-212-176.c3-0.smr-ubr2.sbo-smr.ma.static.cable.rcn.com ([207.172.212.176]:58130
	"EHLO torpor.static.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZK3VVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:21:48 -0500
X-Greylist: delayed 1605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 16:21:47 EST
From: James Y Knight <foom@fuhm.net>
Content-Type: multipart/mixed; boundary=Apple-Mail-346--13056191
Subject: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
Date: Mon, 30 Nov 2009 15:55:01 -0500
Message-Id: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1077)
X-Mailer: Apple Mail (2.1077)
X-Spam-Score: -10.0
X-Spam-Report: ALL_TRUSTED=-10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-346--13056191
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

This test case fails in 2.6.23-2.6.25, because of the bug fixed in =
864f24395c72b6a6c48d13f409f986dc71a5cf4a, and now again in at least =
2.6.31 and 2.6.32pre8 because of a *different* bug. This test *does not* =
fail 2.6.26. I have not tested anything between 2.6.26 and 2.6.31.

The bug in 2.6.31 is definitely not the same bug as 2.6.23's. This time, =
the zero'd area of the file doesn't show up immediately upon writing the =
file. Instead, the kernel waits to mangle the file until it has to flush =
the buffer to disk. *THEN* it zeros out parts of the file.

So, after writing out the new file with writev, and checking the md5sum =
(which is correct), this test case asks the kernel to flush the cache =
for that file, and then checks the md5sum again. ONLY THEN is the file =
corrupted. That is, I won't hesitate to say *incredibly evil* behavior: =
it took me quite some time to figure out WTH was going wrong with my =
program before determining it was a kernel bug.

This test case is distilled from an actual application which doesn't =
even intentionally use writev: it just uses C++'s ofstream class to =
write data to a file. Unfortunately, that class smart and uses writev =
under the covers. Unfortunately, I guess nobody ever tests linux writev =
behavior, since it's broken _so_much_of_the_time_. I really am quite =
astounded to see such a bad track record for such a fundamental core =
system call....

My /tmp is an ext3 filesystem, in case that matters.

Here is the output I get from running the program on a broken kernel:
Compiling test program
Making original file /tmp/writevtest.yzafRmFCOR/test.in
..checking original file's md5sum.
Running test to copy to /tmp/writevtest.yzafRmFCOR/test.out
..checking new file's md5sum.
Attempting to drop the page cache for this file...
..checking new file's md5sum again.
MD5SUM MISMATCH(/tmp/writevtest.yzafRmFCOR/test.out):
  wanted 2fdd6851b32ae931637d4845c037b550
  got    67e5e2d6d4435e8095335d86a3d3e993


(please CC responses to me, I'm not subscribed to this list).

Thanks,
James


--Apple-Mail-346--13056191
Content-Disposition: attachment;
	filename=run-writev-test.sh
Content-Type: application/octet-stream;
	name="run-writev-test.sh"
Content-Transfer-Encoding: 7bit

#!/bin/sh

set -e

MYDIR="$(dirname $0)"

cd "$MYDIR"
echo "Compiling test program"
gcc -o writev-test writev-test.c

test_md5 () {
    local MD5
    MD5=$(md5sum $1|cut -d" " -f1)
    if [[ "$MD5" != $2 ]]; then
	printf "MD5SUM MISMATCH($1):\n  wanted $2\n  got    $MD5\n"
	exit 1
    fi
}

EXPECTED_MD5=2fdd6851b32ae931637d4845c037b550
DIR=$(mktemp -d -t writevtest.XXXXXXXXXX)
echo "Making original file $DIR/test.in"
dd if=/dev/zero bs=1k count=1k  2>/dev/null | tr '\000' '\377' > $DIR/test.in
echo "..checking original file's md5sum."
test_md5 $DIR/test.in $EXPECTED_MD5
echo "Running test to copy to $DIR/test.out"
./writev-test copy $DIR/test.in $DIR/test.out
echo "..checking new file's md5sum."
test_md5 $DIR/test.out $EXPECTED_MD5

echo "Attempting to drop the page cache for this file..."
./writev-test drop $DIR/test.out
#sync; sudo /bin/sh -c "echo 3 > /proc/sys/vm/drop_caches"

echo "..checking new file's md5sum again."
test_md5 $DIR/test.out $EXPECTED_MD5

--Apple-Mail-346--13056191
Content-Disposition: attachment;
	filename=writev-test.c
Content-Type: application/octet-stream;
	name="writev-test.c"
Content-Transfer-Encoding: 7bit

#include <sys/uio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>

void exit_error(char *str) {
    fputs(str, stderr);
    fputc('\n', stderr);
    exit(1);
}

void exit_perror(char *str) {
    perror(str);
    exit(1);
}

int main(int argc, char **argv) {
    int in_fd, out_fd;
    struct stat info;
    void *base_addr;
    char buf[600];
    struct iovec iov[2];
    int mode = 0;

    if (argc < 3)
        exit_error("Usage: writev-test copy infile outfile\n"
                   "       writev-test drop infile\n");

    if (!strcmp(argv[1], "copy")) {
        if (argc < 4)
            exit_error("Missing outfile argument\n");
        mode = 1;
    }
    else if (!strcmp(argv[1], "drop"))
        mode = 0;
    else
        exit_error("Unknown mode\n");

    in_fd = open(argv[2], O_RDONLY);
    if (in_fd < 0)
        exit_perror("open input");

    if (fstat(in_fd, &info) < 0)
        exit_perror("fstat");

    if (mode == 1) {

        base_addr = mmap(0, info.st_size, PROT_READ, MAP_SHARED, in_fd, 0);
        if (base_addr == MAP_FAILED)
            perror("mmap");

        if (read(in_fd, buf, 600) < 600)
            exit_perror("read");

        out_fd = open(argv[3], O_WRONLY|O_TRUNC|O_CREAT, 0666);
        if (out_fd < 0)
            exit_perror("open output");

        iov[0].iov_base = buf;
        iov[0].iov_len = 600;
        iov[1].iov_base = base_addr + 600;
        iov[1].iov_len = info.st_size - 600;
        if (writev(out_fd, iov, 2) < info.st_size)
            exit_perror("writev");

    } else {
        if (fsync(in_fd) < 0)
            perror("fsync");
        if (posix_fadvise(in_fd, 0, info.st_size, POSIX_FADV_DONTNEED) != 0)
            perror("posix_fadvise");
    }
    return 0;
}

--Apple-Mail-346--13056191--
