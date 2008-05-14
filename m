Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYENPoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYENPoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYENPoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:44:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:51688 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYENPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=rLEWKW2syUAW+lWFyxEWYojktDNEQj+emntmwpg/fWwQNC9wEENmlXsfDt0MJBcWdDEXAo4bJy+FFMCQ4G3il4xKcBymixbcorSSevQsjTfdtyvp7o1iGrmEjV9DQaTAWlpOuG2PwTyCFxf3stZojhVOv9ezZI641xn9icxVMJs=
Date: Wed, 14 May 2008 19:44:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Andreas Schwab <schwab@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] init - fix building bug and potential buffer overflow
Message-ID: <20080514154402.GF6902@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does fix build bug on m68k wich does not have strncat in straight way.

What is more important - my previous patch

commit e662e1cfd434aa234b72fbc781f1d70211cb785b
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Mon May 12 14:02:22 2008 -0700

    init: don't lose initcall return values

has introduced potential buffer overflow by wrong calculation
of string accumulator size.

Many thanks Andreas Schwab and Geert Uytterhoeven for helping
to catch and fix the bug.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/init/main.c
===================================================================
--- linux-2.6.git.orig/init/main.c	2008-05-14 17:55:10.000000000 +0400
+++ linux-2.6.git/init/main.c	2008-05-14 19:11:18.000000000 +0400
@@ -702,7 +702,7 @@ static void __init do_initcalls(void)
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		ktime_t t0, t1, delta;
-		char msgbuf[40];
+		char msgbuf[64];
 		int result;
 
 		if (initcall_debug) {
@@ -729,11 +729,11 @@ static void __init do_initcalls(void)
 			sprintf(msgbuf, "error code %d ", result);
 
 		if (preempt_count() != count) {
-			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
+			strcat(msgbuf, "preemption imbalance ");
 			preempt_count() = count;
 		}
 		if (irqs_disabled()) {
-			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
+			strcat(msgbuf, "disabled interrupts ");
 			local_irq_enable();
 		}
 		if (msgbuf[0]) {
