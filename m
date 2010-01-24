Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775Ab0AXVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0AXVP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 16:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181Ab0AXVP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 16:15:56 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:37585 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab0AXVPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 16:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=O63maNXkquoT0GZTNExyRsoRx6nLuzsAWof/FWMT9QLZm95Rdbcx23fC5Tjj9ztE++
         sDG4si/j1Dw15RcqBWqwtXQNgCibVjFlaYrYo6S0HykHj1u2cQ6ZPfgtLj/IlFQt8Jn4
         w0YKUaJO/htUtGK/O9pArPKa9SSH8L+AT+YxA=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: fix filesystem_sync vs write race on rw=>ro remount
References: <87sk9vd92c.fsf@openvz.org>
	<20100124195309.GX19799@ZenIV.linux.org.uk>
Date: Mon, 25 Jan 2010 00:15:51 +0300
In-Reply-To: <20100124195309.GX19799@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 24 Jan 2010 19:53:09 +0000")
Message-ID: <87r5pfw6ew.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sun, Jan 24, 2010 at 02:41:15PM +0300, Dmitry Monakhov wrote:
>> Currently on rw=>ro remount we have following race
>> | mount /mnt -oremount,ro | write-task |
>> |-------------------------+------------|
>> |                         | open(RDWR) |
>> | shrink_dcache_sb(sb);   |            |
>> | sync_filesystem(sb);    |            |
>> |                         | write()    |
>> |                         | close()    |
>> | fs_may_remount_ro(sb)   |            |
>> | sb->s_flags = new_flags |            |
>> Later writeback or sync() will result in error due to MS_RDONLY flag
>> In case of ext4 this result in jbd2_start failure on writeback
>> ext4_da_writepages: jbd2_start: 1024 pages, ino 1431; err -30 
>> In fact all others are affected by this error but it is not visible
>> because the skip s_flags check on writeback. For example ext3 check
>> (s_flags & MS_RDONLY) only if page has no buffers during journal start.
>> 
>> In order to prevent the race we have to block new writers before
>> fs_may_remount_ro() and sync_filesystem(). Let's introduce new
>> sb->s_flags MS_RO_REMOUNT flag for this purpose. But suddenly we have
>> no available space in MS_XXX bits, let's share this bit with MS_REMOUNT.
>> This is possible because MS_REMOUNT used only for passing arguments
>> from flags to sys_mount() and never used in sb->s_flags.
>
> It's not a solution.  You get an _attempted_ remount ro making writes
> fail, even if it's going to be unsuccessful.  No go...
We have two options for new writers:
1) Fail it via -EROFS
   Yes, remount may fail, but it is really unlikely.
2) Defer(block) new writers on until we complete or fail remount
   for example like follows. Do you like second solution ?
diff --git a/fs/namespace.c b/fs/namespace.c
index c768f73..daf3c5a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -196,6 +196,15 @@ int __mnt_is_readonly(struct vfsmount *mnt)
 		return 1;
 	if (mnt->mnt_sb->s_flags & MS_RDONLY)
 		return 1;
+	if (mnt->mnt_sb->s_flags & MS_RO_REMOUNT) {
+		int ret = 0;
+		/* Serialize against remount */
+		down_read(&mnt->mnt_sb->s_umount);
+		if (mnt->mnt_sb->s_flags & MS_RDONLY)
+			ret = 1;
+		up_read(&mnt->mnt_sb->s_umount);
+		return ret;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__mnt_is_readonly);
