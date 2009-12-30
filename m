Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZL3WuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZL3WuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZL3WuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:50:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48325 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZL3WuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y4ZttKNtUGc3fahTIYsrriMomFiktXrvsV2meFXK/4uG9BAW9TQWrTsJAd06OEh0Eb
         Ex1gBQMEwVkqhz/KNA11jHPacu5esUIfB/I3kVscNYsMRbzmMSRddQz2uSub2YmScI+F
         xMF/jotbgeBqE7LFUFGdGv/4ZT3a5NqO/4gSs=
Date: Wed, 30 Dec 2009 23:50:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>, Jason Baron <jbaron@redhat.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dynamic debug - adding ring buffer storage support
Message-ID: <20091230225011.GJ6322@nowhere>
References: <1261481526-17630-1-git-send-email-jolsa@redhat.com> <20091222153955.GD3308@redhat.com> <20091222161353.GB20225@jolsa.lab.eng.brq.redhat.com> <20091228092402.GD24690@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228092402.GD24690@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 10:24:02AM +0100, Ingo Molnar wrote:
> > that way you need to enable tracing as well... but thats ok I guess :)
> > 
> > I was investigating trace events for this, but did not find a way
> > to put variable length argument inside... and I overlooked the
> > trace_printk, I'll look on it and see how it fits, thanks
> > 
> > also having separate ring buffer makes the 'trace'/'trace_pipe' code
> > really simple (suprissingly) compared to ftrace, and I thought
> > on this place it could last for some time.. ;)
> 
> I think what we want is a unified channel of events, of which printk (and 
> dynamic-printk) is one form. I.e. we should add printk events and 
> dynamic-printk events as well, which would show up in /debug/tracing/events/ 
> in a standard ftrace event form and would be accessible to tooling that way.
> 
> For printk a single event would be enough i suspect (we dont want a separate 
> event for every printk), and for dynamic-printk we want to map the existing 
> dyn-printk topologies into /debug/tracing/events, to preserve the distinctions 
> and controls available there.
> 
> This way in the long run we'd have one unified facility.
> 
> 	Ingo


That said, I sometimes dream about one event per printk.

Having, say:

/debug/tracing/events/printk/
         |
         ---- kernel/
         |      |
         |      ------- time/
         |      |        |
         |      |        ---- clocksource.c
         |      |                 |
         |      |                 --- clocksource_unstable:218/
         |      |                 |            |
         |      |                 |            ---- format
         |      |                 |            |
         |      |                 |            ---- filter
         |      |                 |            |
         |      |                 |            ---- enable
         |      |                 --- [...]
         |      ------- [...]
         |
         ---- drivers/
         |       |
         |       ---- [...]
         |
         ---- [...]


That would give a total control over every printk, trace_printk, etc...

Too bad that would bloat the memory.
Well, that could be wrapped in a single, wildly implemented (understand:
not using TRACE_EVENT macro) trace event, something able to walk through
every calls of printk, trace_printk, early_printk, etc... and imitate
a per printk event granularity.

But still it needs to be useful...

