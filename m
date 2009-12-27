Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbZL0MgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbZL0MgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 07:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZL0MgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 07:36:19 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:32802 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZL0MgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 07:36:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 02/10] vfs: get_sb_single() - do not pass options twice
References: <20091223194955.GB18101@kroah.com>
	<1261597963-18323-2-git-send-email-gregkh@suse.de>
Date: Sun, 27 Dec 2009 21:36:11 +0900
In-Reply-To: <1261597963-18323-2-git-send-email-gregkh@suse.de> (Greg
	Kroah-Hartman's message of "Wed, 23 Dec 2009 11:52:35 -0800")
Message-ID: <87my14h9vo.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg Kroah-Hartman <gregkh@suse.de> writes:

> From: Kay Sievers <kay.sievers@vrfy.org>
>
> Filesystem code usually destroys the option buffer while
> parsing it. This leads to errors when the same buffer is
> passed twice. In case we fill a new superblock do not call
> remount.
>
> This is needed to quite a warning that the debugfs code
> causes every boot.
>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  fs/super.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/super.c b/fs/super.c
> index 19eb70b..aff046b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -901,8 +901,9 @@ int get_sb_single(struct file_system_type *fs_type,
>  			return error;
>  		}
>  		s->s_flags |= MS_ACTIVE;
> +	} else {
> +		do_remount_sb(s, flags, data, 0);
>  	}
> -	do_remount_sb(s, flags, data, 0);
>  	simple_set_mnt(mnt, s);
>  	return 0;
>  }

This breaks the historical behavior. Several users of get_sb_single() is
parse data only on ->remount_fs. Well, ok, I like new behavior actually.
But we need to convert to new behavior such users.

I've listed all possibly affected users up (if I'm not missing). This
means, using both data on ->fill_super and ->remount_fs is devtmpfs
only. And capifs, usbfs, devpts would be needed the patch.

arch/powerpc/platforms/cell/spufs/inode.c
	->fill_super
arch/s390/hypfs/inode.c
	->fill_super
drivers/isdn/capi/capifs.c
	->remount_fs
drivers/base/devtmpfs.c
	->fill_super
	->remount_fs
drivers/usb/core/inode.c
	->remount_fs
fs/devpts/inode.c
	->remount_fs

Currently, I'm working on other bugs, so I just attached quick fix for
regression.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/super.c~get_sb_single-fix fs/super.c
--- linux-2.6/fs/super.c~get_sb_single-fix	2009-12-27 20:48:07.000000000 +0900
+++ linux-2.6-hirofumi/fs/super.c	2009-12-27 20:48:29.000000000 +0900
@@ -912,9 +912,8 @@ int get_sb_single(struct file_system_typ
 			return error;
 		}
 		s->s_flags |= MS_ACTIVE;
-	} else {
-		do_remount_sb(s, flags, data, 0);
 	}
+	do_remount_sb(s, flags, data, 0);
 	simple_set_mnt(mnt, s);
 	return 0;
 }
_
