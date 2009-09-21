Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZIUQrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZIUQrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZIUQrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:47:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZIUQrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:47:12 -0400
Subject: Re: TRACE_EVENT_ABI ?
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu
In-Reply-To: <20090921152853.2f8c0597@infradead.org>
References: <20090921093652.0722d745@infradead.org>
	 <alpine.DEB.2.00.0909210926010.7647@gandalf.stny.rr.com>
	 <20090921152853.2f8c0597@infradead.org>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 12:46:07 -0400
Message-Id: <1253551567.2630.26.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 15:28 +0200, Arjan van de Ven wrote:
> On Mon, 21 Sep 2009 09:26:41 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > [ Resending due to wrong SMTP server ]
> > 
> > 
> > On Mon, 21 Sep 2009, Arjan van de Ven wrote:
> > 
> > > Hi,
> > > 
> > > Ingo suggested to make a TRACE_EVENT_ABI, which is equivalent in
> > > implementation to TRACE_EVENT, except that it signals a stable
> > > interface.
> > > 
> > > In trying to implement this I'm running into a wall where
> > > TRACE_EVENT keeps being defined in many different ways all over the
> > > place, making this a really nasty hack to make it just an alias.
> > > 
> > > Do you have any clever ideas on how to make this an alias without
> > > fouling up the whole tracing system?
> > > 
> > 
> > I don't know what you've done so far, but can't you simply in
> > tracepoint.h define:
> > 
> > #define TRACE_EVENT_API(a,b,c,d,e) TRACE_EVENT(a,b,c,d,e)
> 
> unfortunately, due to the preprocessor trickery around TRACE_EVENT this
> completely barfs.

I forgot to tell you about PARAMS.

This patch compiled for me;

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 63a3f7a..9a983d6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -280,6 +280,10 @@ static inline void tracepoint_synchronize_unregister(void)
  * TRACE_EVENT_FN to perform any (un)registration work.
  */
 
+#define TRACE_EVENT_API(name, proto, args, tstruct, assign, print)	\
+	TRACE_EVENT(name, PARAMS(proto), PARAMS(args),			\
+		    PARAMS(tstruct), PARAMS(assign), PARAMS(print))
+
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define TRACE_EVENT_FN(name, proto, args, struct,		\
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b48f1ad..0ee1eb6 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -149,7 +149,7 @@ TRACE_EVENT(sched_wakeup_new,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-TRACE_EVENT(sched_switch,
+TRACE_EVENT_API(sched_switch,
 
 	TP_PROTO(struct rq *rq, struct task_struct *prev,
 		 struct task_struct *next),


