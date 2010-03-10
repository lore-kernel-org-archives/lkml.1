Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0CJUdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:33:51 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41247 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab0CJUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:33:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lAfoD/GojVbQ7QMkaQaryKVfuGQ2rObTZpz4qDJZrNx0gBb3554FVv+GmmBD/nq7jR
         V5HsOz8FRtQ2SZ95PzV6T3BNbqvUJtBxeIXLyCrclOEsAf00syzerBck2H7Fp5fbhULU
         0hXxQbc/U0rMZv9kDu85N6S5UeheCcIVNyQos=
Date: Wed, 10 Mar 2010 21:33:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH] perf: Store relevant events in a hlist
Message-ID: <20100310203338.GA9737@nowhere>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com> <1267772426-5944-2-git-send-regression-fweisbec@gmail.com> <1267781969.16716.55.camel@laptop> <20100308183545.GA5038@nowhere> <1268249692.5279.138.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268249692.5279.138.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 08:34:52PM +0100, Peter Zijlstra wrote:
> I'm not quite sure why you need the node thing, you already have a
> hash-bucket to iterate, simply stick all events into the one bucket and
> walk through it with a filter and process all events that match.


This inter level of indirection was one of my heaviest hesitations.
In case we have a hash collision, I just wanted to ensure we keep
an amortized O(n) in any case, that at the cost of this level of
indirection. Plus that removed the config:id check in every events,
as the check is made only once.

That said I guess we can indeed remove that and have the events
directly in the hash bucket. Assuming we deal well to avoid
collisions, it should be fine.

 
> As to all those for_each_online_cpu() thingies, it might make sense to
> also have a global hash-table for events active on all cpus,... hmm was
> that the reason for the node thing, one event cannot be in multiple
> buckets?


There are several reasons I've made it per cpu.
Assuming we have a global hash table for wide events, it means we'll
have some cache dance each time an event is disabled/enabled (which
is quite often as wide events are per task, even worst if the initial task
has numerous threads that have this event duplicated). Also, as wide
events mean per task, the event will always be active in one cpu at
a time, it would be wasteful to check it on other cpus.

