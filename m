Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZFWTsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZFWTsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZFWTsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:48:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbZFWTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:48:29 -0400
Date: Tue, 23 Jun 2009 12:48:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
       ghaskins@novell.com, rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
Message-Id: <20090623124807.eb9042a5.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 12:25:36 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> The following patch changes the eventfd interface to de-couple the eventfd 
> memory context, from the file pointer instance.
> Without such change, there is no clean way to racely free handle the 
> POLLHUP event sent when the last instance of the file* goes away.
> Also, now the internal eventfd APIs are using the eventfd context instead 
> of the file*.
> Another cleanup this patch does, is making AIO select EVENTFD, instead of 
> adding a bunch of empty function stubs inside eventfd.h in order to 
> handle the (AIO && !EVENTFD) case.
> 

If we really want to squeeze this into 2.6.31 then it would be helpful
to have justification in the changelog, please.  I see that some KVM
feature needs it, but what and why and why now, etc?

The patch conflicts with similar changes int he KVM tree, but that'll
just ruin sfr's life for a day.


Your patch has:


> ...
>  static int eventfd_release(struct inode *inode, struct file *file)
>  {
> -	kfree(file->private_data);
> +	struct eventfd_ctx *ctx = file->private_data;
> +
> +	wake_up_poll(&ctx->wqh, POLLHUP);
> +	eventfd_ctx_put(ctx);
>  	return 0;
>  }

but the patch in linux-next has

static int eventfd_release(struct inode *inode, struct file *file)
{
	struct eventfd_ctx *ctx = file->private_data;

	/*
	 * No need to hold the lock here, since we are on the file cleanup
	 * path and the ones still attached to the wait queue will be
	 * serialized by wake_up_locked_poll().
	 */
	wake_up_locked_poll(&ctx->wqh, POLLHUP);
	kfree(ctx);
	return 0;
}

which looks quite different (and has a nice comment!)

What's going on here?
