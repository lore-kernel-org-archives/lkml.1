Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbXA3TBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbXA3TBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXA3TBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:01:25 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:45015 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXA3TBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IoX6Ht+2IeHV2oEUUe+bOvbnTaw7HuuyJSvXepgkI2aitUAg7fbOPvdRWztPSqwZIjwxe1fkQ7gojzkhmsj0Tnovly5SXGaCT9kzGYe17AapHmaGc8B0itwDl84w+APOPJsreCHgO07czquNfRvfvWXhJTVDGG1eDvIq+FTDpSA=
Subject: [PATCH] EFI x86: pass firmware call parameters on the stack
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: artiom.myaskouvskey@intel.com, bjorn.helgaas@hp.com, akpm@osdl.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 20:01:18 +0100
Message-Id: <1170183678.21603.73.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When calling into an EFI firmware, the parameters need to be passed on
the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
This patch is needed to allow the new Intel-based Macs to suspend to ram
when run in EFI mode (efi.get_time is called during the suspend phase).

Signed-off-by: Frederic Riss <frederic.riss@gmail.com>

---

[As I couldn't find an official maintainer for the linux/efi.h file and
the file header is quite old, I'm Cc:ing the last 2 commiters.]

This patch fixes the issue for x86, but the file is also used by IA64. I
would have used asmlinkage to force arguments on the stack, but it has a
special meaning on IA64, thus I used a raw regparm(0) GCC attribute.
This attribute is documented only for x86, I hope it has no side effect
on other archs.

diff --git a/include/linux/efi.h b/include/linux/efi.h
index df1c918..1db5321 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -157,25 +157,35 @@ typedef struct {
 	unsigned long reset_system;
 } efi_runtime_services_t;
 
-typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
-typedef efi_status_t efi_set_time_t (efi_time_t *tm);
+typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc)
+			__attribute__((regparm(0)));
+typedef efi_status_t efi_set_time_t (efi_time_t *tm)
+			__attribute__((regparm(0)));
 typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
-					    efi_time_t *tm);
-typedef efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm);
+					    efi_time_t *tm)
+			__attribute__((regparm(0)));
+typedef efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm)
+			__attribute__((regparm(0)));
 typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
-					 unsigned long *data_size, void *data);
+					 unsigned long *data_size, void *data)
+			__attribute__((regparm(0)));
 typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
-					      efi_guid_t *vendor);
+					      efi_guid_t *vendor)
+			__attribute__((regparm(0)));
 typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
 					 unsigned long attr, unsigned long data_size, 
-					 void *data);
-typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
+					 void *data)
+			__attribute__((regparm(0)));
+typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count)
+			__attribute__((regparm(0)));
 typedef void efi_reset_system_t (int reset_type, efi_status_t status,
-				 unsigned long data_size, efi_char16_t *data);
+				 unsigned long data_size, efi_char16_t *data)
+			__attribute__((regparm(0)));
 typedef efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_size,
 						unsigned long descriptor_size,
 						u32 descriptor_version,
-						efi_memory_desc_t *virtual_map);
+						efi_memory_desc_t *virtual_map)
+			__attribute__((regparm(0)));
 
 /*
  *  EFI Configuration Table and GUID definitions


