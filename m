Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXGMFZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXGMFZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXGMFZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:25:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36702 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbXGMFZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:25:46 -0400
Date: Thu, 12 Jul 2007 22:24:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: YOSHIFUJI Hideaki / =?UTF-8?B?5ZCJ6Jek6Iux5piO?= 
	<yoshfuji@linux-ipv6.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: sysfs: release mutex when kmalloc() failed in
 sysfs_open_file().
Message-Id: <20070712222452.8f14a7db.akpm@linux-foundation.org>
In-Reply-To: <20070710.135646.84167888.yoshfuji@linux-ipv6.org>
References: <20070710.135646.84167888.yoshfuji@linux-ipv6.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 13:56:46 +0900 (JST) YOSHIFUJI Hideaki / 吉藤英明  <yoshfuji@linux-ipv6.org> wrote:

> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index b502c71..1f64ce5 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -283,6 +283,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
>  	mutex_lock(&inode->i_mutex);
>  	if (!(set = inode->i_private)) {
>  		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL))) {
> +			mutex_unlock(&inode->i_mutex);
>  			error = -ENOMEM;
>  			goto Done;
>  		} else {

All this code is totally different in Greg's development tree, so this
fix really is only applicable to 2.6.22.x.

I suppose we could apply this to -stable, but given GFP_KERNEL's present behaviour
for small allocations it's pretty theoretical.

Unless you've enabled fault-injection in the page allocator, or if you get
oom-killed in that allocation.  In which case your kernel is dead.

So hm, perhaps you'd best send this to stable@kernel.org.
