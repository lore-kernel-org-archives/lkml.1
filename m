Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbZFHRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbZFHRz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbZFHRzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:55:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:35583 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZFHRzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:55:17 -0400
Message-ID: <4A2D506C.5060101@kernel.org>
Date: Mon, 08 Jun 2009 10:54:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Peer Chen <pchen@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] firmware_map: fix hang with x86/32bit
References: <bug-13484-13546@http.bugzilla.kernel.org/> <200906080543.n585hQYj017771@demeter.kernel.org> <4A2CB48C.4080707@kernel.org> <15F501D1A78BD343BE8F4D8DB854566B4283361E@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B4283361E@hkemmail01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


http://bugzilla.kernel.org/show_bug.cgi?id=13484

Peer reported:
| The bug is introduced from kernel 2.6.27, if E820 table reserve the memory
| above 4G in 32bit OS(BIOS-e820: 00000000fff80000 - 0000000120000000
| (reserved)), system will report Int 6 error and hang up. The bug is caused by
| the following code in drivers/firmware/memmap.c, the resource_size_t is 32bit
| variable in 32bit OS, the BUG_ON() will be invoked to result in the Int 6
| error. I try the latest 32bit Ubuntu and Fedora distributions, all hit this
| bug.
|======
|static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
|                  const char *type,
|                  struct firmware_map_entry *entry)

and it only happen with CONFIG_PHYS_ADDR_T_64BIT is not set.

it turns out we need to pass u64 instead of resource_size_t for that.

Reported-and-tested-by: Peer Chen <pchen@nvidia.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Bernhard Walle
Cc: stable@kernel.org

---
 drivers/firmware/memmap.c    |   12 +++++-------
 include/linux/firmware-map.h |   12 ++++--------
 2 files changed, 9 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/firmware/memmap.c
===================================================================
--- linux-2.6.orig/drivers/firmware/memmap.c
+++ linux-2.6/drivers/firmware/memmap.c
@@ -31,8 +31,8 @@
  * information is necessary as for the resource tree.
  */
 struct firmware_map_entry {
-	resource_size_t		start;	/* start of the memory range */
-	resource_size_t		end;	/* end of the memory range (incl.) */
+	u64			start;	/* start of the memory range */
+	u64			end;	/* end of the memory range (incl.) */
 	const char		*type;	/* type of the memory range */
 	struct list_head	list;	/* entry for the linked list */
 	struct kobject		kobj;   /* kobject for each entry */
@@ -101,7 +101,7 @@ static LIST_HEAD(map_entries);
  * Common implementation of firmware_map_add() and firmware_map_add_early()
  * which expects a pre-allocated struct firmware_map_entry.
  **/
-static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
+static int firmware_map_add_entry(u64 start, u64 end,
 				  const char *type,
 				  struct firmware_map_entry *entry)
 {
@@ -132,8 +132,7 @@ static int firmware_map_add_entry(resour
  *
  * Returns 0 on success, or -ENOMEM if no memory could be allocated.
  **/
-int firmware_map_add(resource_size_t start, resource_size_t end,
-		     const char *type)
+int firmware_map_add(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
@@ -157,8 +156,7 @@ int firmware_map_add(resource_size_t sta
  *
  * Returns 0 on success, or -ENOMEM if no memory could be allocated.
  **/
-int __init firmware_map_add_early(resource_size_t start, resource_size_t end,
-				  const char *type)
+int __init firmware_map_add_early(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
Index: linux-2.6/include/linux/firmware-map.h
===================================================================
--- linux-2.6.orig/include/linux/firmware-map.h
+++ linux-2.6/include/linux/firmware-map.h
@@ -24,21 +24,17 @@
  */
 #ifdef CONFIG_FIRMWARE_MEMMAP
 
-int firmware_map_add(resource_size_t start, resource_size_t end,
-		     const char *type);
-int firmware_map_add_early(resource_size_t start, resource_size_t end,
-			   const char *type);
+int firmware_map_add(u64 start, u64 end, const char *type);
+int firmware_map_add_early(u64 start, u64 end, const char *type);
 
 #else /* CONFIG_FIRMWARE_MEMMAP */
 
-static inline int firmware_map_add(resource_size_t start, resource_size_t end,
-				   const char *type)
+static inline int firmware_map_add(u64 start, u64 end, const char *type)
 {
 	return 0;
 }
 
-static inline int firmware_map_add_early(resource_size_t start,
-					 resource_size_t end, const char *type)
+static inline int firmware_map_add_early(u64 start, u64 end, const char *type)
 {
 	return 0;
 }
