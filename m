Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZIAHe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZIAHe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZIAHe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:34:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44067 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZIAHeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:34:25 -0400
Message-ID: <4A9CCE7C.3060702@in.ibm.com>
Date: Tue, 01 Sep 2009 13:04:20 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix compat_sys_utimensat
References: <4A97A7FD.1000202@in.ibm.com>
In-Reply-To: <4A97A7FD.1000202@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Poulose wrote:
> 
> Hi,
> 
> The compat_utimensat syscall does not ignore tv_sec field when tv_nsec 
> is set to UTIME_OMIT/UTIME_NOW and returns -EINVAL.



mjs22lp5:~ # cat utimensat-test.c
#define _GNU_SOURCE
#define _ATFILE_SOURCE
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdlib.h>

main(int argc, char *argv[])
{
	struct timespec ts[2];
	struct timespec *tsp;
	
	if (argc < 2) {
		fprintf(stderr, "Usage : %s filename\n", argv[0]);
		exit (-1);
	}
	
	ts[0].tv_nsec = ts[1].tv_nsec = UTIME_NOW;
	ts[0].tv_sec = ts[1].tv_sec = 1;

	tsp = ts;
	
	if (utimensat(AT_FDCWD, argv[1],tsp,0) == -1)
		perror("utimensat");
	else
		fprintf(stdout, "utimensat success\n");
	return 0;
}
mjs22lp5:~ # cc -m64 utimensat-test.c -o utimensat_test64
mjs22lp5:~ # cc -m32 utimensat-test.c -o utimensat_test32
mjs22lp5:~ # ./utimensat_test32 /tmp/utimensat_test
utimensat: Invalid argument
mjs22lp5:~ # ./utimensat_test64 /tmp/utimensat_test
utimensat success
mjs22lp5:~ # uname -r
2.6.31-rc8

> 
> This problem was revealed with the utimensat_tests from LTP.
> 
> The utimensat() syscall works fine.
> 
> Attaching a patch for the issue. The patch has been tested and verified 
> to fix the issue.

With the patch :

mjs22lp5:~ # ./utimensat_test64 /tmp/utimensat_test
utimensat success
mjs22lp5:~ # ./utimensat_test32 /tmp/utimensat_test
utimensat success
mjs22lp5:~ # uname -r
2.6.31-rc8utimensat


> 
> Please apply.
> 
> Thanks,
> 
> Suzuki
> 

