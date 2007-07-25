Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbXGYGkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbXGYGkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXGYGjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:39:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44864 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbXGYGjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:39:54 -0400
Date: Wed, 25 Jul 2007 07:39:53 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: rae l <crquan@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC] fs/super.c: Why alloc_super use a static variable default_op?
Message-ID: <20070725063953.GC27237@ftp.linux.org.uk>
References: <91b13c310707242048lb54b071u5e7fc4272b142475@mail.gmail.com> <20070725041407.GA27237@ftp.linux.org.uk> <91b13c310707242129u6aa09166j74ad42d31adc4ad7@mail.gmail.com> <20070725043744.GB27237@ftp.linux.org.uk> <91b13c310707242221g27178dacs433d16cdfb119851@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310707242221g27178dacs433d16cdfb119851@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 01:21:19PM +0800, rae l wrote:
 
> But there are also many other subsystems will do
> fs/dcache.c:
> void dput(struct dentry *dentry)
> 	if (dentry->d_op && dentry->d_op->d_delete) {
> Do you think it's worth optimizing it with a static d_op filled?
> 
> we can add a static variable to d_alloc and set its initial d_op to
> this static variable?
> struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)

Try and compare...  It really depends - I suspect that for dentries the
situation differs since the case of ->d_op == NULL is *common*.  So
these checks actually might be a win - we are not unlikely to bail out
on the first one, without hitting the contents of *dentry->d_op.

For superblocks and inodes that is different - if we go looking for a method,
we *are* going to hit the method table anyway; it's not going to be NULL in
anything resembling a normal case.  So having the pointer to table initialized
that way is an obvious win - we don't really lose on space (savings in .text
at least balance the loss in .bss), we win on simpler logics and we actually
win by skipping the useless test.

How well would that pay for dentries...  Hell knows.  Space-wise it's the
same story, but we might end up doing extra work at accesses.  Try it - it's
not a hard patch to write, after all.
