Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXKUXsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXKUXsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 18:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXKUXr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 18:47:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:3165 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbXKUXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 18:47:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=JQ4muqvBeJ4uQ3J+4bzKlgCbS6kbDZgWG28ZtnX4z6rksJSUq32mv/QM2VYg9eadBV7Nxl+FJkBvmHqFgzBvWx4kAc99z2+tg2EtwvO79gtYB/y2xNR0bun0YeclauPsY9TRlesOsFRY3YukRUxnVO1lX4ru0f8eJRGkL2uunfk=
Message-ID: <4744C3A6.3060002@gmail.com>
Date: Thu, 22 Nov 2007 02:47:50 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: zach.brown@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2.6.24-rc3-mm1] loop cleanup in fs/namespace.c - repost
References: <47447184.6040805@gmail.com>	<474481B9.9000603@oracle.com>	<47448D0A.1040405@gmail.com>	<47449932.3090801@oracle.com>	<4744B5EF.5010708@gmail.com> <20071121152433.1b5289c4.akpm@linux-foundation.org>
In-Reply-To: <20071121152433.1b5289c4.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------010907080101030902040800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010907080101030902040800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Andrew Morton пишет:
> On Thu, 22 Nov 2007 01:49:19 +0300
> Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> 
>> Zach Brown пишет:
>>>>> This doesn't look fine.  Did you test this?
>>>> Oops, my fault. Of course, I tested the patch, but kernel modules are
>>>> disabled in my test setup, so I missed the error.
>>> :)
>>>
>>>> Enclosed to this message is a new patch, which replaces the goto-loop by
>>>> the while-based one, but leaves the EXPORT_SYMBOL macro intact.
>>> It certainly looks OK to me now, for whatever that's worth. 
>> Zach, thank you for the code review and suggestions.
>>
>>> You probably want to wait 'till the next merge window to get it in,
>>> though.  It's just a cleanup and so shouldn't go in this late in the -rc
>>> line.
>>>
>>> Maybe Andrew will be willing to queue it until that time in -mm.
>> I am enclosing the patch against current -mm tree and adding Andrew to the Cc: list.
>>
>> Thanks,
>>
>> Dmitri
>>
>>> - z
>>>
>>
> [loop-cleanup-fs-namespace-mm.diff  text/x-patch (742B)]
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
> ---
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 79883fe..b098b63 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -606,19 +606,17 @@ static inline void __mntput(struct vfsmo
>  
>  void mntput_no_expire(struct vfsmount *mnt)
>  {
> -repeat:
> -	if (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
> +	while (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
>  		if (likely(!mnt->mnt_pinned)) {
>  			spin_unlock(&vfsmount_lock);
>  			__mntput(mnt);
> -			return;
> +			break;
>  		}
>  		atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
>  		mnt->mnt_pinned = 0;
>  		spin_unlock(&vfsmount_lock);
>  		acct_auto_close_mnt(mnt);
>  		security_sb_umount_close(mnt);
> -		goto repeat;
>  	}
>  }
>  
> This patch has no changelog which I can use.
> 
> 

Andrew, thanks for the quick reply. I believe that a couple of sentences is enough for the changelog entry, so here it goes...

From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

The mntput_no_expire() routine implements a simple loop using the goto-based construct. Replace this with an equivalent while-based loop, which looks much cleaner in C code.



--------------010907080101030902040800
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
 

--------------010907080101030902040800--
