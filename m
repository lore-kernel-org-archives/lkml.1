Return-Path: <linux-kernel-owner+w=401wt.eu-S932987AbXC3XJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbXC3XJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933056AbXC3XJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:09:29 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55904 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987AbXC3XJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:09:05 -0400
Date: Fri, 30 Mar 2007 16:08:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 1/13] signal/timer/event fds v8 - anonymous inode source
 ...
Message-Id: <20070330160850.d7988a87.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703301532500.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415834.1>
	<20070330123943.8df1aa92.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703301532500.3721@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 15:44:15 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Fri, 30 Mar 2007, Andrew Morton wrote:
> 
> > > +#include <asm/uaccess.h>
> > > +
> > > +
> > > +
> > 
> > Too many blank lines
> 
> It'd be interesting to know how much is enough. You use one, ppl says it 
> is too dense. You use more, ppl says it's too much.
> There's the one-line rule for inter-function spacing, but what's the 
> include-functions ones? Or the functions-data ones?
> 

less ;)

> 
> > > +static int __init aino_init(void)
> > > +{
> > > +	int error;
> > > +
> > > +	error = register_filesystem(&aino_fs_type);
> > > +	if (error)
> > > +		goto err_exit;
> > > +	aino_mnt = kern_mount(&aino_fs_type);
> > > +	if (IS_ERR(aino_mnt)) {
> > > +		error = PTR_ERR(aino_mnt);
> > > +		goto err_unregister_filesystem;
> > > +	}
> > > +	aino_inode = aino_mkinode();
> > > +	if (IS_ERR(aino_inode)) {
> > > +		error = PTR_ERR(aino_inode);
> > > +		goto err_mntput;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +err_mntput:
> > > +	mntput(aino_mnt);
> > > +err_unregister_filesystem:
> > > +	unregister_filesystem(&aino_fs_type);
> > > +err_exit:
> > > +	printk(KERN_ERR "aino_init() failed (%d)\n", error);
> > 
> > I suspect this is panic time?
> 
> Ok, it was panincing, and someone made me change it. Would you please 
> agree?
> The system can survive w/out, but it'll be a broken system WRT userspace.

I'd say panic.  There's no much point in limping along with an
incorrectly-working kernel, only to have some small number of apps fail
mysteriously later on.

> > 
> > Can we make this optional if CONFIG_EMBEDDED?  You plan on converting epoll
> > to use this facility, but with CONFIG_EPOLL=n, this is all dead code?
> 
> Hmmm, the whole point is that all this stuff works with or without epoll. 
> And epoll need no changes to support this.

I'm suggesting that all known clients of anon_inode be made optional. 
Hence anon_iode can become optional too.

It's a desirable objective, at least.  The default, really.
