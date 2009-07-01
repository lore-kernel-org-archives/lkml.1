Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbZGAAkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbZGAAkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760872AbZGAAcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:42 -0400
Received: from kroah.org ([198.145.64.141]:59752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760871AbZGAAcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:49 2009
Message-Id: <20090701001549.207107959@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 07/35] firmware_map: fix hang with x86/32bit
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=firmware_map-fix-hang-with-x86-32bit.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 3b0fde0fac19c180317eb0601b3504083f4b9bf5 upstream.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13484

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

[akpm@linux-foundation.org: add comment]
Reported-and-tested-by: Peer Chen <pchen@nvidia.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/memmap.c    |   16 +++++++++-------
 include/linux/firmware-map.h |   12 ++++--------
 2 files changed, 13 insertions(+), 15 deletions(-)

--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -31,8 +31,12 @@
  * information is necessary as for the resource tree.
  */
 struct firmware_map_entry {
-	resource_size_t		start;	/* start of the memory range */
-	resource_size_t		end;	/* end of the memory range (incl.) */
+	/*
+	 * start and end must be u64 rather than resource_size_t, because e820
+	 * resources can lie at addresses above 4G.
+	 */
+	u64			start;	/* start of the memory range */
+	u64			end;	/* end of the memory range (incl.) */
 	const char		*type;	/* type of the memory range */
 	struct list_head	list;	/* entry for the linked list */
 	struct kobject		kobj;   /* kobject for each entry */
@@ -101,7 +105,7 @@ static LIST_HEAD(map_entries);
  * Common implementation of firmware_map_add() and firmware_map_add_early()
  * which expects a pre-allocated struct firmware_map_entry.
  **/
-static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
+static int firmware_map_add_entry(u64 start, u64 end,
 				  const char *type,
 				  struct firmware_map_entry *entry)
 {
@@ -132,8 +136,7 @@ static int firmware_map_add_entry(resour
  *
  * Returns 0 on success, or -ENOMEM if no memory could be allocated.
  **/
-int firmware_map_add(resource_size_t start, resource_size_t end,
-		     const char *type)
+int firmware_map_add(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
@@ -157,8 +160,7 @@ int firmware_map_add(resource_size_t sta
  *
  * Returns 0 on success, or -ENOMEM if no memory could be allocated.
  **/
-int __init firmware_map_add_early(resource_size_t start, resource_size_t end,
-				  const char *type)
+int __init firmware_map_add_early(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
--- a/include/linux/firmware-map.h
+++ b/include/linux/firmware-map.h
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


