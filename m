Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZFAGJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZFAGJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZFAGJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:09:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49583 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbZFAGJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:09:24 -0400
Message-ID: <4A2370E5.6000407@cn.fujitsu.com>
Date: Mon, 01 Jun 2009 14:10:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [RFC PATCH 1/2] tracing/stat: introduce new hashlist mode
References: <1243834679-19132-1-git-send-email-fweisbec@gmail.com> <1243834679-19132-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1243834679-19132-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Until now, the stat tracing was only able to gather the pointers
> to entries from a tracer, sort them and eventually pass these
> pointers to the tracer output handler.
> 
> It has two drawbacks:
> 
> - if the tracer concurrently releases a pointer, this one may be
>   dereference later in the output callback. There are ways to keep
>   track of these pointers but it ends up with extra code from the
>   tracers.
> 
> - the tracer has to handle its entries itself, through its own
>   hashlist, list or whatever.
> 

indeed

> This patch introduces a new mode for the stat tracers. Those can now
> ask the tracing stat Api to handle their entries, which includes the
> memory allocation, the access, the synchronization, the lookup, etc...
> 
> This is done through an internal hashlist that is built according
> to the number and size of entries provided by the tracer.
> 

But hashlist may not be suitable for all stat tracers?

> A tracer can choose between this new mode and the old one by using
> the HASH_NODES flag in struct tracer_stat.
> 

What's the advantages of the old mode towards this new mode?
I think it's better to move all existing stat tracers to
this new mode, and remove the old mode totally, if we want
this new mode.

> Instead of providing a pair of iterator callbacks, they just need
> to fill up the hlist_size and node_size fields.
> 
> Then using a unique id for each stat entries (usually a simple address
> to a traced thing), they can access to an entry using the two new pairs:
> 
> - get_stat_entry() which retrieve the entry and locks it against
>   concurrent updates
> - put_stat_entry() which unlocks the entry
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace_stat.c |  329 ++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/trace/trace_stat.h |   27 ++++-
>  2 files changed, 353 insertions(+), 3 deletions(-)
