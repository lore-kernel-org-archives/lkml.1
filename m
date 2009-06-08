Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZFHGva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZFHGva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZFHGvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:51:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:50468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbZFHGvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:51:22 -0400
Message-ID: <4A2CB48C.4080707@kernel.org>
Date: Sun, 07 Jun 2009 23:49:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: bugzilla-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peer Chen <pchen@nvidia.com>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [Bug 13484] System report Int 6 error if E820 table reserve the
 memory above 4G
References: <bug-13484-13546@http.bugzilla.kernel.org/> <200906080543.n585hQYj017771@demeter.kernel.org>
In-Reply-To: <200906080543.n585hQYj017771@demeter.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13484
> 
> 
> 
> 
> 
> --- Comment #3 from Peer Chen <pchen@nvidia.com>  2009-06-08 05:43:25 ---
> I'm using 64bit CPU, Intel P8400.
> 
> Yes, if set CONFIG_PHYS_ADDR_T_64BIT, the problem goes away.
> 

please check

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
