Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZKDMEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZKDMEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZKDMEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:04:10 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37104 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbZKDMEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:04:08 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 14/13] sysfs: sysfs_setattr remove unnecessary permission check.
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Nov 2009 04:04:02 -0800
In-Reply-To: <m13a4vbz8r.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 03 Nov 2009 03\:53\:56 -0800")
Message-ID: <m1ljim1op9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


inode_change_ok already clears the SGID bit when necessary so there is
no reason for sysfs_setattr to carry code to do the same, and it is
good to kill the extra copy because when I moved the code, I goofed
and in certain corner cases the code will look at the wrong gid.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 72e2e99..e2595a7 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -120,10 +120,6 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		return error;
 
 	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
-	if (iattr->ia_valid & ATTR_MODE) {
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			iattr->ia_mode &= ~S_ISGID;
-	}
 
 	error = inode_setattr(inode, iattr);
 	if (error)
-- 
1.6.5.2.143.g8cc62

