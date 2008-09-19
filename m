Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYISXGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYISXGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYISXGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:06:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:46081 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYISXGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:06:33 -0400
Subject: Re: [PATCH] fix count(), compat_count() bounds checking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, aaw <aaw@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080919155003.GB3114@redhat.com>
References: <20080919155003.GB3114@redhat.com>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 01:06:13 +0200
Message-Id: <1221865573.8359.2.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-19 at 11:50 -0400, Jason Baron wrote:
> hi,
> 
> With MAX_ARG_STRINGS set to 0x7FFFFFFF, and being passed to 'count()'
> and compat_count(), it would appear that the current max bounds check
> of fs/exec.c:394:
> 
> 	if(++i > max)
> 		return -E2BIG;
> 
> would never trigger. Since 'i' is of type int, so values would wrap and the
> function would continue looping.
> 
> Simple fix seems to be chaning ++i to i++ and checking for '>='.
> 
> thanks,
> 
> -Jason

Right - looks sane enough, although in practise I'm not sure we'll ever
care since I suspect we'll hit the target stack limit before this.

Ollie?

> Signed-off-by: Jason Baron <jbaron@redhat.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> 
> ---
> 
>  fs/compat.c |    2 +-
>  fs/exec.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/compat.c b/fs/compat.c
> index 3d4d57a..2c68dd7 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -1233,7 +1233,7 @@ static int compat_count(compat_uptr_t __user *argv, int max)
>  			if (!p)
>  				break;
>  			argv++;
> -			if(++i > max)
> +			if (i++ >= max)
>  				return -E2BIG;
>  		}
>  	}
> diff --git a/fs/exec.c b/fs/exec.c
> index 9bf0476..7766839 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -389,7 +389,7 @@ static int count(char __user * __user * argv, int max)
>  			if (!p)
>  				break;
>  			argv++;
> -			if(++i > max)
> +			if (i++ >= max)
>  				return -E2BIG;
>  			cond_resched();
>  		}

