Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbYKMNA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbYKMNA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYKMM76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:59:58 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:32541 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYKMM75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:59:57 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
 return tracer lockless
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081113125419.GA32574@elte.hu>
References: <491B4F0A.3080901@gmail.com> <20081112221552.GA6125@elte.hu>
	 <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com>
	 <20081113085551.GF25479@elte.hu>
	 <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com>
	 <20081113092340.GJ25479@elte.hu>
	 <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com>
	 <20081113094027.GK25479@elte.hu>
	 <c62985530811130436s160e3983nd7debbb96cc971ae@mail.gmail.com>
	 <20081113125419.GA32574@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Nov 2008 13:59:41 +0100
Message-Id: <1226581181.7685.4714.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 13:54 +0100, Ingo Molnar wrote:
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ok, so correct me if I'm wrong. Global timestamp would be captured 
> > by using sched_clock(). That's what is done currently in 
> > ring_buffer_time_stamp() And the global timestamp would be 
> > combination of a last global timestamp and a relative position from 
> > now to this last at each insertion in the ring-buffer (or tracing 
> > time capture). Am I right? I don't really understand why you want to 
> > update with a cmpxchg loop...
> 
> the cmpxchg loop would be needed to ensure timestamp monotonicity: 
> every new "global time" is cmpxchg-ed with the "previous global time" 
> (and is first monotonicity checked).
> 
> "prev_global_time" also acts as a global serializer: it ensures that 
> events are timestamped in a monotonic and ordered way.
> 
> i.e. something like this (pseudocode, without the cmpxchg):
> 
>  u64 prev_global_time;
> 
>  DEFINE_PER_CPU(prev_local_time);
> 
>  u64 global_time()
>  {
> 	u64 now, delta, now_global;
> 
> 	prev_global = prev_global_time;
> 	now = sched_clock();
> 	delta = now - per_cpu(prev_local_time, this_cpu);
> 	per_cpu(prev_local_time, this_cpu) = now;
> 
> 	now_global = prev_global + delta;
> 	prev_global = now_global;
> 
> 	return now_global;
>  }
> 
> note how we build "global time" out of "local time".

This goes down shit-creek real fast if the TSC goes funny and jumps fwd
or something.

