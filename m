Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYH3So1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYH3So1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYH3SoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:44:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:2038 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbYH3SoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=WNW/41yBKNOtYRMyu46XBe5C2jxhaRmzv4mSCs41NQKcPZtfgNdJ5RNS+nWboSJYlQ
         D7VIYIA/GNLJaN4e4066GrmYz5t0N7ySx57MyOfMTvh4mhkHd4+kCJpIe+y99NVCgX+q
         MBFUPyuFQv6PfIZI5wJJFKclWB9jJNQCk8Mto=
Date: Sat, 30 Aug 2008 20:44:22 +0200
To: Tom Tucker <tom@opengridcomputing.com>, Neil Brown <neilb@suse.de>,
       Chuck Lever <chuck.lever@oracle.com>, Greg Banks <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: linux-kernel@vger.kernel.org
Subject: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080830184422.GA9598@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that something weird is going on with /proc/sys/sunrpc/transports.
This file is generated in net/sunrpc/sysctl.c, function proc_do_xprt(). When
I "cat" this file, I get the expected output:

    $ cat /proc/sys/sunrpc/transports 
    tcp 1048576
    udp 32768

But I think that it does not check the length of the buffer supplied by
userspace to read(). With my original program, I found that the stack was
being overwritten by the characters above, even when the length given to
read() was just 1. So I have created a test program, see it at the bottom of
this e-mail. Here is its output:

    $ gcc -Wall -std=gnu99 proc-sys-sunrpc-transports.c && ./a.out 
    read(0) returned 0, errno = 0
    read(1) returned -1, errno = 21
    read(2) returned -1, errno = 20
    read(3) returned -1, errno = 19
    read(4) returned -1, errno = 18
    read(5) returned -1, errno = 17
    read(6) returned -1, errno = 16
    read(7) returned -1, errno = 15

...etc. This program just reopens the file and tries to read a different
number of characters each time. Strace can be used to verify that it really
returns these errnos.

With a small change to the program, we can also compare the buffer address
passed to read() and see that the kernel wrote the full file into the buffer
regardless of how many bytes we wanted to get back.

I don't know if this could be used in some malicious way. Maybe if a setuid
root program tried to open a user-supplied file (which could be this one in
/proc), it could crash the program quite easily. But since there is no way
to change the contents of the file... I don't know. Maybe a denial of
service attack where some user can make a daemon open a custom file and
crash? But it relies on the buffer being small enough, and the file is only
38 bytes on my machine. Who would pass a buffer to read that was smaller
than 38 bytes anyway? :-)

This file was introduced in

commit dc9a16e49dbba3dd042e6aec5d9a7929e099a89b
Author: Tom Tucker <tom@opengridcomputing.com>
Date:   Sun Dec 30 21:08:31 2007 -0600

    svc: Add /proc/sys/sunrpc/transport files
    
    Add a file that when read lists the set of registered svc
    transports.
    
    Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
    Acked-by: Neil Brown <neilb@suse.de>
    Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
    Reviewed-by: Greg Banks <gnb@sgi.com>
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

...adding everybody to Cc.

Thanks,


Vegard

--

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int
main(void)
{
	for (int i = 0; i < 20; ++i) {
		int fd = open("/proc/sys/sunrpc/transports", O_RDONLY);
		if (fd == -1)
			exit(EXIT_FAILURE);

		char buf[512];
		memset(buf, 0, sizeof(buf));

		int ret = read(fd, buf, i);
		printf("read(%d) returned %d, errno = %d\n", i, ret, errno);

		close(fd);
	}

	return EXIT_SUCCESS;
}
