Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbZCWSHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbZCWSHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZCWSEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:04:31 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:35010
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757645AbZCWSE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:04:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/11] xen: add "capabilities" file
Date: Mon, 23 Mar 2009 10:55:05 -0700
Message-Id: <1237830911-6249-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xenfs capabilities file allows usermode to determine what
capabilities the domain has.  The only one at present is "control_d"
in a privileged domain.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/xenfs/super.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 515741a..6559e0c 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -20,10 +20,27 @@
 MODULE_DESCRIPTION("Xen filesystem");
 MODULE_LICENSE("GPL");
 
+static ssize_t capabilities_read(struct file *file, char __user *buf,
+				 size_t size, loff_t *off)
+{
+	char *tmp = "";
+
+	if (xen_initial_domain())
+		tmp = "control_d\n";
+
+	return simple_read_from_buffer(buf, size, off, tmp, strlen(tmp));
+}
+
+static const struct file_operations capabilities_file_ops = {
+	.read = capabilities_read,
+};
+
 static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr xenfs_files[] = {
-		[2] = {"xenbus", &xenbus_file_ops, S_IRUSR|S_IWUSR},
+		[1] = {},
+		{ "xenbus", &xenbus_file_ops, S_IRUSR|S_IWUSR },
+		{ "capabilities", &capabilities_file_ops, S_IRUGO },
 		{""},
 	};
 
-- 
1.6.0.6

