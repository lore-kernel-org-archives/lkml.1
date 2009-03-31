Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZCaINB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZCaINB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbZCaIMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:12:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757437AbZCaIML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:12:11 -0400
Date: Tue, 31 Mar 2009 01:04:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 6/8] exofs: super_operations and file_system_type
Message-Id: <20090331010430.72e8137e.akpm@linux-foundation.org>
In-Reply-To: <1237399791-29502-1-git-send-email-bharrosh@panasas.com>
References: <49C1331D.1080805@panasas.com>
	<1237399791-29502-1-git-send-email-bharrosh@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 20:09:51 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:

> This patch ties all operation vectors into a file system superblock
> and registers the exofs file_system_type at module's load time.
> 
> * The file system control block (AKA on-disk superblock) resides in
>   an object with a special ID (defined in common.h).
>   Information included in the file system control block is used to
>   fill the in-memory superblock structure at mount time. This object
>   is created before the file system is used by mkexofs.c It contains
>   information such as:
> 	- The file system's magic number
> 	- The next inode number to be allocated
> 
>
> ...
>
> +static int exofs_statfs(struct dentry *dentry, struct kstatfs *buf)
> +{
> +	struct super_block *sb = dentry->d_sb;
> +	struct exofs_sb_info *sbi = sb->s_fs_info;
> +	struct osd_obj_id obj = {sbi->s_pid, 0};
> +	struct osd_attr attrs[] = {
> +		ATTR_DEF(OSD_APAGE_PARTITION_QUOTAS,
> +			OSD_ATTR_PQ_CAPACITY_QUOTA, sizeof(__be64)),
> +		ATTR_DEF(OSD_APAGE_PARTITION_INFORMATION,
> +			OSD_ATTR_PI_USED_CAPACITY, sizeof(__be64)),
> +	};
> +	uint64_t capacity = ~0;
> +	uint64_t used = ~0;

My brain hurts.

~0 is signed 0xffffffff.

When assigning to a u64 it gets signed extended to signed
0xffffffffffffffff and then converted to unsigned 0xffffffffffffffff.

I think.  Just as with plain old "-1".  Perhaps using plain old "-1"
would be clearer here.

>
> ...
>
> +const struct super_operations exofs_sops = {

This can in fact be made static, I believe.

>
> ...
>

