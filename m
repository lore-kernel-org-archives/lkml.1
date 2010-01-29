Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859Ab0A2JxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab0A2JxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821Ab0A2JxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:53:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:58455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab0A2Jw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:52:59 -0500
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <4B620AD4.8000108@linux.vnet.ibm.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <1263994448.4283.1052.camel@laptop> <1264023204.4283.1124.camel@laptop>
	 <4B57907E.5000207@linux.vnet.ibm.com> <20100121072118.GA10585@elte.hu>
	 <4B58A750.2060607@linux.vnet.ibm.com> <4B58AAF7.60507@linux.vnet.ibm.com>
	 <20100127102834.GA27357@elte.hu>  <4B60990C.1030804@linux.vnet.ibm.com>
	 <1264676244.4283.2093.camel@laptop>  <4B61D0CB.4090809@linux.vnet.ibm.com>
	 <1264705607.4283.2120.camel@laptop>  <4B620AD4.8000108@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 10:52:27 +0100
Message-ID: <1264758747.4283.2150.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 14:08 -0800, Corey Ashford wrote:

> This is one of the reasons why I am leaning toward a /sys/devices-style data 
> structure; the kernel could easily build it based on the pmus that it discovers 
> (through whatever means), and the user can fairly easily choose a pmu from this 
> structure to open, and it's unambiguous to the kernel as to which pmu the user 
> really wants.

Well, the dumb way is simply probing all of them and see who responds.
Another might be adding a pmu attribute (showing the pmu-id) to the
existing sysfs topology layouts (system topology, pci, spu, are all
already available in sysfs iirc).

> I am not convinced that this is the right place to put the event info for each PMU.

Right, I'm not at all sure the kernel wants to know about any events
beyond those needed for pmu scheduling constraints and possible generic
event maps.

Clearly it needs to know about all software events, but I don't think we
need nor want exhaustive hardware event lists in the kernel.

>  > But before we go there the perf core needs to be extended to deal with
>  > multiple hardware pmus, something which isn't too hard but we need to be
>  > careful not to bloat the normal code paths for these somewhat esoteric
>  > use cases.
>  >
> 
> Is this something you've looked into?  If so, what sort of issues have you 
> discovered?

I've poked at it a little yes, while simply abstracting the current hw
interface and making it a list of pmu's isn't hard at all, it does add
overhead to a few key locations.

Another aspect is event scheduling, you'd want to separate the event
lists for the various pmus so that the RR thing works as expected, this
again adds overhead because you now need to abstract out the event lists
as well.

The main fast path affected by both these things is the task switch
event scheduling where you have to iterate all active events and their
pmus.

So while the abstraction itself isn't too hard, doing it so as to
minimize the bloat on the key paths does make it interesting.



