Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZHZOKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZHZOKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZHZOKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:10:53 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:49356 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449AbZHZOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:10:52 -0400
Date: Wed, 26 Aug 2009 16:10:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826141052.GB5946@osiris.boeblingen.de.ibm.com>
References: <20090825141547.GE6114@nowhere>
 <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
 <20090826123550.GD6009@nowhere>
 <20090826125943.GA5946@osiris.boeblingen.de.ibm.com>
 <20090826133019.GE6009@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826133019.GE6009@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 03:30:22PM +0200, Frederic Weisbecker wrote:
> On Wed, Aug 26, 2009 at 02:59:43PM +0200, Heiko Carstens wrote:
> > > Yeah, and as told before, syscalls tracing from kernel thread is
> > > an interesting point but we can't do it that way.
> > > 
> > > I'm queuing this patch for .32, but I need you Signed-off-by to apply it :)
> > 
> > That won't always work as pointed out in the other example:
> > - Process doing sys_init_module then scheduled away
> > - User enables syscall tracing -> TIF_SYSCALL_FTRACE gets set
> > - init function of the module gets called and is doing kernel_thread()
> >   (old API) -> kernel thread inherits TIF_SYSCALL_FTRACE.
> > 
> > I don't think that's what you want. You might want to clear the flag for
> > new processes during fork (only for kernel threads I would guess).
> > 
> > At least the current patch leaves a hole.
> 
> Ah, there are callsites that use kernel_thread() directly?
> Does it means that t->mm could be non NULL for such resulting
> kernel threads, in that case it would be hard to hook on
> do_fork() to check that.

Oh yes, you are right. kernel threads created with kernel_thread()
have t->mm != NULL if the forking process has an mm too.

There are very few callsites left which still use kernel_thread().
(the last one in s390 driver code will be gone after the next
merge window).

As far as I can there are only four callsites left
(excluding staging): jffs2 and three in net/bluetooth/*
