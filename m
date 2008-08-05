Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYHEQW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYHEQW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760114AbYHEQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:22:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357AbYHEQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:22:49 -0400
Date: Tue, 5 Aug 2008 09:22:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Make kthread_stop() not oops when passed a bad pointer
Message-Id: <20080805092209.830f5d0a.akpm@linux-foundation.org>
In-Reply-To: <20080805135559.GQ26461@parisc-linux.org>
References: <20080805135559.GQ26461@parisc-linux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 07:55:59 -0600 Matthew Wilcox <matthew@wil.cx> wrote:

> 
> Due to some botched error handling code in a driver I was writing, I
> recently called kthread_stop(NULL).  It's terribly exciting to discover
> that you've just oopsed while holding a mutex that's required in order
> to shut down.  Make kthread_stop a little more robust against numbskulls
> like me.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 96cff2f..06c3477 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -201,6 +201,9 @@ int kthread_stop(struct task_struct *k)
>  {
>  	int ret;
>  
> +	if (!k || IS_ERR(k))
> +		return -EINVAL;
> +
>  	mutex_lock(&kthread_stop_lock);
>  

hrm.

a) as this is a programming error, the programmer would like it not
   to be hidden.  A WARN_ON() would address that.

b) there are many instances of

	if (p)
		kthread_stop(p);

   which could now be simplified to

	kthread_stop(p);

c) a) and b) are incompatible.
