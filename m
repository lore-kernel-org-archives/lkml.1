Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbXD2NhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbXD2NhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 09:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbXD2NhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 09:37:14 -0400
Received: from ozlabs.org ([203.10.76.45]:47842 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbXD2NhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 09:37:11 -0400
Subject: [PATCH 2/2] lguest: handle new paravirt lazy mode (fix userspace
	segfaults)
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>
In-Reply-To: <1177853697.30071.179.camel@localhost.localdomain>
References: <1177853697.30071.179.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 23:36:58 +1000
Message-Id: <1177853818.30071.182.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's a new paravirt_lazy_mode mode in town.

Well, it's spelled "mode", but it's pronounced "hack".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -59,9 +59,13 @@ static enum paravirt_lazy_mode lazy_mode
 static enum paravirt_lazy_mode lazy_mode;
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	lazy_mode = mode;
-	if (mode == PARAVIRT_LAZY_NONE)
+	if (mode == PARAVIRT_LAZY_FLUSH)
 		hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	else {
+		lazy_mode = mode;
+		if (mode == PARAVIRT_LAZY_NONE)
+			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	}
 }
 
 static void lazy_hcall(unsigned long call,


