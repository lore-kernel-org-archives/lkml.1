Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZCaINz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZCaINz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbZCaIM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:12:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624AbZCaIM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:12:26 -0400
Date: Tue, 31 Mar 2009 01:04:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/8 ver5] exofs: address_space_operations
Message-Id: <20090331010420.8a12810e.akpm@linux-foundation.org>
In-Reply-To: <49C64416.4060801@panasas.com>
References: <49C1331D.1080805@panasas.com>
	<1237399473-29344-1-git-send-email-bharrosh@panasas.com>
	<49C64416.4060801@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Mar 2009 15:58:46 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> OK Now we start to read and write from osd-objects. We try to
> collect at most contiguous pages as possible in a single write/read.
> The first page index is the object's offset.
> 
> TODO:
>    In 64-bit a single bio can carry at most 128 pages.
>    Add support of chaining multiple bios
> 
>
> ...
>
> +static int write_exec(struct page_collect *pcol)
> +{
> +	struct exofs_i_info *oi = exofs_i(pcol->inode);
> +	struct osd_obj_id obj = {pcol->sbi->s_pid,
> +					pcol->inode->i_ino + EXOFS_OBJ_OFF};
> +	struct osd_request *or = NULL;
> +	struct page_collect *pcol_copy = NULL;
> +	loff_t i_start = pcol->pg_first << PAGE_CACHE_SHIFT;

bug.  On 32-bit this shift will overflow prior to getting promoted to
64-bit.  Do:

	loff_t i_start = (loff_t)pcol->pg_first << PAGE_CACHE_SHIFT;

>
> ...
>
> +static int writepage_strip(struct page *page,
> +			   struct writeback_control *wbc_unused, void *data)

Some of these functions could do with some comments explaining why they exist.

> +	struct page_collect *pcol = data;
> +	struct inode *inode = pcol->inode;
> +	struct exofs_i_info *oi = exofs_i(inode);
> +	loff_t i_size = i_size_read(inode);
> +	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
> +	size_t len;
> +	int ret;
> +
>
> ...
>

