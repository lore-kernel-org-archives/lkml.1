Return-Path: <linux-kernel-owner+w=401wt.eu-S935673AbXHHQ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935673AbXHHQ2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936413AbXHHQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:26:54 -0400
Received: from lazybastard.de ([212.112.238.170]:54584 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936406AbXHHQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:26:52 -0400
Date: Wed, 8 Aug 2007 18:22:56 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 15/18] fs/logfs/Locking
Message-ID: <20070808162256.GQ15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-08-05 21:14:35.622844160 +0200
+++ linux-2.6.21logfs/fs/logfs/Locking	2007-08-08 02:57:37.000000000 +0200
@@ -0,0 +1,48 @@
+Locks:
+
+s_victim_mutex
+Protects victim inode for create, unlink, mkdir, rmdir, mknod, link,
+symlink and one variant of rename.  Only one victim inode may exist at
+a time.  In case of unclean unmount, victim inode has to be deleted
+before next read-writable mount.
+
+s_rename_mutex
+Protects victim dd for rename.  Only one victim dd may exist at a
+time.  In case of unclean unmount, victim dd has to be deleted before
+next read-writable mount.
+
+s_write_inode_mutex
+Taken when writing an inode.  Deleted inodes can be locked, preventing
+further iget operations during writeout.  Logfs may need to iget the
+inode for garbage collection, so the inode in question needs to be
+stored in the superblock and used directly without calling iget.
+
+s_journal_sem
+Used for allocating space in journal.
+Also protects super->s_je and super->s_compressed_je.  Those two
+buffers are used unprotected in the mount path, the only valid
+exception.
+
+s_r_sem
+Protects the memory required for reads from the filesystem.
+
+s_w_sem
+Protects the memory required for writes to the filesystem.
+
+s_ino_lock
+Protects s_last_ino.
+
+
+Lock order:
+s_rename_mutex --> s_victim_mutex
+s_rename_mutex --> s_write_inode_mutex
+s_rename_mutex --> s_w_sem
+
+s_victim_mutex --> s_write_inode_mutex
+s_victim_mutex --> s_w_sem
+s_victim_mutex --> s_ino_lock
+
+s_write_inode_mutex --> s_w_sem
+
+s_w_sem --> s_log_sem
+s_w_sem --> s_r_sem
