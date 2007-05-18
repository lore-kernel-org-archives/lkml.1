Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbXERVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbXERVIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbXERVIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:08:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457AbXERVIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:08:15 -0400
Date: Fri, 18 May 2007 14:06:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alex Volkov" <avcp-lkmail@usa.net>
Cc: "'Jeff Garzik'" <jeff@garzik.org>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: aio is unlikely
Message-Id: <20070518140624.1a4db517.akpm@linux-foundation.org>
In-Reply-To: <058f01c7998e$1406e370$650df7cd@MUMBA>
References: <20070509151831.f5956b66.akpm@linux-foundation.org>
	<058f01c7998e$1406e370$650df7cd@MUMBA>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 16:49:49 -0400
"Alex Volkov" <avcp-lkmail@usa.net> wrote:

> 
> Andrew Morton wrote:
> >     aio is unlikely
> >     Stick an unlikely() around is_aio(): I assert that most IO is
> synchronous.
> >
> > -#define in_aio() !is_sync_wait(current->io_wait)
> > +#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))
> 
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> > > > -#define in_aio() !is_sync_wait(current->io_wait)
> > > > +#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))
> > > 
> > > Please revert.  Workload-dependent "likelihood" should not cause 
> > > programmers to add such markers.
> > a) disagree with the above
> > 
> > b) if in_aio() ever returns true we do
> > 
> > 	printk(KERN_ERR "%s(%s:%d) called in async context!\n",
> > 		__FUNCTION__, __FILE__, __LINE__);
> > 
> >    so I sure hope it's unlikely for all workloads. 
> 
> Shouldn't unlikely() go where in_aio() is actually used, if we printk(error)
> there?
> Isn't putting likely/unlikely into a boolean function-like macro itself
> asking for later trouble?
> 

Yes, if you agree with Jeff's original point.

But I don't, actually.  Sure, on some machines+workloads, AIO is more
common than sync IO.  But I expect that when we sum across all the
machines+workloads in the world, sync IO is more common and is hence the
case we should optimise for.

That's assuming that the unlikely() actually does something.
