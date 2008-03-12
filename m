Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbYCLWoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbYCLWoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYCLWod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:44:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbYCLWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:44:32 -0400
Date: Wed, 12 Mar 2008 15:43:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mangoo@wpkg.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       balajirrao@gmail.com, Neil Brown <neilb@suse.de>
Subject: Re: sysfs Kernel BUG when RAID bitmap file has IO errors
Message-Id: <20080312154358.e9d16668.akpm@linux-foundation.org>
In-Reply-To: <20080312153618.b3e0612a.akpm@linux-foundation.org>
References: <47D7A502.6020701@wpkg.org>
	<47D7A7AA.8000302@wpkg.org>
	<20080312153618.b3e0612a.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 15:36:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I assume this is the BUG_ON(count >= (ssize_t)PAGE_SIZE) in
> fill_read_buffer().
> 
> This was reported recently and we prepared a debug patch but the
> reporter was unable to trigger the bug again.
> 
> Please add the below and retest?

err, don't bother.

	rdev->sb_size = MD_SB_BYTES;

...

#define MD_SB_BYTES			4096

...

and

	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
	bmask = queue_hardsect_size(rdev->bdev->bd_disk->queue)-1;
	if (rdev->sb_size & bmask)
		rdev->sb_size = (rdev->sb_size | bmask) + 1;

I'm assuming that either the above sequence of code never ran at all, or it
produced sb_size >= PAGE_SIZE.

then this:

static ssize_t
super_show(mdk_rdev_t *rdev, char *page)
{
	if (rdev->sb_loaded && rdev->sb_size) {
		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
		return rdev->sb_size;
	} else
		return 0;
}

returns something >= PAGE_SIZE then this:

static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
{
	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
	struct sysfs_ops * ops = buffer->ops;
	int ret = 0;
	ssize_t count;

	if (!buffer->page)
		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
	if (!buffer->page)
		return -ENOMEM;

	/* need attr_sd for attr and ops, its parent for kobj */
	if (!sysfs_get_active_two(attr_sd))
		return -ENODEV;

	buffer->event = atomic_read(&attr_sd->s_attr.open->event);
	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);

	sysfs_put_active_two(attr_sd);

	/*
	 * The code works fine with PAGE_SIZE return but it's likely to
	 * indicate truncated result or overflow in normal use cases.
	 */
	BUG_ON(count >= (ssize_t)PAGE_SIZE);

declares game over.

Neil, pls fix?
