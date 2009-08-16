Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZHPVGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZHPVGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZHPVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:06:09 -0400
Received: from www.tglx.de ([62.245.132.106]:46176 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZHPVGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:06:07 -0400
Message-Id: <20090816210335.309469111@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 16 Aug 2009 21:05:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Steve French <sfrench@us.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Roman Zippel <zippel@linux-m68k.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Anton Altaparmakov <aia21@cantab.net>
Subject: [patch] fs: Make unload_nls() NULL pointer safe
Content-Disposition: inline; filename=unload_nls.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most call sites of unload_nls() do:
	if (nls)
		unload_nls(nls);

Check the pointer inside unload_nls() like we do in kfree() and
simplify the call sites.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steve French <sfrench@us.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Anton Altaparmakov <aia21@cantab.net>

---
 fs/befs/linuxvfs.c |    7 +------
 fs/cifs/cifsfs.c   |    3 +--
 fs/fat/inode.c     |   16 ++++------------
 fs/hfs/mdb.c       |    6 ++----
 fs/hfsplus/super.c |    6 ++----
 fs/isofs/inode.c   |    8 ++------
 fs/jfs/super.c     |    9 +++------
 fs/ncpfs/inode.c   |   12 ++----------
 fs/ncpfs/ioctl.c   |    6 ++----
 fs/nls/nls_base.c  |    3 ++-
 fs/ntfs/super.c    |   10 ++++------
 fs/smbfs/inode.c   |   10 ++--------
 12 files changed, 27 insertions(+), 69 deletions(-)

Index: linux-2.6-tip/fs/befs/linuxvfs.c
===================================================================
--- linux-2.6-tip.orig/fs/befs/linuxvfs.c
+++ linux-2.6-tip/fs/befs/linuxvfs.c
@@ -737,12 +737,7 @@ befs_put_super(struct super_block *sb)
 {
 	kfree(BEFS_SB(sb)->mount_opts.iocharset);
 	BEFS_SB(sb)->mount_opts.iocharset = NULL;
-
-	if (BEFS_SB(sb)->nls) {
-		unload_nls(BEFS_SB(sb)->nls);
-		BEFS_SB(sb)->nls = NULL;
-	}
-
+	unload_nls(BEFS_SB(sb)->nls);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
Index: linux-2.6-tip/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6-tip.orig/fs/cifs/cifsfs.c
+++ linux-2.6-tip/fs/cifs/cifsfs.c
@@ -185,8 +185,7 @@ out_mount_failed:
 			cifs_sb->mountdata = NULL;
 		}
 #endif
-		if (cifs_sb->local_nls)
-			unload_nls(cifs_sb->local_nls);
+		unload_nls(cifs_sb->local_nls);
 		kfree(cifs_sb);
 	}
 	return rc;
