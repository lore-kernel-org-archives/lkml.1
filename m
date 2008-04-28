Return-Path: <linux-kernel-owner+w=401wt.eu-S932676AbYD1Hvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbYD1Hvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763172AbYD1Hvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:51:41 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56800 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbYD1Hvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:51:41 -0400
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080427192617.ae8190e3.akpm@linux-foundation.org> (message from
	Andrew Morton on Sun, 27 Apr 2008 19:26:17 -0700)
Subject: Re: [patch 3/5] fuse: fix race in llseek
References: <20080425175520.735386844@szeredi.hu>
	<20080425175657.912755144@szeredi.hu> <20080427192617.ae8190e3.akpm@linux-foundation.org>
Message-Id: <E1JqO9C-0003zM-E2@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Apr 2008 09:51:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
> > +{
> > +	long long retval;
> 
> I switched this to have a type of loff_t.

Ugh, right.  I wonder where that long long came from.  I probably
copied the generic_file_llseek() from some earlier kernel...

> 
> > +	struct inode *inode = file->f_path.dentry->d_inode;
> > +
> > +	mutex_lock(&inode->i_mutex);
> > +	switch (origin) {
> > +	case SEEK_END:
> > +		offset += i_size_read(inode);
> 
> As we hold i_mutex we could directly read inode->i_size here, save a few
> cycles.

No, that's the whole point of the fuse specific function: fuse doesn't
use i_mutex to protect writing i_size, instead it uses a per
filesystem spinlock.

This is probably worth a comment though, so I'll do that.

Thanks,
Miklos
