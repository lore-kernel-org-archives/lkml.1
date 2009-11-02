Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbZKBUbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbZKBUbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbZKBUbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:31:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbZKBUbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:31:48 -0500
Message-ID: <4AEF4178.90907@redhat.com>
Date: Mon, 02 Nov 2009 15:30:48 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from crashing
 function graph tracer
References: <20091029205151.852744305@goodmis.org> <4AEA10EC.8000103@redhat.com> <20091102003723.GF5263@nowhere> <4AEEF47F.7090101@redhat.com> <20091102202201.GF4880@nowhere>
In-Reply-To: <20091102202201.GF4880@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Nov 02, 2009 at 10:02:23AM -0500, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>> I'm not sure I've well understood how is performed the call to the jprobe
>>> handler.
>>> But if I understand well we have:
>>>
>>> 	func() {
>>> 		int3() {
>>> 			jprobe_handler() {
>>> 				(-)
>>> 				set ip after iret to user_handler()
>>> 			}
>>> 		}
>>> 		user_handler() {
>>> 			jprobe_return() {
>>> 				(+)
>>> 				int3() {
>>> 					set ip after iret to func+...()
>>> 				}
>>> 			       |
>>> 			       |
>>> 			       |
>>>                   <--------------
>>>                   (execute the rest of func())
>>> 	}
>>>
>>> If we replace (-) with pause_graph_tracing() and (+) with
>>> unpause_graph_tracing(), this should do the trick...I hope.
>>
>> I'm not so sure about pause_graph_tracing(), however, it seems that
>> int3() and jprobe_handler() already pushed on the stack of the
>> func graph tracer at (-). If it's true, where are those entries
>> popped up?
>>
>
>
> pause_graph_tracing() will disable the tracing for the current task
> but it won't disable the address pop from stack.
>
> If the above jprobe scheme is right, the scenario will be:
>
>        func() {
>                /* push func ret */
>                int3() {
>                        /* push do_trap ret */
>                        jprobe_handler() {
>                                /* push jprobe_handler ret */
>                                pause_graph_tracing();
>                                set ip after iret to user_handler()
>                        } /* pop jprobe_handler ret */
>                } /* pop do_trap ret */
>                user_handler() {
>                        jprobe_return() {
>                                unpause_graph_tracing()
>                                int3() {
>                                       /* push do_trap ret */
>                                        set ip after iret to func+...()
>                                } /* pop do_trap ret */
>                               |
>                               |
>                               |
>                 <--------------
>                 (execute the rest of func())
>        } /* pop func ret */
>
>
> Hmm?

Oh, I see. That should work. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

