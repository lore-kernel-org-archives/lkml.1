Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZFAWE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZFAWE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZFAWEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:04:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZFAWEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:04:48 -0400
Date: Mon, 1 Jun 2009 15:04:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com
Subject: Re: [PATCH 2/4] dma-debug: add debugfs file for driver filter
Message-Id: <20090601150418.79dfd250.akpm@linux-foundation.org>
In-Reply-To: <1243523971-12681-3-git-send-email-joerg.roedel@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
	<1243523971-12681-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 17:19:29 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds the dma-api/driver_filter file to debugfs. The root user
> can write a driver name into this file to see only dma-api errors for
> that particular driver in the kernel log. Writing an empty string to
> that file disables the driver filter.
> 
>
> ...
>
> +static ssize_t filter_read(struct file *file, char __user *user_buf,
> +			   size_t count, loff_t *ppos)
> +{
> +	unsigned long flags;
> +	char buf[NAME_MAX_LEN + 1];
> +	int len;
> +
> +	if (!current_driver_name[0])
> +		return 0;
> +
> +	/*
> +	 * We can't copy to userspace directly because current_driver_name can
> +	 * only be read under the driver_name_lock with irqs disabled. So
> +	 * create a temporary copy first.
> +	 */
> +	read_lock_irqsave(&driver_name_lock, flags);
> +	strncpy(buf, current_driver_name, NAME_MAX_LEN - 1);

If you use strlcpy() here,

> +	read_unlock_irqrestore(&driver_name_lock, flags);
> +
> +	/* make it look nice :-) */
> +	len = strnlen(buf, NAME_MAX_LEN - 1);
> +	buf[len]     = '\n';
> +	buf[len + 1] = 0;

the above can all be replaced with a simple strcat().  I think.

Perhaps the whole lot can be replaced with a single scnprintf(), if
it's known that the input string has appropriate length.

> +	return simple_read_from_buffer(user_buf, count, ppos, buf, len + 1);
> +}
> +
> +static ssize_t filter_write(struct file *file, const char __user *userbuf,
> +			    size_t count, loff_t *ppos)
> +{
> +	unsigned long flags;
> +	char buf[NAME_MAX_LEN];
> +	size_t len = NAME_MAX_LEN - 1;
> +	int i;
> +
> +	/*
> +	 * We can't copy from userspace directly. Access to
> +	 * current_driver_name is protected with a write_lock with irqs
> +	 * disabled. Since copy_from_user can fault and may sleep we
> +	 * need to copy to temporary buffer first
> +	 */
> +	len = min(count, len);
> +	if (copy_from_user(buf, userbuf, len))
> +		return -EFAULT;
> +
> +	buf[NAME_MAX_LEN - 1] = 0;

Might be able to use strncpy_from_user() here.

> +	write_lock_irqsave(&driver_name_lock, flags);
> +	if (!isalnum(buf[0])) {
> +		if (current_driver_name[0])
> +			printk(KERN_INFO "DMA-API: switching off dma-debug "
> +					 "driver filter\n");
> +		current_driver_name[0] = 0;
> +		current_driver = NULL;
> +		goto out_unlock;
> +	}
> +
> +	for (i = 0; i < NAME_MAX_LEN; ++i) {
> +		current_driver_name[i] = buf[i];
> +		if (isspace(buf[i]) || buf[i] == ' ' ||
> +		    buf[i] == '\t' || buf[i] == 0)
> +			break;
> +	}
> +	current_driver_name[i] = 0;
> +	current_driver = NULL;
> +
> +	printk(KERN_INFO "DMA-API: enable driver filter for driver [%s]\n",
> +	       current_driver_name);
> +
> +out_unlock:
> +	write_unlock_irqrestore(&driver_name_lock, flags);
> +
> +	return count;
> +}

It's unobvious what user interface this code is attempting to implement.
The change to DMA-API.txt in the fourth patch doesn't illuminate the
issue either. Some code comments explaining wtf this is doing and why
would help, please.

I'd have thought that the test for isspace() makes the tests for ' '
and '\t' redundant?


> +const struct file_operations filter_fops = {
> +	.read  = filter_read,
> +	.write = filter_write,
> +};
> +
>  static int dma_debug_fs_init(void)
>  {
>  	dma_debug_dent = debugfs_create_dir("dma-api", NULL);
> @@ -497,6 +581,11 @@ static int dma_debug_fs_init(void)
>  	if (!min_free_entries_dent)
>  		goto out_err;
>  
> +	filter_dent = debugfs_create_file("driver_filter", 0644,
> +					  dma_debug_dent, NULL, &filter_fops);
> +	if (!filter_dent)
> +		goto out_err;
> +
>  	return 0;
>  
>  out_err:

