Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbXCYI1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbXCYI1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932486AbXCYI1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:27:08 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200AbXCYI1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:27:07 -0400
Date: Sun, 25 Mar 2007 00:26:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       staubach@redhat.com
Subject: Re: [Patch 5/7] integrity: mtime patch for mmap files
Message-Id: <20070325002656.0a5ceff0.akpm@linux-foundation.org>
In-Reply-To: <1174666198.11149.5.camel@localhost.localdomain>
References: <1174666198.11149.5.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 12:09:58 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> mmaped files are hashed and hmac'ed properly by EVM after being modified
> when the file's mtime is updated correctly.  Peter Staubach's 'memory
> mapped files not updating timestamps v2' patch properly updates the
> mmapped file's mtime.  In those cases when an application does not
> first msync the file before calling munmap, the mtime is eventually
> updated, but not before file_close is called.  This patch forces the
> mtime for mmaped files to be updated in a timely manner.

I don't think we've ever had that patch in -mm?

> signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ----
> Index: linux-2.6.21-rc4-mm1/mm/mmap.c
> ===================================================================
> --- linux-2.6.21-rc4-mm1.orig/mm/mmap.c
> +++ linux-2.6.21-rc4-mm1/mm/mmap.c
> @@ -1790,6 +1790,7 @@ int do_munmap(struct mm_struct *mm, unsi
>  {
>  	unsigned long end;
>  	struct vm_area_struct *vma, *prev, *last;
> +	struct file *file;
>  
>  	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
>  		return -EINVAL;
> @@ -1808,6 +1809,10 @@ int do_munmap(struct mm_struct *mm, unsi
>  	if (vma->vm_start >= end)
>  		return 0;
>  
> +	file = vma->vm_file;
> +	if (file && test_and_clear_bit(AS_MCTIME, &file->f_mapping->flags))
> +		file_update_time(file);
> +
>  	/*
>  	 * If we need to split any vma, do it now to save pain later.
>  	 *

Hence this won't compile.
