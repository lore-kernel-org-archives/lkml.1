Return-Path: <linux-kernel-owner+w=401wt.eu-S1946435AbXBCKry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946435AbXBCKry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946436AbXBCKry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:47:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11531 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946435AbXBCKrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:47:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VODvX5BLrbMrZNk2qwh3ZahAE2pCW/3xNY1+1pXRbopWIcK8NkzMJEOTY8cdNowieKnr/z4X67KegzVKZUVasj8iYOrHf0eaIoblCVJ++/Wns6jYWxAb7r76z0zHt8qddaDUPLrBbHjr6ExeFb7eYX8BZK/zv3f3+dT06FO13Pk=
Subject: Re: 2.6.20-rc7: known regressions
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
In-Reply-To: <200702031058.13830.ak@suse.de>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	 <200702031033.42940.ak@suse.de> <1170496175.31373.31.camel@funkylaptop>
	 <200702031058.13830.ak@suse.de>
Content-Type: text/plain; charset=utf-8
Date: Sat, 03 Feb 2007 11:47:48 +0100
Message-Id: <1170499668.31373.35.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 03 février 2007 à 10:58 +0100, Andi Kleen a écrit :
> Define a efilinkage macro then that expands to nothing on ia64
> 
> Probably asmlinkage would work already, syscall_linkage as used on ia64 doesn't
> seem to affect function pointers.

And here it goes:

When calling into the EFI firmware, the parameters need to be passed on
the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
This patch is needed to allow the new Intel-based Macs to suspend to ram
(efi.get_time is called during the suspend phase).

Signed-off-by: Frederic Riss <frederic.riss@gmail.com>
---

diff --git a/include/linux/efi.h b/include/linux/efi.h
index f8ebd7c..596e806 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -157,22 +157,39 @@ typedef struct {
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
+#ifdef CONFIG_X86_32
+#define efilinkage asmlinkage
+#else
+#define efilinkage
+#endif
+
+typedef efilinkage efi_status_t efi_get_time_t (efi_time_t *tm,
+						efi_time_cap_t *tc);
+typedef efilinkage efi_status_t efi_set_time_t (efi_time_t *tm);
+typedef efilinkage efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, 
+						       efi_bool_t *pending,
+						       efi_time_t *tm);
+typedef efilinkage efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled,
+						       efi_time_t *tm);
+typedef efilinkage efi_status_t efi_get_variable_t (efi_char16_t *name,
+						    efi_guid_t *vendor,
+						    u32 *attr,
+						    unsigned long *data_size,
+						    void *data);
+typedef efilinkage efi_status_t efi_get_next_variable_t (unsigned long *name_sz,
+							 efi_char16_t *name,
+							 efi_guid_t *vendor);
+typedef efilinkage efi_status_t efi_set_variable_t (efi_char16_t *name,
+						    efi_guid_t *vendor,
+						    unsigned long attr,
+						    unsigned long data_size,
+						    void *data);
+typedef efilinkage efi_status_t efi_get_next_high_mono_count_t (u32 *count);
+typedef efilinkage void efi_reset_system_t (int reset_type, 
+					    efi_status_t status,
+					    unsigned long data_size,
+					    efi_char16_t *data);
+typedef efilinkage efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_size,
 						unsigned long descriptor_size,
 						u32 descriptor_version,
 						efi_memory_desc_t *virtual_map);



