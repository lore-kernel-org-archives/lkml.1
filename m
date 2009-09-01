Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZIABlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZIABlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 21:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZIABlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 21:41:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZIABlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 21:41:07 -0400
Subject: Re: [PATCH resend] tracing/events: convert NAPI's tracepoint via
 TRACE_EVENT
From: Steven Rostedt <rostedt@goodmis.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A9C73A4.20003@cn.fujitsu.com>
References: <4A9B6AA7.5020508@cn.fujitsu.com>
	 <alpine.DEB.2.00.0908311402150.13931@gandalf.stny.rr.com>
	 <4A9C73A4.20003@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Aug 2009 21:41:06 -0400
Message-Id: <1251769266.20350.10.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 09:06 +0800, Xiao Guangrong wrote:
> 
> Steven Rostedt wrote:
> > On Mon, 31 Aug 2009, Xiao Guangrong wrote:
> > 
> >> - Convert NAPI's tracepoint via TRACE_EVENT macro, the output information
> >>   like below:
> >>
> >>    sshd-2503  [000]    71.920846: napi_poll: ifname=eth0 state=0 weigth=16 poll=pcnet32_poll
> >>    sshd-2503  [000]    72.020291: napi_poll: ifname=eth0 state=0 weigth=16 poll=pcnet32_poll
> >>    sshd-2503  [000]    72.020418: napi_poll: ifname=eth0 state=NAPI_STATE_SCHED weigth=16 poll=pcnet32_poll
> >>
> >> - Remove the "DECLARE_TRACE" definiens in include/trace/define_trace.h,
> >>   because TRACE_EVENT not use it
> > 
> > The above really needs to be in a separate patch, since it is a tracing 
> > infrastructure change.
> > 
> 
> Hi Steven,
> 
> We can't break this patch into two patches, because it's has redefined 'DECLARE_TRACE'
> in include/trace/define_trace.h, like below:
> 
> 1: if we remove 'DECLARE_TRACE' first, then NAPI's tracepoint can't define tracepoint
>    (it's a NAPI tracepoint's bug,
>     see my previous patch: http://marc.info/?l=linux-kernel&m=125118032931716&w=2)
> 
> 2: if we convert NAPI's tracepoint first, it can't include more TRACE_EVENT .h files in
>    one .c file, the compiler will complain with variables redefined:
> 
> include/trace/events/napi.h:15: error: redefinition of ‘__tpstrtab_napi_poll’
> include/trace/events/napi.h:15: error: previous definition of ‘__tpstrtab_napi_poll’ was here
> include/trace/events/napi.h:15: error: redefinition of ‘__tracepoint_napi_poll’
> include/trace/events/napi.h:15: error: previous definition of ‘__tracepoint_napi_poll’ was here
> In file included from include/trace/ftrace.h:644,
> 
> So, I think we do better fix this bug early, then other people can go on his work on ftrace.

Ah, I missed the dependency there. That needs to be commented in the
change log. That is, to comment that a dependency exists.

Luckily, none of the DECLARE_TRACE users used the CREATE_TRACEPOINT way
of creating the trace points. Of course using DECLARE_TRACE directly is
now deprecated, but this change would have broken it if it was used,
because the define_trace.h was also written for that in mind. But since
we never converted any of the old users to do so, this wont break
anything.

OK, you have have Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


