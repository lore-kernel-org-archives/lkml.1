Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYGJLRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYGJLRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYGJLRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:17:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:22022 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYGJLRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JUv+piW3oyS+3uJ661MUykJ5dHFbp9+CWgh9f05hwLmvQoKLZIiuxPfp+xnTCGG6BD
         /PIZGfFzEh/hcb9xUCnhPWmQBCiE+KmQLjYY0XG2aKJGapITC4XxQWHron5Tno5wCTKx
         80UYpi/PEf7y2DLWhkLP1QWoaoMqRjQSSmfCA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: e820 remove the range instead of update it to reserved
Date: Thu, 10 Jul 2008 04:17:00 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Bernhard Walle <bwalle@suse.de>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092016.36490.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com>
In-Reply-To: <200807092017.51004.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807100417.00285.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also let mem= to print out modified e820 map too

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1165,6 +1165,8 @@ static void early_panic(char *msg)
 	panic(msg);
 }
 
+static int userdef __initdata;
+
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
 {
@@ -1180,17 +1182,15 @@ static int __init parse_memopt(char *p)
 	}
 #endif
 
+	userdef = 1;
 	mem_size = memparse(p, &p);
 	end_user_pfn = mem_size>>PAGE_SHIFT;
-	e820_update_range(mem_size, ULLONG_MAX - mem_size,
-		E820_RAM, E820_RESERVED);
+	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
 }
 early_param("mem", parse_memopt);
 
-static int userdef __initdata;
-
 static int __init parse_memmap_opt(char *p)
 {
 	char *oldp;
@@ -1230,8 +1230,7 @@ static int __init parse_memmap_opt(char
 		e820_add_region(start_at, mem_size, E820_RESERVED);
 	} else {
 		end_user_pfn = (mem_size >> PAGE_SHIFT);
-		e820_update_range(mem_size, ULLONG_MAX - mem_size,
-			E820_RAM, E820_RESERVED);
+		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 	}
 	return *p == '\0' ? 0 : -EINVAL;
 }
