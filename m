Return-Path: <linux-kernel-owner+w=401wt.eu-S1767006AbXDSVlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767006AbXDSVlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767007AbXDSVlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:41:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767006AbXDSVlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:41:52 -0400
Date: Thu, 19 Apr 2007 14:40:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] nfs lockd reclaimer: Convert to kthread API
Message-Id: <20070419144059.7f5b9b39.akpm@linux-foundation.org>
In-Reply-To: <1177017564.6628.5.camel@heimdal.trondhjem.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769696321319-git-send-email-ebiederm@xmission.com>
	<1176999710.6663.12.camel@heimdal.trondhjem.org>
	<m1slawkw76.fsf@ebiederm.dsl.xmission.com>
	<1177017564.6628.5.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 17:19:24 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > Regardless kernel threads should be an implementation detail
> > not a part of the user interface.  If kernel threads are part
> > of the user interface it makes them very hard to change.
> > 
> > So it isn't that it doesn't make sense to me it is that it looks
> > fundamentally broken and like a maintenance nightmare.
> > 
> > I would rather kill kernel threads then try and simulate them
> > when the kernel implementation has changed and kernel threads
> > are not visible.
> > 
> > If I could be convinced that signal handling in kernel threads
> > is not something that will impede code modifications and refactoring
> > I would have less of a problem, and might not care.
> 
> Tough. You're the one proposing to change existing code.

Using signals to communicate with kernel threads is fairly unpleasant, IMO.
We have much simpler, faster and more idiomatic ways of communicating
between threads in-kernel and there are better ways in which userspace can
communicate with the kernel - system calls, for example...

So I think generally any move which gets us away from using signals in
kernel threads is moving in a good direction.

> > With pid namespaces all kernel threads will disappear so how do
> > we cope with the problem when the sysadmin can not see the kernel
> > threads?
> 
> Then you have a usability problem. How does the sysadmin reboot the
> system if there is no way to shut down the processes that are hanging on
> an unresponsive filesystem?

Where's the hang?  A user process is stuck on h_rwsem?

If so, would it be appropriate to convert the user process to use
down_foo_interruptible(), so that the operator can just kill the user
process as expected, rather than having to futz around killing kernel
threads?

