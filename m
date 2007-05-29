Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbXE2Th7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbXE2Th7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXE2Thu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:37:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:57230 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbXE2Ths (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:37:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=l8VErJNZU8FOmL0OhOG2JKLo6/Ev9Cm3u/kBQEpYpa4Skg0fCkMHPTIKIaDtq3rkTrydu8gaOOAkQZBrTJ08td3Yz3KgjE77fpXB3dZIku+sTL/J2kGhXbOTYKx3PWppQaBImENg08Gv7KFMOR3ZnX5bQgeCGNH7ABpHs3brTz8=
Date: Tue, 29 May 2007 23:38:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add procfs tunable to enable immediate panic when there are busy inodes after umount
Message-ID: <20070529193813.GC5666@martell.zuzino.mipt.ru>
References: <20070529114042.5fe0b810.jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529114042.5fe0b810.jlayton@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 11:40:42AM -0400, Jeff Layton wrote:
> After spending quite a bit of time tracking down a "VFS: busy inodes
> after unmount" problem, it occurs to me that it would be nice to be
> able to force a panic when that occurs. While an oops message alone is
> not generally helpful for tracking down this sort of problem,
> collecting and analyzing a coredump when this occurs can be.
>
> The following patch adds a procfs tunable that allows you to force a
> core when a "busy inodes after umount" problem occurs. It also changes
> the classic error message to be something a bit less cryptic to users.

> @@ -303,10 +305,15 @@ void generic_shutdown_super(struct super_block *sb)
>  			sop->put_super(sb);
>
>  		/* Forget any remaining inodes */
> -		if (invalidate_inodes(sb)) {
> -			printk("VFS: Busy inodes after unmount of %s. "
> -			   "Self-destruct in 5 seconds.  Have a nice day...\n",
> -			   sb->s_id);
> +		if (busy = invalidate_inodes(sb)) {
> +			printk("VFS: %d busy inodes after unmount of %s. ",
> +				 busy, sb->s_id);
> +			if (umount_debug != 0) {
> +				printk("Crashing host on request.\n");
> +				BUG();
> +			} else {
> +				printk("This machine will likely crash eventually. Consider a reboot.\n");
> +			}

You can add just BUG_ON here and do

	echo 1 >/proc/sys/kernel/panic_on_oops

