Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbZKBUWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbZKBUWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbZKBUWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:22:02 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:55062 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbZKBUWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f8DcqhP/Eh7lIq78kxrntid7gIEkkF7zD7bWxPnySezivbmV+2E4htDO9SyJ0RDUBT
         amgw/S7QhvXvsIlx7lgwyYYaV+JY1Xxh9C9SqnshKyTbdIGoX2YRDJLzEitELQ6mSF9z
         VXbH+WolEUV3viX8AW+vB5HP81VOkAS58Q8Nk=
Date: Mon, 2 Nov 2009 21:22:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
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
Message-ID: <20091102202201.GF4880@nowhere>
References: <20091029205151.852744305@goodmis.org> <4AEA10EC.8000103@redhat.com> <20091102003723.GF5263@nowhere> <4AEEF47F.7090101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEEF47F.7090101@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 10:02:23AM -0500, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> I'm not sure I've well understood how is performed the call to the jprobe
>> handler.
>> But if I understand well we have:
>>
>> 	func() {
>> 		int3() {
>> 			jprobe_handler() {
>> 				(-)
>> 				set ip after iret to user_handler()
>> 			}
>> 		}
>> 		user_handler() {
>> 			jprobe_return() {
>> 				(+)
>> 				int3() {
>> 					set ip after iret to func+...()
>> 				}
>> 			       |
>> 			       |
>> 			       |
>>                  <--------------
>>                  (execute the rest of func())
>> 	}
>>
>> If we replace (-) with pause_graph_tracing() and (+) with
>> unpause_graph_tracing(), this should do the trick...I hope.
>
> I'm not so sure about pause_graph_tracing(), however, it seems that
> int3() and jprobe_handler() already pushed on the stack of the
> func graph tracer at (-). If it's true, where are those entries
> popped up?
>


pause_graph_tracing() will disable the tracing for the current task
but it won't disable the address pop from stack.

If the above jprobe scheme is right, the scenario will be:

      func() {
              /* push func ret */
              int3() {
                      /* push do_trap ret */
                      jprobe_handler() {
                              /* push jprobe_handler ret */
                              pause_graph_tracing();
                              set ip after iret to user_handler()
                      } /* pop jprobe_handler ret */
              } /* pop do_trap ret */
              user_handler() {
                      jprobe_return() {
                              unpause_graph_tracing()
                              int3() {
                                     /* push do_trap ret */
                                      set ip after iret to func+...()
                              } /* pop do_trap ret */
                             |
                             |
                             |
               <--------------
               (execute the rest of func())
      } /* pop func ret */


Hmm?

