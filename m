Return-Path: <linux-kernel-owner+w=401wt.eu-S1161158AbXCAXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158AbXCAXa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161194AbXCAXa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:30:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161158AbXCAXaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:30:25 -0500
Message-ID: <45E761CB.2020904@redhat.com>
Date: Thu, 01 Mar 2007 17:29:15 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
In-Reply-To: <20070301183445.GA7911@amitarora.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Amit K. Arora wrote:

Might want more error checking in there, something like (rough cut)...
(or is some of this glibc's job?)

> +asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len)
> +{
> +	struct file *file;
> +	struct inode *inode;
> +	long ret;
 > +
 > +	ret = -EINVAL;
 > + 	if (len == 0 || offset < 0)
 > +		goto out;
 > + 	ret = -EBADF;
> +	file = fget(fd);
> +	if (!file)
> +		goto out;
 > +	if (!(file->f_mode & FMODE_WRITE))
 > +		goto out_fput;
> +	inode = file->f_path.dentry->d_inode;
 > +	ret = -ESPIPE;
 > +	if (S_ISFIFO(inode->i_mode))
 > +		goto out_fput;
 > +	ret = -ENODEV;
 > +     if (!S_ISREG(inode->i_mode))
 > +		goto out_fput;
 > + 	ret = -EFBIG;
 > + 	if (offset + len > inode->i_sb->s_maxbytes)
 > +		goto out_fput;
> +	if (inode->i_op && inode->i_op->fallocate)
> +		ret = inode->i_op->fallocate(inode, offset, len);
> +	else
> +		ret = -ENOTTY;
 > +out_fput:
> +	fput(file);
> +out:
> +	return ret;
> +}

which would keep things in line with posix_fallocate's specified errors, 
too?

-Eric
