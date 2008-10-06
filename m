Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYJFUrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYJFUrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYJFUr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:47:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:45346 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbYJFUr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:47:29 -0400
Subject: Re: [PATCH 0/2] utrace
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hch <hch@infradead.org>, Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20080826220102.89635154233@magilla.localdomain>
References: <20080826220102.89635154233@magilla.localdomain>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 22:47:02 +0200
Message-Id: <1223326023.12409.60.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

I've been looking over the utrace code:

git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git

git diff d3a47e82b6bc3724dd60f3ee4e84fe4479104382..utrace/master

and while I'm nowhere near done, I'd like to provide some feedback and
pose some questions.

 - what's up with these weak declarations?

 - struct utrace_attached_engine is a tad strange as we don't have a
regular struct utrace_engine.

 - does it make sense to create this struct utrace_engine and replace
the struct utrace_engine_ops and the void *data members of struct
utrace_attached_engine with a pointer to it, and obtain the data by
using container_of() on the engine itself? That is, let the user embed
struct utrace_engine in a larger structure.

 - I encountered a lot of unannotated memory barriers. Please add a
comment to each and every one describing the race and a pointer to its
pair. There is no such thing as a trivial memory barrier.

 - it has these decidedly un-kernel-ish public/private comments

 - Why does it have two lists for attaching tasks? The
description/comments explain how it works but not why we do it that way.

 - utrace_attach_task() was very hard to read, the code flow is
unconventional at best.

 - utrace_stop() can seemingly return true even though it didn't get
SIGKILL - contrary to its comments.

 - get_utrace_lock() made me look at ->engine_ops serialisation - I
couldn't convince myself its race free.

 - I saw a lot of if (unlikely(a) || unlikely(b)) style thing, please
write as if (unlikely(a || b)).

 - utrace_release_task() seems to be missing
rcu_read_lock()/rcu_read_unlock() to ensure the utrace pointer stays
valid.

 - utrace_control() seems to access ->exit_state in a racy manner.

 - some comments say 'race' but fail to provide specifics.

 - as was suggested by Christoph and Alexey, removing struct utrace
*task_struct::utrace in favour of embedding it right into task_struct
itself would remove quite a bit of complexity. I would consider doing
this, esp as you could remove the ptrace specifics from task_struct.

hth

