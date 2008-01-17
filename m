Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYAQVqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYAQVqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbYAQVlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:46 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44805 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbYAQVlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:44 -0500
Date: Thu, 17 Jan 2008 16:40:46 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Karol Swietlicki <magotari@gmail.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/20] UML - Fix infinite mconsole loop
Message-ID: <20080117214046.GA6762@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karol Swietlicki <magotari@gmail.com>

This patch takes care of a problem with the stopping code.

The function inside the while condition returns 0 to signify a problem.
A problem could be for example a bad command or a bad version of the
mconsole client.
A bad command would terminate the stopping loop and resume the kernel.
This is a problem.

A better solution is to make the loop infinite and don't leave it
until we are explicitly told to.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/mconsole_kern.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/mconsole_kern.c	2007-12-12 13:44:20.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/mconsole_kern.c	2007-12-12 15:53:08.000000000 -0500
@@ -305,7 +305,9 @@ void mconsole_stop(struct mc_request *re
 	deactivate_fd(req->originating_fd, MCONSOLE_IRQ);
 	os_set_fd_block(req->originating_fd, 1);
 	mconsole_reply(req, "stopped", 0, 0);
-	while (mconsole_get_request(req->originating_fd, req)) {
+	for (;;) {
+		if (!mconsole_get_request(req->originating_fd, req))
+			continue;
 		if (req->cmd->handler == mconsole_go)
 			break;
 		if (req->cmd->handler == mconsole_stop) {
