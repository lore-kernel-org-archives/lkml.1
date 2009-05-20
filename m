Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZETHMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZETHMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZETHMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:12:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZETHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:12:30 -0400
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
In-Reply-To: <cover.1242763826.git.jbaron@redhat.com>
References: <cover.1242763826.git.jbaron@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2009 09:12:04 +0200
Message-Id: <1242803524.26820.530.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 17:03 -0400, Jason Baron wrote:
> hi,
> 
> After disassembling some of the tracepoints, I've noticed that arguments that
> are passed as macros or that perform  dereferences, evaluate prior to the
> tracepoint on/off check. This means that we are needlessly impacting the 
> off case.
> 
> I am proposing to fix this by adding a macro that first checks for on/off and
> then calls 'trace_##name', preserving type checking. Thus, callsites have to 
> move from:
> 
> trace_block_bio_complete(md->queue, bio);
> 
> to:
> 
> tracepoint_call(block_bio_complete,  md->queue, bio);
> 
> I've tried '__always_inline', but that did not fix this issue. Obviously this
> change will require changes to all the callsites. But, that shouldn't be
> very hard, I've already included the scheduler and block changes with this
> patch. I think its important to minimize code execution in the off case, and
> thus going through all the callsites is well worth it. If we agree on this
> change, I can change the rest in very short order.
> 
> Below I'm also showing the assembly in the 'dec_pending()' function before and
> after this change to show the difference it makes. The arguments to the
> tracepoint are as above, 'md->queue' and 'bio'. Notice the 2 extra instructions,
> before the initial 'je', that could be moved after the 'je'.

I really really hate this.

Why can't 

trace_block_bio_complete(arg..)
   if (__trace_block_bio_compete.state)
     __trace_block_bio_complete(arg)

work?

Surely its possible to wrap the whole stuff in yet another macro layer
that will do the conditional before evaluating the arguments?
