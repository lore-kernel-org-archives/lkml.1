Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXGRHO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXGRHO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbXGRHOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:14:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:58073 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbXGRHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=M3pdhiPjr89uA2bwa0jcVxMmbW9NA+2a6Ox7ZyoXp97HZ5H/dkRrhnpQ4ABC/U7suv3olDnB9+H5MhdzfYea1tg5r/LYPLM9ovqjS4DTlNkwR3bp88K989geTXbM0+BGtunyFgx/fIehDt7zx/LW7lEuVgRwSjJki3OsQUSAPyk=
Date: Wed, 18 Jul 2007 16:14:45 +0900
From: Tejun Heo <htejun@gmail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Message-ID: <20070718071445.GI23568@htj.dyndns.org>
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com> <469A5C94.7030201@googlemail.com> <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com> <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com> <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com> <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com> <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469BC34C.4080107@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a subtle bug in sysfs_create_link() failure path.  When
symlink creation fails because there's already a node with the same
name, the target sysfs_dirent is put twice - once by failure path of
sysfs_create_link() and once more when the symlink is released.

Fix it by making only the symlink node responsible for putting
target_sd.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Gabriel, Miles, please verify this fixes your problem.  Thanks.

 fs/sysfs/symlink.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 2f86e04..d056e96 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -86,7 +86,9 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
 	if (!sd)
 		goto out_put;
+
 	sd->s_elem.symlink.target_sd = target_sd;
+	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
