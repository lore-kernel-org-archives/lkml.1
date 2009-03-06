Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZCFNpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZCFNpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZCFNpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:45:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:52830 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZCFNpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:45:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dicYqeQyOqIEyVSxIO618AVtEEdWjKmJwBHCJfudICT3F+WwchCdgSigvkgmeYKWck
         mQ0XIAgGjqzhBrTtP9CnUpIuuJzG5fp46ElQ4TKsmW4DkW2U5OC4zbtsD0ayODkrm/BQ
         Hjo6TJpOyATAI+Vn88Hc70BtRW4I71xQhaVNk=
Date: Fri, 6 Mar 2009 14:45:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 07/18] dma-debug: add debugfs interface
Message-ID: <20090306134527.GD5988@nowhere>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-8-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236346229-6618-8-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 02:30:18PM +0100, Joerg Roedel wrote:
> Impact: add debugfs interface for configuring DMA-API debugging
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 78 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 2ede463..20d6cdb 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -19,6 +19,7 @@
>  
>  #include <linux/dma-debug.h>
>  #include <linux/spinlock.h>
> +#include <linux/debugfs.h>
>  #include <linux/types.h>
>  #include <linux/list.h>
>  #include <linux/slab.h>
> @@ -61,12 +62,29 @@ static DEFINE_SPINLOCK(free_entries_lock);
>  /* Global disable flag - will be set in case of an error */
>  static bool global_disable __read_mostly;
>  
> +/* Global error count */
> +static u32 error_count;
> +
> +/* Global error show enable*/
> +static u32 show_all_errors __read_mostly;
> +/* Number of errors to show */
> +static u32 show_num_errors = 1;
> +
>  static u32 num_free_entries;
>  static u32 min_free_entries;
>  
>  /* number of preallocated entries requested by kernel cmdline */
>  static u32 req_entries;
>  
> +/* debugfs dentry's for the stuff above */
> +static struct dentry *dma_debug_dent        __read_mostly;
> +static struct dentry *global_disable_dent   __read_mostly;
> +static struct dentry *error_count_dent      __read_mostly;
> +static struct dentry *show_all_errors_dent  __read_mostly;
> +static struct dentry *show_num_errors_dent  __read_mostly;
> +static struct dentry *num_free_entries_dent __read_mostly;
> +static struct dentry *min_free_entries_dent __read_mostly;
> +
>  /*
>   * Hash related functions
>   *
> @@ -241,6 +259,58 @@ out_err:
>  	return -ENOMEM;
>  }
>  
> +static int dma_debug_fs_init(void)
> +{
> +	dma_debug_dent = debugfs_create_dir("dma-api", NULL);
> +	if (!dma_debug_dent) {
> +		printk(KERN_ERR "DMA-API: can not create debugfs directory\n");
> +		return -ENOMEM;
> +	}
> +
> +	global_disable_dent = debugfs_create_bool("disabled", 0444,
> +			dma_debug_dent,
> +			(u32 *)&global_disable);
> +	if (!global_disable_dent)
> +		goto out_err;
> +
> +	error_count_dent = debugfs_create_u32("error_count", 0444,
> +			dma_debug_dent, &error_count);
> +	if (!error_count_dent)
> +		goto out_err;
> +
> +	show_all_errors_dent = debugfs_create_u32("all_errors", 0644,
> +			dma_debug_dent,
> +			&show_all_errors);
> +	if (!show_all_errors_dent)
> +		goto out_err;
> +
> +	show_num_errors_dent = debugfs_create_u32("num_errors", 0644,
> +			dma_debug_dent,
> +			&show_num_errors);
> +	if (!show_num_errors_dent)
> +		goto out_err;
> +
> +	num_free_entries_dent = debugfs_create_u32("num_free_entries", 0444,
> +			dma_debug_dent,
> +			&num_free_entries);
> +	if (!num_free_entries_dent)
> +		goto out_err;
> +
> +	min_free_entries_dent = debugfs_create_u32("min_free_entries", 0444,
> +			dma_debug_dent,
> +			&min_free_entries);
> +	if (!min_free_entries_dent)
> +		goto out_err;


Hi,

At least for the read-only files, why not create a single file
which displays num_free_entries, min_free_entries and global disable?


> +
> +	return 0;
> +
> +out_err:
> +	debugfs_remove_recursive(dma_debug_dent);
> +
> +	return -ENOMEM;
> +}
> +
> +
>  /*
>   * Let the architectures decide how many entries should be preallocated.
>   */
> @@ -256,6 +326,14 @@ void dma_debug_init(u32 num_entries)
>  		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
>  	}
>  
> +	if (dma_debug_fs_init() != 0) {
> +		printk(KERN_ERR "DMA-API: error creating debugfs entries "
> +				"- disabling\n");
> +		global_disable = true;
> +
> +		return;
> +	}
> +
>  	if (req_entries)
>  		num_entries = req_entries;
>  
> -- 
> 1.5.6.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

