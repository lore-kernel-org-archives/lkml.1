Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYJGK4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYJGK4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYJGK4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:56:02 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46964 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbYJGK4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:56:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	<m163o47kc5.fsf_-_@frodo.ebiederm.org>
	<m11vys7k92.fsf_-_@frodo.ebiederm.org>
	<m1vdw465lm.fsf_-_@frodo.ebiederm.org>
Date: Tue, 07 Oct 2008 03:52:15 -0700
In-Reply-To: <m1vdw465lm.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 07 Oct 2008 03:51:17 -0700")
Message-ID: <m1prmc65k0.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0090]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 3/3] sysfs: Take sysfs_mutex when fetching the root inode.  
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sysfs_get_inode ultimately calls sysfs_count_nlink when the a
directory inode is fectched.  sysfs_count_nlink needs to be called
under the sysfs_mutex to guard against the unlikely but possible
scenario that the root directory is changing as we are counting the
number entries in it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/mount.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 8f2237a..59e55f0 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -65,7 +65,9 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent,
 
 	/* get root inode, initialize and unlock it */
 	error = -ENOMEM;
+	mutex_lock(&sysfs_mutex);
 	inode = sysfs_get_inode(&sysfs_root);
+	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
 		goto out_err;
-- 
1.5.3.rc6.17.g1911

