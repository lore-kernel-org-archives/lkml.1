Return-Path: <linux-kernel-owner+w=401wt.eu-S1762787AbXGYFV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787AbXGYFV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbXGYFVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:21:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:4457 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbXGYFVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aIABQtLP3q+XuCuoT8pE16P8uL+04utbY8HeV8j7JCjccAyUuAwA3pO/TI4YkpG+akDecsEv3DPMiS9UxlFEv5HPPOfdhWMeQaIF0aL7CjhwjcZT+X5ck7jYJa9Ww6tuer3Zd4SQFzjJHYVHFbhMTL7SkaO+EOCv/zKVueHg9f8=
Message-ID: <91b13c310707242221g27178dacs433d16cdfb119851@mail.gmail.com>
Date: Wed, 25 Jul 2007 13:21:19 +0800
From: "rae l" <crquan@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [RFC] fs/super.c: Why alloc_super use a static variable default_op?
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20070725043744.GB27237@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310707242048lb54b071u5e7fc4272b142475@mail.gmail.com>
	 <20070725041407.GA27237@ftp.linux.org.uk>
	 <91b13c310707242129u6aa09166j74ad42d31adc4ad7@mail.gmail.com>
	 <20070725043744.GB27237@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Wed, Jul 25, 2007 at 12:29:17PM +0800, rae l wrote:
> > But is it valuable? Compared to a waste of sizeof(struct super_block)
> > bytes memory.
>
> It's less that struct super_block, actually.
>
> > When some code want to refer fs_type->s_op, it almost always want to
> > refer some function pointer in s_op with fs_type->s_op->***, but all
> > pointers in default_op are all NULLs, what about this scenario?
>
> Yes, and?  You still need one test instead of two.  Which gets you
> more than 21 words used by that sucker, only in .text instead of .bss.
>
> > and if you do grep s_op in the source code, you will found nowhere
> > will want to test s_op or dependent on s_op not NULL.
>
> What?  fs/inode.c:
>         if (sb->s_op->alloc_inode)
>                 inode = sb->s_op->alloc_inode(sb);
>         else
>                 inode = (struct inode *) kmem_cache_alloc(inode_cachep, GFP_KERNEL);
> and the same goes everywhere else.  Of course we don't check for
> sb->s_op not being NULL - that's exactly why we are safe skipping such
> tests.
Oh, Thank you.

But there are also many other subsystems will do
fs/dcache.c:
void dput(struct dentry *dentry)
	if (dentry->d_op && dentry->d_op->d_delete) {
Do you think it's worth optimizing it with a static d_op filled?

we can add a static variable to d_alloc and set its initial d_op to
this static variable?
struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)

>

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
