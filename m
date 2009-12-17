Return-Path: <linux-kernel-owner+w=401wt.eu-S934628AbZLQJZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbZLQJZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934392AbZLQJZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:25:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:43995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933817AbZLQJZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:25:16 -0500
Subject: Re: [PATCH 2/2] perf lock: Fix output of tracing lock events
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 10:24:45 +0100
Message-ID: <1261041885.27920.110.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 12:28 +0900, Hitoshi Mitake wrote:
> This patch adds address of lockdep_map to each lock events.
> perf lock uses these addresses as IDs of lock instances.
> 
> And this removes waittime from output of lock_acquired event.
> The value will be caliculated in userspace based on timestamp.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/trace/events/lock.h |   27 ++++++++++++++++++---------
>  kernel/lockdep.c            |    2 +-
>  2 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
> index a870ba1..2f94e25 100644
> --- a/include/trace/events/lock.h
> +++ b/include/trace/events/lock.h
> @@ -18,16 +18,19 @@ TRACE_EVENT(lock_acquire,
>  	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
>  
>  	TP_STRUCT__entry(
> +		__field(struct lockdep_map *, lockdep_addr)
>  		__field(unsigned int, flags)
>  		__string(name, lock->name)
>  	),

I feel a bit awkward explicitly leaking kernel pointers like that. All
this is accessible by root only (for now) so its not too harmfull, but
sitll.

Also, I don't think we want to expose the struct lockdep_map thing, a
regular void * would be better.

As to removing the waittime, I'm not sure, in this case, yes, but if you
want some other processing that hooks straight into the tracepoints
instead of using a logging structure, it might be useful.

Removing that do_div() from there and exposing waittime as u64 in nsec,
for sure, that do_div() is just silly.

