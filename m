Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZKPWmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZKPWmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZKPWmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:42:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbZKPWmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:42:00 -0500
Message-ID: <4B01D4B5.1050909@redhat.com>
Date: Mon, 16 Nov 2009 17:39:49 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -tip 3/3] Add get_signal tracepoint
References: <20091113225226.15079.90813.stgit@harusame>	<20091113225240.15079.4863.stgit@harusame>	<20091113235333.0E3CC15E8@magilla.sf.frob.com>	<20091114001020.GB24738@elte.hu>	<4B01C95B.1070302@redhat.com> <20091116220957.8E2142F@magilla.sf.frob.com>
In-Reply-To: <20091116220957.8E2142F@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>>>    - signal loss events (queue overflow)
>>
>> Perhaps, this event is only for rt-signals, since
>> legacy signals just overwritten if it was sent.
>
> Not exactly.  Nothing is ever "overwritten".  If a non-RT signal is already
> pending, then you just leave the existing queue elements alone--i.e. the
> first one isn't overwritten, rather the second one is dropped.  But this is
> not really the point.
>
> The "queue overflow" happens in two ways.  For RT signals it really is a
> "signal loss" event--but that's also reported to the sender as -EAGAIN.  So
> a signal-generation tracepoint that reports the return value would already
> cover that in a way.
>
> For non-RT signals, a new signal is never lost.  But __sigqueue_alloc() can
> still fail.  In this case, you get no queue element and thus no siginfo_t
> stored, so you can lose some information about the signal.  You don't lose
> the signal itself, but will later dequeue it with an all-zeros siginfo_t.
> While calling this a "signal loss" is inaccurate, it is indeed a silent
> failure of sorts (unlike the RT signal case, which the userland caller
> knows about from the return value).

Hmm, actually, trace_signal_send() doesn't record the return value.
So, what about trace_signal_overflow() for RT-signals and
trace_signal_loss_info() for non-RT?

e.g.
@@ -918,12 +918,15 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
                         break;
                 }
         } else if (!is_si_special(info)) {
-               if (sig >= SIGRTMIN && info->si_code != SI_USER)
+               if (sig >= SIGRTMIN && info->si_code != SI_USER) {
                 /*
                  * Queue overflow, abort.  We may abort if the signal was rt
                  * and sent by user using something other than kill().
                  */
+                       trace_signal_overflow(sig, t);
                         return -EAGAIN;
+               }
+               trace_signal_loss_info(sig, info);
         }

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

