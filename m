Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXKJGyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXKJGyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 01:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXKJGyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 01:54:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:48838 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXKJGyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 01:54:38 -0500
Message-ID: <7e0fb38c0711092254v19678f41vf91d5c2c6fa96991@mail.gmail.com>
Date: Sat, 10 Nov 2007 01:54:36 -0500
From: "Eric Paris" <eparis@parisplace.org>
To: casey@schaufler-ca.com
Subject: Re: [PATCH 2/2] Version 11 (2.6.24-rc2) Smack: Simplified Mandatory Access Control Kernel
Cc: akpm@osdl.org, torvalds@osdl.org, method@manicmethod.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4733E6B4.8010108@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4733E6B4.8010108@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[snip from fs/super.c:vfs_kern_mount() just for reference]
        if (data) {
                secdata = alloc_secdata();
                if (!secdata)
                        goto out_mnt;

                error = security_sb_copy_data(type, data, secdata);
                if (error)
                        goto out_free_secdata;
        }

        error = type->get_sb(type, flags, name, data, mnt);
        if (error < 0)
                goto out_free_secdata;
        BUG_ON(!mnt->mnt_sb);

        error = security_sb_kern_mount(mnt->mnt_sb, secdata);
        if (error)
                goto out_sb;
[end snip]

> +/**
> + * smack_sb_copy_data - copy mount options data for processing
> + * @type: file system type
> + * @orig: where to start
> + * @smackopts
> + *
> + * Returns 0 on success or -ENOMEM on error.
> + *
> + * Copy the Smack specific mount options out of the mount
> + * options list.
> + */
> +static int smack_sb_copy_data(struct file_system_type *type, void *orig,
> +                             void *smackopts)
> +{
> +       char *cp, *commap, *otheropts, *dp;
> +
> +       /* Binary mount data: just copy */
> +       if (type->fs_flags & FS_BINARY_MOUNTDATA) {
> +               copy_page(smackopts, orig);
> +               return 0;
> +       }

So given NFS, which may have passed you a nfs_mount_data,
nfs_parsed_mount_data, or a nfs_clone_mount struct one page is going
to get coppied back out to the VFS.
> +
> +       otheropts = (char *)get_zeroed_page(GFP_KERNEL);
> +       if (otheropts == NULL)
> +               return -ENOMEM;
> +
> +       for (cp = orig, commap = orig; commap != NULL; cp = commap + 1) {
> +               if (strstr(cp, SMK_FSDEFAULT) == cp)
> +                       dp = smackopts;
> +               else if (strstr(cp, SMK_FSFLOOR) == cp)
> +                       dp = smackopts;
> +               else if (strstr(cp, SMK_FSHAT) == cp)
> +                       dp = smackopts;
> +               else if (strstr(cp, SMK_FSROOT) == cp)
> +                       dp = smackopts;
> +               else
> +                       dp = otheropts;
> +
> +               commap = strchr(cp, ',');
> +               if (commap != NULL)
> +                       *commap = '\0';
> +
> +               if (*dp != '\0')
> +                       strcat(dp, ",");
> +               strcat(dp, cp);
> +       }
> +
> +       strcpy(orig, otheropts);
> +       free_page((unsigned long)otheropts);
> +
> +       return 0;
> +}
> +
> +/**
> + * smack_sb_kern_mount - Smack specific mount processing
> + * @sb: the file system superblock
> + * @data: the smack mount options
> + *
> + * Returns 0 on success, an error code on failure
> + */
> +static int smack_sb_kern_mount(struct super_block *sb, void *data)
> +{
> +       struct dentry *root = sb->s_root;
> +       struct inode *inode = root->d_inode;
> +       struct superblock_smack *sp = sb->s_security;
> +       struct inode_smack *isp;
> +       char *op;
> +       char *commap;
> +       char *nsp;
> +
> +       spin_lock(&sp->smk_sblock);
> +       if (sp->smk_initialized != 0) {
> +               spin_unlock(&sp->smk_sblock);
> +               return 0;
> +       }
> +       sp->smk_initialized = 1;
> +       spin_unlock(&sp->smk_sblock);
> +
> +       for (op = data; op != NULL; op = commap) {

Here you walk this page of binary NFS data looking for your stuff.
And while I assume its unlikely you find anything you like on this
page and go wrong, its not impossible.

SELinux tried to solve this problem right here in its equivalent
function years ago, but it has since been despised by the FS people
and now i'm trying to make everyone happy.  I'd love you comment on
how you plan to support NFS and other filesystems which use
FS_BINARY_MOUNTDATA)

> +               commap = strchr(op, ',');
> +               if (commap != NULL)
> +                       *commap++ = '\0';
> +
> +               if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
> +                       op += strlen(SMK_FSHAT);
> +                       nsp = smk_import(op, 0);
> +                       if (nsp != NULL)
> +                               sp->smk_hat = nsp;
> +               } else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
> +                       op += strlen(SMK_FSFLOOR);
> +                       nsp = smk_import(op, 0);
> +                       if (nsp != NULL)
> +                               sp->smk_floor = nsp;
> +               } else if (strncmp(op, SMK_FSDEFAULT,
> +                                  strlen(SMK_FSDEFAULT)) == 0) {
> +                       op += strlen(SMK_FSDEFAULT);
> +                       nsp = smk_import(op, 0);
> +                       if (nsp != NULL)
> +                               sp->smk_default = nsp;
> +               } else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
> +                       op += strlen(SMK_FSROOT);
> +                       nsp = smk_import(op, 0);
> +                       if (nsp != NULL)
> +                               sp->smk_root = nsp;
> +               }
> +       }
> +
> +       /*
> +        * Initialize the root inode.
> +        */
> +       isp = inode->i_security;
> +       if (isp == NULL)
> +               inode->i_security = new_inode_smack(sp->smk_root);
> +       else
> +               isp->smk_inode = sp->smk_root;
> +
> +       return 0;
> +}
> +
