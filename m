Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYCZW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYCZW01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYCZW0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:26:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53555 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYCZW0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:26:14 -0400
Date: Wed, 26 Mar 2008 22:25:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] vfs: mountinfo: add mount ID
Message-ID: <20080326222541.GT10722@ZenIV.linux.org.uk>
References: <20080326211131.705321084@szeredi.hu> <20080326212139.187837394@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326212139.187837394@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 10:11:34PM +0100, Miklos Szeredi wrote:
> +static int mnt_alloc_id(struct vfsmount *mnt)
> +{
> +	int res;
> +
> + retry:
> +	spin_lock(&vfsmount_lock);
> +	res = ida_get_new(&mnt_id_ida, &mnt->mnt_id);
> +	spin_unlock(&vfsmount_lock);
> +	if (res == -EAGAIN) {
> +		if (ida_pre_get(&mnt_id_ida, GFP_KERNEL))
> +			goto retry;
> +		res = -ENOMEM;
> +	}
> +	return res;

*Ugh*

Why bother with vfsmount_lock here?  All allocations are done under
namespace_sem.  Moreover, I'd rather replace that 'goto retry' with
a single call of ida_get_new(), since we are serialized anyway.

> @@ -353,6 +386,7 @@ EXPORT_SYMBOL(simple_set_mnt);
>  void free_vfsmnt(struct vfsmount *mnt)
>  {
>  	kfree(mnt->mnt_devname);
> +	mnt_free_id(mnt);
>  	kmem_cache_free(mnt_cache, mnt);
>  }

... and I'd rather do that earlier, e.g. in umount_tree().  At that point
we (a) have namespace_sem and (b) irrevocably kick the sucker out of
any namespace.

I'd rather minimize banging vfsmount_lock like that...
