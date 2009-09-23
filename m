Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZIWK54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZIWK54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZIWK54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:57:56 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48456 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZIWK5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BpQqGQLFYzxCiIY4yeaOEu4gtQ+2Me9PNsbAt4CHY3SIi6ORWHCoKA4VOAXLmAvxIW
         p5320bBE4Fpa4J/eZx3RSlQI4WXlUBpYtIRoQWY3Fie3NmCH6KcyvA2riMDmj6TqAMjn
         FFwRIYRwAxoGCKmKnr7CqFMTrGzVwWcyJX+a4=
MIME-Version: 1.0
In-Reply-To: <20090923103244.7aa5d027@infradead.org>
References: <20090921093652.0722d745@infradead.org>
	 <alpine.DEB.2.00.0909210926010.7647@gandalf.stny.rr.com>
	 <20090921152853.2f8c0597@infradead.org>
	 <1253551567.2630.26.camel@frodo>
	 <20090921200042.29f0cf49@infradead.org>
	 <1253568031.2935.5.camel@frodo>
	 <20090923103244.7aa5d027@infradead.org>
Date: Wed, 23 Sep 2009 12:57:58 +0200
Message-ID: <c62985530909230357k5050a3cese1e303abea61f831@mail.gmail.com>
Subject: Re: [patch] introduce TRACE_EVENT_ABI (was Re: TRACE_EVENT_ABI ?)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/23, Arjan van de Ven <arjan@infradead.org>:
> From e2c647ae2d3ddc25b804f0419956caf40d89c606 Mon Sep 17 00:00:00 2001
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 21 Sep 2009 20:14:53 +0200
> Subject: [PATCH] trace: introduce TRACE_EVENT_ABI
>
> Some trace events are suitable to form a stable userspace ABI;
> this patch introduces infrastructure to mark them as such,
> and marks the first few tracepoints this way
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  include/linux/tracepoint.h   |    4 ++++
>  include/trace/events/power.h |    6 +++---
>  include/trace/events/sched.h |    4 ++--
>  3 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 63a3f7a..4cb454f 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -280,6 +280,10 @@ static inline void tracepoint_synchronize_unregister(void)
>  * TRACE_EVENT_FN to perform any (un)registration work.
>  */
>
> +#define TRACE_EVENT_ABI(name, proto, args, tstruct, assign, print)     \
> +       TRACE_EVENT(name, PARAMS(proto), PARAMS(args),                  \
> +                   PARAMS(tstruct), PARAMS(assign), PARAMS(print))
> +


You may probably need to undefine it from trace/define_trace.h
once every cpp magic have been done (ie: once trace/ftrace.h
have been included.)

Because some files include several tracepoint/trace event headers,
then linux/tracepoint.h gets included several times and eventually
TRACE_EVENT_ABI() would be redefined (and then crash).

That's why we have:

#ifdef CONFIG_EVENT_TRACING
#include <trace/ftrace.h>
#endif

#undef TRACE_EVENT
#undef TRACE_EVENT_FN
#undef TRACE_HEADER_MULTI_READ

in define_trace.h: to allow such re-inclusion of tracepoint.h
and avoid redefinitions of TRACE_EVENT and TRACE_EVENT_FN.

So you just need to add:

 #undef TRACE_EVENT
 #undef TRACE_EVENT_FN
+#undef TRACE_EVENT_ABI
 #undef TRACE_HEADER_MULTI_READ


The problem is visible if you build napi that has such
multiple tracepoint headers included in a single C file.

Thanks.
