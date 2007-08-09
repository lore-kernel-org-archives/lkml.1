Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbXHIEnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbXHIEnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXHIEmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:42:32 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:50250 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbXHIEma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:42:30 -0400
Message-Id: <20070809044125.276249230@goodmis.org>
References: <20070809043626.830486783@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 09 Aug 2007 00:36:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH 3/5 -v2] Remove __pa() use in hvc_lguest
Content-Disposition: inline; filename=0003-Remove-__pa-use-in-hvc_lguest.txt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hvc_lguest uses __pa in the const initialization.
In some architectures, __pa() is not constant so this fails in compiles.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/hvc_lguest.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hvc_lguest.c b/drivers/char/hvc_lguest.c
index feeccba..c7d7d4c 100644
--- a/drivers/char/hvc_lguest.c
+++ b/drivers/char/hvc_lguest.c
@@ -42,7 +42,6 @@
  * use of physical address for the buffer itself. */
 static char inbuf[256];
 static struct lguest_dma cons_input = { .used_len = 0,
-					.addr[0] = __pa(inbuf),
 					.len[0] = sizeof(inbuf),
 					.len[1] = 0 };
 
@@ -114,6 +113,13 @@ static struct hv_ops lguest_cons = {
  * (0), and the struct hv_ops containing the put_chars() function. */
 static int __init cons_init(void)
 {
+	/*
+	 * We can't initialize using __pa in const declarations,
+	 * since __pa(inbuf) does not evaluate into a constant on
+	 * all architectures (namely x86_64).
+	 */
+	cons_input.addr[0] = __pa(inbuf);
+
 	if (strcmp(paravirt_ops.name, "lguest") != 0)
 		return 0;
 
-- 
1.4.4.4

-- 
