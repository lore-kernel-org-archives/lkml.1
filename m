Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZBEDma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZBEDma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZBEDmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:42:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbZBEDmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:42:20 -0500
Date: Wed, 4 Feb 2009 19:42:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
       adobriyan@gmail.com, ebierderm@xmission.com, stable@kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Separate FMODE_PREAD/FMODE_PWRITE into separate flags
Message-Id: <20090204194203.a2c652d2.akpm@linux-foundation.org>
In-Reply-To: <20090204193615.2d9aaa7a.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0902041736080.15728@kitami.corp.google.com>
	<20090204193615.2d9aaa7a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 19:36:15 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> >  /*
> >   * Don't update ctime and mtime.
> 
> Seems OK.
> 
> I augmented the changelog to
> 
>   Separate FMODE_PREAD and FMODE_PWRITE into separate flags to
>   reflect the reality that the read and write paths may have
>   independent restrictions.
> 
>   A git grep verifies that these flags are always cleared together so
>   this new behavior will only apply to interfaces that change to clear
>   flags individually.
> 
> + This is required for "seq_file: properly cope with pread", a
> + post-2.6.25 regression fix.
> 
> and added this comment:
> 
> --- a/include/linux/fs.h~vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix
> +++ a/include/linux/fs.h
> @@ -54,6 +54,11 @@ struct inodes_stat_t {
>  #define MAY_ACCESS 16
>  #define MAY_OPEN 32
>  
> +/*
> + * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
> + * to O_WRONLY and O_RDWR via the strange trick in __dentry_open()
> + */
> +
>  /* file is open for reading */
>  #define FMODE_READ		((__force fmode_t)1)
>  /* file is open for writing */
> _
> 

And I updated seq_file-properly-cope-with-pread.patch thusly:

--- a/fs/seq_file.c~seq_file-properly-cope-with-pread-fix
+++ a/fs/seq_file.c
@@ -48,6 +48,16 @@ int seq_open(struct file *file, const st
 	 */
 	file->f_version = 0;
 
+	/*
+	 * seq_files support lseek() and pread().  They do not implement
+	 * write() at all, but we clear FMODE_PWRITE here for historical
+	 * reasons.
+	 *
+	 * If a client of seq_files a) implements file.write() and b) wishes to
+	 * support pwrite() then that client will need to implement its own
+	 * file.open() which calls seq_open() and then sets FMODE_WRITE.
+	 */
+	file->f_mode &= ~FMODE_PWRITE;
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
diff -puN include/linux/seq_file.h~seq_file-properly-cope-with-pread-fix include/linux/seq_file.h
_

