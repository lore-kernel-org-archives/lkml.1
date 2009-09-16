Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZIPKaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZIPKaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZIPKaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:30:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:4145 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774AbZIPK3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,397,1249282800"; 
   d="scan'208";a="188224422"
Message-Id: <20090916100657.911259914@intel.com>
References: <20090916100119.275066569@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 18:01:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 8/8] page-types: add hwpoison/unpoison feature
Content-Disposition: inline; filename=page-types-hwpoison.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For hwpoison stress testing.
The debugfs mount point is assumed to be /debug/.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |   73 +++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

--- linux-mm.orig/Documentation/vm/page-types.c	2009-09-16 17:54:35.000000000 +0800
+++ linux-mm/Documentation/vm/page-types.c	2009-09-16 17:54:59.000000000 +0800
@@ -170,6 +170,13 @@ static int		page_size;
 static int		pagemap_fd;
 static int		kpageflags_fd;
 
+static int		opt_hwpoison;
+static int		opt_unpoison;
+
+static char		*hwpoison_debug_fs = "/debug/hwpoison";
+static int		hwpoison_inject_fd;
+static int		hwpoison_forget_fd;
+
 #define HASH_SHIFT	13
 #define HASH_SIZE	(1 << HASH_SHIFT)
 #define HASH_MASK	(HASH_SIZE - 1)
@@ -447,6 +454,53 @@ static uint64_t kpageflags_flags(uint64_
 }
 
 /*
+ * page actions
+ */
+
+static void prepare_hwpoison_fd(void)
+{
+	char buf[100];
+
+	if (opt_hwpoison && !hwpoison_inject_fd) {
+		sprintf(buf, "%s/corrupt-pfn", hwpoison_debug_fs);
+		hwpoison_inject_fd = checked_open(buf, O_WRONLY);
+	}
+
+	if (opt_unpoison && !hwpoison_forget_fd) {
+		sprintf(buf, "%s/renew-pfn", hwpoison_debug_fs);
+		hwpoison_forget_fd = checked_open(buf, O_WRONLY);
+	}
+}
+
+static int hwpoison_page(unsigned long offset)
+{
+	char buf[100];
+	int len;
+
+	len = sprintf(buf, "0x%lx\n", offset);
+	len = write(hwpoison_inject_fd, buf, len);
+	if (len < 0) {
+		perror("hwpoison inject");
+		return len;
+	}
+	return 0;
+}
+
+static int unpoison_page(unsigned long offset)
+{
+	char buf[100];
+	int len;
+
+	len = sprintf(buf, "0x%lx\n", offset);
+	len = write(hwpoison_forget_fd, buf, len);
+	if (len < 0) {
+		perror("hwpoison forget");
+		return len;
+	}
+	return 0;
+}
+
+/*
  * page frame walker
  */
 
@@ -485,6 +539,11 @@ static void add_page(unsigned long voffs
 	if (!bit_mask_ok(flags))
 		return;
 
+	if (opt_hwpoison)
+		hwpoison_page(offset);
+	if (opt_unpoison)
+		unpoison_page(offset);
+
 	if (opt_list == 1)
 		show_page_range(voffset, offset, flags);
 	else if (opt_list == 2)
@@ -624,6 +683,8 @@ static void usage(void)
 "            -l|--list                 Show page details in ranges\n"
 "            -L|--list-each            Show page details one by one\n"
 "            -N|--no-summary           Don't show summay info\n"
+"            -X|--hwpoison             hwpoison pages\n"
+"            -x|--unpoison             unpoison pages\n"
 "            -h|--help                 Show this usage message\n"
 "addr-spec:\n"
 "            N                         one page at offset N (unit: pages)\n"
@@ -833,6 +894,8 @@ static struct option opts[] = {
 	{ "list"      , 0, NULL, 'l' },
 	{ "list-each" , 0, NULL, 'L' },
 	{ "no-summary", 0, NULL, 'N' },
+	{ "hwpoison"  , 0, NULL, 'X' },
+	{ "unpoison"  , 0, NULL, 'x' },
 	{ "help"      , 0, NULL, 'h' },
 	{ NULL        , 0, NULL, 0 }
 };
@@ -844,7 +907,7 @@ int main(int argc, char *argv[])
 	page_size = getpagesize();
 
 	while ((c = getopt_long(argc, argv,
-				"rp:f:a:b:lLNh", opts, NULL)) != -1) {
+				"rp:f:a:b:lLNXxh", opts, NULL)) != -1) {
 		switch (c) {
 		case 'r':
 			opt_raw = 1;
@@ -870,6 +933,14 @@ int main(int argc, char *argv[])
 		case 'N':
 			opt_no_summary = 1;
 			break;
+		case 'X':
+			opt_hwpoison = 1;
+			prepare_hwpoison_fd();
+			break;
+		case 'x':
+			opt_unpoison = 1;
+			prepare_hwpoison_fd();
+			break;
 		case 'h':
 			usage();
 			exit(0);

-- 

