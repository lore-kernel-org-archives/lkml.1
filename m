Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYFCUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYFCUQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYFCUP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:15:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:26052 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYFCUPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:from;
        b=iG7XUvDMt7naLHayvRYYfIREJC8YRwCaTsxu9aL9jXd1kdcgH9xXW18sUKE71OQlPPFJWlLHueY2tsNPg0nh+x9Wy2wUVo6G0GZIEOvcMQk4Q0e8pIhMKEoVPCwCY0iGHc4nSPatcH2gcezwpN8XLi0ydxUVH7ydCKgmRxHDFLg=
Message-ID: <4845A64B.7050207@gmail.com>
Date: Tue, 03 Jun 2008 22:15:07 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: utimensat() non-conformances and fixes [v4] (test results)
References: <48454F1D.6060507@gmail.com> <484569E5.5090108@gmail.com>
In-Reply-To: <484569E5.5090108@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090606050903030802050700"
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090606050903030802050700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew,

The following is why I think my patch should
preferably be applied for 2.6.26, rather than
waiting for .27.

The first reason is the obvious.  The test suite
runs 99 tests.  With my patch applied to 2.6.24-rc4,
all tests pass (see the attached test results).

There is another reason why I think we should apply the
patch for .26.

On 2.6.25, we have:

Total tests: 99; passed: 73; failed: 26

On 2.6.26-rc4, we have:
Total tests: 99; passed: 74; failed: 25

As far as I can see, this is due to the changes from
Miklos's

commit 02c6be615f1fcd37ac5ed93a3ad6692ad8991cd9
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Thu May 1 04:34:45 2008 -0700

But the small improvement in the test results isn't
quite what it seems.  There is for 2.6.25:

Failed tests:  21 22 23 24 28 29 30 31 32 33 38 46 47 48 49 50 51 58 59 60 75 76 87 88 98 99

And for 2.6.24-rc4:

Failed tests:  21 24 28 29 30 31 32 33 38 41 46 47 48 49 50 51 58 59 60 75 76 87 88 98 99

Looking at the list shows that 2.6.24-rc4 fixes tests
22 and 23, but breaks test 41[*].  I don't think we
should do that.

Cheers,

Michael


[*] Test 41 is:

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   EACCES
FAILED test 41

In other words, make the call

utimensat(fd, NULL, {{0, UTIME_NOW}, {0. UTIME_NOW}}, 0)

where fd is a read-only (O_RDONLY) descriptor that refers to
a file that is not owned by the caller, but is writable by
the caller.  This call should succeed.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html



--------------090606050903030802050700
Content-Type: text/x-log;
 name="utimensat_tests-2.6.25.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="utimensat_tests-2.6.25.log"

============================================================

Testing read-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515937 1212515937
PASSED test 1

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515937 1212515937
PASSED test 2

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515937 1212515937
PASSED test 3

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515937 1212515937
PASSED test 4

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515938 1212515938
PASSED test 5

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515938 1212515938
PASSED test 6

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 7

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 8

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 9

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212515938 0
PASSED test 10

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212515938 0
PASSED test 11

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212515938 0
PASSED test 12

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212515938
PASSED test 13

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212515938
PASSED test 14

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212515938
PASSED test 15

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 16

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 17

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 18

============================================================

Testing read-only file, not owned by self

***** Testing times==NULL case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 19

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 20

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   SUCCESS 1212515939 1212515939
FAILED test 21

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   SUCCESS 1212515939 1212515939
FAILED test 22

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   SUCCESS 1212515939 1212515939
FAILED test 23

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   SUCCESS 1212515939 1212515939
FAILED test 24

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 25

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 26

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 27

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212515940 0
FAILED test 28

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212515940 0
FAILED test 29

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212515940 0
FAILED test 30

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212515940
FAILED test 31

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212515940
FAILED test 32

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212515940
FAILED test 33

***** Testing times=={ x, y } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 34

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 35

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 36

============================================================

Testing writable file, not owned by self

***** Testing times==NULL case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515941 1212515941
PASSED test 37

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   EACCES  
FAILED test 38

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515941 1212515941
PASSED test 39

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515941 1212515941
PASSED test 40

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515941 1212515941
PASSED test 41

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515941 1212515941
PASSED test 42

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 43

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 44

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 45

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212515942 0
FAILED test 46

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212515942 0
FAILED test 47

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212515942 0
FAILED test 48

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212515942
FAILED test 49

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212515942
FAILED test 50

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212515942
FAILED test 51

***** Testing times=={ x, y } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 52

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 53

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 54

============================================================

Testing append-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515943 1212515943
PASSED test 55

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515943 1212515943
PASSED test 56

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212515943 1212515943
PASSED test 57

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   EPERM  
FAILED test 58

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   EPERM  
FAILED test 59

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   EPERM  
FAILED test 60

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 61

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 62

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 63

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 64

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 65

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 66

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 67

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 68

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 69

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 70

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 71

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 72

