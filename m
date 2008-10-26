Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbYJZT42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbYJZT42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 15:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYJZT4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 15:56:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55244 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbYJZT4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 15:56:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Date: Sun, 26 Oct 2008 21:01:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
References: <1224886068.6478.21.camel@nigel-laptop>
In-Reply-To: <1224886068.6478.21.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810262101.08822.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 of October 2008, Nigel Cunningham wrote:
> Hi.

Hi Nigel,

> While working on freezing fuse filesystems, I found that if a filesystem
> is frozen when we try to freeze processes, freezing can fail because
> threads are waiting in vfs_check_frozen for the filesystem to be thawed.
> We should thus not count such threads.
> 
> The check will be safe if a filesystem is thawed while we're freezing
> processes because filesystem thaws are only invoked from userspace. Any
> waiting processes will be woken and frozen prior to us completing the
> freezing of userspace (the caller invoking the filesystem thaw will be
> freezing) or - in the worst case - together with kernel threads.

While your description above seems completely correct to me and I have no
objections to the patch, I'd prefer it if someone having more experience with
the VFS looked at it.  Miklos, can you have a look, please?

Thanks,
Rafael


> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a6a625b..c9b055d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -8,6 +8,7 @@
>  
>  #include <linux/limits.h>
>  #include <linux/ioctl.h>
> +#include <linux/freezer.h>
>  
>  /*
>   * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
> @@ -1187,8 +1190,11 @@ enum {
>  	SB_FREEZE_TRANS = 2,
>  };
>  
> -#define vfs_check_frozen(sb, level) \
> -	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
> +#define vfs_check_frozen(sb, level) do { \
> +	freezer_do_not_count(); \
> +	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level))); \
> +	freezer_count(); \
> +} while (0)
>  
>  #define get_fs_excl() atomic_inc(&current->fs_excl)
>  #define put_fs_excl() atomic_dec(&current->fs_excl)
> 
> 
