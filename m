Return-Path: <linux-kernel-owner+w=401wt.eu-S1763224AbZD3OHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763224AbZD3OHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763233AbZD3OH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:07:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763498AbZD3OHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:07:25 -0400
Date: Thu, 30 Apr 2009 16:06:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] use GFP_NOFS in kernel_event()
Message-ID: <20090430140642.GB14696@elte.hu>
References: <20090430020004.GA1898@localhost> <20090429191044.b6fceae2.akpm@linux-foundation.org> <1241097573.6020.7.camel@localhost.localdomain> <20090430134821.GB8644@localhost> <20090430140324.GA12033@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430140324.GA12033@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Thu, Apr 30, 2009 at 09:48:21PM +0800, Wu Fengguang wrote:
> > On Thu, Apr 30, 2009 at 09:19:33PM +0800, Eric Paris wrote:
> > > inotify: lockdep annotation when watch being removed
> > > 
> > > From: Eric Paris <eparis@redhat.com>
> > > 
> > > When a dentry is being evicted from memory pressure, if the inode associated
> > > with that dentry has i_nlink == 0 we are going to drop all of the watches and
> > > kick everything out.  Lockdep complains that previously holding inotify_mutex
> > > we did a __GFP_FS allocation and now __GFP_FS reclaim is taking that lock.
> > > There is no deadlock or danger, since we know on this code path we are
> > > actually cleaning up and evicting everything.  So we move the lock into a new
> > > class for clean up.
> > 
> > I can reproduce the bug and hence confirm that this patch works, so
> > 
> > Tested-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> btw, I really see no point to have one GFP_KERNEL and one GFP_NOFS
> sitting side by side inside kernel_event(). So this patch?
> 
> ---
> inotify: use consistent GFP_KERNEL in kernel_event()
> 
> kernel_event() has side by side kmem_cache_alloc(GFP_NOFS)
> and kmalloc(GFP_KERNEL). Change to consistent GFP_KERNELs.
> 
> cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/notify/inotify/inotify_user.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- mm.orig/fs/notify/inotify/inotify_user.c
> +++ mm/fs/notify/inotify/inotify_user.c
> @@ -189,7 +189,7 @@ static struct inotify_kernel_event * ker
>  {
>  	struct inotify_kernel_event *kevent;
>  
> -	kevent = kmem_cache_alloc(event_cachep, GFP_NOFS);
> +	kevent = kmem_cache_alloc(event_cachep, GFP_KERNEL);

good point - this essentially reverts the earlier workaround.

	Ingo
