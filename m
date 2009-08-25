Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZHYCdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZHYCdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 22:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZHYCdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 22:33:41 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48626 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbZHYCcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 22:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wS2YXC2tWMAfApt8z0syndw7BBgdN7yULyrc2yBh6GBAsws2Oe4paFVYDHVRLmq9uU
         C2iVG0UxpKkL9GJB19CHR1dHQ23FC7szqRzW1mngSwgwxrdPAud5iDgHIW1VWILHFcy0
         j1oWFfsB0c2jo8ZGeEiMdo4t5PHelcD0eFN6w=
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH 1/4] kill-the-bkl/reiserfs: fix "reiserfs lock" / "inode mutex" lock inversion dependency
Date: Tue, 25 Aug 2009 04:32:47 +0200
Message-Id: <1251167570-5233-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_xattr_init is called with the reiserfs write lock held, but
if the ".reiserfs_priv" entry is not created, we take the superblock
root directory inode mutex until .reiserfs_priv is created.

This creates a lock dependency inversion against other sites such as
reiserfs_file_release() which takes an inode mutex and the reiserfs
lock after.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
---
 fs/reiserfs/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 59870a4..58aa8e7 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -1004,7 +1004,7 @@ int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 		goto error;
 
 	if (!privroot->d_inode && !(mount_flags & MS_RDONLY)) {
-		mutex_lock(&s->s_root->d_inode->i_mutex);
+		reiserfs_mutex_lock_safe(&s->s_root->d_inode->i_mutex, s);
 		err = create_privroot(REISERFS_SB(s)->priv_root);
 		mutex_unlock(&s->s_root->d_inode->i_mutex);
 	}
-- 
1.6.2.3

