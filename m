Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbZDQWRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbZDQWRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759954AbZDQWRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:17:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbZDQWRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:17:04 -0400
Date: Fri, 17 Apr 2009 15:14:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Blunck <jblunck@suse.de>
Cc: npiggin@suse.de, paulmck@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atomic: Only take lock when the counter drops to zero
 on UP as well
Message-Id: <20090417151405.3ca49c39.akpm@linux-foundation.org>
In-Reply-To: <20090411141754.45F7B16080@e179.suse.de>
References: <20090411141754.45F7B16080@e179.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 18:13:57 +0200
Jan Blunck <jblunck@suse.de> wrote:

> I think it is wrong to unconditionally take the lock before calling
> atomic_dec_and_test() in _atomic_dec_and_lock(). This will deadlock in
> situation where it is known that the counter will not reach zero (e.g. holding
> another reference to the same object) but the lock is already taken.
> 

It can't deadlock, because spin_lock() doesn't do anything on
CONFIG_SMP=n.

You might get lockdep whines on CONFIG_SMP=n, but they'd be false
positives because lockdep doesn't know that we generate additional code
for SMP builds.

> ---
>  lib/dec_and_lock.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/dec_and_lock.c b/lib/dec_and_lock.c
> index a65c314..e73822a 100644
> --- a/lib/dec_and_lock.c
> +++ b/lib/dec_and_lock.c
> @@ -19,11 +19,10 @@
>   */
>  int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
>  {
> -#ifdef CONFIG_SMP
>  	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
>  	if (atomic_add_unless(atomic, -1, 1))
>  		return 0;
> -#endif
> +
>  	/* Otherwise do it the slow way */
>  	spin_lock(lock);
>  	if (atomic_dec_and_test(atomic))

The patch looks reasonable from a cleanup/consistency POV, but the
analysis and changelog need a bit of help, methinks.

