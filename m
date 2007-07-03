Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXGCEi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXGCEi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 00:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXGCEiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 00:38:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51611 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbXGCEis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 00:38:48 -0400
Date: Mon, 2 Jul 2007 21:38:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH 09/12] remove race between use and initialization of
 locks
Message-Id: <20070702213832.8864656c.akpm@linux-foundation.org>
In-Reply-To: <2823ea0d22cb0a4aea5a5c22bb8e6b63b2b07441.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
	<2823ea0d22cb0a4aea5a5c22bb8e6b63b2b07441.1182883861.git.ecashin@coraid.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 14:50:12 -0400 "Ed L. Cashin" <ecashin@coraid.com> wrote:

> This change was originally submitted by Alexey Dobriyan in an email
> with ...
> 
>   Message-ID: <20070325190221.GA5308@martell.zuzino.mipt.ru>
> 
> and the comment,
> 
>   Some drivers do register_chrdev() before lock or semaphore used in
>   corresponding file_operations is initialized.
> 
> Andrew Morton commented that these locks should be initialized at
> compile time, but Alexey Debriyan pointed out that the Documentation
> tells us to use dynamic initialization whenever possible, and then the
> discussion petered out.
> 
>   http://preview.tinyurl.com/2pxq6p
> 
> I believe we made these locks dynamic because of the notice in
> Documentation/spinlocks.txt, which says that static initializers are
> deprecated:
> 
>   UPDATE March 21 2005 Amit Gud <gud@eth.net>
> 
>   Macros SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated and will be
>   removed soon. So for any new code dynamic initialization should be used:

The document is inaccurate.

Yes, the use of SPIN_LOCK_UNLOCKED should be avoided because it breaks
lockdep.  But it can be replaced with DEFINE_SPINLOCK: there is no need to
switch to runtime initialisation.



> ...
> 
> In any case, the patch below makes the code correct and in keeping
> with the existing documentation.  If the existing docs are wrong, I'd
> be happy to follow up with a patch that corrects them and makes these
> aoechr.c locks static.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
> ---
>  drivers/block/aoe/aoechr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
> index 10b38a7..2b4f873 100644
> --- a/drivers/block/aoe/aoechr.c
> +++ b/drivers/block/aoe/aoechr.c
> @@ -256,13 +256,13 @@ aoechr_init(void)
>  {
>  	int n, i;
>  
> +	sema_init(&emsgs_sema, 0);
> +	spin_lock_init(&emsgs_lock);
>  	n = register_chrdev(AOE_MAJOR, "aoechr", &aoe_fops);
>  	if (n < 0) { 
>  		printk(KERN_ERR "aoe: can't register char device\n");
>  		return n;
>  	}
> -	sema_init(&emsgs_sema, 0);
> -	spin_lock_init(&emsgs_lock);
>  	aoe_class = class_create(THIS_MODULE, "aoe");
>  	if (IS_ERR(aoe_class)) {
>  		unregister_chrdev(AOE_MAJOR, "aoechr");
> -- 
> 1.5.2.1
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
