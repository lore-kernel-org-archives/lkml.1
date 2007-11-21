Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbXKUWtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbXKUWtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbXKUWt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:49:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:56575 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbXKUWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=qCjeY80BEfuCzIKouLrWlEF94pnrnnScqO7DgIOSpU3VtOlxjudD09kkotfbA6ml0G/t4a+yQV6bav4UUjQs3kaN8xTMjqOwgG3GN48quz8CdMxDZ6FD2xY4bOh41OZ+8c5oEw/CUCk8VGkQAIoOXvMJ+sB0NGMTKZ3mniBrwUE=
Message-ID: <4744B5EF.5010708@gmail.com>
Date: Thu, 22 Nov 2007 01:49:19 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [2.6.24-rc3-mm1] loop cleanup in fs/namespace.c - repost
References: <47447184.6040805@gmail.com> <474481B9.9000603@oracle.com> <47448D0A.1040405@gmail.com> <47449932.3090801@oracle.com>
In-Reply-To: <47449932.3090801@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------080107090803000008020202"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080107090803000008020202
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit

Zach Brown пишет:
>>> This doesn't look fine.  Did you test this?
>> Oops, my fault. Of course, I tested the patch, but kernel modules are
>> disabled in my test setup, so I missed the error.
> 
> :)
> 
>> Enclosed to this message is a new patch, which replaces the goto-loop by
>> the while-based one, but leaves the EXPORT_SYMBOL macro intact.
> 
> It certainly looks OK to me now, for whatever that's worth. 

Zach, thank you for the code review and suggestions.

> 
> You probably want to wait 'till the next merge window to get it in,
> though.  It's just a cleanup and so shouldn't go in this late in the -rc
> line.
> 
> Maybe Andrew will be willing to queue it until that time in -mm.

I am enclosing the patch against current -mm tree and adding Andrew to the Cc: list.

Thanks,

Dmitri

> 
> - z
> 


--------------080107090803000008020202
Content-Type: text/x-patch;
 name="loop-cleanup-fs-namespace-mm.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="loop-cleanup-fs-namespace-mm.diff"

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
 

--------------080107090803000008020202--
