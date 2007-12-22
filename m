Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXLVGAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXLVGAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 01:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXLVGAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 01:00:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbXLVGAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 01:00:46 -0500
Date: Fri, 21 Dec 2007 22:00:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] remove race between use and initialization of
 locks
Message-Id: <20071221220040.5862b43b.akpm@linux-foundation.org>
In-Reply-To: <1198188961-25147-9-git-send-email-ecashin@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
	<1198188961-25147-9-git-send-email-ecashin@coraid.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 17:15:57 -0500 "Ed L. Cashin" <ecashin@coraid.com> wrote:

> Alexey Dobriyan noticed a race in the initialization of the dynamic
> locks in ...
> 
>   Message-ID: <20070325190221.GA5308@martell.zuzino.mipt.ru>
> 
> Andrew Morton commented that these locks should be initialized at
> compile time, so this patch does that.
> 
> Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
> ---
>  drivers/block/aoe/aoechr.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
> index 1bc85aa..670bba6 100644
> --- a/drivers/block/aoe/aoechr.c
> +++ b/drivers/block/aoe/aoechr.c
> @@ -35,8 +35,8 @@ struct ErrMsg {
>  
>  static struct ErrMsg emsgs[NMSG];
>  static int emsgs_head_idx, emsgs_tail_idx;
> -static struct semaphore emsgs_sema;
> -static spinlock_t emsgs_lock;
> +static __DECLARE_SEMAPHORE_GENERIC(emsgs_sema, 0);

That's not very attractive.  This would be the only user of
__DECLARE_SEMAPHORE_GENERIC() in the tree.  It seems that all architectures
(apart from uml) do implement this (although I didn't verify that they all
offer the same interface for it).  But still...

And no, we don't appear to have a proper interface to statically declare a
locked semaphore.  Nor do we appear to have one for mutexes(!).

> +static DEFINE_SPINLOCK(emsgs_lock);
>  static int nblocked_emsgs_readers;
>  static struct class *aoe_class;
>  static struct aoe_chardev chardevs[] = {
> @@ -264,8 +264,6 @@ aoechr_init(void)
>  		printk(KERN_ERR "aoe: can't register char device\n");
>  		return n;
>  	}
> -	sema_init(&emsgs_sema, 0);
> -	spin_lock_init(&emsgs_lock);
>  	aoe_class = class_create(THIS_MODULE, "aoe");
>  	if (IS_ERR(aoe_class)) {
>  		unregister_chrdev(AOE_MAJOR, "aoechr");

I think it would be better to go back to initialising emsgs_lock at runtime
rather than fattening the exported semaphore API like this.

emssgs_sema is a weird-looking thing.  There really should be some comments
in there because it is unobvious what the code is attempting to do.

What is the code attempting to do?

It appears to me that nblocked_emsgs_readers gets incorrectly decremented
if the down_interruptible() got interrupted, btw.  
