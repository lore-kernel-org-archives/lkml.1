Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbYBAXeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbYBAXeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbYBAXe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:34:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbYBAXe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:34:27 -0500
Date: Fri, 1 Feb 2008 15:34:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org, davem@davemloft.net,
       sparclinux@vger.kernel.org, hch@lst.de
Subject: Re: 2.6.24-rc8-mm1: sparc64 warning at fs/file_table.c:49
 __fput+0x1a8/0x1e0()
Message-Id: <20080201153411.ec20cdc6.akpm@linux-foundation.org>
In-Reply-To: <1201043638.7585.47.camel@nimitz.home.sr71.net>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<200801222130.24136.m.kozlowski@tuxland.pl>
	<20080122130228.e7596163.akpm@linux-foundation.org>
	<1201043638.7585.47.camel@nimitz.home.sr71.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008 15:13:58 -0800
Dave Hansen <haveblue@us.ibm.com> wrote:

> @@ -566,10 +567,26 @@ static void mark_files_ro(struct super_b
>  {
>  	struct file *f;
>  
> +retry:
>  	file_list_lock();
>  	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
> -		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
> -			f->f_mode &= ~FMODE_WRITE;
> +		struct vfsmount mnt;
> +		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
> +		       continue;
> +		if (!file_count(f))
> +			continue;
> +		if (!(f->f_mode & FMODE_WRITE))
> +			continue;
> +		f->f_mode &= ~FMODE_WRITE;
> +		f->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
> +		mnt = f->f_path.mnt;
> +		file_list_unlock();
> +		/*
> +		 * This can sleep, so we can't hold
> +		 * the file_list_lock() spinlock.
> +		 */
> +		mnt_drop_write(mnt);
> +		goto retry;
>  	}
>  	file_list_unlock();
>  }
> _

this doesn't even compile.  How much confidence am I supposed
to have that once I've fixed it, it will actually work?
