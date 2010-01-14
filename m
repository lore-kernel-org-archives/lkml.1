Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249Ab0ANDcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0ANDcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402Ab0ANDcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:32:18 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:48339 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0ANDcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:32:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: Fix refcnt leak on ecryptfs_follow_link() error path
References: <87my0kjxpd.fsf@devron.myhome.or.jp>
	<20100113194458.GB4673@ZenIV.linux.org.uk>
Date: Thu, 14 Jan 2010 12:32:13 +0900
In-Reply-To: <20100113194458.GB4673@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 13 Jan 2010 19:44:58 +0000")
Message-ID: <87tyupfjk2.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Tue, Jan 12, 2010 at 03:36:14AM +0900, OGAWA Hirofumi wrote:
>> 
>> If ->follow_link handler return the error, it should decrement
>> nd->path refcnt. But, ecryptfs_follow_link() doesn't decrement.
>> 
>> This patch fix it by using usual nd_set_link() style error handling,
>> instead of playing with nd->path.
>
> Applied.

Sigh, sorry. I introduced new bug by this patch. Please apply this too.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


[PATCH] ecryptfs: Fix memory leak of buf in ecryptfs_follow_link()

Fix memory leak of buf in ecryptfs_follow_link() in recent my change.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/ecryptfs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~namei-ecryptfs-follow_link-fix-fix fs/ecryptfs/inode.c
--- linux-2.6/fs/ecryptfs/inode.c~namei-ecryptfs-follow_link-fix-fix	2010-01-14 05:33:49.000000000 +0900
+++ linux-2.6-hirofumi/fs/ecryptfs/inode.c	2010-01-14 05:34:30.000000000 +0900
@@ -722,9 +722,10 @@ static void *ecryptfs_follow_link(struct
 	set_fs(get_ds());
 	rc = dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, len);
 	set_fs(old_fs);
-	if (rc < 0)
+	if (rc < 0) {
+		kfree(buf);
 		buf = ERR_PTR(rc);
-	else
+	} else
 		buf[rc] = '\0';
 out:
 	nd_set_link(nd, buf);
_
