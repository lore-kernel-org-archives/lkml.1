Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbXCEU6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbXCEU6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933196AbXCEU6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:16 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46860 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbXCEU6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:10 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 04/11] uml - hostfs: avoid possible escapes from hostfs=.
Date: Mon, 05 Mar 2007 21:49:02 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204902.9072.1224.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L2NZJ008307

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Avoid accepting things like -o .., -o dir/../../dir2, -o dir/../.. .
This may be considered useless, but YMMV. I consider that this has a limited
security value, exactly like disabling module support (in many case it is
useful).

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 fs/hostfs/hostfs_kern.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 9baf697..0bcf7ac 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -936,6 +936,28 @@ static const struct address_space_operations hostfs_link_aops = {
 	.readpage	= hostfs_link_readpage,
 };
 
+static inline int str_ends_with(const char * str, const char* suffix)
+{
+	size_t len = strlen(str), suffix_len = strlen(suffix);
+	return strcmp(str + len - suffix_len, suffix) == 0;
+}
+
+static int contains_dotdot(const char* path)
+{
+	/*
+	 * Prevent escaping from hostfs=folder, even if this is not useful to
+	 * jail the UML superuser.
+	 * Since foo..bar is a valid name, we must look for /../ in the string,
+	 * or for ../ at the beginning, /.. at the end, or check whether '..' is
+	 * the complete string.
+	 */
+
+	return  strstr(path, "/../") != NULL ||
+		strcmp(path, "..") == 0 ||
+		strncmp(path, "../", strlen("../")) == 0 ||
+		str_ends_with(path, "/..");
+}
+
 static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 {
 	struct inode *root_inode;
@@ -951,6 +973,10 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	if (data == NULL)
 		data = "";
 
+	err = -EINVAL;
+	if (unlikely(contains_dotdot(data)))
+		goto out;
+
 	err = -ENOMEM;
 	name = kmalloc(strlen(root_ino) + 1
 			+ strlen(data) + 1, GFP_KERNEL);


