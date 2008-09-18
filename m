Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYIRWUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYIRWUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYIRWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:19:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbYIRWTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:19:54 -0400
Date: Thu, 18 Sep 2008 15:19:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH -tip] uaccess: fix parameters inversion for
 __copy_from_user_inatomic()
Message-Id: <20080918151908.9857ba64.akpm@linux-foundation.org>
In-Reply-To: <48CF061A.5060002@ct.jp.nec.com>
References: <48CF061A.5060002@ct.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 18:04:26 -0700
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> The following patch changes to use __copy_from_user_inatomic(),
> but the passing parameters incorrect.
> 
>     x86: some lock annotations for user copy paths, v3
> 
>     - add annotation back to clear_user()
>     - change probe_kernel_address() to _inatomic*() method
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  include/linux/uaccess.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 2062293..6b58367 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -78,7 +78,7 @@ static inline unsigned long __copy_from_user_nocache(void *to,
>  							\
>  		set_fs(KERNEL_DS);			\
>  		pagefault_disable();			\
> -		ret = __copy_from_user_inatomic((__force typeof(retval) __user *)(addr), &(retval), sizeof(retval));		\
> +		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\
>  		pagefault_enable();			\
>  		set_fs(old_fs);				\
>  		ret;					\

The bug which this fixes was merged into linux-next-20080918, and
manifests as squillions of messages like

[   58.693759] SLAB: cache with size 65536 has lost its name
[   58.693926] SLAB: cache with size 65536 has lost its name
[   58.694095] SLAB: cache with size 32768 has lost its name
[   58.694261] SLAB: cache with size 32768 has lost its name
[   58.694434] SLAB: cache with size 16384 has lost its name
[   58.694606] SLAB: cache with size 16384 has lost its name
[   58.694773] SLAB: cache with size 8192 has lost its name
[   58.694940] SLAB: cache with size 8192 has lost its name
[   58.695101] SLAB: cache with size 4096 has lost its name

so this version of linux-next (which will be the most-recent
version of linux-next for the next three weeks) will need this patch:


--- a/include/linux/uaccess.h~uaccess-fix-parameters-inversion-for-__copy_from_user_inatomic
+++ a/include/linux/uaccess.h
@@ -78,7 +78,7 @@ static inline unsigned long __copy_from_
 							\
 		set_fs(KERNEL_DS);			\
 		pagefault_disable();			\
-		ret = __copy_from_user_inatomic((__force typeof(retval) __user *)(addr), &(retval), sizeof(retval));		\
+		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\
 		pagefault_enable();			\
 		set_fs(old_fs);				\
 		ret;					\
_

