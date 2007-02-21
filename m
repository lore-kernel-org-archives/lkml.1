Return-Path: <linux-kernel-owner+w=401wt.eu-S965071AbXBUB4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965071AbXBUB4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965324AbXBUB4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:56:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:35778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814AbXBUBv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:51:56 -0500
Date: Tue, 20 Feb 2007 17:50:28 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, sandeen@redhat.com,
       Roman Zippel <zippel@linux-m68k.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 08/18] hfs_fill_super returns success even if no root inode (CVE-2006-6056)
Message-ID: <20070221015028.GI3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hfs_fill_super-returns-success-even-if-no-root-inode.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Sandeen <sandeen@redhat.com>

http://kernelfun.blogspot.com/2006/11/mokb-14-11-2006-linux-26x-selinux.html

mount that image...
fs: filesystem was not cleanly unmounted, running fsck.hfs is recommended.  mounting read-only.
hfs: get root inode failed.
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000018
 printing eip
...
EIP is at superblock_doinit+0x21/0x767
...
 [] selinux_sb_kern_mount+0xc/0x4b
 [] vfs_kern_mount+0x99/0xf6
 [] do_kern_mount+0x2d/0x3e
 [] do_mount+0x5fa/0x66d
 [] sys_mount+0x77/0xae
 [] syscall_call+0x7/0xb
DWARF2 unwinder stuck at syscall_call+0x7/0xb

hfs_fill_super() returns success even if
  root_inode = hfs_iget(sb, &fd.search_key->cat, &rec);
or
  sb->s_root = d_alloc_root(root_inode);

fails.  This superblock finds its way to superblock_doinit() which does:

        struct dentry *root = sb->s_root;
        struct inode *inode = root->d_inode;

and boom.  Need to make sure the error cases return an error, I think.

[akpm@osdl.org: return -ENOMEM on oom]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
Date: Thu, 16 Nov 2006 09:19:22 +0000 (-0800)
Subject: [patch 08/18] [PATCH] hfs_fill_super returns success even if no root inode
X-Git-Tag: v2.6.19
X-Git-Url: http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d6ddf55440833fd9404138026af246c51ebeef22

 fs/hfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.18.7.orig/fs/hfs/super.c
+++ linux-2.6.18.7/fs/hfs/super.c
@@ -391,11 +391,13 @@ static int hfs_fill_super(struct super_b
 		hfs_find_exit(&fd);
 		goto bail_no_root;
 	}
+	res = -EINVAL;
 	root_inode = hfs_iget(sb, &fd.search_key->cat, &rec);
 	hfs_find_exit(&fd);
 	if (!root_inode)
 		goto bail_no_root;
 
+	res = -ENOMEM;
 	sb->s_root = d_alloc_root(root_inode);
 	if (!sb->s_root)
 		goto bail_iput;

--
