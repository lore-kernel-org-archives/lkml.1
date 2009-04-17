Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZDQDFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZDQDFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 23:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZDQDFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 23:05:34 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:62657 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbZDQDFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 23:05:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAJ+M50lMQW1W/2dsb2JhbACBTs46g30G
Date: Thu, 16 Apr 2009 23:05:30 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] tracepoints : let subsystem nop-out the tracepoints at
	build time
Message-ID: <20090417030530.GB26612@Krystal>
References: <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <49E7C74A.8030100@goop.org> <20090417001317.GB20513@Krystal> <49E7CADE.1060202@goop.org> <20090417002831.GC20513@Krystal> <49E7D0BC.4070700@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49E7D0BC.4070700@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:38:21 up 47 days, 23:04,  1 user,  load average: 0.56, 0.67,
	0.60
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> "all this code" is actually :
>>
>>                rcu_read_lock_sched_notrace();                          \
>>                 it_func = rcu_dereference((tp)->funcs);                 \
>>                 if (it_func) {                                          \
>>                         do {                                            \
>>                                 ((void(*)(proto))(*it_func))(args);     \
>>                         } while (*(++it_func));                         \
>>                 }                                                       \
>>                 rcu_read_unlock_sched_notrace();                        \
>>
>> Which does nothing more than disabling preemption and a for loop to
>> call all the tracepoint handlers. I don't see the big win in laying out
>> the stack to call this code out-of-line; we would just remove the
>> preempt disable and the loop, which are minimal compared to most
>> call stacks.
>>   
>
> Well, look at it from my perspective:  Ingo has been repeatedly beating  
> me up for the overhead pvops adds to a native kernel, where it really is  
> just a (direct) function call.  I want to instrument each pvop site with  
> a tracepoint so I can actually work out which calls are being called how  
> frequently to look for new optimisation opportunities.
>
> I would guess the tracepoint code sequence is going to increase the  
> impact of each pvop call site by a fair bit, and that's not counting the  
> effects the extra register pressure will have.  That's a pile of code to  
> add.
>
> And frankly, that's fine by me, because I would expect this degree of  
> introspection to have some performance hit.  But it does make the need  
> for per-subsystem tracing Kconfig entries fairly important, because I  
> don't think this would be acceptable to ship in a non-debug-everything  
> kernel build, even though other tracepoints might be.
>

Agreed. Tracepoints might change the code surrounding the pvops in a
similar fashion as the pvops themselves would change the code.
Therefore, it makes sense to have a Kconfig option to enable the pvops
tracepoints.

In terms of tracepoints (with the DECLARE_TRACE/DEFINE_TRACE semantic),
we could have something like :

in include/trace/pvops.h :

#include <linux/tracepoint.h>

#ifdef CONFIG_PVOPS_TRACEPOINTS

#define DECLARE_PVOPS_TRACE			DECLARE_TRACE
#define DEFINE_PVOPS_TRACE			DEFINE_TRACE
#define EXPORT_PVOPS_TRACEPOINT_SYMBOL_GPL	EXPORT_TRACEPOINT_SYMBOL_GPL
#define EXPORT_PVOPS_TRACEPOINT_SYMBOL		EXPORT_TRACEPOINT_SYMBOL

#else /* !CONFIG_PVOPS_TRACEPOINTS */

#define DECLARE_PVOPS_TRACE			DECLARE_TRACE_NOP
#define DEFINE_PVOPS_TRACE			DEFINE_TRACE_NOP
#define EXPORT_PVOPS_TRACEPOINT_SYMBOL_GPL	EXPORT_TRACEPOINT_SYMBOL_GPL_NOP
#define EXPORT_PVOPS_TRACEPOINT_SYMBOL		EXPORT_TRACEPOINT_SYMBOL_NOP

#endif /* CONFIG_PVOPS_TRACEPOINTS */

And then do the declarations/definitions using the new

DECLARE_PVOPS_TRACE / DEFINE_PVOPS_TRACE.

For that you'll need the patch I am attaching below. I'll let Steven
figure out how to tweak TRACE_EVENT() to support this new tracepoint
feature.

>> So basically, tracepoints are already just doing a function call, with a
>> few more bytes for preempt disable and multiple handler support.
>>
>> About the compiler deciding to put the unlikely branch out-of-line, I've
>> never seen any function calls generated just for the sake of saving
>> those few bytes, that would be crazy of the part of the compiler.
>> However, it can (and should) freely put the stack setup in the coldest
>> cache-lines possible, which are reachable by a near jump.
>>   
>
> No, it wouldn't generate a call.  But if its going to put the code out  
> of line into cold cache-lines, then it may as well generate a call.
>

Jumping out-of-line was somewhat faster than calling a function if I
recall well my performance tests. But that's all been done long ago.

And note that whenever the tracer becomes active, the out-of-line code
of busy tracepoints becomes cache-hot, which means that there is no more
cache line fetch to perform, which leaves the stack setup and other
overhead of function call/return vs 2*jump very measurable.

> Anyway, the important point from my perspective is that tracepoint.h  
> have no #include dependencies beyond linux/types.h (compiler.h, etc).
>

Is preempt.h a problem ?

Here is the patch.

Mathieu


tracepoints : let subsystem nop-out the tracepoints at build time

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>
---
 include/linux/tracepoint.h |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

Index: linux.trees.git/include/linux/tracepoint.h
===================================================================
--- linux.trees.git.orig/include/linux/tracepoint.h	2009-04-16 22:40:26.000000000 -0400
+++ linux.trees.git/include/linux/tracepoint.h	2009-04-16 22:40:33.000000000 -0400
@@ -37,6 +37,24 @@ struct tracepoint {
 #define TP_PROTO(args...)	args
 #define TP_ARGS(args...)		args
 
+#define DECLARE_TRACE_NOP(name, proto, args)				\
+	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
+	{ }								\
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline int register_trace_##name(void (*probe)(proto))	\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	{								\
+		return -ENOSYS;						\
+	}
+
+#define DEFINE_TRACE_NOP(name)
+#define EXPORT_TRACEPOINT_SYMBOL_GPL_NOP(name)
+#define EXPORT_TRACEPOINT_SYMBOL_NOP(name)
+
 #ifdef CONFIG_TRACEPOINTS
 
 /*
@@ -95,23 +113,11 @@ extern void tracepoint_update_probe_rang
 	struct tracepoint *end);
 
 #else /* !CONFIG_TRACEPOINTS */
-#define DECLARE_TRACE(name, proto, args)				\
-	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
-	{ }								\
-	static inline void trace_##name(proto)				\
-	{ }								\
-	static inline int register_trace_##name(void (*probe)(proto))	\
-	{								\
-		return -ENOSYS;						\
-	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
-	{								\
-		return -ENOSYS;						\
-	}
 
-#define DEFINE_TRACE(name)
-#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
-#define EXPORT_TRACEPOINT_SYMBOL(name)
+#define DECLARE_TRACE			DECLARE_TRACE_NOP
+#define DEFINE_TRACE			DEFINE_TRACE_NOP
+#define EXPORT_TRACEPOINT_SYMBOL_GPL	EXPORT_TRACEPOINT_SYMBOL_GPL_NOP
+#define EXPORT_TRACEPOINT_SYMBOL	EXPORT_TRACEPOINT_SYMBOL_NOP
 
 static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end)


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
