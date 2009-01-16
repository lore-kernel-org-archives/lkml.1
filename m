Return-Path: <linux-kernel-owner+w=401wt.eu-S933702AbZAPXAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbZAPXAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbZAPXAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:00:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385AbZAPXAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:00:09 -0500
Date: Fri, 16 Jan 2009 23:59:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090116225948.GA12314@elte.hu>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu> <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com> <20090116160202.GA15209@elte.hu> <alpine.DEB.1.10.0901161111490.22303@gandalf.stny.rr.com> <20090116163021.GA27495@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116163021.GA27495@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > I was afraid you would say that :-)
> > 
> > Yes, we could add something to do this. It would take some thought on 
> > a good api, and implementation. This is not an easy task by any means. 
> > We need a way to map between a function call and a tracer, where a 
> > function call can call more than one tracer.
> 
> Note that some other things could be consolidated under per function 
> metadata: for example set_graph_function - which really is a per 
> function attribute too. Plus a lot of new things would be enabled i 
> think.

a few other things that could be per-function attributes:

 - Using function trace 'limits': trace a function 50 times and dont trace 
   it afterwards. Each invocation of that function decreases the
   remaining-count by one. For example:

     echo 'btrfs_join_transaction:#2' >> set_ftrace_filter

   Would specify that we generate two trace entries of
   btrfs_join_transaction(), then stop tracing this function.

 - Using function-triggered tracing: a function could be specified (via a 
   filter format extension) to act as a 'start tracing' trigger. Another 
   extension would be 'stop tracing' trigger.

   For example:

      echo 'btrfs_join_transaction:+' >> set_ftrace_filter
      echo 'btrfs_commit_transaction:-' >> set_ftrace_filter

   The '+' is a start-tracing trigger condition, the '-' is a stop-tracing 
   trigger condition. All function calls between btrfs_join_transaction() 
   and btrfs_commit_transaction() would be traced.

The two could be combined - to generate the trace of a single btrfs 
transaction, one could do:

      echo 0 > tracing_enabled
      echo 'btrfs_join_transaction:+#1' >> set_ftrace_filter
      echo 'btrfs_commit_transaction:-#1' >> set_ftrace_filter
      echo 1 > tracing_enabled

Other extensions are possible too:

 - Trace length triggers. For example one could do:

      echo 'btrfs_join_transaction:+*#10' >> set_ftrace_filter

   To trace 10 function calls [allowed by current filter settings] after
   the first btrfs_join_transaction() call - and stop tracing after those 
   10 trace entries.

This would allow the creation of "surgical" one-time traces - of events 
and functions one is specifically interested in.

	Ingo
