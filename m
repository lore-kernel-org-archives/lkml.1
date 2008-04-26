Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbYDZUkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbYDZUkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbYDZUjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:39:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757329AbYDZUjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:39:54 -0400
Date: Sat, 26 Apr 2008 13:39:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai.lu@sun.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, boot protocol
Message-Id: <20080426133928.a6f40caa.akpm@linux-foundation.org>
In-Reply-To: <20080426195407.GA13729@elte.hu>
References: <20080426185516.GA32364@elte.hu>
	<alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
	<20080426195407.GA13729@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008 21:54:07 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> Linus, please pull the following x86 changes from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-bootparam.git for-linus
> 
> these are boot parameter extensions for really large SGI UV boxes. The 
> change was seen and acked by the boot protocol guys. (well, Peter that 
> is ;-)
> 
> ...
>
> +void __init free_early(unsigned long start, unsigned long end)
> +{
> +	struct early_res *r;
> +	int i, j;
> +
> +	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
> +		r = &early_res[i];
> +		if (start == r->start && end == r->end)
> +			break;
> +	}
> +	if (i >= MAX_EARLY_RES || !early_res[i].end)
> +		panic("free_early on not reserved area: %lx-%lx!", start, end);
> +
> +	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
> +		;
> +
> +	memcpy(&early_res[i], &early_res[i + 1],
> +	       (j - 1 - i) * sizeof(struct early_res));

nit: memcpy() shouldn't be used for overlapping copies.  It happens to be
OK (for dst<src) in the kernel implementations.  We hope.

> +	early_res[j - 1].end = 0;
> +}
> +

> +static ssize_t
> +setup_data_read(struct file *file, char __user *user_buf, size_t count,
> +		loff_t *ppos)
> +{
> +	struct setup_data_node *node = file->private_data;
> +	unsigned long remain;
> +	loff_t pos = *ppos;
> +	struct page *pg;
> +	void *p;
> +	u64 pa;
> +
> +	if (pos < 0)
> +		return -EINVAL;
> +	if (pos >= node->len)
> +		return 0;
> +
> +	if (count > node->len - pos)
> +		count = node->len - pos;
> +	pa = node->paddr + sizeof(struct setup_data) + pos;
> +	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
> +	if (PageHighMem(pg)) {
> +		p = ioremap_cache(pa, count);
> +		if (!p)
> +			return -ENXIO;
> +	} else {
> +		p = __va(pa);
> +	}
> +
> +	remain = copy_to_user(user_buf, p, count);
> +
> +	if (PageHighMem(pg))
> +		iounmap(p);
> +
> +	if (remain)
> +		return -EFAULT;
> +
> +	*ppos = pos + count;
> +
> +	return count;
> +}

nit2: a read() function should return the number of bytes copied, and
should advance the file pointer by that much.  This code fails to do this
when a partial copy_to_user() occurs.

But we've made that mistake in many places and it doesn't appear to matter.
