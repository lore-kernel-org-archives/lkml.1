Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZAUTzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZAUTzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 14:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZAUTzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 14:55:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43341 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZAUTzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 14:55:23 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 21 Jan 2009 11:55:11 -0800
Message-ID: <m13afch1sw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] sysfs: Take sysfs_mutex when fetching the root inode.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sysfs_get_inode ultimately calls sysfs_count_nlink when the a
directory inode is fectched.  sysfs_count_nlink needs to be
called under the sysfs_mutex to guard against the unlikely
but possible scenario that the root directory is changing
as we are counting the number entries in it, and just in
general to be consistent.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/mount.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index ab343e3..f3e34fd 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -53,7 +53,9 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sysfs_sb = sb;
 
 	/* get root inode, initialize and unlock it */
+	mutex_lock(&sysfs_mutex);
 	inode = sysfs_get_inode(&sysfs_root);
+	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
 		return -ENOMEM;
-- 
1.5.6.3

