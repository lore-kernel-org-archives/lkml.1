Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZDNGwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZDNGwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZDNGwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:52:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbZDNGwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:52:43 -0400
Date: Tue, 14 Apr 2009 08:52:39 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Blunck <jblunck@suse.de>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] atomic: Only take lock when the counter drops to zero on UP as well
Message-ID: <20090414065239.GA20951@wotan.suse.de>
References: <20090411141754.45F7B16080@e179.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411141754.45F7B16080@e179.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:13:57PM +0200, Jan Blunck wrote:
> I think it is wrong to unconditionally take the lock before calling
> atomic_dec_and_test() in _atomic_dec_and_lock(). This will deadlock in
> situation where it is known that the counter will not reach zero (e.g. holding
> another reference to the same object) but the lock is already taken.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Paul's worry about callers aside, I think it is probably a good idea
to reduce ifdefs and share more code.

So for this patch,

Acked-by: Nick Piggin <npiggin@suse.de>
 
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
> -- 
> 1.6.0.2
