Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYFWNcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYFWNcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYFWNck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:32:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54970 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751647AbYFWNck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:32:40 -0400
To: mingo@elte.hu
Subject: [PATCH] SGI UV: uv_ptc_proc_write security hole
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAm9h-0002Fe-8a@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 23 Jun 2008 08:32:25 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

Someone could write 0 bytes to /proc/sgi_uv/ptc_statistics,
causing
  optstr[count - 1] = '\0';
to write to who-knows-where.

(Andi Kleen noticed this need from a patch I sent for
 similar code in the ia64 world (sn2_ptc_proc_write()).)

(count less than zero is not possible here, as count is unsigned)

Diffed against 2.6.26-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -492,7 +492,7 @@ static ssize_t uv_ptc_proc_write(struct 
 	long newmode;
 	char optstr[64];
 
-	if (count > 64)
+	if (count == 0 || count > sizeof(optstr))
 		return -EINVAL;
 	if (copy_from_user(optstr, user, count))
 		return -EFAULT;
