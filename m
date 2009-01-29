Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZA2I6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZA2I6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZA2I6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:58:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbZA2I6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:58:11 -0500
Date: Thu, 29 Jan 2009 00:57:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Bron Gondwana <brong@fastmail.fm>
Subject: Re: [patch] drop epoll max_user_instances and rely only on
 max_user_watches
Message-Id: <20090129005716.6dd51929.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [patch] drop epoll max_user_instances and rely only on max_user_watches

nanonit: please prepare titles in the form "subsystem-id:
what-i-did-to-it", so a suitable name here would be

	epoll: drop max_user_instances and rely only on max_user_watches

On Wed, 28 Jan 2009 20:56:07 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:

> Linus suggested to put limits where the money is, and max_user_watches 
> already does that w/out the need of max_user_instances. That has the 
> advantage to mitigate the potential DoS while allowing pretty generous 
> default behavior.

A reader of this changelog would be wondering what this DoS is.

> Allowing top 4% of low memory (per user) to be allocated in epoll 
> watches, we have:
> 
> LOMEM    MAX_WATCHES (per user)
> 512MB    ~178000
> 1GB      ~356000
> 2GB      ~712000
> 
> A box with 512MB of lomem, will meet some challenge in hitting 180K 
> watches, socket buffers math teaches us.
> No more max_user_instances limits then.

So the max consumable memory is

	number-of-users * max_user_watches * sizeof(whatever)

?

So if enough users gang up (or if one person has access to a lot of
UIDs), there's still a DoS?

I suspect we can live with that.



I assume that because you based all this on all the other patches, you
view it as 2.6.30 material?

> @@ -581,10 +570,6 @@

please use `diff -p'.  It helps.

>  	struct eventpoll *ep;
>  
>  	user = get_current_user();
> -	error = -EMFILE;
> -	if (unlikely(atomic_read(&user->epoll_devs) >=
> -			max_user_instances))
> -		goto free_uid;
>  	error = -ENOMEM;
>  	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
>  	if (unlikely(!ep))
> @@ -1141,7 +1126,6 @@
>  			      flags & O_CLOEXEC);
>  	if (fd < 0)
>  		ep_free(ep);
> -	atomic_inc(&ep->user->epoll_devs);
>  
>  error_return:
>  	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",

I hit a reject here (which is actually in epoll_create1()) (and diff -p
might not have told us of this, because of that darned
SYSCALL_DEFINE1() thing we just added) (which broke ctags too).

The code I have is

	if (error < 0)
		ep_free(ep);
	else
		atomic_inc(&ep->user->epoll_devs);

so I obviously nuked the `else' as well.



