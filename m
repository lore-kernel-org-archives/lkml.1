Return-Path: <linux-kernel-owner+w=401wt.eu-S1767574AbXEDBPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767574AbXEDBPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 21:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767575AbXEDBPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 21:15:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767574AbXEDBPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 21:15:42 -0400
Date: Thu, 3 May 2007 18:15:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-Id: <20070503181513.0b0aa4fb.akpm@linux-foundation.org>
In-Reply-To: <20070503204226.GA212@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 00:42:26 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Thanks to Jarek Poplawski for the ideas and for spotting the bug in the
> initial draft patch.
> 
> cancel_rearming_delayed_work() currently has many limitations, because it
> requires that dwork always re-arms itself via queue_delayed_work(). So it
> hangs forever if dwork doesn't do this, or cancel_rearming_delayed_work/
> cancel_delayed_work was already called. It uses flush_workqueue() in a loop,
> so it can't be used if workqueue was freezed, and it is potentially live-
> lockable on busy system if delay is small.
> 
> With this patch cancel_rearming_delayed_work() doesn't make any assumptions
> about dwork, it can re-arm itself via queue_delayed_work(), or queue_work(),
> or do nothing.
> 
> As a "side effect", cancel_work_sync() was changed to handle re-arming works
> as well.
> 
> Disadvantages:
> 
> 	- this patch adds wmb() to insert_work().
> 
> 	- slowdowns the fast path (when del_timer() succeeds on entry) of
> 	  cancel_rearming_delayed_work(), because wait_on_work() is called
> 	  unconditionally. In that case, compared to the old version, we are
> 	  doing "unneeded" lock/unlock for each online CPU.
> 
> 	  On the other hand, this means we don't need to use cancel_work_sync()
> 	  after cancel_rearming_delayed_work().
> 
> 	- complicates the code (.text grows by 130 bytes).
> 

hm, this is getting complex.

> +	while (!try_to_grab_pending(work))
> +		;

The patch adds a couple of spinloops.  Normally we put a cpu_relax() into
such loops.  It can make a very large difference under some circumstances.


> +	while (!del_timer(&dwork->timer) &&
> +	       !try_to_grab_pending(&dwork->work))
> +		;

