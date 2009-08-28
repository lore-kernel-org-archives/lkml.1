Return-Path: <linux-kernel-owner+w=401wt.eu-S1751765AbZH1Jsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbZH1Jsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZH1Jsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:48:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36165 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZH1Jsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:48:53 -0400
Message-ID: <4A97A7FD.1000202@in.ibm.com>
Date: Fri, 28 Aug 2009 15:18:45 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix compat_sys_utimensat 
Content-Type: multipart/mixed;
 boundary="------------050005020803010602060000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050005020803010602060000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi,

The compat_utimensat syscall does not ignore tv_sec field when tv_nsec 
is set to UTIME_OMIT/UTIME_NOW and returns -EINVAL.

This problem was revealed with the utimensat_tests from LTP.

The utimensat() syscall works fine.

Attaching a patch for the issue. The patch has been tested and verified 
to fix the issue.

Please apply.

Thanks,

Suzuki

--------------050005020803010602060000
Content-Type: text/plain;
 name="fix-compat-utimensat-syscall.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-compat-utimensat-syscall.diff"

Compat utimensat() returns EINVAL when the tv_nsec is one of UTIME_OMIT or UTIME_NOW and
the tv_sec is set to non-zero. As per man pages, the tv_sec field should be ignored.

The sys_utimensat() works fine in this case.

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>

Index: linux-2.6.31-rc7/fs/compat.c
===================================================================
--- linux-2.6.31-rc7.orig/fs/compat.c	2009-08-22 06:30:46.000000000 +0530
+++ linux-2.6.31-rc7/fs/compat.c	2009-08-28 14:14:32.781364904 +0530
@@ -100,13 +100,6 @@
 		    get_compat_timespec(&tv[1], &t[1]))
 			return -EFAULT;
 
-		if ((tv[0].tv_nsec == UTIME_OMIT || tv[0].tv_nsec == UTIME_NOW)
-		    && tv[0].tv_sec != 0)
-			return -EINVAL;
-		if ((tv[1].tv_nsec == UTIME_OMIT || tv[1].tv_nsec == UTIME_NOW)
-		    && tv[1].tv_sec != 0)
-			return -EINVAL;
-
 		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
 			return 0;
 	}

--------------050005020803010602060000--
