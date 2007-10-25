Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbXJYOSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbXJYOSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761110AbXJYOSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:18:21 -0400
Received: from rich-paul.net ([70.85.129.89]:42030 "EHLO rich-paul.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761057AbXJYOSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:18:20 -0400
X-Spam-Check-By: rich-paul.net
Date: Thu, 25 Oct 2007 10:11:07 -0400
From: Rich Paul <socketpair_bug@rich-paul.net>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG in sys_socketpair
Message-ID: <20071025141107.GA19437@dragon.rich-paul.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.23, there seems to be a minor bug in sys_socketpair.  When the
calls to sock_alloc_fd fail, it aborts the routine, but it returns the
variable err, which is not set in this case.

The result is a silent failure if you have too many files open and call
socketpair.

Here is a simple UNTESTED patch (not even compiled) which should resolve the
issue.

Regards,
Rich

--- net/socket.c.orig   2007-10-25 10:03:56.000000000 -0400
+++ net/socket.c        2007-10-25 10:04:00.000000000 -0400
@@ -1245,11 +1245,14 @@
                goto out_release_both;

        fd1 = sock_alloc_fd(&newfile1);
-       if (unlikely(fd1 < 0))
+       if (unlikely(fd1 < 0)) {
+               err=fd1;
                goto out_release_both;
+       }

        fd2 = sock_alloc_fd(&newfile2);
        if (unlikely(fd2 < 0)) {
+               err=fd2;
                put_filp(newfile1);
                put_unused_fd(fd1);
                goto out_release_both;

