Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZCBK7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZCBK7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZCBK7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:59:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43768 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbZCBK7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:59:01 -0500
Date: Mon, 2 Mar 2009 11:58:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] zedtrace generic kernel filtering
Message-ID: <20090302105847.GO20897@elte.hu>
References: <1235725256.8512.88.camel@charm-linux> <20090228092657.GA2869@elte.hu> <1235978989.7581.46.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235978989.7581.46.camel@charm-linux>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> > Note that Steve added explicit field enumeration and 'raw' C 
> > syntax tracepoints to the event tracer earlier today (partly 
> > based on your ideas here), so that would be a good basis to 
> > extend/enhance/fix, if you are interested.
> 
> Yeah, I took a quick look and saw some nice improvements.  

:)

> Anyway, the filtering I did for this was basically a 
> side-effect of the event description stuff, which made the 
> filtering relatively easy to do (and the event description 
> files give the user a way to list the available fields).  What 
> I'm wondering is if you're interested in the filtering part 
> alone or in the event description part as well, which I hadn't 
> thought of as separable (I guess I need to look at the current 
> ftrace code to see what's already there).

No, not filtering alone - event description / field enumeration 
part is mandatory for user-space to be able to define filters, 
so yes, that bit is also needed and desired. Steve already added 
those bits we just dont yet have them exposed in 
/debug/tracing/events, like your patch does. (I think it's next 
on Steve's TODO list.)

Basically, i think the big picture is the following. The best 
model for tracepoints is for them to have the following life 
cycle:

 - trace_printk() ad-hoc additions. Not stable, not hookable and
   not enumerated - but highly convenient.

 - if a trace_printk() turns out to be useful it might become a
   bit more active and turn into a regular tracepoint. This
   makes it hookable by ftrace plugins and makes it faster - but 
   it's not generally enumerated yet.

 - the final stage for a tracepoint is for it to become a 
   "C-style" tracepoint. That makes it generally available to 
   all ftrace plugins, makes it available to opaque user-space 
   consumption as well and all fields are enumerated. The 
   in-kernel value filtering machinery you added can make use of 
   them as well.

   ( The downside is (and there are always downsides ;-) that 
     such tracepoints are the hardest to add and have the 
     highest ongoing maintenance overhead - but that aspect is 
     easily visible and will be a well understood property of 
     them. )

Most tracepoints would move on the most convenient-to-add first 
two levels - but eventually some would percolate up to the last 
stage as well.

I think the ones you've identified in your patchset are good 
candidates for that final stage already - and we've added a few 
more too, such as the IRQ entry/exit tracepoints.

	Ingo
