Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXGMX67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXGMX67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbXGMX6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:58:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbXGMX6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:58:50 -0400
Date: Fri, 13 Jul 2007 16:58:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic_nvram: use inode lock not lock_kernel
Message-Id: <20070713165840.70f5f382.akpm@linux-foundation.org>
In-Reply-To: <20070709144745.029094ae@the-village.bc.nu>
References: <20070709144745.029094ae@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 14:47:45 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> The locking is only done for lseek so this isn't a big change. All the
> other operations are thrown at the arch specific lower layers for locking
> handling without the file pointer being directly exposed.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc6-mm1/drivers/char/generic_nvram.c linux-2.6.22-rc6-mm1/drivers/char/generic_nvram.c
> --- linux.vanilla-2.6.22-rc6-mm1/drivers/char/generic_nvram.c	2007-07-02 20:47:23.000000000 +0100
> +++ linux-2.6.22-rc6-mm1/drivers/char/generic_nvram.c	2007-07-09 12:05:06.786669552 +0100
> @@ -30,7 +30,7 @@
>  
>  static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
>  {
> -	lock_kernel();
> +	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
>  	switch (origin) {
>  	case 1:
>  		offset += file->f_pos;
> @@ -44,7 +44,7 @@
>  		return -EINVAL;
>  	}
>  	file->f_pos = offset;
> -	unlock_kernel();
> +	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
>  	return file->f_pos;
>  }
>  

You left an unlock_kernel() on the error path, thus introducing a deadly
bug.

Can we just use generic_file_llseek() in here?  afacit that simply requires
that i_size have the correct value.  Does it?

generic_file_llseek() uses file->f_mapping->host->i_mutex which is
equivalent for this file, but we might as well be consistent.

While we're there, we can do s/magic numbers/standard symbols/.

And we can fix the remaining race in there by reading f_pos while holding
the mutex, not after having dropped it.


End result:


static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
{
	struct inode *inode = file->f_mapping->host;

	mutex_lock(&inode->i_mutex);
	switch (origin) {
	case SEEK_CUR:
		offset += file->f_pos;
		break;
	case SEEK_END:
		offset += NVRAM_SIZE;
		break;
	}
	if (offset < 0) {
		offset = -EINVAL;
		goto out;
	}
	file->f_pos = offset;
out:
	mutex_unlock(&inode->i_mutex);
	return offset;
}

