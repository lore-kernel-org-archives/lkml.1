Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYL2UiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYL2UiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYL2Ufe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:35:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbYL2Ufb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:35:31 -0500
Date: Mon, 29 Dec 2008 12:34:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] exofs: file and file_inode operations
Message-Id: <20081229123443.36c022bc.akpm@linux-foundation.org>
In-Reply-To: <4947C685.1000800@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<4947C685.1000800@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:17:25 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> implementation of the file_operations and inode_operations for
> regular data files.
> 
> Most file_operations are generic vfs implementations except:
> - exofs_truncate will truncate the OSD object as well
> - Generic file_fsync is not good for none_bd devices so open code it
> - The default for .flush in Linux is todo nothing so call exofs_fsync
>   on the file.
> 
> ...
>
> +int exofs_file_fsync(struct file *filp, struct dentry *dentry, int datasync)
> +{
> +	int ret1, ret2;
> +	struct address_space *mapping = filp->f_mapping;
> +
> +	ret1 = filemap_write_and_wait(mapping);
> +	ret2 = file_fsync(filp, dentry, datasync);
> +
> +	return ret1 ? : ret2;

mutter.  That gccism always makes me fall over dazed and confused. 
Maybe that's just me.

Did we really want to call file_fsync() if filemap_write_and_wait() failed?

> +}
>
> ...
>
> +struct file_operations exofs_file_operations = {
> +struct inode_operations exofs_file_inode_operations = {

These both could/should be made const.

> +	.truncate	= exofs_truncate,
> +	.setattr	= exofs_setattr,
> +};

