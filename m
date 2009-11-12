Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZKLQUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZKLQUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZKLQUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:20:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:33108 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbZKLQUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:20:22 -0500
Date: Thu, 12 Nov 2009 17:20:26 +0100
From: Jan Kara <jack@suse.cz>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: warn on lookup_one_length/vfs_quota_on_mount
Message-ID: <20091112162026.GJ14528@duck.suse.cz>
References: <195c7a900911112329v7df8e718s5c0a5babdea39b99@mail.gmail.com> <20091112124238.GH14528@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20091112124238.GH14528@duck.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Thu 12-11-09 13:42:38, Jan Kara wrote:
> On Thu 12-11-09 08:29:06, Bastien ROUCARIES wrote:
> > I get the following warm on my reiserfs disk with quota enabled at
> > boot (each boot) see
> > http://www.kerneloops.org/raw.php?rawid=937752&msgid=
> > *lookup_one_len
> > ? lookup_one_len
> > ? lookup_one_len
> > ? warn_slowpath_common
> > ? lookup_one_len
> > ? vfs_quota_on_mount
> > ? finish_unfinished
> > ? reiserfs_remount
> > ? __filemap_fdatawrite_range
> > ? do_remount_sb
> > ? do_mount
> > ? sys_mount
> > ? system_call_fastpath
> > 
> > But it seems a generic bug in the quota layer due to:
> > http://www.kerneloops.org/oops.php?number=799645
> > http://www.kerneloops.org/oops.php?number=700122
>   OK, this shouldn't lead to any real bug (since we look them up during
> filesystem mount or remount read-write when noone can mess with the root
> directory). But it's probably good to silence the warning by proper locking
> anyway. I'll do it. Thanks for the report!
  Attached patch fixes the warning for me.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--LQksG6bCIzRHxTLp
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-quota-Fix-WARN_ON-in-lookup_one_len.patch"

>From 1422c40784979ee85aa0f74655fc6e627ddbb1c0 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 12 Nov 2009 15:42:08 +0100
Subject: [PATCH] quota: Fix WARN_ON in lookup_one_len

We should hold i_mutex when looking up quota files for journaled quotas,
otherwise a WARN_ON in lookup_one_len triggers. The fact that we didn't
hold i_mutex previously probably could not lead to a real bug since the
filesystem is just being mounted / remounted read-write and thus the
root directory cannot change anyway but it's definitely cleaner with
i_mutex.

Reported-by: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 39b49c4..aa97df1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2233,7 +2233,9 @@ int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
 	struct dentry *dentry;
 	int error;
 
+	mutex_lock(&sb->s_root->d_inode->i_mutex);
 	dentry = lookup_one_len(qf_name, sb->s_root, strlen(qf_name));
+	mutex_unlock(&sb->s_root->d_inode->i_mutex);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-- 
1.6.0.2


--LQksG6bCIzRHxTLp--
