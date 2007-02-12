Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbXBLHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbXBLHlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933107AbXBLHkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:40:23 -0500
Received: from ns2.suse.de ([195.135.220.15]:49658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964773AbXBLHib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:31 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [34/39] i386: Use stack arguments for calling into EFI
Message-Id: <20070212073822.8F33E13D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When calling into the EFI firmware, the parameters need to be passed on
the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
This patch is needed to allow the new Intel-based Macs to suspend to ram
(efi.get_time is called during the suspend phase).

Signed-off-by: Frederic Riss <frederic.riss@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/efi.h |   43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

Index: linux/include/linux/efi.h
===================================================================
--- linux.orig/include/linux/efi.h
+++ linux/include/linux/efi.h
@@ -157,22 +157,33 @@ typedef struct {
 	unsigned long reset_system;
 } efi_runtime_services_t;
 
-typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
-typedef efi_status_t efi_set_time_t (efi_time_t *tm);
-typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
-					    efi_time_t *tm);
-typedef efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm);
-typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
-					 unsigned long *data_size, void *data);
-typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
-					      efi_guid_t *vendor);
-typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
-					 unsigned long attr, unsigned long data_size, 
-					 void *data);
-typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
-typedef void efi_reset_system_t (int reset_type, efi_status_t status,
-				 unsigned long data_size, efi_char16_t *data);
-typedef efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_size,
+typedef asmlinkage efi_status_t efi_get_time_t (efi_time_t *tm,
+						efi_time_cap_t *tc);
+typedef asmlinkage efi_status_t efi_set_time_t (efi_time_t *tm);
+typedef asmlinkage efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled,
+						       efi_bool_t *pending,
+						       efi_time_t *tm);
+typedef asmlinkage efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled,
+						       efi_time_t *tm);
+typedef asmlinkage efi_status_t efi_get_variable_t (efi_char16_t *name,
+						    efi_guid_t *vendor,
+						    u32 *attr,
+						    unsigned long *data_size,
+						    void *data);
+typedef asmlinkage efi_status_t efi_get_next_variable_t (unsigned long *name_sz,
+							 efi_char16_t *name,
+							 efi_guid_t *vendor);
+typedef asmlinkage efi_status_t efi_set_variable_t (efi_char16_t *name,
+						    efi_guid_t *vendor,
+						    unsigned long attr,
+						    unsigned long data_size,
+						    void *data);
+typedef asmlinkage efi_status_t efi_get_next_high_mono_count_t (u32 *count);
+typedef asmlinkage void efi_reset_system_t (int reset_type,
+					    efi_status_t status,
+					    unsigned long data_size,
+					    efi_char16_t *data);
+typedef asmlinkage efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_size,
 						unsigned long descriptor_size,
 						u32 descriptor_version,
 						efi_memory_desc_t *virtual_map);
