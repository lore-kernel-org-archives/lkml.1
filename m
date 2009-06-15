Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZFOPha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZFOPha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZFOPhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:37:21 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:59183 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZFOPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YeprDAhb6FZGQXGbhKWETrifs+z1BgyVBZUgNLlA4cxqLSRUIB2JBLcFqJnlkJxh6W
         j1N2RU4JSE9JuX55jDLOMZGFzspd0JxdwEyTHvuaWlnTmNgUBaR0+9C+FsCw/ZQHJLxG
         ptuu7MltX4SICME5QdXnzvI7Utzmr9LsWV0I8=
Date: Mon, 15 Jun 2009 17:37:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 3/7] add syscall tracepoints
Message-ID: <20090615153715.GB6044@nowhere>
References: <cover.1244837725.git.jbaron@redhat.com> <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com> <20090612215726.GA9177@Krystal> <20090615141209.GA3126@redhat.com> <20090615152428.GB32010@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615152428.GB32010@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:24:28AM -0400, Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> > On Fri, Jun 12, 2009 at 05:57:26PM -0400, Mathieu Desnoyers wrote:
> > > > Introduce a new 'DECLARE_TRACE_REG()' macro, so that tracepoints can associate
> > > > an external register/unregister function.
> > > > 
> > > > 
> > > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > > 
> > > > ---
> > > >  include/linux/tracepoint.h |   27 +++++++++++++++++++++++----
> > > >  1 files changed, 23 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > > > index 14df7e6..9a3660b 100644
> > > > --- a/include/linux/tracepoint.h
> > > > +++ b/include/linux/tracepoint.h
> > > > @@ -61,7 +61,7 @@ struct tracepoint {
> > > >   * not add unwanted padding between the beginning of the section and the
> > > >   * structure. Force alignment to the same alignment as the section start.
> > > >   */
> > > > -#define DECLARE_TRACE(name, proto, args)				\
> > > > +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
> > > >  	extern struct tracepoint __tracepoint_##name;			\
> > > >  	static inline void trace_##name(proto)				\
> > > >  	{								\
> > > > @@ -71,13 +71,29 @@ struct tracepoint {
> > > >  	}								\
> > > >  	static inline int register_trace_##name(void (*probe)(proto))	\
> > > >  	{								\
> > > > -		return tracepoint_probe_register(#name, (void *)probe);	\
> > > > +		int ret;						\
> > > > +		void (*func)(void) = (void (*)(void))reg;		\
> > > > +									\
> > > > +		ret = tracepoint_probe_register(#name, (void *)probe);	\
> > > > +		if (func && !ret)					\
> > > > +			func();						\
> > > 
> > > I don't see why you need to add this weird interface when all you really
> > > need to do is to call the function to set the TIF flags explicitly in
> > > reg_event_syscall_enter when registering a tracepoint.
> > > 
> > > Mathieu
> > > 
> > 
> > I could enable the TIF flag in reg_event_syscall_enter, however that
> > would not manage the TIF flag for other users of these traceoints. When
> > users 'register/unregister' with a tracepoint, they expect the tracepoint
> > to be enabled/disabled. If we move this functionality to the user, we are
> > changing how that interface works. Therefore, I associated the
> > enabling/disabling of the tracepoint, with the tracepoint definition.
> > 
> 
> I agree it should be hidden from userspace APIs, but I don't think we
> should hide it or from the "in kernel" API users, really. People
> interfacing with this kind of API from the kernel-side expect to have a
> great level of control on how they use it, and we can expect people to
> know what they are doing.
> 
> Mathieu


Indeed it's fine to let the user of the tracepoint have a good
control of what is happening, but actually there is no point in
registering this one without having the TIF_FLAGS set, so it
seems legitimate to handle it like Jason did.
Remember it's a very specific tracepoint that needs these thread
flags to be activated.

Also this management of thread flags would become fragile once
you let the user deal with it concurrently with the event
registering.

I think it's more sane/safe to encapsulate it as it is.

 
> 
> > thanks,
> > 
> > -Jason
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

