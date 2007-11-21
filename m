Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbXKUTzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbXKUTzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXKUTzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:55:00 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:36086 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbXKUTy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:54:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=B6x2qBfSA/Abi+mX1vF6BO4K71XzZhbxGLeYRDvggbWkRybxO3UZ/BShv/2NKX3viJwJU7URoMEoKfENT2QqYMhbf+qLDqvmq7/KyjaPaWwTnUkHcdEK6RqlkhJSYFn6ZHMgXVlC4qHVD3S2C5QzK30hKCspc1BeCTWzKj8kSPI=
Message-ID: <47448D0A.1040405@gmail.com>
Date: Wed, 21 Nov 2007 22:54:50 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]loop cleanup in fs/namespace.c - repost
References: <47447184.6040805@gmail.com> <474481B9.9000603@oracle.com>
In-Reply-To: <474481B9.9000603@oracle.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown пишет:
>> The patch given below replaces the goto-loop by a while-based one.
> 
> That certainly looks fine.  I would also replace the 'return' with
> 'break', but I guess that's more of a question of personal preference.
> 
>> Besides, it removes the export for the same routine, because there are
>> no users for it outside of the core VFS code.
> 
> This doesn't look fine.  Did you test this?

Oops, my fault. Of course, I tested the patch, but kernel modules are disabled in my test setup, so I missed the error. Thanks for pointing that out, Zach.

Enclosed to this message is a new patch, which replaces the goto-loop by the while-based one, but leaves the EXPORT_SYMBOL macro intact.

And yes, I agree that for this routine, the break statement looks more appropriate than return.

> 
> mntput_no_expire() is called from mntput() which is an inline function
> in mount.h.  So lots of callers of mntput() in modules will end up
> trying to call mntput_no_expire() from modules.
> 
> $ nm fs/fuse/fuse.ko | grep mntput_no_expire
>                  U mntput_no_expire
> 
> - z
> 

Signed-off-by Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
diff --git a/fs/namespace.c b/fs/namespace.c
index 0608388..410e766 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -278,19 +278,17 @@ static inline void __mntput(struct vfsmo
 
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
 
