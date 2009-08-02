Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZHBVgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZHBVgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZHBVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:36:30 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54882 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbZHBVga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:36:30 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: mnt_want_write_file() has problem?
Date: Mon, 03 Aug 2009 06:36:27 +0900
Message-ID: <871vnt7vac.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While I'm reading some code, I suspected that mnt_want_write_file() may
have wrong assumption.  I think mnt_want_write_file() is assuming it
increments ->mnt_writers if (file->f_mode & FMODE_WRITE). But, if it's
special_file(), it is false?

Sorry, I'm still not checking all of those though. E.g. I'm thinking the
below.

static inline int __get_file_write_access(struct inode *inode,
					  struct vfsmount *mnt)
{
[...]
	if (!special_file(inode->i_mode)) {
		/*
		 * Balanced in __fput()
		 */
		error = mnt_want_write(mnt);
		if (error)
			put_write_access(inode);
	}
	return error;
}

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/namespace.c~mnt_want_write-wrong-assume fs/namespace.c
--- linux-2.6/fs/namespace.c~mnt_want_write-wrong-assume	2009-08-03 04:33:35.000000000 +0900
+++ linux-2.6-hirofumi/fs/namespace.c	2009-08-03 04:31:34.000000000 +0900
@@ -316,7 +316,8 @@ EXPORT_SYMBOL_GPL(mnt_clone_write);
  */
 int mnt_want_write_file(struct file *file)
 {
-	if (!(file->f_mode & FMODE_WRITE))
+	struct inode *inode = file->f_dentry->d_inode;
+	if (!(file->f_mode & FMODE_WRITE) || special_file(inode->i_mode))
 		return mnt_want_write(file->f_path.mnt);
 	else
 		return mnt_clone_write(file->f_path.mnt);
_
