Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbYFXV7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbYFXV7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbYFXV5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:57:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:19356 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbYFXV5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:57:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Lh1CwuTyhWxj8tMQCRxXICO4K8jOfipOKDu7ZqD4wvLI6Gz7lk+ZPN2Rcr5Q3w/kby
         SPoWjlRk9i1GXbNyoQSJdEZ82JXnG46IlImt4so1NPoXq+ahv2ZJlHW84XrZCoxymcAM
         nalQTqSFdyTcSkLZB/YaRCv6B2ZTTMfkKVVTY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: add table_top check for alloc_low_page in 64 bit
Date: Tue, 24 Jun 2008 14:57:29 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806241455.33199.yhlu.kernel@gmail.com> <200806241456.20753.yhlu.kernel@gmail.com>
In-Reply-To: <200806241456.20753.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241457.29607.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


that range is from find_e820_area, so don't try to use end_pfn to see
if out of boundary...use table_top instead to avoid possible strange
result while cross the boundary...

also change early_printk to printk, because init_memory_mapping is after
early param parsing, and console=uart8250 already working at that time.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0c92624..6517642 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -227,6 +227,7 @@ void __init cleanup_highmap(void)
 
 static unsigned long __initdata table_start;
 static unsigned long __meminitdata table_end;
+static unsigned long __meminitdata table_top;
 
 static __meminit void *alloc_low_page(unsigned long *phys)
 {
@@ -240,7 +241,7 @@ static __meminit void *alloc_low_page(unsigned long *phys)
 		return adr;
 	}
 
-	if (pfn >= end_pfn)
+	if (pfn >= table_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
@@ -424,10 +425,10 @@ static void __init find_early_table_space(unsigned long end)
 
 	table_start >>= PAGE_SHIFT;
 	table_end = table_start;
+	table_top = table_start + (tables >> PAGE_SHIFT);
 
-	early_printk("kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, table_start << PAGE_SHIFT,
-		(table_start << PAGE_SHIFT) + tables);
+	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
+		end, table_start << PAGE_SHIFT, table_top << PAGE_SHIFT);
 }
 
 static void __init init_gbpages(void)
