Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYF0GQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYF0GQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYF0GQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:16:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:55550 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYF0GQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:reply-to:content-type
         :content-transfer-encoding;
        b=l7I5xTWLc+CEhj9+00amNj7hQZ3HUZgt0jx0SucyxG8MUuJM7V+8xbt2zXOY5p1jiY
         tgWMyCkJX48TGpAIEusdtaRs7xuxByVWpKRjsTnB31XjMdgvjSwM9og/AVDiyk7Qlf61
         fU3I59HcG4h4SWFhjbB7jsI1rZmmSpzRsfN5w=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: early res print out alignment
Date: Thu, 26 Jun 2008 23:17:48 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806252151.29028.yhlu.kernel@gmail.com>
In-Reply-To: <200806252151.29028.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806262317.48716.yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -828,16 +828,26 @@ void __init free_early(u64 start, u64 en
 
 void __init early_res_to_bootmem(u64 start, u64 end)
 {
-	int i;
+	int i, count;
 	u64 final_start, final_end;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+
+	count  = 0;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++)
+		count++;
+
+	printk(KERN_INFO "(%d early reservations):\n", count);
+	for (i = 0; i < count; i++) {
 		struct early_res *r = &early_res[i];
+		printk(KERN_INFO "  #%d [%08llx-%08llx] %16s", i,
+			r->start, r->end - 1, r->name);
 		final_start = max(start, r->start);
 		final_end = min(end, r->end);
-		if (final_start >= final_end)
+		if (final_start >= final_end) {
+			printk(KERN_INFO "\n");
 			continue;
-		printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
-			final_start, final_end - 1, r->name);
+		}
+		printk(KERN_CONT " ==> [%08llx-%08llx] converted\n",
+			final_start, final_end - 1);
 		reserve_bootmem_generic(final_start, final_end - final_start,
 				BOOTMEM_DEFAULT);
 	}
