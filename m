Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXEaWh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXEaWh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXEaWhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:37:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826AbXEaWhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:37:46 -0400
Date: Thu, 31 May 2007 15:37:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in tty_io.c
Message-Id: <20070531153712.de2f8a68.akpm@linux-foundation.org>
In-Reply-To: <20070531134226.GO14284@traven>
References: <20070425154934.GP6798@traven>
	<20070425191359.GA13241@infradead.org>
	<20070425194633.GA3280@traven>
	<20070425194550.GA18914@infradead.org>
	<20070531134226.GO14284@traven>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 15:42:26 +0200
Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:

> drivers/char/tty_io.c: Use spinlock instead of a (binary) semaphore
> 

hm.

> 
> --
> 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index 7a32df5..ff27587 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c

We end up with this:

	/* find a device that is not in use. */
	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL))
		return -ENOMEM;

	spin_lock(&allocated_ptys_lock);

	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
	if (idr_ret < 0) {
		spin_unlock(&allocated_ptys_lock);
		if (idr_ret == -EAGAIN)
			return -ENOMEM;
		return -EIO;
	}
	if (index >= pty_limit) {
		idr_remove(&allocated_ptys, index);
		spin_unlock(&allocated_ptys_lock);
		return -EIO;
	}
	spin_unlock(&allocated_ptys_lock);

this leaves a small window in which another thread can come in and steal
away the idr tree's reserves, causing the idr_get_new() to fail.  It's
highly improbable, but it's real.

Hence I think a straight semaphore->mutex conversion would be better.

The IDR API absolutely blows chunks: it should require caller-provided
locking, like radix-tree.  But then it'd need gunk like radix_tree_preload
to be reliable.  Fact is, storage librares which need to allocate memory at
insert-time are always going to be problematic in-kernel.


