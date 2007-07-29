Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbXG2HxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbXG2HxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 03:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbXG2HxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 03:53:13 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:65407 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170AbXG2HxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 03:53:12 -0400
Subject: [BUG] Linux VM use-once mechanisms don't work (test case with
	numbers included)
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-6Gysxto92Mr8vPduR7GF"
Date: Sun, 29 Jul 2007 03:53:09 -0400
Message-Id: <1185695589.6665.16.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6Gysxto92Mr8vPduR7GF
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Linux VM use-once mechanisms don't seem to work.  Simple scenario like
streaming a file much greater than physical RAM size should be
identified to avoid trashing the page cache with useless data.

I know the VM cannot predict the future or assume anything about the
user's intent.  But this workload is simple and common, it should be
detected and better handled.

Test case:

Linux 2.6.20-16-lowlatency SMP PREEMPT x86_64 (also tried on 2.6.23-rc1)

- A file of 1/3 the RAM size is created, mapped and frequently accessed
(4 times).
- The test is run multiple times (4 total) to time it's execution.
- After the first run, other runs take much less time, because the file
is cached.
- A previously created file, 4 times the size of the RAM, is read or
copied.
- The test is re-run (2 times) to time it's execution.

To test:

$ make
# ./use-once-test.sh

Some big files will be created in your /tmp. They don't get erased after
the test to speedup multiple runs.

Results:

- The test execution time greatly increase after reading or copying the
large file.
- Frequently used data got kick out of the page cache and replaced with
useless read once data.
- Both the read only and copy (read + write) cases don't work.

I believe this clearly illustrate the slowdowns I experience after I
copy large files around my system.  All applications on my desktop are
jerky for some moments after that.  Watching a DVD is another example.

Base test:

1st run: 0m8.958s
2nd run: 0m3.442s
3rd run: 0m3.452s
4th run: 0m3.443s

Reading a large file test:

1st run: 0m8.997s
2nd run: 0m3.522s
`/tmp/large_file' -> `/dev/null'
3rd run: 0m8.999s    <<< page cache trashed
4th run: 0m3.440s

Copying (using cp) a large file test:

1st run: 0m8.979s
2nd run: 0m3.442s
`/tmp/large_file' -> `/tmp/large_file.copy'
3rd run: 0m13.814s    <<< page cache trashed
4th run: 0m3.455s

Copying (using fadvise_cp) a large file test:

1st run: 0m9.018s
2nd run: 0m3.444s
Copying large file...
3rd run: 0m14.024s    <<< page cache trashed
4th run: 0m3.449s

Copying (using splice-cp) a large file test:

1st run: 0m8.977s
2nd run: 0m3.442s
Copying large file...
3rd run: 0m14.118s    <<< page cache trashed
4th run: 0m3.456s

Possible solutions:

Various patches to fix the use-once mechanisms were discussed in the
past.  Some more that 6 years ago and some more recently.

http://lwn.net/2001/0726/a/2q.php3
http://lkml.org/lkml/2005/5/3/6
http://lkml.org/lkml/2006/7/17/192
http://lkml.org/lkml/2007/7/9/340
http://lkml.org/lkml/2007/7/21/219 (*1)

(*1) I have tested Peter's patch with some success.  It fix the read
case, but no the copy case.  Results: http://lkml.org/lkml/2007/7/24/527

Test programs and batch files are attached.


- Eric


--=-6Gysxto92Mr8vPduR7GF
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

--=-6Gysxto92Mr8vPduR7GF
Content-Disposition: attachment; filename=Makefile
Content-Type: text/x-makefile; name=Makefile; charset=UTF-8
Content-Transfer-Encoding: 7bit

all:
	gcc fadvise_cp.c -o fadvise_cp
	gcc working_set_simul.c -o working_set_simul


--=-6Gysxto92Mr8vPduR7GF
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


--=-6Gysxto92Mr8vPduR7GF
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

--=-6Gysxto92Mr8vPduR7GF--

