Return-Path: <linux-kernel-owner+w=401wt.eu-S965755AbZLHSTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755AbZLHSTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937871AbZLHSTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:19:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:54382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937315AbZLHSTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:19:43 -0500
Subject: Re: [RFC,PATCH 14/14] utrace core
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
In-Reply-To: <20091208163131.GA14815@redhat.com>
References: <20091124200220.GA5828@redhat.com>
	 <1259697242.1697.1075.camel@laptop> <20091201220847.GA25400@redhat.com>
	 <1260210877.3935.594.camel@laptop> <20091208150417.GA11883@redhat.com>
	 <1260286163.3935.1497.camel@laptop>  <20091208163131.GA14815@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 19:19:38 +0100
Message-ID: <1260296378.17334.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 17:31 +0100, Oleg Nesterov wrote:

> > If you take a task ref you can write the much saner:
> >
> > utrace_control()
> > {
> >   ...
> >   spin_lock(&utrace->lock);
> >   ...
> >   if (reset)
> >     utrace_reset(utrace);
> >
> >   spin_unlock(&utrace->lock);
> > }
> 
> No, get_task_struct() in utrace_reset() can't help, we should move
> it into utrace_control() then. And in this case it becomes even more
> subtle: it is needed because ->utrace_flags may be cleared inside
> utrace_reset() and after that utrace_control()->spin_unlock() becomes
> unsafe.

The task->utrace pointer is cleaned up on
free_task()->tracehook_free_task()->utrace_free_task(), so by holding a
ref on the task, we ensure ->utrace stays around, and we can do
spin_unlock(), right?

> Also. utrace_reset() drops utrace->lock to call put_detached_list()
> lockless. If we want to avoid the assymetric locking, every caller
> should pass "struct list_head *detached" to utrace_reset(), drop
> utrace->lock, and call put_detached_list().

All that seems to do is call ->release() and kmem_cache_free()s the
utrace_engine thing, why can't that be done with utrace->lock held?

But yeah, passing that list along does seem like a better solution.

