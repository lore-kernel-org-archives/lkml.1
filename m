Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZLAERx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZLAERx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZLAERv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:17:51 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51178 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZLAERq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:17:46 -0500
Date: Mon, 30 Nov 2009 23:17:23 -0500
Message-Id: <200912010417.nB14HN2N030489@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 33/41] fallthru: jffs2 fallthru support 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:31 PDT."
             <1256152779-10054-34-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-34-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> Add support for fallthru dentries to jffs2.
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/jffs2/dir.c        |   31 ++++++++++++++++++++++++++++++-
>  include/linux/jffs2.h |    6 ++++++
>  2 files changed, 36 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
> index 46a2e1b..544d6c5 100644
> --- a/fs/jffs2/dir.c
> +++ b/fs/jffs2/dir.c
> @@ -35,6 +35,7 @@ static int jffs2_rename (struct inode *, struct dentry *,
>  			 struct inode *, struct dentry *);
>  
>  static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
> +static int jffs2_fallthru (struct inode *, struct dentry *);
>  
>  const struct file_operations jffs2_dir_operations =
>  {
> @@ -57,6 +58,7 @@ const struct inode_operations jffs2_dir_inode_operations =
>  	.rmdir =	jffs2_rmdir,
>  	.mknod =	jffs2_mknod,
>  	.rename =	jffs2_rename,
> +	.fallthru =     jffs2_fallthru,
>  	.whiteout =     jffs2_whiteout,
>  	.permission =	jffs2_permission,
>  	.setattr =	jffs2_setattr,
> @@ -107,6 +109,9 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
>  		case DT_WHT:
>  			target->d_flags |= DCACHE_WHITEOUT;
>  			break;
> +		case JFFS2_DT_FALLTHRU:
> +			target->d_flags |= DCACHE_FALLTHRU;
> +			break;
>  		default:
>  			ino = fd->ino;
>  			break;
> @@ -168,7 +173,10 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
>  				  fd->name, fd->ino, fd->type, curofs, offset));
>  			continue;
>  		}
> -		if (!fd->ino) {
> +		if (fd->type == JFFS2_DT_FALLTHRU)
> +			/* XXX Should really do a lookup for the real inode number here */
> +			fd->ino = 100;

In the ext2 patch, it was ino=123, here it's 100.  Is there a consistently
useful reserved number to use instead, for jffs2 as well?  If not, maybe at
least we can pick one random inode number and use it for all default inode
numbers for ext2, jffs2, etc.?

> +		else if (!fd->ino && (fd->type != DT_WHT)) {
>  			D2(printk(KERN_DEBUG "Skipping deletion dirent \"%s\"\n", fd->name));
>  			offset++;
>  			continue;
> @@ -797,6 +805,26 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, int mode, de
>  	return 0;
>  }
>  
> +static int jffs2_fallthru (struct inode *dir, struct dentry *dentry)
> +{
> +	struct jffs2_sb_info *c = JFFS2_SB_INFO(dir->i_sb);
> +	uint32_t now;
> +	int ret;
> +
> +	now = get_seconds();
> +	ret = jffs2_do_link(c, JFFS2_INODE_INFO(dir), 0, DT_UNKNOWN,
> +			    dentry->d_name.name, dentry->d_name.len, now);
> +	if (ret)
> +		return ret;
> +
> +	d_instantiate(dentry, NULL);
> +	spin_lock(&dentry->d_lock);
> +	dentry->d_flags |= DCACHE_FALLTHRU;
> +	spin_unlock(&dentry->d_lock);
> +
> +	return 0;
> +}
> +
>  static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
>  			   struct dentry *new_dentry)
>  {
> @@ -830,6 +858,7 @@ static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
>  		return ret;
>  
>  	spin_lock(&new_dentry->d_lock);
> +	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
>  	new_dentry->d_flags |= DCACHE_WHITEOUT;
>  	spin_unlock(&new_dentry->d_lock);
>  	d_add(new_dentry, NULL);
> diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
> index 65533bb..dbe8c93 100644
> --- a/include/linux/jffs2.h
> +++ b/include/linux/jffs2.h
> @@ -114,6 +114,12 @@ struct jffs2_unknown_node
>  	jint32_t hdr_crc;
>  };
>  
> +/*
> + * Non-standard directory entry type(s), for on-disk use
> + */
> +
> +#define                JFFS2_DT_FALLTHRU       (DT_WHT + 1)
> +
>  struct jffs2_raw_dirent
>  {
>  	jint16_t magic;
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.

