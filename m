Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbZJWJlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbZJWJlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZJWJlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:41:46 -0400
Received: from host-181-75-169-83.static.internet-fr.net ([83.169.75.181]:44716
	"EHLO seanodes.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbZJWJlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:41:45 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Oct 2009 05:41:44 EDT
Message-ID: <4AE178AF.3010804@gmail.com>
Date: Fri, 23 Oct 2009 11:34:39 +0200
From: Erwan Velu <erwanaliasr1@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org
Subject: [PATCH] dmi_check_system can generate Warnings when no DMI table
 is present
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running the Linux Kernel, on some systems that doesn't have any DMI 
table (like a Xen domU), some dmi_* calls can generates Warnings like :

>/ WARNING: at /usr/src/linux-2.6.29.1/drivers/firmware/dmi_scan.c:425/
>/ dmi_matches+0x7e/0x80()/
>/ dmi check: not initialized yet/

Some users reported this error :
http://lists.xensource.com/archives/html/xen-users/2009-04/msg00128.html
https://qa.mandriva.com/show_bug.cgi?id=54775

When the kernel is compiled with CONFIG_DMI, dmi_check_system(), 
dmi_first_match(), dmi_name_in_vendors(), dmi_find_device(), 
dmi_get_date(), dmi_match() calls doesn't check the status of the 
dmi_available variable.

When this functions are called and if no valid dmi table has been found, 
this pretty simple patch just return the default values returned when 
CONFIG_DMI isn't set.

This patch applies to the lastest git tree.
I'm CCing the x86 maintainers as I can't find any maintainer of 
drivers/firmware/dmi.

Signed-off-by: Erwan Velu <erwanaliasr1@gmail.com>


diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 938100f..ea8b433 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -457,6 +457,9 @@ int dmi_check_system(const struct dmi_system_id *list)
     int count = 0;
     const struct dmi_system_id *d;
 
+    if (!dmi_available)
+        return 0;
+
     for (d = list; d->ident; d++)
         if (dmi_matches(d)) {
             count++;
@@ -484,6 +487,9 @@ const struct dmi_system_id *dmi_first_match(const 
struct dmi_system_id *list)
 {
     const struct dmi_system_id *d;
 
+    if (!dmi_available)
+        return NULL;
+
     for (d = list; d->ident; d++)
         if (dmi_matches(d))
             return d;
@@ -501,6 +507,9 @@ EXPORT_SYMBOL(dmi_first_match);
  */
 const char *dmi_get_system_info(int field)
 {
+    if (!dmi_available)
+        return NULL;
+
     return dmi_ident[field];
 }
 EXPORT_SYMBOL(dmi_get_system_info);
@@ -512,6 +521,10 @@ EXPORT_SYMBOL(dmi_get_system_info);
 int dmi_name_in_serial(const char *str)
 {
     int f = DMI_PRODUCT_SERIAL;
+
+    if (!dmi_available)
+        return 0;
+
     if (dmi_ident[f] && strstr(dmi_ident[f], str))
         return 1;
     return 0;
@@ -527,6 +540,10 @@ int dmi_name_in_vendors(const char *str)
                 DMI_PRODUCT_NAME, DMI_PRODUCT_VERSION, DMI_BOARD_VENDOR,
                 DMI_BOARD_NAME, DMI_BOARD_VERSION, DMI_NONE };
     int i;
+
+    if (!dmi_available)
+        return 0;
+
     for (i = 0; fields[i] != DMI_NONE; i++) {
         int f = fields[i];
         if (dmi_ident[f] && strstr(dmi_ident[f], str))
@@ -554,6 +571,9 @@ const struct dmi_device * dmi_find_device(int type, 
const char *name,
     const struct list_head *head = from ? &from->list : &dmi_devices;
     struct list_head *d;
 
+    if (!dmi_available)
+        return NULL;
+
     for(d = head->next; d != &dmi_devices; d = d->next) {
         const struct dmi_device *dev =
             list_entry(d, struct dmi_device, list);
@@ -592,6 +612,16 @@ bool dmi_get_date(int field, int *yearp, int 
*monthp, int *dayp)
     const char *s, *y;
     char *e;
 
+    if (!dmi_available) {
+            if (yearp)
+                    *yearp = 0;
+            if (monthp)
+                    *monthp = 0;
+            if (dayp)
+                    *dayp = 0;
+            return false;
+    }
+
     s = dmi_get_system_info(field);
     exists = s;
     if (!exists)
@@ -676,6 +706,9 @@ bool dmi_match(enum dmi_field f, const char *str)
 {
     const char *info = dmi_get_system_info(f);
 
+    if (!dmi_available)
+        return false;
+
     if (info == NULL || str == NULL)
         return info == str;
 

