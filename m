Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbZJMHtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbZJMHtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZJMHtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:49:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:60968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZJMHtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:49:03 -0400
Subject: Re: [tip:timers/tracing] hrtimer: Add tracepoint for hrtimers
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, zhaolei@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, linux-tip-commits@vger.kernel.org
In-Reply-To: <1255404309.7113.948.camel@gandalf.stny.rr.com>
References: <4A7F8B2B.5020908@cn.fujitsu.com>
	 <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org>
	 <1255404309.7113.948.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Oct 2009 09:48:02 +0200
Message-Id: <1255420082.8392.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 23:25 -0400, Steven Rostedt wrote:
> > +     TP_printk("hrtimer %p, func %pf, expires %llu, softexpires %llu",
> > +               __entry->timer, __entry->function,
> > +               (unsigned long long)ktime_to_ns((ktime_t) {
> > +                               .tv64 = __entry->expires }),
> > +               (unsigned long long)ktime_to_ns((ktime_t) {
> > +                               .tv64 = __entry->softexpires }))
> > +);
> > +
> 
> I was just fixing up the trace-cmd parser (which is also used for perf)
> and came across this code. That TP_printk shows up in the format file
> as:
> 
> print fmt: "hrtimer %p, func %pf, expires %llu, softexpires %llu", REC->timer, REC->function, (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64), (unsigned long long)(((ktime_t) { .tv64 = REC->softexpires }).tv64)
> 
> Now I'm trying to parse this with a tool so that we can have something
> that can read the binary output, and be able to easily figure it out by
> reading the format files. But trying to parse:
> 
> (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64)
> 
> Is not easy. It's basically implementing a C interpreter :-(
> 
> Is there anyway we can change that TRACE_EVENT to give us a better,
> trace printk output?

LOL

Either convince tglx that ktime_t really ought to die for good (yeah, I
know arm), or specialize the whole printout for 32 vs 64 ktime_t.

union ktime {
        s64     tv64;
#if BITS_PER_LONG != 64 && !defined(CONFIG_KTIME_SCALAR)
        struct {
# ifdef __BIG_ENDIAN
        s32     sec, nsec;
# else
        s32     nsec, sec;
# endif
        } tv;
#endif
};


