Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYKMMg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYKMMg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYKMMgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:36:19 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:14438 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYKMMgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:36:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nLcQr/fUdRXL9uuwu42Ig7Mz0PTlJWnpKWHVHRj4dqga6a4ogXJLb+kuJ28khEH3nL
         dGowNdaxDlvy+EUtApPK/MHzgqSo/dbWFCvbBWQ/deGOsEEWdQO8HPbSeosm+TcVCCZf
         gdrW/aqf24njA6xgtCgrw4vKCuQ+NBNCSIa54=
Message-ID: <c62985530811130436s160e3983nd7debbb96cc971ae@mail.gmail.com>
Date: Thu, 13 Nov 2008 13:36:17 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081113094027.GK25479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F0A.3080901@gmail.com> <20081112221552.GA6125@elte.hu>
	 <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com>
	 <20081113085551.GF25479@elte.hu>
	 <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com>
	 <20081113092340.GJ25479@elte.hu>
	 <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com>
	 <20081113094027.GK25479@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Ingo Molnar <mingo@elte.hu>:
> yeah - and it would be all means by a global entity in the beginning -
> i.e. we'd just generalize the code around ring_buffer_time_stamp() to
> listen to the "globally coherent" flag, and allow it to be used for
> callgraph cost measurement code too.
>
> If the "globally coherent" flag is set, then the implementation would
> be something like:
>
> A simple "last global timestamp" value combined with a "last local
> timestamp" value, and the global timestamp is only ever moved forward.
> It is updated via cmpxchg loop. This gives coherency and a monotonic
> clock. The local timestamp would be taken from cpu_clock(cpu), and a
> global timestamp would be constructed out of it. Or something like
> that.
>
> Would that work? [ Would you be interested in sending patches? :-) ]
>
>        Ingo
>


Ok, so correct me if I'm wrong.
Global timestamp would be captured by using sched_clock().
That's what is done currently in ring_buffer_time_stamp()
And the global timestamp would be combination of a last global
timestamp and a relative position from now to this last at
each insertion in the ring-buffer (or tracing time capture). Am I right?
I don't really understand why you want to update with a cmpxchg loop...

And the local timestamp would be built through cpu_clock() with
absolute values at each captures? Because we can't consider
relative values since this is loosing sense between cpu. Unless we
have per_cpu relative values.....

Then, depending of the current_tracer, ring_buffer_time_stamp would
act as a wrapper:
if (current_tracer->time_flag == TIME_GLOBAL_COHERENT)
    return ring_buffer_global_timestamp();
else
    return ring_buffer_local_timestamp();

Or more efficient with a function pointer set at the same we change
the time flag for the current tracer.
