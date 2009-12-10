Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZLJXrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZLJXrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbZLJXrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:47:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364AbZLJXro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:47:44 -0500
X-Authority-Analysis: v=1.0 c=1 a=0ZecOPpkQPkA:10 a=7U3hwN5JcxgA:10 a=Vz1B4DFC6Hul0ebJPGAA:9 a=qYu0Y4mGprouCBvnei0A:7 a=NmFPWN7c850xz7nsFV6j9ci0A3sA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: "Bird, Tim" <Timothy.Bird@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B217803.6080407@am.sony.com>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
	 <4B216478.3080601@am.sony.com>
	 <1260482698.2146.234.camel@gandalf.stny.rr.com>
	 <4B217803.6080407@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 18:47:49 -0500
Message-ID: <1260488869.2146.307.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 14:36 -0800, Tim Bird wrote:

> The ring buffer code was particularly slow.  I was using
> a simple fixed-size array in KFT (on a uniprocessor), and
> the time to save an event was under 1 microsecond.  With
> ftrace on the same hardware, it costs about 6 microseconds
> to save an event.
>  

Well, I know you work in embedded so it may be much slower.

I just ran the ring_buffer_benchmark on a Xeon Quad 2660MHz with
2.6.32-rc7 and I got 190ns per trace entry. (Note most of this time is
spent in the timestamp calculation!)

I booted the latest 2.6.32 kernel, where I've made some changes to the
time keeping code and got 117ns per entry. I sent out a RFC patch set,
and disabled all the RB_WARN_ON safety checks and got it down to 90ns
per trace entry!  This still includes the 3 levels of checking if the
buffer is enabled. Those checks are just a nit and probably (haven't
tested) cost a single ns. The variables being checked are labeled
read_mostly and are most likely in the cache.


Maybe you want to test out the overhead again?

Note, the ftrace infrastructure's first priority is stability so I won't
be removing those RB_WARN_ONs. Next priority is to have non tracing be
unaffected. Third is tracing being as fast as possible. A tracer that
does not need to worry about going away when  disabled will probably
have a performance advantage when tracing. But, if it causes a
noticeable overhead when disabled (like -finstrument-function does, and
it has a lot more lines than mcount), it will never be merged.

-- Steve



