Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbZCMITN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbZCMITN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZCMIMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:31 -0400
Received: from gw.goop.org ([64.81.55.164]:34827 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757221AbZCMIM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 18/24] xen: add "capabilities" file
Date: Fri, 13 Mar 2009 01:11:54 -0700
Message-Id: <1236931920-6861-19-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
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

