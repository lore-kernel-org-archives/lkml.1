Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZFXKC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZFXKC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZFXKCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:02:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49190 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZFXKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:02:51 -0400
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de,
       tj@kernel.org
In-reply-to: <1245317073-24000-3-git-send-email-tj@kernel.org> (message from
	Tejun Heo on Thu, 18 Jun 2009 18:24:31 +0900)
Subject: Re: [PATCH 2/4] FUSE: make request_wait_answer() wait for ->end() completion
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-3-git-send-email-tj@kernel.org>
Message-Id: <E1MJPJX-0001NB-SG@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Jun 2009 12:02:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Tejun Heo wrote:
> Previously, a request was marked FINISHED before ->end() is executed
> and thus request_wait_answer() can return before it's done.  This
> patch makes request_wait_answer() wait for ->end() to finish before
> returning.

Why is this change needed?

> 
> Note that no current ->end() user waits for request completion, so
> this change doesn't cause any behavior difference.
> 
> While at it, beef up the comment above ->end() hook and clarify when
> and where it's called.

OK.

[snip]

> @@ -293,10 +292,21 @@ __releases(&fc->lock)
>  		fc->active_background--;
>  		flush_bg_queue(fc);
>  	}
> +
>  	spin_unlock(&fc->lock);
> -	wake_up(&req->waitq);
> -	if (end)
> +
> +	if (end) {
>  		end(fc, req);
> +		smp_wmb();

Why is this barrier needed?

Thanks,
Miklos
