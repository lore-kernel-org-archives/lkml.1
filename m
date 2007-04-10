Return-Path: <linux-kernel-owner+w=401wt.eu-S965940AbXDJAYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965940AbXDJAYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965942AbXDJAX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:23:59 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38307 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965826AbXDJAX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:23:58 -0400
Date: Mon, 9 Apr 2007 17:23:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-Id: <20070409172339.48d661d6.akpm@linux-foundation.org>
In-Reply-To: <4616CBF0.7090606@garzik.org>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<4616CBF0.7090606@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 18:38:40 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Robin Holt wrote:
> > We have been testing a new larger configuration and we are seeing a very
> > large scan time of init's tsk->children list.  In the cases we are seeing,
> > there are numerous kernel processes created for each cpu (ie: events/0
> > ... events/<big number>, xfslogd/0 ... xfslogd/<big number>).  These are
> > all on the list ahead of the processes we are currently trying to reap.
> 
> What about attacking the explosion of kernel threads?
> 
> As CPU counts increase, the number of per-CPU kernel threads gets really 
> ridiculous.
> 
> I would rather change the implementation under the hood to start per-CPU 
> threads on demand, similar to a thread-pool implementation.
> 
> Boxes with $BigNum CPUs probably won't ever use half of those threads.

I suspect there are quite a few kernel threads which don't really need to
be threads at all: the code would quite happily work if it was changed to
use keventd, via schedule_work() and friends.  But kernel threads are
somewhat easier to code for.

I also suspect that there are a number of workqueue threads which
could/should have used create_singlethread_workqueue().  Often this is
because the developer just didn't think to do it.

otoh, a lot of these inefficeincies are probably down in scruffy drivers
rather than in core or top-level code.

<I also wonder where all these parented-by-init,
presumably-not-using-kthread kernel threads are coming from>

