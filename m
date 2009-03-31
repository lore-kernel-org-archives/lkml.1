Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZCaIN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZCaIN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZCaIMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:12:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757444AbZCaIML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:12:11 -0400
Date: Tue, 31 Mar 2009 01:04:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 5/8] exofs: dir_inode and directory operations
Message-Id: <20090331010423.930883a0.akpm@linux-foundation.org>
In-Reply-To: <1237399729-29465-1-git-send-email-bharrosh@panasas.com>
References: <49C1331D.1080805@panasas.com>
	<1237399729-29465-1-git-send-email-bharrosh@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 20:08:49 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:

> implementation of directory and inode operations.
> 
> * A directory is treated as a file, and essentially contains a list
>   of <file name, inode #> pairs for files that are found in that
>   directory. The object IDs correspond to the files' inode numbers
>   and are allocated using a 64bit incrementing global counter.
> * Each file's control block (AKA on-disk inode) is stored in its
>   object's attributes. This applies to both regular files and other
>   types (directories, device files, symlinks, etc.).
> 
>
> ...
>
> +static inline unsigned long dir_pages(struct inode *inode)
> +{
> +	return (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> +}

Do we need i_size_read() here?  Probably not if it's always called
under i_mutex.  Needs checking and commenting please.

> +static unsigned exofs_last_byte(struct inode *inode, unsigned long page_nr)
> +{
> +	unsigned last_byte = inode->i_size;
> +
> +	last_byte -= page_nr << PAGE_CACHE_SHIFT;

hm.  Strange to left-shift an unsigned long and then copy it to a
smaller type.

Are the types here appropriately chosen?

> +	if (last_byte > PAGE_CACHE_SIZE)
> +		last_byte = PAGE_CACHE_SIZE;
> +	return last_byte;
> +}
> +
> +static int exofs_commit_chunk(struct page *page, loff_t pos, unsigned len)
>
> ...
>

This all looks vaguely familiar :)
