Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXGLEZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXGLEZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 00:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbXGLEZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 00:25:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbXGLEZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 00:25:40 -0400
Date: Wed, 11 Jul 2007 21:24:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, hch@lst.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
Message-Id: <20070711212435.abd33524.akpm@linux-foundation.org>
In-Reply-To: <1184208521.6005.695.camel@localhost.localdomain>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070711122324.GA21714@lst.de>
	<1184203311.6005.664.camel@localhost.localdomain>
	<20070711.192829.08323972.davem@davemloft.net>
	<1184208521.6005.695.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 12:48:41 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wed, 2007-07-11 at 19:28 -0700, David Miller wrote:
> > From: Rusty Russell <rusty@rustcorp.com.au>
> > Date: Thu, 12 Jul 2007 11:21:51 +1000
> > 
> > > To do inter-guest (ie. inter-process) I/O you really have to make sure
> > > the other side doesn't go away.
> > 
> > You should just let it exit and when it does you receive some kind of
> > exit notification that resets your virtual device channel.
> > 
> > I think the reference counting approach is error and deadlock prone.
> > Be more loose and let the events reset the virtual devices when
> > guests go splat.
> 
> There are two places where we grab task refcnt.  One might be avoidable
> (will test and get back) but the deferred wakeup isn't really:
> 
>         /* We cache one process to wakeup: helps for batching & wakes outside locks. */
>         void set_wakeup_process(struct lguest *lg, struct task_struct *p)
>         {
>         	if (p == lg->wake)
>         		return;
>         
>         	if (lg->wake) {
>         		wake_up_process(lg->wake);
>         		put_task_struct(lg->wake);
>         	}
>         	lg->wake = p;
>         	if (lg->wake)
>         		get_task_struct(lg->wake);
>         }

<handwaving>

We seem to be taking the reference against the wrong thing here.  It should
be against the mm, not against a task_struct?
