Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbYLKUe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbYLKUe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbYLKUet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:34:49 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:44403 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbYLKUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=r5djmk3TykhAJ/GO+ZjUxu1jJ4nvkJHsadYfQtV5P4xn35e+Fc23ajKGjvVXXR7SLp
         +fP5pAUdADc/cJdmLdWjNTuyS+ccgtPDRjlGkm6EZXP1t+JRnhPfw7Ymke5vUBIcmsNh
         AyavdUX289BzLI9VpXu5P72xElsO/WgCezBiU=
Message-ID: <e9e943910812111234h3e2bbc1bh934a6605f30b5fea@mail.gmail.com>
Date: Thu, 11 Dec 2008 20:34:46 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] JFS: ensure link targets are NULL-terminated
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Boaz Harrosh" <bharrosh@panasas.com>,
       Dave.Kleikamp.shaggy@austin.ibm.com,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <1229025971.9245.18.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-2-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-3-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-4-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-5-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-6-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-7-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-8-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-9-git-send-email-duaneg@dghda.com>
	 <1229025971.9245.18.camel@norville.austin.ibm.com>
X-Google-Sender-Auth: a103fb40bef59884
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/11 Dave Kleikamp <shaggy@linux.vnet.ibm.com>:
> Thanks.
>
> I came up with an alternate patch that I like slightly better.  This one
> null-terminates the string when the inode is read rather than every time
> the link is followed, and at the proper place (i_size).  It's not a big
> deal, since the symlink will be corrupted either way.  What do you think
> of this patch?
>
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>
> diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
> index 2103397..b00ee9f 100644
> --- a/fs/jfs/inode.c
> +++ b/fs/jfs/inode.c
> @@ -59,8 +59,14 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
>                if (inode->i_size >= IDATASIZE) {
>                        inode->i_op = &page_symlink_inode_operations;
>                        inode->i_mapping->a_ops = &jfs_aops;
> -               } else
> +               } else {
>                        inode->i_op = &jfs_symlink_inode_operations;
> +                       /*
> +                        * The inline data should be null-terminated, but
> +                        * don't let on-disk corruption crash the kernel
> +                        */
> +                       JFS_IP(inode)->i_inline[inode->i_size] = '\0';
> +               }
>        } else {
>                inode->i_op = &jfs_file_inode_operations;
>                init_special_inode(inode, inode->i_mode, inode->i_rdev);

Yes, I prefer your version too :)

I'll rework the other patches similarly, where appropriate. Thanks!

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