============================================================

Testing immutable file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 73

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 74

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   EPERM  
FAILED test 75

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EPERM  
FAILED test 76

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 77

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 78

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 79

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 80

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 81

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 82

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 83

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 84

============================================================

Testing immutable append-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 85

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 86

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   EPERM  
FAILED test 87

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EPERM  
FAILED test 88

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 89

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 90

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 91

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 92

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 93

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 94

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 95

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 96

============================================================

***** Testing pathname==NULL, dirfd!=AT_FDCWD, flags has AT_SYMLINK_NOFOLLOW *****
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q -n -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EINVAL   
RESULT:   EINVAL  
PASSED test 97

============================================================

tv_sec should be ignored if tv_nsec is UTIME_OMIT or UTIME_NOW
***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 n 1 n
EXPECTED: SUCCESS y  y
RESULT:   EINVAL  
FAILED test 98

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 o 1 o
EXPECTED: SUCCESS n  n
RESULT:   EINVAL  
FAILED test 99

============================================================

Linux hauroko 2.6.25-default #3 SMP Sat May 3 11:12:56 CEST 2008 i686 i686 i386 GNU/Linux
Tue Jun  3 19:59:08 CEST 2008
Total tests: 99; passed: 73; failed: 26
Failed tests:  21 22 23 24 28 29 30 31 32 33 38 46 47 48 49 50 51 58 59 60 75 76 87 88 98 99



--------------090606050903030802050700
Content-Type: text/x-log;
 name="utimensat_tests-2.6.26-rc4.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="utimensat_tests-2.6.26-rc4.log"

============================================================

Testing read-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508717 1212508717
PASSED test 1

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508717 1212508717
PASSED test 2

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508717 1212508717
PASSED test 3

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508717 1212508717
PASSED test 4

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508717 1212508717
PASSED test 5

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508717 1212508717
PASSED test 6

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 7

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 8

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 9

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212508718 0
PASSED test 10

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212508718 0
PASSED test 11

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212508718 0
PASSED test 12

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212508718
PASSED test 13

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212508718
PASSED test 14

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212508718
PASSED test 15

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 16

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 17

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 18

============================================================

Testing read-only file, not owned by self

***** Testing times==NULL case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 19

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 20

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   SUCCESS 1212508719 1212508719
FAILED test 21

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 22

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 23

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   SUCCESS 1212508719 1212508719
FAILED test 24

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 25

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 26

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 27

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EACCES  
FAILED test 28

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EACCES  
FAILED test 29

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212508720 0
FAILED test 30

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EACCES  
FAILED test 31

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EACCES  
FAILED test 32

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212508720
FAILED test 33

***** Testing times=={ x, y } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 34

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 35

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 36

============================================================

Testing writable file, not owned by self

***** Testing times==NULL case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508721 1212508721
PASSED test 37

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   EACCES  
FAILED test 38

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508721 1212508721
PASSED test 39

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508721 1212508721
PASSED test 40

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   EACCES  
FAILED test 41

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508721 1212508721
PASSED test 42

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 43

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 44

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 45

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212508722 0
FAILED test 46

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EACCES  
FAILED test 47

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   SUCCESS 1212508722 0
FAILED test 48

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212508722
FAILED test 49

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EACCES  
FAILED test 50

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   SUCCESS 0 1212508722
FAILED test 51

***** Testing times=={ x, y } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 52

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 53

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 54

============================================================

Testing append-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508723 1212508723
PASSED test 55

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508723 1212508723
PASSED test 56

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212508723 1212508723
PASSED test 57

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   EPERM  
FAILED test 58

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   EPERM  
FAILED test 59

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   EPERM  
FAILED test 60

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 61

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 62

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 63

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 64

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 65

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 66

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 67

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 68

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 69

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 70

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 71

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 72

============================================================

Testing immutable file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 73

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 74

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   EPERM  
FAILED test 75

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EPERM  
FAILED test 76

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 77

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 78

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 79

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 80

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 81

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 82

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 83

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 84

============================================================

Testing immutable append-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 85

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 86

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   EPERM  
FAILED test 87

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EPERM  
FAILED test 88

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 89

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 90

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 91

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 92

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 93

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 94

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 95

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 96

============================================================

***** Testing pathname==NULL, dirfd!=AT_FDCWD, flags has AT_SYMLINK_NOFOLLOW *****
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q -n -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EINVAL   
RESULT:   EINVAL  
PASSED test 97

============================================================

tv_sec should be ignored if tv_nsec is UTIME_OMIT or UTIME_NOW
***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 n 1 n
EXPECTED: SUCCESS y  y
RESULT:   EINVAL  
FAILED test 98

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 o 1 o
EXPECTED: SUCCESS n  n
RESULT:   EINVAL  
FAILED test 99

============================================================

