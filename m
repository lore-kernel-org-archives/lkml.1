Return-Path: <linux-kernel-owner+w=401wt.eu-S1763549AbXJRJu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549AbXJRJu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbXJRJuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:50:13 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:40040 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1755347AbXJRJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:50:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 05:50:11 EDT
Message-ID: <471728F7.6020809@dev.rtsoft.ru>
Date: Thu, 18 Oct 2007 13:35:51 +0400
From: Dmitry Antipov <antipov@dev.rtsoft.ru>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] -EINVAL if no fasync op for file
Content-Type: multipart/mixed;
 boundary="------------040703020206030006080805"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040703020206030006080805
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch proposes an additional error checking performed within setfl().

As a result, fcntl (fd, F_SETFL, O_ASYNC) will return -1 and set errno
to -EINVAL if filp->f_op->fasync is NULL for file specified by fd. This
is possible, for example, if fd is a descriptor returned by inotify_init().


Dmitry


--------------040703020206030006080805
Content-Type: text/x-patch;
 name="2.6.23-fcntl-fasync-check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.23-fcntl-fasync-check.patch"

Signed-off-by: Dmitry Antipov <antipov@dev.rtsoft.ru>

--- .orig-2.6.23/fs/fcntl.c	2007-10-17 15:26:06.000000000 +0400
+++ 2.6.23/fs/fcntl.c	2007-10-17 15:25:27.000000000 +0400
@@ -240,6 +240,9 @@
 			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
 			if (error < 0)
 				goto out;
+		} else {
+			error = -EINVAL;
+			goto out;
 		}
 	}
 

--------------040703020206030006080805--
