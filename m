Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZGAHLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZGAHLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZGAHLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:11:43 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49134 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZGAHLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:11:43 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 1 Jul 2009 00:10:50 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Avi Kivity <avi@qumranet.com>, linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: linux-next: manual merge of the kvm tree with Linus' tree
In-Reply-To: <20090701145711.1c9c8935.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0907010007020.8745@makko.or.mcafeemobile.com>
References: <20090701145711.1c9c8935.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Stephen Rothwell wrote:

> Hi Avi,
> 
> Today's linux-next merge of the kvm tree got a conflict in fs/eventfd.c
> between commit 133890103b9de08904f909995973e4b5c08a780e ("eventfd:
> revised interface and cleanups") from Linus' tree and commit
> 28ddf0aebbf546e56efd1951725d5457ce1ebf98 ("eventfd: Allow waiters to be
> notified about the eventfd file* going away") from the kvm tree.
> 
> Overlapping changes.  I fixed it up (see below), but don't know if this
> is the correct fix.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/eventfd.c
> index 31d12de,72f5f8d..0000000
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@@ -105,8 -63,13 +105,13 @@@ static int eventfd_release(struct inod
>   {
>   	struct eventfd_ctx *ctx = file->private_data;
>   
> - 	wake_up_poll(&ctx->wqh, POLLHUP);
> + 	/*
> + 	 * No need to hold the lock here, since we are on the file cleanup
> + 	 * path and the ones still attached to the wait queue will be
> + 	 * serialized by wake_up_locked_poll().
> + 	 */
> + 	wake_up_locked_poll(&ctx->wqh, POLLHUP);
>  -	kfree(ctx);
>  +	eventfd_ctx_put(ctx);
>   	return 0;
>   }

That's fine.
There are a couple of extra spaces before the last two -+ in that patch 
though ;)


- Davide


