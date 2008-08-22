Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYHVWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYHVWgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYHVWgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:36:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbYHVWgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:36:06 -0400
Date: Fri, 22 Aug 2008 15:34:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zev Weiss <zevweiss@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@enneenne.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO
 ioctl()
Message-Id: <20080822153451.bb79bd1f.akpm@linux-foundation.org>
In-Reply-To: <48ABCC0B.40607@gmail.com>
References: <48ABCC0B.40607@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 00:47:23 -0700
Zev Weiss <zevweiss@gmail.com> wrote:

> From: Zev Weiss <zevweiss@gmail.com>
> 
> The MEMGETREGIONINFO ioctl() in mtdchar.c was clobbering user memory by
> overwriting more than intended, due to the size of struct
> mtd_erase_region_info changing in commit
> 0ecbc81adfcb9f15f86b05ff576b342ce81bbef8.
> 
> Fix uses a member-by-member copy into a local struct region_info_user,
> which is then copy_to_user()'d (and matches the size correctly by being
> of the same type as the pointer passed in the ioctl() call).
> 
> Signed-off-by: Zev Weiss <zevweiss@gmail.com>
> Tested-by: Zev Weiss <zevweiss@gmail.com>
> ---
> I had been having some problems with userspace memory corruption, and traced
> them to a MEMGETREGIONINFO ioctl() on an MTD device.  I applied this patch and
> it seems to fix the problem, though I am not an expert and there may be a more
> correct way to go about doing this.  I'm also new at submitting patches, so
> hopefully I haven't screwed up the patch-submission etiquette too
> horrifically.
> 
>   drivers/mtd/mtdchar.c |   11 +++++++++--
>   1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 13cc67a..0acb135 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -411,14 +411,21 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
>   	case MEMGETREGIONINFO:
>   	{
>   		struct region_info_user ur;
> +		struct mtd_erase_region_info *kr;
> 
>   		if (copy_from_user(&ur, argp, sizeof(struct region_info_user)))
>   			return -EFAULT;
> 
>   		if (ur.regionindex >= mtd->numeraseregions)
>   			return -EINVAL;
> -		if (copy_to_user(argp, &(mtd->eraseregions[ur.regionindex]),
> -				sizeof(struct mtd_erase_region_info)))
> +
> +		kr = &(mtd->eraseregions[ur.regionindex]);
> +
> +		ur.offset = kr->offset;
> +		ur.erasesize = kr->erasesize;
> +		ur.numblocks = kr->numblocks;
> +
> +		if (copy_to_user(argp, &ur, sizeof(struct region_info_user)))
>   			return -EFAULT;
>   		break;
>   	}

ug.

Putting a kernel pointer into a shared-with-userspace data structure
(struct mtd_erase_region_info) was a big mistake.

Copying a `struct region_info_user' back to userspace seems better than
copying a `struct mtd_erase_region_info', but what do I know?

Actually...

Before 0ecbc81adfcb9f15f86b05ff576b342ce81bbef8, `struct
mtd_erase_region_info' had three members, all u32.  We were copying
three u32's out to userspace.

After 0ecbc81adfcb9f15f86b05ff576b342ce81bbef8, `struct
mtd_erase_region_info' has four members: three u32's and one ulong*. 
We're copying three u32's and one ulong* out to userspace.

After your change, we're copying _four_ u32's out to userspace, so
there still is potential for scribbling on unsuspecting userspace?

If that reading is right, we need to go back to copying just the three
u32's.  Perhaps via

struct mtd_erase_region_info {
	struct {
		u_int32_t offset;
		u_int32_t erasesize;
		u_int32_t numblocks;
	} user_part;
	unsigned long *lockmap;
};

or similar.

David?  Help?  2.6.25.x anmd 2.6.26.x need fixing as well.

