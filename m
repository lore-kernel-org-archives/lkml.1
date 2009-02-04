Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZBDXF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZBDXF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBDXFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:05:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbZBDXFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:05:10 -0500
Date: Wed, 4 Feb 2009 15:05:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mtk.manpages@gmail.com, linux-api@vger.kernel.org
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Message-Id: <20090204150507.665b5b7c.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 14:58:39 -0800 (PST)
Davide Libenzi <davidel@xmailserver.org> wrote:

> People started using eventfd in scnarios where before where using pipes. 
> Many of them use eventfds in a semaphore-like way, like they were before 
> with pipes. The problem with eventfd is that a read() on the fd returns 
> and wipes the whole counter, making the use of it as semaphore a little 
> bit more cumbersome. You can do a read() followed by a write() of 
> COUNTER-1, but IMO it's pretty easy and cheap to make this work w/out 
> extra steps. This patch introduces a new eventfd flag that tells eventfd 
> to only dequeue 1 from the counter, allowing simple read/write to make it 
> behave like a semaphore.

Would be nice to spell out what "a sempahore-like way" is.

> Simple test here:
> 
> http://www.xmailserver.org/eventfd-sem.c
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> +/*
> + * CAREFUL: Check include/asm-generic/fcntl.h when defining
> + * new flags, since they might collide with O_* ones. We want
> + * to re-use O_* flags that couldn't possibly have a meaning
> + * from eventfd, in order to leave a free define-space for
> + * shared O_* flags.
> + */
> +#define EFD_SEMAPHORE (1 << 0)
>  #define EFD_CLOEXEC O_CLOEXEC
>  #define EFD_NONBLOCK O_NONBLOCK
>  
> +#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
> +#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)

How would you recommend that userspace determine whether its kernel
supports this feature, bearing in mind that someone might backport this
patch into arbitrarily earlier kernel versions?

What should be userspace's fallback strategy if that support is not
present?
