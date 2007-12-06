Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbXLFRHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbXLFRHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbXLFRHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:07:01 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:32908 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXLFRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:06:59 -0500
Date: Thu, 6 Dec 2007 12:06:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Karol Swietlicki <magotari@gmail.com>
Subject: [PATCH 3/6] UML - fix mconsole stop
Message-ID: <20071206170641.GA7440@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karol Swietlicki <magotari@gmail.com>

This patch brings back the functionality of stopping user mode linux
with the help of mconsole.

[ jdike - the bug being fixed is that the mconsole file descriptor is
already set O_NONBLOCK or not, depending on whether we want no
blocking (the normal case) or we want blocking (when an mconsole stop
is in effect), so the MSG_DONTWAIT is redundant in the normal case,
and wrong when we want to block. ]

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/mconsole_user.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.22/arch/um/drivers/mconsole_user.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/mconsole_user.c	2007-12-05 10:49:25.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/mconsole_user.c	2007-12-05 12:21:05.000000000 -0500
@@ -83,9 +83,8 @@ int mconsole_get_request(int fd, struct 
 	int len;
 
 	req->originlen = sizeof(req->origin);
-	req->len = recvfrom(fd, &req->request, sizeof(req->request),
-			    MSG_DONTWAIT, (struct sockaddr *) req->origin,
-			    &req->originlen);
+	req->len = recvfrom(fd, &req->request, sizeof(req->request), 0,
+			    (struct sockaddr *) req->origin, &req->originlen);
 	if (req->len < 0)
 		return 0;
 
