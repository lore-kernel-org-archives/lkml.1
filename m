Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYGNQZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYGNQZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbYGNQZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:25:23 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:61586 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbYGNQZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:25:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgFAKIVe0hMRKxB/2dsb2JhbACBWqkk
Date: Mon, 14 Jul 2008 12:25:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace memory barriers
Message-ID: <20080714162518.GA3027@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150045.025136754@polymtl.ca> <20080709153434.GA9186@Krystal> <20080709162158.GB10601@Krystal> <20080709190957.GA16779@Krystal> <20080711143709.GB11500@Krystal> <Pine.LNX.4.58.0807141112540.30484@gandalf.stny.rr.com> <20080714153334.GA651@Krystal> <Pine.LNX.4.58.0807141153250.29493@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807141153250.29493@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:06:34 up 39 days, 20:47,  5 users,  load average: 1.33, 0.98,
	0.85
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ed LKML)

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 14 Jul 2008, Mathieu Desnoyers wrote:
> >
> > Thanks a lot Steve! By the way, you might be interested in looking at
> > the extra tracing enable/disabled tests you have in ftrace : it should
> > be enough to register/unregister the probes to activate/deactivate
> > tracing. I don't see why you would need if() checks in the probe itself.
> >
> 
> That was actually one of the causes of the bugs I had. We had two markers,
> one tracing schedule switches, the other wake ups. As soon as one is
> enabled, tracing starts, and you will miss the tracing of the other one.
> 
> The result was a strange trace were things were waking up then the waker
> was being scheduled in??
> 
> I need to enable all markers at the same time, which can be done with the
> if () check. Not to mention, I like to be able to shut of tracing on oops
> without needing to do anyting drastic (like deactivating probes).
> 
> -- Steve
> 

I see the reason why you need this, but beware that the activation
boolean you are using in your check won't be seen as active at the same
time by all CPUs because of out-of-order read/writes. So while the
update is per se atomic, the replication of the updated value to all
processors isn't. However, when one CPU sees the new version, this
version will stay valid.

This is one of the reasons why I don't aim to provide atomic activation
of multiple markers : thinking that the state will be atomically changed
on all CPUs without using the proper memory barriers is a bit bogus
anyway. Does ftrace expect such atomic propagation of the change across
all CPUs or does it deal with the information it receives on a per-cpu
basis ?

In any case, you should also make sure that you call synchronize_sched()
after the probe registration to make sure the quiescent state is reached
and that all probes are connected (so that no marker still see the old
data structures). This should be done before you activate your boolean
in the probes.

I agree that the extra check is very well suited to the OOPS case.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
