Return-Path: <linux-kernel-owner+w=401wt.eu-S1762844AbYF0Wha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762844AbYF0Wha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYF0WhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:37:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:47745 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbYF0WhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YNK1oDsFukslRRsheD6hgm0z0pM/htvVTGsAAFpSTLcDt5SIluaZsxMkjYmTtdlTXa
         wQLLOOtpqrErekI29s5FHHyLlRCfwhy4atw3tAVKwBqzkskhy2/GnQ9KY6RMVBs1o0UI
         4tnY9qvjCEELQu+rAANsQcPp5yvXpzSdMjj/Y=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: early res print out alignment v2
Date: Fri, 27 Jun 2008 15:36:54 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806252151.29028.yhlu.kernel@gmail.com> <200806262317.48716.yhlu.kernel@gmail.com>
In-Reply-To: <200806262317.48716.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271536.54351.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2: fix print info to cont
    [ - ] change to xxx - xxx

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
+	printk(KERN_INFO "(%d early reservations) ==> bootmem\n", count);
+	for (i = 0; i < count; i++) {
 		struct early_res *r = &early_res[i];
+		printk(KERN_INFO "  #%d %010llx - %010llx %16s", i,
+			r->start, r->end, r->name);
 		final_start = max(start, r->start);
 		final_end = min(end, r->end);
-		if (final_start >= final_end)
+		if (final_start >= final_end) {
+			printk(KERN_CONT "\n");
 			continue;
-		printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
-			final_start, final_end - 1, r->name);
+		}
+		printk(KERN_CONT " ==> %010llx - %010llx\n",
+			final_start, final_end);
 		reserve_bootmem_generic(final_start, final_end - final_start,
 				BOOTMEM_DEFAULT);
 	}
