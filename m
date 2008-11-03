Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYKCApW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYKCApW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 19:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYKCApI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 19:45:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYKCApH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 19:45:07 -0500
Date: Sun, 2 Nov 2008 19:45:04 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
In-Reply-To: <490E3F73.1000405@gmail.com>
Message-ID: <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
References: <490E3F73.1000405@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008, Frederic Weisbecker wrote:

> When I tried to figure out why my experimental function's return tracer was hanging, I discovered
> that it was partially caused by the fact that the ring buffer might use the usual spinlocks during
> entry insertion.
> 
> ring_buffer_lock_reserve() -> rb_reserve_next_event() -> __rb_reserve_next() -> spin_lock_irqsave()
> 
> Since this last function is traced, the result is a recursion during the trace. I guess it
> happens too with the function tracer.
> 
> We should use the raw_spin_locks which are not traced.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Frederic,

Ingo has been very adamant about not using raw_spin_locks in the ring 
buffers. My original code did this, and he nacked it. The reason being 
(and he eventually convinced me) was that by using raw, we not only do not 
trace the locking, we also remove the lock checking. This code can easily 
produce deadlocks, so we do not want the lock checking removed.

The real fix is to find a way in your tracer to detect the recursion, and 
be able to prevent it. Like the atomic disables I use in ftrace. It does 
the same thing. It leaves the lockdep checking on its own locks, but can 
also detect if the lock checking caused it to recurse. When the recusion 
is detected, the tracer itself will not trace.

[ I hope this makes sense, I'm writing this on 3 hours of sleep ]

Thanks,

-- Steve

