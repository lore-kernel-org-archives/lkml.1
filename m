Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbXKUXY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbXKUXY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 18:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXKUXYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 18:24:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbXKUXYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 18:24:46 -0500
Date: Wed, 21 Nov 2007 15:24:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: zach.brown@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2.6.24-rc3-mm1] loop cleanup in fs/namespace.c -
 repost
Message-Id: <20071121152433.1b5289c4.akpm@linux-foundation.org>
In-Reply-To: <4744B5EF.5010708@gmail.com>
References: <47447184.6040805@gmail.com>
	<474481B9.9000603@oracle.com>
	<47448D0A.1040405@gmail.com>
	<47449932.3090801@oracle.com>
	<4744B5EF.5010708@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 01:49:19 +0300
Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> Zach Brown пишет:
> >>> This doesn't look fine.  Did you test this?
> >> Oops, my fault. Of course, I tested the patch, but kernel modules are
> >> disabled in my test setup, so I missed the error.
> > 
> > :)
> > 
> >> Enclosed to this message is a new patch, which replaces the goto-loop by
> >> the while-based one, but leaves the EXPORT_SYMBOL macro intact.
> > 
> > It certainly looks OK to me now, for whatever that's worth. 
> 
> Zach, thank you for the code review and suggestions.
> 
> > 
> > You probably want to wait 'till the next merge window to get it in,
> > though.  It's just a cleanup and so shouldn't go in this late in the -rc
> > line.
> > 
> > Maybe Andrew will be willing to queue it until that time in -mm.
> 
> I am enclosing the patch against current -mm tree and adding Andrew to the Cc: list.
> 
> Thanks,
> 
> Dmitri
> 
> > 
> > - z
> > 
> 
> 
[loop-cleanup-fs-namespace-mm.diff  text/x-patch (742B)]
Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
diff --git a/fs/namespace.c b/fs/namespace.c
index 79883fe..b098b63 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -606,19 +606,17 @@ static inline void __mntput(struct vfsmo
 
 void mntput_no_expire(struct vfsmount *mnt)
 {
-repeat:
-	if (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
+	while (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
 		if (likely(!mnt->mnt_pinned)) {
 			spin_unlock(&vfsmount_lock);
 			__mntput(mnt);
-			return;
+			break;
 		}
 		atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
 		mnt->mnt_pinned = 0;
 		spin_unlock(&vfsmount_lock);
 		acct_auto_close_mnt(mnt);
 		security_sb_umount_close(mnt);
-		goto repeat;
 	}
 }
 
This patch has no changelog which I can use.

