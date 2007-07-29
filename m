Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbXG2H51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbXG2H51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 03:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760218AbXG2H5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 03:57:20 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48708 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760174AbXG2H5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 03:57:20 -0400
Subject: [BUG] fadvise POSIX_FADV_NOREUSE does nothing
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-kVAFE2/xXwvOOzM2hhpA"
Date: Sun, 29 Jul 2007 03:57:17 -0400
Message-Id: <1185695837.6665.22.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kVAFE2/xXwvOOzM2hhpA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Related to my other bug report today, calling posix_fadvise (which uses
fadvise64) with the POSIX_FADV_NOREUSE flag does nothing.  The pages are
not dropped behind.

I also tried call fadvise with POSIX_FADV_SEQUENTIAL first.

This is expected as the POSIX_FADV_NOREUSE is a no-op in the recent
kernels.

Also, POSIX_FADV_SEQUENTIAL only does the readahead window. It doesn't
hint the VM in any way to possibly drop-behind the pages.

(See the previous bug report for more details of the test case)

Relevant numbers:

Copying (using fadvise_cp) a large file test:

1st run: 0m9.018s
2nd run: 0m3.444s
Copying large file...
3rd run: 0m14.024s    <<< page cache trashed
4th run: 0m3.449s

Test programs and batch files are attached.


- Eric


--=-kVAFE2/xXwvOOzM2hhpA
Content-Disposition: attachment; filename=fadvise_cp.c
Content-Type: text/x-csrc; name=fadvise_cp.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int in;
	int out;
	int pagesize; 
	void *buf;
	off_t pos;

	if (argc != 3) {
		printf("Usage: %s <src> <dest>\n", argv[0]); 
		return EXIT_FAILURE;
	}

	in = open(argv[1], O_RDONLY, 0);
	out = open(argv[2], O_CREAT | O_WRONLY | O_TRUNC, 0666);

	posix_fadvise(in, 0, 0, POSIX_FADV_SEQUENTIAL);
	posix_fadvise(out, 0, 0, POSIX_FADV_SEQUENTIAL);

	pagesize = getpagesize();
	buf = malloc(pagesize);

	pos = 0;

	for (;;) {
		ssize_t count;

		count = read(in, buf, pagesize);
		if (!count || count == -1)
			break;

		write(out, buf, count);

		/* right usage pattern? */
		posix_fadvise(in, pos, count, POSIX_FADV_NOREUSE);
		posix_fadvise(out, pos, count, POSIX_FADV_NOREUSE);

		pos += count;
	}

	free(buf);
	close(in);
	close(out);

	return EXIT_SUCCESS;
}

--=-kVAFE2/xXwvOOzM2hhpA
Content-Disposition: attachment; filename=Makefile
Content-Type: text/x-makefile; name=Makefile; charset=UTF-8
Content-Transfer-Encoding: 7bit

all:
	gcc fadvise_cp.c -o fadvise_cp
	gcc working_set_simul.c -o working_set_simul


--=-kVAFE2/xXwvOOzM2hhpA
Content-Disposition: attachment; filename=use-once-test.sh
Content-Type: application/x-shellscript; name=use-once-test.sh
Content-Transfer-Encoding: 7bit

#!/bin/bash

if [ $UID != 0 ]; then
	echo "Must be root."
	exit 0
fi

ram_size=$(free -mto | grep Mem: | awk '{ print $2 }')
medium_file_size=$(($ram_size / 3))
large_file_size=$(($ram_size * 4))

if [ ! -e "/tmp/medium_file" ] || [ ! -e "/tmp/large_file" ]; then
	echo "Creating test files..."
	dd if=/dev/zero of=/tmp/medium_file bs=1M count=$medium_file_size
	dd if=/dev/zero of=/tmp/large_file bs=1M count=$large_file_size
	echo
fi

TIMEFORMAT=' %3lR'

echo "Base test:"
echo

sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st run:"
time ./working_set_simul /tmp/medium_file
echo -n "2nd run:"
time ./working_set_simul /tmp/medium_file
echo -n "3rd run:"
time ./working_set_simul /tmp/medium_file
echo -n "4th run:"
time ./working_set_simul /tmp/medium_file
echo

echo "Reading a large file test:"
echo

sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st run:"
time ./working_set_simul /tmp/medium_file
echo -n "2nd run:"
time ./working_set_simul /tmp/medium_file
cp -v /tmp/large_file /dev/null
echo -n "3rd run:"
time ./working_set_simul /tmp/medium_file
echo -n "4th run:"
time ./working_set_simul /tmp/medium_file
echo

echo "Copying (using cp) a large file test:"
echo

sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st run:"
time ./working_set_simul /tmp/medium_file
echo -n "2nd run:"
time ./working_set_simul /tmp/medium_file
cp -v /tmp/large_file /tmp/large_file.copy
echo -n "3rd run:"
time ./working_set_simul /tmp/medium_file
echo -n "4th run:"
time ./working_set_simul /tmp/medium_file
rm /tmp/large_file.copy
echo

echo "Copying (using fadvise_cp) a large file test:"
echo

sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st run:"
time ./working_set_simul /tmp/medium_file
echo -n "2nd run:"
time ./working_set_simul /tmp/medium_file
echo "Copying large file..."
./fadvise_cp /tmp/large_file /tmp/large_file.copy
echo -n "3rd run:"
time ./working_set_simul /tmp/medium_file
echo -n "4th run:"
time ./working_set_simul /tmp/medium_file
rm /tmp/large_file.copy
echo

echo "Copying (using splice-cp) a large file test:"
echo

sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st run:"
time ./working_set_simul /tmp/medium_file
echo -n "2nd run:"
time ./working_set_simul /tmp/medium_file
echo "Copying large file..."
splice-cp /tmp/large_file /tmp/large_file.copy
echo -n "3rd run:"
time ./working_set_simul /tmp/medium_file
echo -n "4th run:"
time ./working_set_simul /tmp/medium_file
rm /tmp/large_file.copy
echo

echo "Copying (using rsync) a large file test:"
echo

sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st run:"
time ./working_set_simul /tmp/medium_file
echo -n "2nd run:"
time ./working_set_simul /tmp/medium_file
rsync -cv /tmp/large_file /tmp/large_file.copy
echo -n "3rd run:"
time ./working_set_simul /tmp/medium_file
echo -n "4th run:"
time ./working_set_simul /tmp/medium_file
rm /tmp/large_file.copy
echo

exit 0


--=-kVAFE2/xXwvOOzM2hhpA
Content-Disposition: attachment; filename=working_set_simul.c
Content-Type: text/x-csrc; name=working_set_simul.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

#include <fcntl.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h> 

int main(int argc, char *argv[])
{
	int fd;
	off_t size;
	char *mapping;
	unsigned r;
	unsigned i;

	if (argc != 2) {
		printf("Usage: %s <file>\n", argv[0]); 
		return EXIT_FAILURE;
	}

	fd = open(argv[1], O_RDONLY, 0);
	size = lseek(fd, 0, SEEK_END); 

	mapping = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);

	/* access (read) the file a couple of times*/
	for (r = 0; r < 4; r++) {
		for (i = 0; i < size; i++) {
			char t = mapping[i];
		}
	}

	munmap(mapping, size);
	close(fd);

	return EXIT_SUCCESS;
}

--=-kVAFE2/xXwvOOzM2hhpA--

