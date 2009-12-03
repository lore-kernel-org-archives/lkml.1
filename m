Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZLCTl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZLCTl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZLCTl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:41:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46217 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbZLCTl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:41:57 -0500
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
 includes when defining CREATE_TRACE_POINTS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <20091203193549.GA18664@hmsreliant.think-freely.org>
References: <20091202191916.GA7589@hmsreliant.think-freely.org>
	 <1259849726.12870.123.camel@gandalf.stny.rr.com>
	 <20091203193549.GA18664@hmsreliant.think-freely.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 03 Dec 2009 14:42:01 -0500
Message-Id: <1259869321.12870.145.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 14:35 -0500, Neil Horman wrote:
> On Thu, Dec 03, 2009 at 09:15:26AM -0500, Steven Rostedt wrote:
> > On Wed, 2009-12-02 at 14:19 -0500, Neil Horman wrote:
> > > Fix tracing infrastructure to allow multiple header files with TRACE_EVENTS to
> > > be included with CREATE_TRACE_EVENTS defined
> > > 
> > > I've been workingon adding a few tracepoints to the network stack, and in so
> > > doing it was convienient for me to add a second include file to
> > > net/core/net-traces.c with TRACE_EVENTS defined in them.  net-traces.c defines
> > > CREATE_TRACE_EVENTS, and during the build it was failing, complaining about
> > > duplicate definitions of __tpstrtab_<name>.  I tracked down the bug to find that
> > > define_trace.h redefined DECLARE_TRACE to be DEFINE_TRACE, so after the first
> > > run through define_trace.h (which is included from skb.h, included in
> > > net-trace.c first), the DECLARE_TRACE macro was left with an improper definition
> > > to start a new cycle with the next header.
> > > 
> > > The fix I came up with was to make sure that DECLARE_TRACE was undefined at the
> > > end of define_trace.h, and to add a conditional re-definition in tracepoint.h.
> > > This places us back in the proper state to define a new set of tracepoints in a
> > > subsequent header file.  Not sure if theres a better way to handle this, but
> > > this worked well for me, allowing me to include multiple headers with
> > > TRACE_EVENT macros in a c file with CREATE_TRACE_POINTS defined.
> > > 
> > 
> > Nice, just some comments below.
> ><snip> 
> > 
> > You duplicate the DECLARE_TRACE from above and place it into an
> > unprotected area. Why not move it instead of duplicating it. This is
> > just a bug waiting to happen if we ever need to modify DECLARE_TRACE.
> > 
> > If you change it to:
> > 
> > #if !defined(CONFIG_TRACEPOINTS) && !defined(DECLARE_TRACE)
> > 
> > #define DECLARE_TRACE(...) ....
> > 
> > #endif
> > 
> > Then you can remove the first definition of it. The first time
> > processing the file, when it hits the #ifndef DECLARE_TRACE in the
> > _LINUX_TRACEPOINT_H conditional, it still does not define DECLARE_TRACE,
> > and then when it exits that conditional, it does.
> 
> 
> Yeah, that makes sense to me.  Although I think you mean if
> defined(CONFIG_TRACEPOINTS) rather than if !defined(CONFIG_TRACEPOINTS).  The

Yep, that's what I meant ;-)

> case I'm moving to outside the unprotected area is the one that we use if
> tracepoints are enabled.  I just tested this new patch, and it works well for
> me.  Thanks!
> 
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

OK, I'll give it some testing tonight.

-- Steve


