Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbZJFWTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbZJFWTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933644AbZJFWTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52266 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933655AbZJFWTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:19:38 -0400
Message-ID: <4ACBC24F.2040005@linux.vnet.ibm.com>
Date: Tue, 06 Oct 2009 17:18:55 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] ima: ecryptfs fix imbalance message (updated)
References: <1254767144-4756-1-git-send-email-zohar@linux.vnet.ibm.com>
In-Reply-To: <1254767144-4756-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Enigmail-Version: 0.97a
OpenPGP: id=5D35E502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2009 01:25 PM, Mimi Zohar wrote:
> The unencrypted files are being measured.  Update the counters to get
> rid of the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)
> 
> Reported-by: Sachin Garg
> Cc: stable@kernel.org
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  fs/ecryptfs/main.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index 101fe4c..c6ac85d 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -35,6 +35,7 @@
>  #include <linux/key.h>
>  #include <linux/parser.h>
>  #include <linux/fs_stack.h>
> +#include <linux/ima.h>
>  #include "ecryptfs_kernel.h"
> 
>  /**
> @@ -118,6 +119,7 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
>  	const struct cred *cred = current_cred();
>  	struct ecryptfs_inode_info *inode_info =
>  		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
> +	int opened_lower_file = 0;
>  	int rc = 0;
> 
>  	mutex_lock(&inode_info->lower_file_mutex);
> @@ -134,9 +136,12 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
>  			       "for lower_dentry [0x%p] and lower_mnt [0x%p]; "
>  			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
>  			inode_info->lower_file = NULL;
> -		}
> +		} else
> +			opened_lower_file = 1;
>  	}
>  	mutex_unlock(&inode_info->lower_file_mutex);
> +	if (opened_lower_file)
> +		ima_counts_get(inode_info->lower_file);
>  	return rc;
>  }
> 

Hi Mimi - Thanks for the updated patch!

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Tyler
