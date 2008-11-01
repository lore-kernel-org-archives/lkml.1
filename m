Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYKACCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYKACCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 22:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYKACBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 22:01:52 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:47635 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbYKACBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 22:01:51 -0400
Subject: Re: [PATCH 1/4] Check for serial key in dmi_name_in_vendors
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <490B8BB2.3070105@zytor.com>
References: <1224894097.28224.71.camel@alok-dev1>
	 <490B8BB2.3070105@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 31 Oct 2008 19:01:50 -0700
Message-Id: <1225504910.4181.30.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since there is only one user, we could change that user, perhaps to take
> a bitmask or pointer to one of several canned lists as an argument, or
> we can introduce another entry point.


Hi hpa, 

I have added a new interface to check for a string in the product serial
information. And now i use this new interface to detect VMware.

This does not touch the dmi_name_in_vendors function, so the original
patch on this thread should be ignored.

Also please note that this new patch needs to be applied on top of the
hypervisor detection patch. 
 
Thanks,
Alok

--
DMI, check for the string in product serial key.

From: Alok N Kataria <akataria@vmware.com>

In some user configured cases, VMware may choose not to put VMware specific DMI
information, but the product serial key is always there and is VMware specific.
Add a interface to check the serial key, and use this new interface when
checking for VMware specific string in the DMI information.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
---

 arch/x86/kernel/cpu/vmware.c |    2 +-
 drivers/firmware/dmi_scan.c  |   11 +++++++++++
 include/linux/dmi.h          |    2 ++
 3 files changed, 14 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index d5d1b75..d0e3918 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -74,7 +74,7 @@ int vmware_platform(void)
 		hyper_vendor_id[12] = '\0';
 		if (!strcmp(hyper_vendor_id, "VMwareVMware"))
 			return 1;
-	} else if (dmi_available && dmi_name_in_vendors("VMware") &&
+	} else if (dmi_available && dmi_name_in_serial("VMware") &&
 		   __vmware_platform())
 		return 1;
 
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 3e526b6..d66d412 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -467,6 +467,17 @@ const char *dmi_get_system_info(int field)
 }
 EXPORT_SYMBOL(dmi_get_system_info);
 
+/**
+ *	dmi_name_in_serial - 	Check if string is in the DMI product serial
+ *				information.
+ */
+int dmi_name_in_serial(const char *str)
+{
+	int f = DMI_PRODUCT_SERIAL;
+	if (dmi_ident[f] && strstr(dmi_ident[f], str))
+		return 1;
+	return 0;
+}
 
 /**
  *	dmi_name_in_vendors - Check if string is anywhere in the DMI vendor information.
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index e5084eb..2bfda17 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -44,6 +44,7 @@ extern const struct dmi_device * dmi_find_device(int type, const char *name,
 extern void dmi_scan_machine(void);
 extern int dmi_get_year(int field);
 extern int dmi_name_in_vendors(const char *str);
+extern int dmi_name_in_serial(const char *str);
 extern int dmi_available;
 extern int dmi_walk(void (*decode)(const struct dmi_header *));
 
@@ -56,6 +57,7 @@ static inline const struct dmi_device * dmi_find_device(int type, const char *na
 static inline void dmi_scan_machine(void) { return; }
 static inline int dmi_get_year(int year) { return 0; }
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
+static inline int dmi_name_in_serial(const char *s) { return 0; }
 #define dmi_available 0
 static inline int dmi_walk(void (*decode)(const struct dmi_header *))
 	{ return -1; }


