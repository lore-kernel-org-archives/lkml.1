Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZKPXA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZKPXA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZKPXA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:00:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbZKPXAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:00:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -tip 3/3] Add get_signal tracepoint
In-Reply-To: Masami Hiramatsu's message of  Monday, 16 November 2009 17:39:49 -0500 <4B01D4B5.1050909@redhat.com>
References: <20091113225226.15079.90813.stgit@harusame>
	<20091113225240.15079.4863.stgit@harusame>
	<20091113235333.0E3CC15E8@magilla.sf.frob.com>
	<20091114001020.GB24738@elte.hu>
	<4B01C95B.1070302@redhat.com>
	<20091116220957.8E2142F@magilla.sf.frob.com>
	<4B01D4B5.1050909@redhat.com>
X-Zippy-Says: I'm thinking about DIGITAL READ-OUT systems and computer-generated
    IMAGE FORMATIONS..
Message-Id: <20091116230037.23EEB1A2@magilla.sf.frob.com>
Date: Mon, 16 Nov 2009 15:00:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, actually, trace_signal_send() doesn't record the return value.

Is that because it's called before the action really happens?
Is it important that it be called beforehand?  If it's called
afterwards, it's easy to pass the return value.

> So, what about trace_signal_overflow() for RT-signals and
> trace_signal_loss_info() for non-RT?

Really you can distinguish those just by looking at sig and info, so
perhaps a single tracepoint is enough.  I guess it really depends on what
filtering you would want and how inconvenient it is to have to apply that
filtering.  Having these two distinct tracepoints lets you trivially trace
only "silent information loss" without seeing the events where userland
gets full information (if applications are paying attention).

If you want to have a full suite of tracepoints where each one covers one
unambiguous corner of the semantics, then there are more than these just
for sending.  e.g. see below.

Thanks,
Roland


--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -838,8 +841,10 @@ static int __send_signal(int sig, struct
 
 	assert_spin_locked(&t->sighand->siglock);
 
-	if (!prepare_signal(sig, t, from_ancestor_ns))
+	if (!prepare_signal(sig, t, from_ancestor_ns)) {
+		trace_signal_generate_ignored(sig, group, info);
 		return 0;
+	}
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
@@ -847,8 +852,10 @@ static int __send_signal(int sig, struct
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (legacy_queue(pending, sig))
+	if (legacy_queue(pending, sig)) {
+		trace_signal_generate_dropped_duplicate(sig, group, info);
 		return 0;
+	}
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.
@@ -896,12 +903,22 @@ static int __send_signal(int sig, struct
 			break;
 		}
 	} else if (!is_si_special(info)) {
-		if (sig >= SIGRTMIN && info->si_code != SI_USER)
-		/*
-		 * Queue overflow, abort.  We may abort if the signal was rt
-		 * and sent by user using something other than kill().
-		 */
+		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
+			/*
+			 * Queue overflow, abort.  We may abort if the
+			 * signal was rt and sent by user using something
+			 * other than kill().
+			 */
+			trace_signal_generate_overflow_fail(sig, group, info);
 			return -EAGAIN;
+		} else {
+			/*
+			 * This is a silent loss of information.  We still
+			 * send the signal, but the *info bits are lost.
+			 */
+			trace_signal_generate_overflow_lose_info(sig, group,
+								 info);
+		}
 	}
 
 out_set:

