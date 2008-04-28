Return-Path: <linux-kernel-owner+w=401wt.eu-S1764816AbYD1C1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764816AbYD1C1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 22:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbYD1C0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 22:26:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbYD1C0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 22:26:54 -0400
Date: Sun, 27 Apr 2008 19:26:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/5] fuse: fix race in llseek
Message-Id: <20080427192617.ae8190e3.akpm@linux-foundation.org>
In-Reply-To: <20080425175657.912755144@szeredi.hu>
References: <20080425175520.735386844@szeredi.hu>
	<20080425175657.912755144@szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 19:55:23 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> +static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
> +{
> +	long long retval;

I switched this to have a type of loff_t.

> +	struct inode *inode = file->f_path.dentry->d_inode;
> +
> +	mutex_lock(&inode->i_mutex);
> +	switch (origin) {
> +	case SEEK_END:
> +		offset += i_size_read(inode);

As we hold i_mutex we could directly read inode->i_size here, save a few
cycles.

> +		break;
> +	case SEEK_CUR:
> +		offset += file->f_pos;
> +	}
> +	retval = -EINVAL;
> +	if (offset >= 0 && offset <= inode->i_sb->s_maxbytes) {
> +		if (offset != file->f_pos) {
> +			file->f_pos = offset;
> +			file->f_version = 0;
> +		}
> +		retval = offset;
> +	}
> +	mutex_unlock(&inode->i_mutex);
> +	return retval;
> +}
