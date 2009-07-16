Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbZGPUPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbZGPUPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933233AbZGPUPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:15:03 -0400
Received: from fieldses.org ([174.143.236.118]:33240 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193AbZGPUPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:15:02 -0400
X-Greylist: delayed 2827 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2009 16:15:02 EDT
Date: Thu, 16 Jul 2009 15:27:55 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/20] ceph: nfs re-export support
Message-ID: <20090716192755.GE2495@fieldses.org>
References: <1247693090-27796-8-git-send-email-sage@newdream.net> <1247693090-27796-9-git-send-email-sage@newdream.net> <1247693090-27796-10-git-send-email-sage@newdream.net> <1247693090-27796-11-git-send-email-sage@newdream.net> <1247693090-27796-12-git-send-email-sage@newdream.net> <1247693090-27796-13-git-send-email-sage@newdream.net> <1247693090-27796-14-git-send-email-sage@newdream.net> <1247693090-27796-15-git-send-email-sage@newdream.net> <1247693090-27796-16-git-send-email-sage@newdream.net> <1247693090-27796-17-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247693090-27796-17-git-send-email-sage@newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 02:24:46PM -0700, Sage Weil wrote:
> Basic NFS re-export support is included.  This mostly works.  However,
> Ceph's MDS design precludes the ability to generate a (small)
> filehandle that will be valid forever, so this is of limited utility.

Is there any hope of fixing that?

--b.

> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/ceph/export.c |  155 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 155 insertions(+), 0 deletions(-)
>  create mode 100644 fs/ceph/export.c
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> new file mode 100644
> index 0000000..6ec1629
> --- /dev/null
> +++ b/fs/ceph/export.c
> @@ -0,0 +1,155 @@
> +#include <linux/exportfs.h>
> +#include <asm/unaligned.h>
> +
> +#include "super.h"
> +#include "ceph_debug.h"
> +
> +int ceph_debug_export __read_mostly = -1;
> +#define DOUT_MASK DOUT_MASK_EXPORT
> +#define DOUT_VAR ceph_debug_export
> +
> +/*
> + * fh is N tuples of
> + *  <ino, parent's d_name.hash>
> + *
> + * This is only a semi-reliable strategy.  The fundamental issue is
> + * that ceph doesn't not have a way to locate an arbitrary inode by
> + * ino.  Keeping a few parents in the handle increases the probability
> + * that we'll find it in one of the MDS caches, but it is by no means
> + * a guarantee.
> + *
> + * Also, the FINDINODE request is currently directed at a single MDS.
> + * It should probably try all MDS's before giving up.  For a single MDS
> + * system that isn't a problem.
> + *
> + * In the meantime, this works reasonably well for basic usage.
> + */
> +
> +
> +struct ceph_export_item {
> +	struct ceph_vino ino;
> +	struct ceph_vino parent_ino;
> +	u32 parent_name_hash;
> +} __attribute__ ((packed));
> +
> +#define IPSZ ((sizeof(struct ceph_export_item) + sizeof(u32) + 1) / sizeof(u32))
> +
> +static int ceph_encode_fh(struct dentry *dentry, u32 *rawfh, int *max_len,
> +		   int connectable)
> +{
> +	int type = 1;
> +	struct ceph_export_item *fh =
> +		(struct ceph_export_item *)rawfh;
> +	int max = *max_len / IPSZ;
> +	int len;
> +	struct dentry *d_parent;
> +
> +	dout(10, "encode_fh %p max_len %d u32s (%d export items)%s\n", dentry,
> +	     *max_len, max, connectable ? " connectable" : "");
> +
> +	if (max < 1 || (connectable && max < 2))
> +		return -ENOSPC;
> +
> +	for (len = 0; len < max; len++) {
> +		d_parent = dentry->d_parent;
> +		fh[len].ino = ceph_vino(dentry->d_inode);
> +		fh[len].parent_ino = ceph_vino(d_parent->d_inode);
> +		fh[len].parent_name_hash = dentry->d_parent->d_name.hash;
> +
> +		if (IS_ROOT(dentry))
> +			break;
> +
> +		dentry = dentry->d_parent;
> +
> +		if (!dentry)
> +			break;
> +	}
> +
> +	if (len > 1)
> +		type = 2;
> +
> +	*max_len = len * IPSZ;
> +	return type;
> +}
> +
> +static struct dentry *__fh_to_dentry(struct super_block *sb,
> +			      struct ceph_export_item *fh, int len)
> +{
> +	struct ceph_mds_client *mdsc = &ceph_client(sb)->mdsc;
> +	struct inode *inode;
> +	struct dentry *dentry;
> +	int err;
> +#define BUF_SIZE 16
> +	char path2[BUF_SIZE];
> +	u32 hash = fh->parent_name_hash;
> +
> +	inode = ceph_find_inode(sb, fh->ino);
> +	if (!inode) {
> +		struct ceph_mds_request *req;
> +		derr(10, "fh_to_dentry %llx.%x -- no inode\n", fh->ino.ino,
> +		     hash);
> +		req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPHASH,
> +					       USE_ANY_MDS);
> +		if (IS_ERR(req))
> +			return ERR_PTR(PTR_ERR(req));
> +
> +		req->r_ino1 = fh->ino;
> +		snprintf(path2, BUF_SIZE, "%d", hash);
> +		req->r_ino2 = fh->parent_ino;
> +		req->r_num_caps = 1;
> +		err = ceph_mdsc_do_request(mdsc, NULL, req);
> +		ceph_mdsc_put_request(req);
> +		inode = ceph_find_inode(sb, fh->ino);
> +		if (!inode)
> +			return ERR_PTR(err ? err : -ESTALE);
> +	}
> +
> +	dentry = d_obtain_alias(inode);
> +
> +	if (!dentry) {
> +		derr(10, "fh_to_dentry %llx.%x -- inode %p but ENOMEM\n",
> +		     fh->ino.ino,
> +		     hash, inode);
> +		iput(inode);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	err = ceph_init_dentry(dentry);
> +
> +	if (err < 0) {
> +		iput(inode);
> +		return ERR_PTR(err);
> +	}
> +	dout(10, "fh_to_dentry %llx.%x -- inode %p dentry %p\n", fh->ino.ino,
> +	     hash, inode, dentry);
> +	return dentry;
> +
> +}
> +
> +static struct dentry *ceph_fh_to_dentry(struct super_block *sb, struct fid *fid,
> +				 int fh_len, int fh_type)
> +{
> +	u32 *fh = fid->raw;
> +	return __fh_to_dentry(sb, (struct ceph_export_item *)fh, fh_len/IPSZ);
> +}
> +
> +static struct dentry *ceph_fh_to_parent(struct super_block *sb, struct fid *fid,
> +				 int fh_len, int fh_type)
> +{
> +	u32 *fh = fid->raw;
> +	u64 ino = get_unaligned((u64 *)fh);
> +	u32 hash = fh[2];
> +
> +	derr(10, "fh_to_parent %llx.%x\n", (unsigned long long)ino, hash);
> +
> +	if (fh_len < 6)
> +		return ERR_PTR(-ESTALE);
> +
> +	return __fh_to_dentry(sb, (struct ceph_export_item *)fh + 1,
> +			      fh_len/IPSZ - 1);
> +}
> +
> +const struct export_operations ceph_export_ops = {
> +	.encode_fh = ceph_encode_fh,
> +	.fh_to_dentry = ceph_fh_to_dentry,
> +	.fh_to_parent = ceph_fh_to_parent,
> +};
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
