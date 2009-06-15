Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbZFOPYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbZFOPYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZFOPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:24:32 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:53094 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbZFOPYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:24:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnsFAM/+NUpMQWTN/2dsb2JhbACBT9QZhA0F
Date: Mon, 15 Jun 2009 11:24:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 3/7] add syscall tracepoints
Message-ID: <20090615152428.GB32010@Krystal>
References: <cover.1244837725.git.jbaron@redhat.com> <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com> <20090612215726.GA9177@Krystal> <20090615141209.GA3126@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090615141209.GA3126@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:22:00 up 107 days, 11:48,  3 users,  load average: 0.56, 1.19,
	1.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Fri, Jun 12, 2009 at 05:57:26PM -0400, Mathieu Desnoyers wrote:
> > > Introduce a new 'DECLARE_TRACE_REG()' macro, so that tracepoints can associate
> > > an external register/unregister function.
> > > 
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > 
> > > ---
> > >  include/linux/tracepoint.h |   27 +++++++++++++++++++++++----
> > >  1 files changed, 23 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > > index 14df7e6..9a3660b 100644
> > > --- a/include/linux/tracepoint.h
> > > +++ b/include/linux/tracepoint.h
> > > @@ -61,7 +61,7 @@ struct tracepoint {
> > >   * not add unwanted padding between the beginning of the section and the
> > >   * structure. Force alignment to the same alignment as the section start.
> > >   */
> > > -#define DECLARE_TRACE(name, proto, args)				\
> > > +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
> > >  	extern struct tracepoint __tracepoint_##name;			\
> > >  	static inline void trace_##name(proto)				\
> > >  	{								\
> > > @@ -71,13 +71,29 @@ struct tracepoint {
> > >  	}								\
> > >  	static inline int register_trace_##name(void (*probe)(proto))	\
> > >  	{								\
> > > -		return tracepoint_probe_register(#name, (void *)probe);	\
> > > +		int ret;						\
> > > +		void (*func)(void) = (void (*)(void))reg;		\
> > > +									\
> > > +		ret = tracepoint_probe_register(#name, (void *)probe);	\
> > > +		if (func && !ret)					\
> > > +			func();						\
> > 
> > I don't see why you need to add this weird interface when all you really
> > need to do is to call the function to set the TIF flags explicitly in
> > reg_event_syscall_enter when registering a tracepoint.
> > 
> > Mathieu
> > 
> 
> I could enable the TIF flag in reg_event_syscall_enter, however that
> would not manage the TIF flag for other users of these traceoints. When
> users 'register/unregister' with a tracepoint, they expect the tracepoint
> to be enabled/disabled. If we move this functionality to the user, we are
> changing how that interface works. Therefore, I associated the
> enabling/disabling of the tracepoint, with the tracepoint definition.
> 

I agree it should be hidden from userspace APIs, but I don't think we
should hide it or from the "in kernel" API users, really. People
interfacing with this kind of API from the kernel-side expect to have a
great level of control on how they use it, and we can expect people to
know what they are doing.

Mathieu


> thanks,
> 
> -Jason

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
