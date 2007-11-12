Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbXKLPqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbXKLPqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXKLPqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:46:22 -0500
Received: from [198.99.130.12] ([198.99.130.12]:58078 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbXKLPqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:46:21 -0500
Date: Mon, 12 Nov 2007 10:45:43 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] UML - Fix recvmsg return value checking
Message-ID: <20071112154543.GA5571@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stupid bug - we need to compare the return value of recvmsg to the
value of iov_len, not its size.  This caused port_helper processes not
to be killed on shutdown on x86_64 because the pids weren't being
passed out properly.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/um/os-Linux/file.c
===================================================================
--- linux-2.6.orig/arch/um/os-Linux/file.c	2007-11-12 10:26:26.000000000 -0500
+++ linux-2.6/arch/um/os-Linux/file.c	2007-11-12 10:32:30.000000000 -0500
@@ -496,8 +496,7 @@ int os_rcv_fd(int fd, int *helper_pid_ou
 	n = recvmsg(fd, &msg, 0);
 	if(n < 0)
 		return -errno;
-
-	else if(n != sizeof(iov.iov_len))
+	else if(n != iov.iov_len)
 		*helper_pid_out = -1;
 
 	cmsg = CMSG_FIRSTHDR(&msg);
