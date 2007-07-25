Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXGYEhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXGYEhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXGYEhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:37:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57508 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbXGYEhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:37:46 -0400
Date: Wed, 25 Jul 2007 05:37:44 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: rae l <crquan@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC] fs/super.c: Why alloc_super use a static variable default_op?
Message-ID: <20070725043744.GB27237@ftp.linux.org.uk>
References: <91b13c310707242048lb54b071u5e7fc4272b142475@mail.gmail.com> <20070725041407.GA27237@ftp.linux.org.uk> <91b13c310707242129u6aa09166j74ad42d31adc4ad7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310707242129u6aa09166j74ad42d31adc4ad7@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 12:29:17PM +0800, rae l wrote:
> But is it valuable? Compared to a waste of sizeof(struct super_block)
> bytes memory.

It's less that struct super_block, actually.

> When some code want to refer fs_type->s_op, it almost always want to
> refer some function pointer in s_op with fs_type->s_op->***, but all
> pointers in default_op are all NULLs, what about this scenario?

Yes, and?  You still need one test instead of two.  Which gets you
more than 21 words used by that sucker, only in .text instead of .bss.
 
> and if you do grep s_op in the source code, you will found nowhere
> will want to test s_op or dependent on s_op not NULL.

What?  fs/inode.c:
        if (sb->s_op->alloc_inode)
                inode = sb->s_op->alloc_inode(sb);
        else
                inode = (struct inode *) kmem_cache_alloc(inode_cachep, GFP_KERNEL);
and the same goes everywhere else.  Of course we don't check for
sb->s_op not being NULL - that's exactly why we are safe skipping such
tests.
