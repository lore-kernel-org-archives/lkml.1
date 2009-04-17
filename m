Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbZDQQK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbZDQQK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbZDQQKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:10:12 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:39844 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758974AbZDQQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:10:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAG9D6ElMQW1W/2dsb2JhbACBTs5Ag30G
Date: Fri, 17 Apr 2009 12:10:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
Message-ID: <20090417161005.GA16361@Krystal>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090417154640.GB8253@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:06:49 up 48 days, 12:33,  3 users,  load average: 1.20, 0.78,
	0.79
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > 
> > Mainly simplify linux/tracepoint.h's include dependencies (removes 
> > rcupdate.h), but it can't help with icache locality, since it 
> > definitely moves the code out of line, rather than relying on gcc 
> > to do it.
> 
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -15,7 +15,6 @@
> >   */
> >  
> >  #include <linux/types.h>
> > -#include <linux/rcupdate.h>
> 
> nice!
> 
> > +#define DEFINE_DO_TRACE(name, proto, args)				\
> > +	void __do_trace_##name(struct tracepoint *tp, TP_PROTO(proto))	\
> > +	{								\
> 
> that needs to be marked notrace, otherwise the function tracer 
> becomes noisy. (or even lockupy.)
> 

I guess I'll have to put it more clearly : I am all for minimizing
tracepoint header dependency, but I'll be nacking this kind of
out-of-lining patch. Taking a function call, and moving it out-of-line
(thus duplicating the function call for nothing) seems *really*
pointless and will hurt tracer performance.

If thread_info.h is now so big that it needs a cleanup, I guess we'll
just have to do it.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
