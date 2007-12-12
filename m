Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbXLLCH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbXLLCH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXLLCHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:07:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbXLLCHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:07:13 -0500
Date: Tue, 11 Dec 2007 18:06:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] 9p util semaphore to mutex
Message-Id: <20071211180607.c1f8b797.akpm@linux-foundation.org>
In-Reply-To: <20071209171613.670807836@gmail.com>
References: <20071209171509.601451827@gmail.com>
	<20071209171613.670807836@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Dec 2007 13:15:11 -0400 Kevin Winchester <kjwinchester@gmail.com> wrote:

> Convert the semaphore to a mutex in net/9p/util.c
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> 
> ---
>  net/9p/util.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Index: v2.6.24-rc4/net/9p/util.c
> ===================================================================
> --- v2.6.24-rc4.orig/net/9p/util.c
> +++ v2.6.24-rc4/net/9p/util.c
> @@ -33,7 +33,7 @@
>  #include <net/9p/9p.h>
>  
>  struct p9_idpool {
> -	struct semaphore lock;
> +	struct mutex lock;
>  	struct idr pool;
>  };
>  
> @@ -45,7 +45,7 @@ struct p9_idpool *p9_idpool_create(void)
>  	if (!p)
>  		return ERR_PTR(-ENOMEM);
>  
> -	init_MUTEX(&p->lock);
> +	mutex_init(&p->lock);
>  	idr_init(&p->pool);
>  
>  	return p;
> @@ -76,14 +76,14 @@ retry:
>  	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
>  		return 0;
>  
> -	if (down_interruptible(&p->lock) == -EINTR) {
> +	if (mutex_lock_interruptible(&p->lock) == -EINTR) {
>  		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
>  		return -1;
>  	}
>  
>  	/* no need to store exactly p, we just need something non-null */
>  	error = idr_get_new(&p->pool, p, &i);
> -	up(&p->lock);
> +	mutex_unlock(&p->lock);
>  
>  	if (error == -EAGAIN)
>  		goto retry;
> @@ -104,12 +104,12 @@ EXPORT_SYMBOL(p9_idpool_get);
>  
>  void p9_idpool_put(int id, struct p9_idpool *p)
>  {
> -	if (down_interruptible(&p->lock) == -EINTR) {
> +	if (mutex_lock_interruptible(&p->lock) == -EINTR) {
>  		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
>  		return;
>  	}
>  	idr_remove(&p->pool, id);
> -	up(&p->lock);
> +	mutex_unlock(&p->lock);
>  }
>  EXPORT_SYMBOL(p9_idpool_put);

I cannot see how the code which you are modifying could have been correct.

If the lock is contended and this task has signal_pending() then boom - we
return from p9_idpool_put() without having removed the item from the IDR
tree and then we just lose all track of this fact.  It is at a minimum a
memory leak.

I'm getting the feeling that we need to go and take a general look at the
down_interuptible() and mutex_lock_interruptible() callers in the nether
regions of the kernel...

Meanwhile I'd propose this instead:


From: Andrew Morton <akpm@linux-foundation.org>

Don't use down_interruptible() in situations where we cannot handle the
consequences.

Cc: Kevin Winchester <kjwinchester@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/util.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN net/9p/util.c~9p-util-fix-semaphore-handling net/9p/util.c
--- a/net/9p/util.c~9p-util-fix-semaphore-handling
+++ a/net/9p/util.c
@@ -76,12 +76,8 @@ retry:
 	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
 		return 0;
 
-	if (down_interruptible(&p->lock) == -EINTR) {
-		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
-		return -1;
-	}
-
 	/* no need to store exactly p, we just need something non-null */
+	down(&p->lock);
 	error = idr_get_new(&p->pool, p, &i);
 	up(&p->lock);
 
@@ -104,10 +100,7 @@ EXPORT_SYMBOL(p9_idpool_get);
 
 void p9_idpool_put(int id, struct p9_idpool *p)
 {
-	if (down_interruptible(&p->lock) == -EINTR) {
-		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
-		return;
-	}
+	down(&p->lock);
 	idr_remove(&p->pool, id);
 	up(&p->lock);
 }
_

