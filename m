Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZCaIMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZCaIMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZCaILv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:11:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756578AbZCaILt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:11:49 -0400
Date: Tue, 31 Mar 2009 01:04:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/8] exofs: file and file_inode operations
Message-Id: <20090331010417.43deb1e7.akpm@linux-foundation.org>
In-Reply-To: <1237399127-29206-1-git-send-email-bharrosh@panasas.com>
References: <49C1331D.1080805@panasas.com>
	<1237399127-29206-1-git-send-email-bharrosh@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 19:58:47 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:

> implementation of the file_operations and inode_operations for
> regular data files.
> 
> Most file_operations are generic vfs implementations except:
> - exofs_truncate will truncate the OSD object as well
> - Generic file_fsync is not good for none_bd devices so open code it
> - The default for .flush in Linux is todo nothing so call exofs_fsync
>   on the file.
> 
>
> ...
>
> +static int exofs_file_fsync(struct file *filp, struct dentry *dentry,
> +			    int datasync)
> +{
> +	int ret1, ret2;
> +	struct address_space *mapping = filp->f_mapping;
> +
> +	ret1 = filemap_write_and_wait(mapping);
> +	ret2 = file_fsync(filp, dentry, datasync);
> +
> +	return ret1 ? ret1 : ret2;
> +}

It might be better to abort if filemap_write_and_wait() failed.  if the
hardware is bad, these things can take a looooong time retrying and
timing out.  There's no point in doubling the delay.

>
> ...
>

