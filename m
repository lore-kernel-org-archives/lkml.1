Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbYIOSUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbYIOSUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYIOSU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:20:26 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:19832 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbYIOSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=PDJ7mfAGaey9dNDNRBOzaqFuZ+Y5t853MvNKlrDJJ6fDnghZf2gKflx0rFJpXuEBVh
         ApoECyRlAmCCMKPM5MZ2TEEw4gnP2dQwk1wWZiefYeT7hF1a3Pe1y195ojvJrPCuqTNw
         TxVSucAC8mUvtgXINn6i7yHqXpwAMRloG6Cjk=
Message-ID: <84144f020809151120u36338574y4577fa73ea3d222f@mail.gmail.com>
Date: Mon, 15 Sep 2008 21:20:23 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 18/27] nilfs2: pathname operations
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1221419304-18572-19-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-13-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-14-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-15-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-16-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-17-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-18-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1221419304-18572-19-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Google-Sender-Auth: c7295c0c3f49ff9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryusuke,

On Sun, Sep 14, 2008 at 10:08 PM, Ryusuke Konishi
<konishi.ryusuke@lab.ntt.co.jp> wrote:
> This adds pathname operations, most of which comes from the ext2 file
> system.
>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> +/*
> + * By the time this is called, we already have created
> + * the directory cache entry for the new file, but it
> + * is so far negative - it has no inode.
> + *
> + * If the create succeeds, we fill in the inode information
> + * with d_instantiate().
> + */
> +static int nilfs_create(struct inode *dir, struct dentry *dentry, int mode,
> +                       struct nameidata *nd)
> +{
> +       struct inode *inode;
> +       struct nilfs_transaction_info ti;
> +       int err, err2;
> +
> +       err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
> +       if (err)
> +               return err;
> +       inode = nilfs_new_inode(dir, mode);
> +       err = PTR_ERR(inode);
> +       if (!IS_ERR(inode)) {
> +               inode->i_op = &nilfs_file_inode_operations;
> +               inode->i_fop = &nilfs_file_operations;
> +               inode->i_mapping->a_ops = &nilfs_aops;
> +               mark_inode_dirty(inode);
> +               err = nilfs_add_nondir(dentry, inode);
> +       }
> +       err2 = nilfs_transaction_end(dir->i_sb, !err);

OK, I don't understand this. The only way nilfs_transaction_end() can
fail is if we have NILFS_TI_SYNC set and we fail to construct the
segment. But why do we want to construct a segment if we don't commit?

I guess what I'm asking is why don't we have a separate
nilfs_transaction_abort() function that can't fail for the erroneous
case to avoid this double error value tracking thing?

                      Pekka
