Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbZFOONc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbZFOONc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZFOONY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:13:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52855 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbZFOONX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:13:23 -0400
Date: Mon, 15 Jun 2009 10:12:10 -0400
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 3/7] add syscall tracepoints
Message-ID: <20090615141209.GA3126@redhat.com>
References: <cover.1244837725.git.jbaron@redhat.com> <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com> <20090612215726.GA9177@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612215726.GA9177@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 05:57:26PM -0400, Mathieu Desnoyers wrote:
> > Introduce a new 'DECLARE_TRACE_REG()' macro, so that tracepoints can associate
> > an external register/unregister function.
> > 
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> >  include/linux/tracepoint.h |   27 +++++++++++++++++++++++----
> >  1 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 14df7e6..9a3660b 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -61,7 +61,7 @@ struct tracepoint {
> >   * not add unwanted padding between the beginning of the section and the
> >   * structure. Force alignment to the same alignment as the section start.
> >   */
> > -#define DECLARE_TRACE(name, proto, args)				\
> > +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
> >  	extern struct tracepoint __tracepoint_##name;			\
> >  	static inline void trace_##name(proto)				\
> >  	{								\
> > @@ -71,13 +71,29 @@ struct tracepoint {
> >  	}								\
> >  	static inline int register_trace_##name(void (*probe)(proto))	\
> >  	{								\
> > -		return tracepoint_probe_register(#name, (void *)probe);	\
> > +		int ret;						\
> > +		void (*func)(void) = (void (*)(void))reg;		\
> > +									\
> > +		ret = tracepoint_probe_register(#name, (void *)probe);	\
> > +		if (func && !ret)					\
> > +			func();						\
> 
> I don't see why you need to add this weird interface when all you really
> need to do is to call the function to set the TIF flags explicitly in
> reg_event_syscall_enter when registering a tracepoint.
> 
> Mathieu
> 

I could enable the TIF flag in reg_event_syscall_enter, however that
would not manage the TIF flag for other users of these traceoints. When
users 'register/unregister' with a tracepoint, they expect the tracepoint
to be enabled/disabled. If we move this functionality to the user, we are
changing how that interface works. Therefore, I associated the
enabling/disabling of the tracepoint, with the tracepoint definition.

thanks,

-Jason
