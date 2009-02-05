Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbZBEDgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbZBEDgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZBEDgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:36:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbZBEDgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:36:32 -0500
Date: Wed, 4 Feb 2009 19:36:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, ebierderm@xmission.com,
       stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Separate FMODE_PREAD/FMODE_PWRITE into separate flags
Message-Id: <20090204193615.2d9aaa7a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0902041736080.15728@kitami.corp.google.com>
References: <Pine.LNX.4.64.0902041736080.15728@kitami.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's restored)

On Wed, 4 Feb 2009 18:06:11 -0800 (PST) Paul Turner <pjt@google.com> wrote:

> Separate FMODE_PREAD and FMODE_PWRITE into separate flags to reflect the
> reality that the read and write paths may have independent restrictions.
> 
> A git grep verifies that these flags are always cleared together so this new
> behavior will only apply to interfaces that change to clear flags individually.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  include/linux/fs.h |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6022f44..d6a51d9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -60,18 +60,19 @@ struct inodes_stat_t {
>  #define FMODE_WRITE		((__force fmode_t)2)
>  /* file is seekable */
>  #define FMODE_LSEEK		((__force fmode_t)4)
> -/* file can be accessed using pread/pwrite */
> +/* file can be accessed using pread */
>  #define FMODE_PREAD		((__force fmode_t)8)
> -#define FMODE_PWRITE		FMODE_PREAD	/* These go hand in hand */
> +/* file can be accessed using pwrite */
> +#define FMODE_PWRITE		((__force fmode_t)16)
>  /* File is opened for execution with sys_execve / sys_uselib */
> -#define FMODE_EXEC		((__force fmode_t)16)
> +#define FMODE_EXEC		((__force fmode_t)32)
>  /* File is opened with O_NDELAY (only set for block devices) */
> -#define FMODE_NDELAY		((__force fmode_t)32)
> +#define FMODE_NDELAY		((__force fmode_t)64)
>  /* File is opened with O_EXCL (only set for block devices) */
> -#define FMODE_EXCL		((__force fmode_t)64)
> +#define FMODE_EXCL		((__force fmode_t)128)
>  /* File is opened using open(.., 3, ..) and is writeable only for ioctls
>     (specialy hack for floppy.c) */
> -#define FMODE_WRITE_IOCTL	((__force fmode_t)128)
> +#define FMODE_WRITE_IOCTL	((__force fmode_t)256)
>  
>  /*
>   * Don't update ctime and mtime.

Seems OK.

I augmented the changelog to

  Separate FMODE_PREAD and FMODE_PWRITE into separate flags to
  reflect the reality that the read and write paths may have
  independent restrictions.

  A git grep verifies that these flags are always cleared together so
  this new behavior will only apply to interfaces that change to clear
  flags individually.

+ This is required for "seq_file: properly cope with pread", a
+ post-2.6.25 regression fix.

and added this comment:

--- a/include/linux/fs.h~vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix
+++ a/include/linux/fs.h
@@ -54,6 +54,11 @@ struct inodes_stat_t {
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
 
+/*
+ * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
+ * to O_WRONLY and O_RDWR via the strange trick in __dentry_open()
+ */
+
 /* file is open for reading */
 #define FMODE_READ		((__force fmode_t)1)
 /* file is open for writing */
_

