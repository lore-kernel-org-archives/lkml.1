Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbZCZRup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbZCZRup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZCZRuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:50:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38529 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbZCZRug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:50:36 -0400
Date: Thu, 26 Mar 2009 17:49:56 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 1/2] Add a strictatime mount option
Message-ID: <20090326174956.GB7198@srcf.ucam.org>
References: <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for explicitly requesting full atime updates. This makes it
possible for kernels to default to relatime but still allow userspace to
override it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 fs/namespace.c        |    6 +++++-
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 06f8e63..d0659ec 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -780,6 +780,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_STRICTATIME, ",strictatime" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
@@ -1932,11 +1933,14 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_STRICTATIME)
+		mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
+		   MS_STRICTATIME);
 
 	/* ... and get the mountpoint */
 	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 92734c0..5bc81c4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -141,6 +141,7 @@ struct inodes_stat_t {
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
+#define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
diff --git a/include/linux/mount.h b/include/linux/mount.h
index cab2a85..51f55f9 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -27,6 +27,7 @@ struct mnt_namespace;
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
 #define MNT_READONLY	0x40	/* does the user want this to be r/o? */
+#define MNT_STRICTATIME 0x80
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_IMBALANCED_WRITE_COUNT	0x200 /* just for debugging */

-- 
Matthew Garrett | mjg59@srcf.ucam.org
