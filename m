Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZIKOkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZIKOkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZIKOkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:40:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbZIKOkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:40:23 -0400
Subject: Re: [PATCH 2/3] tracing/profile: add ref count for registering
 profile events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <1252678183.7126.34.camel@laptop>
References: <20090911135452.866274568@goodmis.org>
	 <20090911135626.421489476@goodmis.org>  <1252677861.7126.32.camel@laptop>
	 <1252678183.7126.34.camel@laptop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 10:40:25 -0400
Message-Id: <1252680025.18996.684.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 16:09 +0200, Peter Zijlstra wrote:
> On Fri, 2009-09-11 at 16:04 +0200, Peter Zijlstra wrote:
> > On Fri, 2009-09-11 at 09:54 -0400, Steven Rostedt wrote:
> > 
> > > +#ifdef MODULE
> > > +# define event_trace_up_ref()					\
> > > +	do {							\
> > > +		if (!try_module_get(THIS_MODULE)) {		\
> > > +			atomic_dec(&event_call->profile_count);	\
> > > +			return -ENOENT;				\
> > > +		}						\
> > > +	} while (0)
> > > +# define event_trace_down_ref() module_put(THIS_MODULE)
> > > +#else
> > > +# define event_trace_up_ref() do { } while (0)
> > > +# define event_trace_down_ref() do { } while (0)
> > > +#endif
> > 
> > That's like truely gruesomely ugly.
> > 
> > At the very least write it like:
> > 
> > int event_trace_up_ref(struct ftrace_event_call *call)
> > {
> > 	if (!try_module_get(THIS_MODULE)) {
> > 		atomic_dev(&call->profile_count);
> > 		return -ENOENT;
> > 	}
> > 	return 0;
> > }
> 
> Or we can go with Li's original patch, that was less ugly.

Here's another version of the patch (less ugly). I forgot that the
try_module_get should handle code compiled with !CONFIG_MODULE.
This should be less ugly.

-- Steve

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 308bafd..6d5edd1 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -409,16 +409,23 @@ static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
 {									\
 	int ret = 0;							\
 									\
-	if (!atomic_inc_return(&event_call->profile_count))		\
+	if (!atomic_inc_return(&event_call->profile_count)) {		\
+		if (!try_module_get(THIS_MODULE))			\
+			goto out_fail;					\
 		ret = register_trace_##call(ftrace_profile_##call);	\
+	}								\
 									\
 	return ret;							\
+ out_fail:								\
+	atomic_dec(&event_call->profile_count);				\
 }									\
 									\
 static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 {									\
-	if (atomic_add_negative(-1, &event_call->profile_count))	\
+	if (atomic_add_negative(-1, &event_call->profile_count)) {	\
 		unregister_trace_##call(ftrace_profile_##call);		\
+		module_put(THIS_MODULE)					\
+	}								\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)


