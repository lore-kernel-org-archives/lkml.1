Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZCRTo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZCRTo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZCRToO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:44:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCRToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:44:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=oysl/1eDkQVP8G2KdDRdaPlOAMSZ6IagJmdzEyL4TPNTFRNhCmyJeAeYIyBuKssuR
	2TeeGqpDcvfWLk3G1skyg==
MIME-Version: 1.0
Date: Wed, 18 Mar 2009 12:44:08 -0700
Message-ID: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
Subject: ftruncate-mmap: pages are lost after writing to mmaped file.
From: Ying Han <yinghan@google.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We triggered the failure during some internal experiment with
ftruncate/mmap/write/read sequence. And we found that some pages are
"lost" after writing to the mmaped file. which in the following test
cases (count >= 0).

First we deployed the test cases into group of machines and see about
>20% failure rate on average. Then, I did couple of experiment to try
to reproduce it on a single machine. what i found is that:
1. add a fsync after write the file, i can not reproduce this issue.
2. add memory pressure(mmap/mlock) while run the test in infinite
loop, the failure is reproduced quickly. ( background flushing ? )

The "bad pages" count differs each time from one digit to 4,5 digit
for 128M ftruncated file. and what i also found that the bad page
number are contiguous for each segment which total bad pages container
several segments. ext "1-4, 9-20, 48-50" (  batch flushing ? )

(The failure is reproduced based on 2.6.29-rc8, also happened on
2.6.18 kernel. . Here is the simple test case to reproduce it with
memory pressure. )

#include <sys/mman.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long kMemSize  = 128 << 20;
int kPageSize = 4096;

int main(int argc, char **argv) {
	int status;
	int count = 0;
	int i;
	char *fname = "/root/test.mmap";
	char *mem;

	unlink(fname);
	int fd = open(fname, O_CREAT | O_EXCL | O_RDWR, 0600);
	status = ftruncate(fd, kMemSize);

	mem = mmap(0, kMemSize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	// Fill the memory with 1s.
	memset(mem, 1, kMemSize);

	for (i = 0; i < kMemSize; i++) {
		int byte_good = mem[i] != 0;

		if (!byte_good && ((i % kPageSize) == 0)) {
			//printf("%d ", i / kPageSize);
			count++;
		}
	}

	munmap(mem, kMemSize);
	close(fd);
	unlink(fname);

	if (count > 0) {
		printf("Running %d bad page\n", count);
		return 1;
	}
	return 0;
}

--Ying
