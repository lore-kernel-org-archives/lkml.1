Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXKZKao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXKZKao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbXKZKae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:30:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55199 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXKZKad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:30:33 -0500
Date: Mon, 26 Nov 2007 10:30:28 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, zach.brown@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2.6.24-rc3-mm1] loop cleanup in fs/namespace.c - repost
Message-ID: <20071126103028.GQ8181@ftp.linux.org.uk>
References: <47447184.6040805@gmail.com> <474481B9.9000603@oracle.com> <47448D0A.1040405@gmail.com> <47449932.3090801@oracle.com> <4744B5EF.5010708@gmail.com> <20071121152433.1b5289c4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121152433.1b5289c4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 03:24:33PM -0800, Andrew Morton wrote:
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

BTW, I have a problem with that one.  The change is misleading; FWIW,
I'm very tempted to turn that into tail recursion, with

	if (!atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock))
		return;

in the very beginning (i.e. invert the test and pull the body to top level).
