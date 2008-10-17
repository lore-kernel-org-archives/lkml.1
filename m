Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbYJQKIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbYJQKIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYJQKIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:08:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYJQKIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:08:43 -0400
Message-ID: <48F863E3.3070003@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 18:07:31 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Fix debugfs_create_*'s error checking method for arm/plat-omap
References: <48F85976.4070609@cn.fujitsu.com>
In-Reply-To: <48F85976.4070609@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_create_*() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Comparing to PATCH v1, because clk_debugfs_init is included in
"#if defined CONFIG_DEBUG_FS", we only need to check NULL return.
Thanks Li Zefan <lizf@cn.fujitsu.com>

debugfs_create_u8() and other function's return value's checking method are
also fixed in this patch.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/arm/plat-omap/clock.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index bf6a10c..be6aab9 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -428,23 +428,23 @@ static int clk_debugfs_register_one(struct clk *c)
 	if (c->id != 0)
 		sprintf(p, ":%d", c->id);
 	d = debugfs_create_dir(s, pa ? pa->dent : clk_debugfs_root);
-	if (IS_ERR(d))
-		return PTR_ERR(d);
+	if (!d)
+		return -ENOMEM;
 	c->dent = d;
 
 	d = debugfs_create_u8("usecount", S_IRUGO, c->dent, (u8 *)&c->usecount);
-	if (IS_ERR(d)) {
-		err = PTR_ERR(d);
+	if (!d) {
+		err = -ENOMEM;
 		goto err_out;
 	}
 	d = debugfs_create_u32("rate", S_IRUGO, c->dent, (u32 *)&c->rate);
-	if (IS_ERR(d)) {
-		err = PTR_ERR(d);
+	if (!d) {
+		err = -ENOMEM;
 		goto err_out;
 	}
 	d = debugfs_create_x32("flags", S_IRUGO, c->dent, (u32 *)&c->flags);
-	if (IS_ERR(d)) {
-		err = PTR_ERR(d);
+	if (!d) {
+		err = -ENOMEM;
 		goto err_out;
 	}
 	return 0;
@@ -483,8 +483,8 @@ static int __init clk_debugfs_init(void)
 	int err;
 
 	d = debugfs_create_dir("clock", NULL);
-	if (IS_ERR(d))
-		return PTR_ERR(d);
+	if (!d)
+		return -ENOMEM;
 	clk_debugfs_root = d;
 
 	list_for_each_entry(c, &clocks, node) {
-- 
1.5.5.3


