Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZFTIOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZFTIOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 04:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZFTIOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 04:14:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZFTIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 04:14:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
Date: Sat, 20 Jun 2009 08:13:59 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Ankit Jain <me@ankitjain.org>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
References: <4980C71F.1010804@ankitjain.org> <20090619182807.GA32683@infradead.org>
In-Reply-To: <20090619182807.GA32683@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906200813.59793.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19BUbXqGyXYzw16+ssFRNIqywfRNTVXWCxKHKG
 77DnewkeI3+cHIJ0SVhWlMfxZjrdKuLGtHhCvRleBe3vTvdxBY
 +BWytqfRFy12xF0d7tAnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 June 2009 06:28:07 pm Christoph Hellwig wrote:

> +/* on ia32 l_start is on a 32-bit boundary */
> +#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
> +struct space_resv_32 {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__s64		l_start	__attribute__((packed));
> +			/* len == 0 means until end of file */
> +	__s64		l_len __attribute__((packed));
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserve area */
> +};
> +
> +#define FS_IOC_RESVSP_32		_IOW ('X', 40, struct space_resv_32)
> +#define FS_IOC_RESVSP64_32	_IOW ('X', 42, struct space_resv_32)

I'd just define this using compat_s64 instead of __s64 __packed so we can
use the same code on all architectures, even at the small cost of extra
text size on non-x86 architectures.

> +/* just account for different alignment */
> +static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
> +{
> +	struct space_resv_32	__user *p32 = (void __user *)arg;
> +	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
> +
> +	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
> +	    copy_in_user(&p->l_whence,	&p32->l_whence, sizeof(s16)) ||
> +	    copy_in_user(&p->l_start,	&p32->l_start,	sizeof(s64)) ||
> +	    copy_in_user(&p->l_len,	&p32->l_len,	sizeof(s64)) ||
> +	    copy_in_user(&p->l_sysid,	&p32->l_sysid,	sizeof(s32)) ||
> +	    copy_in_user(&p->l_pid,	&p32->l_pid,	sizeof(u32)) ||
> +	    copy_in_user(&p->l_pad,	&p32->l_pad,	4*sizeof(u32)))
> +		return -EFAULT;
> +
> +	return ioctl_preallocate(file, p);
> +}
> +#endif
> +

Here, you can call do_fallocate directly in the same way that ioctl_preallocate
does, replacing the copy_in_user calls with __get_user().

	Arnd <><
