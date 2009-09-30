Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZI3TGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZI3TGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZI3TGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:06:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57053 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZI3TGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:06:37 -0400
Message-ID: <4AC3AC33.1020907@linux.vnet.ibm.com>
Date: Wed, 30 Sep 2009 14:06:27 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] ima: ecryptfs fix imbalance message
References: <1254258535-18894-1-git-send-email-zohar@linux.vnet.ibm.com>
In-Reply-To: <1254258535-18894-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Enigmail-Version: 0.97a
OpenPGP: id=5D35E502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 04:08 PM, Mimi Zohar wrote:
> The underlying files are measured. Update the counters to get rid of
> the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)
> 
> Reported-by: Sachin Garg <ascii79@gmail.com>
> Cc: stable@kernel.org
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  fs/ecryptfs/main.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index 9f0aa98..177e61e 100644
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
> @@ -135,7 +136,8 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
>  			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
>  			rc = PTR_ERR(inode_info->lower_file);
>  			inode_info->lower_file = NULL;
> -		}
> +		} else
> +			ima_counts_get(inode_info->lower_file);
>  	}
>  	mutex_unlock(&inode_info->lower_file_mutex);
>  	return rc;

Hi Mimi - I can't think of why we would want to measure the underlying
files.  The file contents are encrypted with a randomly generated key
and there is eCryptfs metadata stored in the first 8K of the underlying
file.  If you have two eCryptfs mounts, using the same key, and copy the
same file into both mount points, you'll end up with two entirely
different underlying files.

Taking a closer look at IMA is still on my TODO list, so I could be
missing something obvious.  The upper (decrypted) file is being
measured, right?

For performance and the reason mentioned above, it seems like the proper
fix is to only measure the upper file.  What do you think?

Tyler
