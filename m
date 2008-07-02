Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbYGBDCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbYGBDCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759017AbYGBDCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:02:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:24000 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981AbYGBDCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DcxJKV8kfU3E5RCtSBXoqJvEijdW42R+d/+/udW5955Rz1g39oK93blm3DSEh1CE08
         OGa113Iq6DybmhduN5btWXkXWkVwi9XnWkuiQCGZPTGxmz4aAfeoyg6kn7GgLEDNfWVB
         Wis9jVJMpq+tL2r/tjHYOWDDuIDH9EIzWbvLo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: change copy_e820_map to append_e820_map
Date: Tue, 1 Jul 2008 20:02:16 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200806301834.59156.yhlu.kernel@gmail.com>
In-Reply-To: <200806301834.59156.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012002.16622.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so it has meaningfull name.
also change it to static

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   15 ++++++++-------
 include/asm-x86/e820.h |    1 -
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -360,7 +360,7 @@ int __init sanitize_e820_map(struct e820
 	return 0;
 }
 
-static int __init __copy_e820_map(struct e820entry *biosmap, int nr_map)
+static int __init __append_e820_map(struct e820entry *biosmap, int nr_map)
 {
 	while (nr_map) {
 		u64 start = biosmap->addr;
@@ -389,13 +389,13 @@ static int __init __copy_e820_map(struct
  * will have given us a memory map that we can use to properly
  * set up memory.  If we aren't, we'll fake a memory map.
  */
-int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
+static int __init append_e820_map(struct e820entry *biosmap, int nr_map)
 {
 	/* Only one memory region (or negative)? Ignore it */
 	if (nr_map < 2)
 		return -1;
 
-	return __copy_e820_map(biosmap, nr_map);
+	return __append_e820_map(biosmap, nr_map);
 }
 
 u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
@@ -581,7 +581,7 @@ void __init parse_e820_ext(struct setup_
 	if (map_len > PAGE_SIZE)
 		sdata = early_ioremap(pa_data, map_len);
 	extmap = (struct e820entry *)(sdata->data);
-	__copy_e820_map(extmap, entries);
+	__append_e820_map(extmap, entries);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 	if (map_len > PAGE_SIZE)
 		early_iounmap(sdata, map_len);
@@ -1245,7 +1245,8 @@ char *__init default_machine_specific_me
 			ARRAY_SIZE(boot_params.e820_map),
 			&new_nr);
 	boot_params.e820_entries = new_nr;
-	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0) {
+	if (append_e820_map(boot_params.e820_map, boot_params.e820_entries)
+	  < 0) {
 		u64 mem_size;
 
 		/* compare results from other methods and take the greater */
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -67,7 +67,6 @@ extern void e820_add_region(u64 start, u
 extern void e820_print_map(char *who);
 extern int
 sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, int *pnr_map);
-extern int copy_e820_map(struct e820entry *biosmap, int nr_map);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