Index: linux-2.6-tip/fs/fat/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/fat/inode.c
+++ linux-2.6-tip/fs/fat/inode.c
@@ -470,19 +470,11 @@ static void fat_put_super(struct super_b
 
 	iput(sbi->fat_inode);
 
-	if (sbi->nls_disk) {
-		unload_nls(sbi->nls_disk);
-		sbi->nls_disk = NULL;
-		sbi->options.codepage = fat_default_codepage;
-	}
-	if (sbi->nls_io) {
-		unload_nls(sbi->nls_io);
-		sbi->nls_io = NULL;
-	}
-	if (sbi->options.iocharset != fat_default_iocharset) {
+	unload_nls(sbi->nls_disk);
+	unload_nls(sbi->nls_io);
+
+	if (sbi->options.iocharset != fat_default_iocharset)
 		kfree(sbi->options.iocharset);
-		sbi->options.iocharset = fat_default_iocharset;
-	}
 
 	sb->s_fs_info = NULL;
 	kfree(sbi);
Index: linux-2.6-tip/fs/hfs/mdb.c
===================================================================
--- linux-2.6-tip.orig/fs/hfs/mdb.c
+++ linux-2.6-tip/fs/hfs/mdb.c
@@ -344,10 +344,8 @@ void hfs_mdb_put(struct super_block *sb)
 	brelse(HFS_SB(sb)->mdb_bh);
 	brelse(HFS_SB(sb)->alt_mdb_bh);
 
-	if (HFS_SB(sb)->nls_io)
-		unload_nls(HFS_SB(sb)->nls_io);
-	if (HFS_SB(sb)->nls_disk)
-		unload_nls(HFS_SB(sb)->nls_disk);
+	unload_nls(HFS_SB(sb)->nls_io);
+	unload_nls(HFS_SB(sb)->nls_disk);
 
 	free_pages((unsigned long)HFS_SB(sb)->bitmap, PAGE_SIZE < 8192 ? 1 : 0);
 	kfree(HFS_SB(sb));
Index: linux-2.6-tip/fs/hfsplus/super.c
===================================================================
--- linux-2.6-tip.orig/fs/hfsplus/super.c
+++ linux-2.6-tip/fs/hfsplus/super.c
@@ -229,8 +229,7 @@ static void hfsplus_put_super(struct sup
 	iput(HFSPLUS_SB(sb).alloc_file);
 	iput(HFSPLUS_SB(sb).hidden_dir);
 	brelse(HFSPLUS_SB(sb).s_vhbh);
-	if (HFSPLUS_SB(sb).nls)
-		unload_nls(HFSPLUS_SB(sb).nls);
+	unload_nls(HFSPLUS_SB(sb).nls);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 
@@ -464,8 +463,7 @@ out:
 
 cleanup:
 	hfsplus_put_super(sb);
-	if (nls)
-		unload_nls(nls);
+	unload_nls(nls);
 	return err;
 }
 
Index: linux-2.6-tip/fs/isofs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/isofs/inode.c
+++ linux-2.6-tip/fs/isofs/inode.c
@@ -46,10 +46,7 @@ static void isofs_put_super(struct super
 #ifdef CONFIG_JOLIET
 	lock_kernel();
 
-	if (sbi->s_nls_iocharset) {
-		unload_nls(sbi->s_nls_iocharset);
-		sbi->s_nls_iocharset = NULL;
-	}
+	unload_nls(sbi->s_nls_iocharset);
 
 	unlock_kernel();
 #endif
@@ -912,8 +909,7 @@ out_no_root:
 		printk(KERN_WARNING "%s: get root inode failed\n", __func__);
 out_no_inode:
 #ifdef CONFIG_JOLIET
-	if (sbi->s_nls_iocharset)
-		unload_nls(sbi->s_nls_iocharset);
+	unload_nls(sbi->s_nls_iocharset);
 #endif
 	goto out_freesbi;
 out_no_read:
Index: linux-2.6-tip/fs/jfs/super.c
===================================================================
--- linux-2.6-tip.orig/fs/jfs/super.c
+++ linux-2.6-tip/fs/jfs/super.c
@@ -178,13 +178,11 @@ static void jfs_put_super(struct super_b
 	rc = jfs_umount(sb);
 	if (rc)
 		jfs_err("jfs_umount failed with return code %d", rc);
-	if (sbi->nls_tab)
-		unload_nls(sbi->nls_tab);
-	sbi->nls_tab = NULL;
+
+	unload_nls(sbi->nls_tab);
 
 	truncate_inode_pages(sbi->direct_inode->i_mapping, 0);
 	iput(sbi->direct_inode);
-	sbi->direct_inode = NULL;
 
 	kfree(sbi);
 
@@ -347,8 +345,7 @@ static int parse_options(char *options, 
 
 	if (nls_map != (void *) -1) {
 		/* Discard old (if remount) */
-		if (sbi->nls_tab)
-			unload_nls(sbi->nls_tab);
+		unload_nls(sbi->nls_tab);
 		sbi->nls_tab = nls_map;
 	}
 	return 1;
Index: linux-2.6-tip/fs/ncpfs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/ncpfs/inode.c
+++ linux-2.6-tip/fs/ncpfs/inode.c
@@ -746,16 +746,8 @@ static void ncp_put_super(struct super_b
 
 #ifdef CONFIG_NCPFS_NLS
 	/* unload the NLS charsets */
-	if (server->nls_vol)
-	{
-		unload_nls(server->nls_vol);
-		server->nls_vol = NULL;
-	}
-	if (server->nls_io)
-	{
-		unload_nls(server->nls_io);
-		server->nls_io = NULL;
-	}
+	unload_nls(server->nls_vol);
+	unload_nls(server->nls_io);
 #endif /* CONFIG_NCPFS_NLS */
 
 	if (server->info_filp)
Index: linux-2.6-tip/fs/ncpfs/ioctl.c
===================================================================
--- linux-2.6-tip.orig/fs/ncpfs/ioctl.c
+++ linux-2.6-tip/fs/ncpfs/ioctl.c
@@ -223,10 +223,8 @@ ncp_set_charsets(struct ncp_server* serv
 	oldset_io = server->nls_io;
 	server->nls_io = iocharset;
 
-	if (oldset_cp)
-		unload_nls(oldset_cp);
-	if (oldset_io)
-		unload_nls(oldset_io);
+	unload_nls(oldset_cp);
+	unload_nls(oldset_io);
 
 	return 0;
 }
Index: linux-2.6-tip/fs/nls/nls_base.c
===================================================================
--- linux-2.6-tip.orig/fs/nls/nls_base.c
+++ linux-2.6-tip/fs/nls/nls_base.c
@@ -270,7 +270,8 @@ struct nls_table *load_nls(char *charset
 
 void unload_nls(struct nls_table *nls)
 {
-	module_put(nls->owner);
+	if (nls)
+		module_put(nls->owner);
 }
 
 static const wchar_t charset2uni[256] = {
Index: linux-2.6-tip/fs/ntfs/super.c
===================================================================
--- linux-2.6-tip.orig/fs/ntfs/super.c
+++ linux-2.6-tip/fs/ntfs/super.c
@@ -201,8 +201,7 @@ use_utf8:
 						v, old_nls->charset);
 				nls_map = old_nls;
 			} else /* nls_map */ {
-				if (old_nls)
-					unload_nls(old_nls);
+				unload_nls(old_nls);
 			}
 		} else if (!strcmp(p, "utf8")) {
 			bool val = false;
@@ -2427,10 +2426,9 @@ static void ntfs_put_super(struct super_
 		ntfs_free(vol->upcase);
 		vol->upcase = NULL;
 	}
-	if (vol->nls_map) {
-		unload_nls(vol->nls_map);
-		vol->nls_map = NULL;
-	}
+
+	unload_nls(vol->nls_map);
+
 	sb->s_fs_info = NULL;
 	kfree(vol);
 
Index: linux-2.6-tip/fs/smbfs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/smbfs/inode.c
+++ linux-2.6-tip/fs/smbfs/inode.c
@@ -459,14 +459,8 @@ smb_show_options(struct seq_file *s, str
 static void
 smb_unload_nls(struct smb_sb_info *server)
 {
-	if (server->remote_nls) {
-		unload_nls(server->remote_nls);
-		server->remote_nls = NULL;
-	}
-	if (server->local_nls) {
-		unload_nls(server->local_nls);
-		server->local_nls = NULL;
-	}
+	unload_nls(server->remote_nls);
+	unload_nls(server->local_nls);
 }
 
 static void


