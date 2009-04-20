Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbZDTUyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbZDTUyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbZDTUyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:54:41 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:53242 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZDTUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:54:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AukFACd47ElMQW1W/2dsb2JhbACBTtA6g30G
Date: Mon, 20 Apr 2009 16:54:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] Stupid tracepoint ideas
Message-ID: <20090420205438.GA11567@Krystal>
References: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:48:40 up 51 days, 17:14,  1 user,  load average: 0.71, 0.67,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> Mathieu,
> 
> You may have tried this in your creation of tracepoints, but I figured I 
> would ask before wasting too much time on it.
> 
> I'm looking at ways to make tracepoints even lighter weight when disabled. 
> And I thought of doing section code. I'm playing with the following idea 
> (see below patch) but I'm afraid gcc is allowed to think that the code it 
> produces will not move to different sections.
> 
> Any thoughts on how we could do something similar to this.
> 
> Note, this patch is purely proof-of-concept. I'm fully aware that it is an 
> x86 solution only.
> 
> -- Steve
> 
> [ no Signed-off-by: because this patch is crap ]
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 4353f3f..6953f78 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -65,9 +65,18 @@ struct tracepoint {
>  	extern struct tracepoint __tracepoint_##name;			\
>  	static inline void trace_##name(proto)				\
>  	{								\
> -		if (unlikely(__tracepoint_##name.state))		\
> +		if (unlikely(__tracepoint_##name.state)) {		\
> +			asm volatile ("jmp 43f\n"			\
> +				      "42:\n"				\
> +				      ".section .unlikely,\"ax\"\n"	\
> +				      "43:\n"				\
> +				      ::: "memory");			\
>  			__DO_TRACE(&__tracepoint_##name,		\
> -				TP_PROTO(proto), TP_ARGS(args));	\
> +				   TP_PROTO(proto), TP_ARGS(args));	\
> +			asm volatile ("jmp 42b\n"			\
> +			     ".previous\n"				\
> +			     ::: "memory");				\
> +		}							\

You are right, I thought of this.

gcc forbids jumping outside of inline assembly statements. Optimisations
done by gcc are not aware of this sort of execution flow modification,
and gcc has every rights to interleave unrelated code between the two
inline assembly statements.

And is it me or this sounds like an infinite loop ?

42:
....
jmp 42b

Mathieu

>  	}								\
>  	static inline int register_trace_##name(void (*probe)(proto))	\
>  	{								\

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
