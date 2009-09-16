Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZIPUh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZIPUh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760019AbZIPUh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:37:57 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53223 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989AbZIPUhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WxlUzxQLFXefX1hlaYqDDSlMhKxmqhJdbEBHhTu/qPHtKGakeUl4xQcIYmD6ZJm2IG
         koXT0/qw37lKQLiyTMJGLAe+/mgWQpTtQsijnVoBbUoyRI7WHxVi5pKT5mOrlKbVDgVY
         4XJq0i5TK9XsOpmZ9E+ZU+gnsxeHFvyDglDNI=
Date: Wed, 16 Sep 2009 22:37:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>
Subject: Re: [PATCH 0/4] kill-the-bkl/reiserfs: fix some lock dependency
	inversions
Message-ID: <20090916203747.GB5068@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com> <20090826201330.GA18761@orion> <20090914203749.GF6045@nowhere> <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 01:33:42AM +0400, Alexander Beregalov wrote:
> > Hi Alexander,
> >
> > It should be fixed now, still in the following tree:
> 
> Hi!
> Another one, similar:
> It is v2.6.31-3123-g99bc470 plus your 805031859(kill-the-bkl/reiserfs:
> panic in case of lock imbalance), UP.



Although I can't reproduce it, I think I see how that can happen.

On mount time, we have the following dependency:

reiserfs_lock -> bdev_mutex -> sysfs_mutex

which happens while calling journal_init_dev() because
we open the device there.

But also in case of mmap on a reiserfs filesystem we
may call reiserfs_readpages(), holding the reiserfs lock
while already holding mm->mmap_sem

The above dependency is then updated:

mmap_sem
     |
     |
     ------- reiserfs_lock -> bdev_mutex -> sysfs_mutex

And later, while doing a readdir() on a sysfs directory,
sysfs calls filldir, which might_fault, and then might grab
mmap_sem. filldir is called there while holding sys_mutex,
creating the new following dependency

sysfs_mutex -> mmap_sem

Hence the inversion.
It seems the deadlock can't ever happen, I even don't see
corner cases where it could happen.

But still, this dependency should disappear.

Could you please tell me if the following patch makes it shut down?

Otherwise, I may need your config. I don't know why, but I suspect
the lock_acquire(mmap_sem) in might_fault doesn't trigger needed the lockdep
check, although I have the appropriate debug config, at least it seems.
But anyway, it should also happen in my box but it doesn't...

Thanks!

The patch:

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index d23d6d7..59f7a4c 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2801,11 +2801,14 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 		goto free_and_return;
 	}
 
+	reiserfs_write_unlock(sb);
 	if (journal_init_dev(sb, journal, j_dev_name) != 0) {
 		reiserfs_warning(sb, "sh-462",
 				 "unable to initialize jornal device");
+		reiserfs_write_lock(sb);
 		goto free_and_return;
 	}
+	reiserfs_write_lock(sb);
 
 	rs = SB_DISK_SUPER_BLOCK(sb);
 

