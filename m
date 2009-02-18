Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZBRW1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZBRW1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZBRW1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:27:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbZBRW1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:27:04 -0500
Date: Wed, 18 Feb 2009 14:26:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: npiggin@suse.de, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [locking bug] inotify: inconsistent {RECLAIM_FS-ON-W} ->
 {IN-RECLAIM_FS-W} usage.
Message-Id: <20090218142642.2505ed5f.akpm@linux-foundation.org>
In-Reply-To: <20090216081304.GA18980@elte.hu>
References: <20090216081304.GA18980@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 09:13:04 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> --- a/fs/notify/inotify/inotify.c
> +++ b/fs/notify/inotify/inotify.c
> @@ -156,7 +156,7 @@ static int inotify_handle_get_wd(struct inotify_handle *ih,
>  	int ret;
>  
>  	do {
> -		if (unlikely(!idr_pre_get(&ih->idr, GFP_KERNEL)))
> +		if (unlikely(!idr_pre_get(&ih->idr, GFP_NOFS)))

Geeze the IDR interface sucks.

>  			return -ENOSPC;

Well that doesn't make a lot of sense.

>  		ret = idr_get_new_above(&ih->idr, watch, ih->last_wd+1, &watch->wd);
>  	} while (ret == -EAGAIN);

And afacit that can't happen.  We hold the lock, so if idr_pre_get()
succeeded, idr_get_new_above() will not return -EAGAIN (which should
have been -ENOMEM).

I'd better stop looking.

