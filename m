Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYGOXD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYGOXD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYGOXDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:03:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:37256 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbYGOXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=VFX+utvtl14oliKzMG6X5OF+aJA1ssA1FyKxI+dGs41UqiTXGTJ9L6Mjc00IaGS9dS
         f9jLXv9IjSA4s4+AtUyMOSZuVvxAFG1/s64frV/J3BHs2tht4z8pX6z47PoqhObzb2rh
         HKuLG0v6Ymfxilj4tNvH6hS4H/udV8TuIlDHw=
Subject: madvise(2) MADV_SEQUENTIAL behavior
From: Eric Rannaud <eric.rannaud@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 15 Jul 2008 23:03:42 +0000
Message-Id: <1216163022.3443.156.camel@zenigma>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/madvise.c and madvise(2) say:

 *  MADV_SEQUENTIAL - pages in the given range will probably be accessed
 *		once, so they can be aggressively read ahead, and
 *		can be freed soon after they are accessed.


But as the sample program at the end of this post shows, and as I
understand the code in mm/filemap.c, MADV_SEQUENTIAL will only increase
the amount of read ahead for the specified page range, but will not
influence the rate at which the pages just read will be freed from
memory.

Running the sample program on a large file, say 4GB on a machine with
3GB of RAM, the resident size of the program will grow enough to evict
pretty much everything else. (on 2.6.25.9-40.fc8)

Right before the program below is done reading the 4GB file:

7f6c3e654000-7f6d3e654000 r--s 00000000 fd:02 98125                      /tmp/bigfile
Size:            4194304 kB
Rss:             2472220 kB
Pss:             2472220 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:   2472220 kB
Private_Dirty:         0 kB
Referenced:       718748 kB


I'm well aware that the kernel is free to ignore the advice given
through madvise(2) (fadvise(2) seems to behave similarly, btw), so I'm
certainly not claiming this is a bug. However, I was wondering what was
the rationale behind it, and whether the manpages should be updated to
be more accurate.

There is a very straightforward workaround: MADV_DONTNEED on the range
just read, every so often, will be very effective at controlling the
resident size of the mapping. (mm/madvise.c:madvise_dontneed() calls
zap_page_range())

Thanks.



---
# dd if=/dev/zero of=/tmp/bigfile bs=1024 count=$((4*1024*1024))
# gcc test.c
# Run:
file=/tmp/bigfile; ./a.out $file &  pid=$! ; while true; do cat /proc/$pid/smaps | grep -A 8 $file; sleep 1; done

# cat test.c 

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

int main(int argc, char **argv)
{
	if (argc != 2)
		return -EINVAL;

	char *fn = argv[1];
	int fd = open(fn, O_RDONLY);
	if (fd < 0)
		return -errno;

	struct stat st;
	int ret = fstat(fd, &st);
	if (ret)
		return -errno;

	unsigned char *map = mmap(0, st.st_size, PROT_READ, MAP_SHARED, fd, 0);
	if (map == MAP_FAILED)
		return -errno;

	ret = madvise(map, st.st_size, MADV_SEQUENTIAL);
	if (ret) {
		fprintf(stderr, "madvise failed\n");
		return -errno;
	}

	const int pagesize = sysconf(_SC_PAGESIZE);
	unsigned char dummy = 0;
	off_t i;

	for (i = 0; i < st.st_size; i += pagesize) {
		dummy += map[i];
	}

	munmap(map, st.st_size);
	close(fd);

	return dummy;
}



