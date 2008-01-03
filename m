Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYACOKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYACOKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYACOKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:10:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37143 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYACOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:10:35 -0500
Date: Thu, 3 Jan 2008 14:10:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080103141033.GT27894@ZenIV.linux.org.uk>
References: <477CE1E0.4010504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477CE1E0.4010504@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 02:23:44PM +0100, Jiri Slaby wrote:

> ISOFS: unable to read i-node block

isofs_read_inode() failing, about to do make_bad_inode()

> Unable to handle kernel NULL pointer dereference at 00000000000000ad RIP:
>  [<ffffffff802a679f>] d_splice_alias+0x1f/0x100

struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
{
        struct dentry *new = NULL;

        if (inode && S_ISDIR(inode->i_mode)) {
	                     ^^^^^^^^^^^^^

> RIP: 0010:[<ffffffff802a679f>]  [<ffffffff802a679f>] d_splice_alias+0x1f/0x100
> RSP: 0000:ffff810061543b08  EFLAGS: 00010282
> RAX: 00000000ffffffff RBX: fffffffffffffffb RCX: ffffffff880d3454
> RDX: ffff810048542750 RSI: ffff81005e114e10 RDI: fffffffffffffffb

with inode equal to (struct inode *)-5.  Which is ERR_PTR(-EIO)...

>  [<ffffffff880d2395>] :isofs:isofs_lookup+0x395/0x4a0

        inode = NULL;
        if (found) {
                inode = isofs_iget(dir->i_sb, block, offset);
                if (!inode) {
                        unlock_kernel();
                        return ERR_PTR(-EACCES);
                }
        }
        unlock_kernel();
        return d_splice_alias(inode, dentry);

So we've got ERR_PTR(-EIO) from isofs_iget().  Bloody odd, seeing that
isofs_iget() either explicitly returns NULL or does

        if (inode && (inode->i_state & I_NEW)) {
                sb->s_op->read_inode(inode);
                unlock_new_inode(inode);
        }

        return inode;

which would not manage to return ERR_PTR(-EIO), no matter what - it would
die on access to inode->i_state.  I don't have -mm tree at hand, check if
there's anything affected in these areas.  Perhaps somebody tried to pass
error values from isofs_iget() and forgot to update callers?
