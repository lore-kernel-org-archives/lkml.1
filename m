Return-Path: <linux-kernel-owner+w=401wt.eu-S965496AbXDBOpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496AbXDBOpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXDBOpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:45:32 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:40531 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965496AbXDBOpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:45:32 -0400
Date: Mon, 2 Apr 2007 16:33:54 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: CPU ordering with respect to krefs
Message-Id: <20070402163354.ef741262.dada1@cosmosbay.com>
In-Reply-To: <200704021447.59476.oneukum@suse.de>
References: <200704021447.59476.oneukum@suse.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007 14:47:59 +0200
Oliver Neukum <oneukum@suse.de> wrote:

> Hi,
> 
> some atomic operations are only atomic, not ordered. Thus a CPU is allowed
> to reorder memory references to an object to before the reference is
> obtained. This fixes it.
> 
> 	Regards
> 		Oliver
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ------
> 
> --- a/lib/kref.c	2007-04-02 14:40:40.000000000 +0200
> +++ b/lib/kref.c	2007-04-02 14:40:50.000000000 +0200
> @@ -21,6 +21,7 @@
>  void kref_init(struct kref *kref)
>  {
>  	atomic_set(&kref->refcount,1);
> +	smp_mb();
>  }

I dont understand why smp_mb() is needed here, and not in spinlock_init() for example.

If you have ordering issues, then the caller of kref_init() should take care of it, not kref_init() itself.

Random example taken in drivers/usb/gadget/file_storage.c :

static int __init fsg_alloc(void)
{
...
kref_init(&fsg->ref);
init_completion(&fsg->thread_notifier);

the_fsg = fsg;
}

In this example, "the_fsg = fsg" memory write might be visible before the memory writes done in init_completion().
Doing a smp_mb() in kref_init() wont help.

AFAIK kref implementation doesnt need this extra smp_mb().

