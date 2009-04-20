Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZDTTS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZDTTS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZDTTSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:18:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZDTTSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:18:20 -0400
Date: Mon, 20 Apr 2009 21:17:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] Stupid tracepoint ideas
Message-ID: <20090420191755.GA15571@elte.hu>
References: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

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
>  	}								\
>  	static inline int register_trace_##name(void (*probe)(proto))	\

does this boot fine? If yes then it would be nice to have a 
measurement.

	Ingo
