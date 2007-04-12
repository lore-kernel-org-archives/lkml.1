Return-Path: <linux-kernel-owner+w=401wt.eu-S1751052AbXDLQdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbXDLQdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXDLQdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:33:25 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50715 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXDLQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:33:24 -0400
Date: Thu, 12 Apr 2007 12:28:05 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 5/6 ] UML - AIO deadlock avoidance
Message-ID: <20070412162805.GA7250@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow deadlocks to be avoided in the AIO code by setting the pipe to
the I/O thread non-blocking.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/aio.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.21-mm/arch/um/os-Linux/aio.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/aio.c	2007-04-12 11:34:40.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/aio.c	2007-04-12 11:47:14.000000000 -0400
@@ -221,6 +221,11 @@ static int init_aio_24(void)
 
 	aio_req_fd_w = fds[0];
 	aio_req_fd_r = fds[1];
+
+	err = os_set_fd_block(aio_req_fd_w, 0);
+	if(err)
+		goto out_close_pipe;
+
 	err = run_helper_thread(not_aio_thread, NULL,
 				CLONE_FILES | CLONE_VM | SIGCHLD, &stack, 0);
 	if(err < 0)