Linux hauroko 2.6.26-rc4-default #1 SMP Tue May 27 21:07:14 CEST 2008 i686 i686 i386 GNU/Linux
Tue Jun  3 17:58:48 CEST 2008
Total tests: 99; passed: 74; failed: 25
Failed tests:  21 24 28 29 30 31 32 33 38 41 46 47 48 49 50 51 58 59 60 75 76 87 88 98 99



--------------090606050903030802050700
Content-Type: text/x-log;
 name="utimensat_tests-2.6.26-rc4-utimensat-fix-v4.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="utimensat_tests-2.6.26-rc4-utimensat-fix-v4.log"

============================================================

Testing read-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516206 1212516206
PASSED test 1

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516206 1212516206
PASSED test 2

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516206 1212516206
PASSED test 3

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516206 1212516206
PASSED test 4

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516206 1212516206
PASSED test 5

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516206 1212516206
PASSED test 6

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 7

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 8

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 9

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212516207 0
PASSED test 10

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212516207 0
PASSED test 11

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: SUCCESS y  n
RESULT:   SUCCESS 1212516207 0
PASSED test 12

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212516207
PASSED test 13

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212516207
PASSED test 14

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: SUCCESS n  y
RESULT:   SUCCESS 0 1212516207
PASSED test 15

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 16

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 17

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1 1
PASSED test 18

============================================================

Testing read-only file, not owned by self

***** Testing times==NULL case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 19

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 20

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 21

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 22

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 23

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 24

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 25

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 26

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 27

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 28

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 29

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 30

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 31

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 32

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 33

***** Testing times=={ x, y } case *****
Pathname test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 34

Readable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 35

Writable file descriptor (futimens(3)) test
Owner=root; perms=-r--------; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 36

============================================================

Testing writable file, not owned by self

***** Testing times==NULL case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516210 1212516210
PASSED test 37

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516210 1212516210
PASSED test 38

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516210 1212516210
PASSED test 39

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516210 1212516210
PASSED test 40

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516210 1212516210
PASSED test 41

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516210 1212516210
PASSED test 42

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 43

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 44

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 45

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 46

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 47

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 48

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 49

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 50

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 51

***** Testing times=={ x, y } case *****
Pathname test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 52

Readable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 53

Writable file descriptor (futimens(3)) test
Owner=root; perms=-rw-rw-rw-; EFAs=---
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 54

============================================================

Testing append-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516212 1212516212
PASSED test 55

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516212 1212516212
PASSED test 56

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516212 1212516212
PASSED test 57

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516212 1212516212
PASSED test 58

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516212 1212516212
PASSED test 59

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516212 1212516212
PASSED test 60

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 61

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 62

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 63

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 64

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 65

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 66

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 67

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 68

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 69

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 70

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 71

Writable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Append_Only
./test_utimensat -q -w -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 72

============================================================

Testing immutable file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 73

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 74

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 75

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 76

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 77

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 78

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 79

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 80

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 81

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 82

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 83

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 84

============================================================

Testing immutable append-only file, owned by self

***** Testing times==NULL case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 85

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 86

***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 87

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 n
EXPECTED: EACCES   
RESULT:   EACCES  
PASSED test 88

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 89

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 90

***** Testing times=={ UTIME_NOW, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 91

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 n 0 o
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 92

***** Testing times=={ UTIME_OMIT, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 93

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 0 o 0 n
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 94

***** Testing times=={ x, y } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 95

Readable file descriptor (futimens(3)) test
Owner=mtk; perms=-rw-------; EFAs=Immutable,Append_Only
./test_utimensat -q -d /tmp/utimensat_tests/utimensat.test_file NULL 1 1 1 1
EXPECTED: EPERM   
RESULT:   EPERM  
PASSED test 96

============================================================

***** Testing pathname==NULL, dirfd!=AT_FDCWD, flags has AT_SYMLINK_NOFOLLOW *****
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q -n -d /tmp/utimensat_tests/utimensat.test_file NULL 
EXPECTED: EINVAL   
RESULT:   EINVAL  
PASSED test 97

============================================================

tv_sec should be ignored if tv_nsec is UTIME_OMIT or UTIME_NOW
***** Testing times=={ UTIME_NOW, UTIME_NOW } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 n 1 n
EXPECTED: SUCCESS y  y
RESULT:   SUCCESS 1212516216 1212516216
PASSED test 98

***** Testing times=={ UTIME_OMIT, UTIME_OMIT } case *****
Pathname test
Owner=mtk; perms=-rw-------; EFAs=---
./test_utimensat -q /tmp/utimensat_tests/utimensat.test_file 1 o 1 o
EXPECTED: SUCCESS n  n
RESULT:   SUCCESS 0 0
PASSED test 99

============================================================

Linux hauroko 2.6.26-rc4-utimensat-fix-v4-default #9 SMP Tue Jun 3 14:10:01 CEST 2008 i686 i686 i386 GNU/Linux
Tue Jun  3 20:03:37 CEST 2008
Total tests: 99; passed: 99; failed: 0



--------------090606050903030802050700--
