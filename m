Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0CNSON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 14:14:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:55749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab0CNSOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 14:14:09 -0400
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
 lock
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 19:13:55 +0100
Message-ID: <1268590435.9440.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-14 at 19:38 +0900, Hitoshi Mitake wrote:
> Current lockdep is too complicated because,
>  * dependency validation
>  * statistics
>  * event tracing
> are all implemented by it.
> This cause problem of overhead.
> If user enables one of them, overhead of rests part is not avoidable.
> (tracing is exception. If user enables validation or stat,
> overhead of tracing doesn't occur.)
> 
> So I suggest new subsystem "lock monitor".
> This is a general purpose lock event hooking mechanism.
> 
> lock monitor will be enable easy implementing and running
> these features related to lock.
> 
> And I'm hoping that lock monitor will reduce overhead of perf lock.
> Because lock monitor separates dependency validation and event tracing clearly,
> so calling of functions of lockdep (e.g. lock_acquire()) only for validation
> will not occur lock events.
> 
> I implemented it on the branch perf/inject of Frederic's random-tracing tree.
> Because the branch is hottest place of lock and tracing :)

OK, so I really don't like this much..

Building a lockstat kernel (PROVE_LOCKING=n) should not have much more
overhead than the proposed solution, if the simple lock acquistion
tracking bothers you, you can do a patch to weaken that.

I really really dislike how you add a monitor variable between
everything for no reason what so ever.

You use a new rwlock_t, which is an instant fail, those things are worse
than useless.

You add chained indirect calls into all lock ops, that's got to hurt.

