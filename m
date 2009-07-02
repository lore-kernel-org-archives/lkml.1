Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZGBHWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZGBHWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZGBHWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:22:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:20708 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZGBHWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=urzjYvTYUwF+EfSocKrCHnEA1GcDpShMTIpC5Zv3QabzP+X20lJ2TuYaRIVCXgonA+
         Y04TMJ7FjeDrXuSi5vJYE+Cl9+QyVk9EKiV4TxQKg41debT1xf44aQDwYU1xKWd7SXQL
         4Ho9WNS6V22qJXYMrocKPoc+7BL69UdOusSxo=
Message-ID: <4A4C6013.9090509@gmail.com>
Date: Thu, 02 Jul 2009 15:21:55 +0800
From: Changli Gao <xiaosuo@gmail.com>
Reply-To: xiaosuo@gmail.com
User-Agent: Thunderbird 2.0.0.21 (X11/20090505)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: xiaosuo <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: PATCH: fd leak if pipe() is called with an invalid address.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fd leak if pipe() is called with an invalid address.

Though -EFAULT is returned, the file descriptors opened by pipe() call
are left open.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----

 x86/ia32/sys_ia32.c     |    5 ++++-
 xtensa/kernel/syscall.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


--- arch/x86/ia32/sys_ia32.c.orig	2009-07-02 15:08:39.000000000 +0800
+++ arch/x86/ia32/sys_ia32.c	2009-07-02 15:09:49.000000000 +0800
@@ -197,8 +197,11 @@
 	retval = do_pipe_flags(fds, 0);
 	if (retval)
 		goto out;
-	if (copy_to_user(fd, fds, sizeof(fds)))
+	if (copy_to_user(fd, fds, sizeof(fds))) {
+		sys_close(fd[0]);
+		sys_close(fd[1]);
 		retval = -EFAULT;
+	}
 out:
 	return retval;
 }
--- arch/xtensa/kernel/syscall.c.orig	2009-07-02 15:09:01.000000000 +0800
+++ arch/xtensa/kernel/syscall.c	2009-07-02 15:10:15.000000000 +0800
@@ -51,8 +51,11 @@
 
 	error = do_pipe_flags(fd, 0);
 	if (!error) {
-		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
+		if (copy_to_user(userfds, fd, 2 * sizeof(int))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
 			error = -EFAULT;
+		}
 	}
 	return error;
 }

