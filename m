Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZI2Hqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZI2Hqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 03:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZI2Hql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 03:46:41 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:40760 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZI2Hql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 03:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s49rF31+mICIJExNcS+E4lhrXxfy1Cda6yqmRfLRCrNzRWrLTvi+Xl/Qexg5k4WVKu
         DZLGPW5Fa9+vaajdwmSZwXBn3aL/YJlFGSCAQBqTP/WywJoBnMt0i9O4g9FUnh0Xu9Sq
         T8WT9D1BX9eB1CNpDaRouPKU9vQEX3dA33zYU=
Date: Tue, 29 Sep 2009 09:46:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>
Subject: Re: [PATCH] kill-the-bkl/reiserfs: Fix induced mm->mmap_sem to
	sysfs_mutex dependency
Message-ID: <20090929074640.GA5233@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com> <20090826201330.GA18761@orion> <20090914203749.GF6045@nowhere> <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com> <20090916203747.GB5068@nowhere> <a4423d670909161637r67c933a0n2c142898ea493f22@mail.gmail.com> <20090917050639.GA5060@nowhere> <a4423d670909220655j37cc49f8rcd29d8f154c5e6e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670909220655j37cc49f8rcd29d8f154c5e6e6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 05:55:43PM +0400, Alexander Beregalov wrote:
> Hi Frederic.
> 
> Another very similar warning.
> (smp 2*2core)
> v2.6.31-7068-g43c1266 plus 193be0ee1 kill-the-bkl/reiserfs: Fix
> induced mm->mmap_sem to sysfs_mutex dependency
> 
> 
> [ INFO: possible circular locking dependency detected ]
> 2.6.31-07095-g25a3912 #4
> -------------------------------------------------------
> udevadm/790 is trying to acquire lock:
>  (&mm->mmap_sem){++++++}, at: [<c1098942>] might_fault+0x72/0xc0
> 
> but task is already holding lock:
>  (sysfs_mutex){+.+.+.}, at: [<c110813c>] sysfs_readdir+0x7c/0x260
> 
> which lock already depends on the new lock.



Yeah indeed, it's about the same kind of thing.
Could you please test the following patch?

Thanks!

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 04e3c42..2f8a7e7 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2933,8 +2933,11 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	}
 
 	reiserfs_mounted_fs_count++;
-	if (reiserfs_mounted_fs_count <= 1)
+	if (reiserfs_mounted_fs_count <= 1) {
+		reiserfs_write_unlock(sb);
 		commit_wq = create_workqueue("reiserfs");
+		reiserfs_write_lock(sb);
+	}
 
 	INIT_DELAYED_WORK(&journal->j_work, flush_async_commits);
 	journal->j_work_sb = sb;


