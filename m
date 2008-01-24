Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYAXToJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYAXToJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbYAXTeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:46 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46521 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbYAXTeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:25 -0500
Message-Id: <20080124193421.888241466@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:46 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 05/26] mount options: fix afs
Content-Disposition: inline; filename=afs_opts.patch
Cc: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to afs.

Use generic_show_options() and save the complete option string in
afs_get_sb().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/afs/super.c
===================================================================
--- linux.orig/fs/afs/super.c	2008-01-24 11:42:44.000000000 +0100
+++ linux/fs/afs/super.c	2008-01-24 12:05:50.000000000 +0100
@@ -52,6 +52,7 @@ static const struct super_operations afs
 	.clear_inode	= afs_clear_inode,
 	.umount_begin	= afs_umount_begin,
 	.put_super	= afs_put_super,
+	.show_options	= generic_show_options,
 };
 
 static struct kmem_cache *afs_inode_cachep;
@@ -357,6 +358,7 @@ static int afs_get_sb(struct file_system
 	struct super_block *sb;
 	struct afs_volume *vol;
 	struct key *key;
+	char *new_opts = kstrdup(options, GFP_KERNEL);
 	int ret;
 
 	_enter(",,%s,%p", dev_name, options);
@@ -408,9 +410,11 @@ static int afs_get_sb(struct file_system
 			deactivate_super(sb);
 			goto error;
 		}
+		sb->s_options = new_opts;
 		sb->s_flags |= MS_ACTIVE;
 	} else {
 		_debug("reuse");
+		kfree(new_opts);
 		ASSERTCMP(sb->s_flags, &, MS_ACTIVE);
 	}
 
@@ -424,6 +428,7 @@ error:
 	afs_put_volume(params.volume);
 	afs_put_cell(params.cell);
 	key_put(params.key);
+	kfree(new_opts);
 	_leave(" = %d", ret);
 	return ret;
 }

--
