Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0BMDrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:47:19 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:23719 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0BMDrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:47:18 -0500
X-SpamScore: -34
X-BigFish: VPS-34(zz1432R98dN936eM1521M9371Pab9bhzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B7620BD.4070307@am.sony.com>
Date: Fri, 12 Feb 2010 19:47:09 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to function_graph
 tracer
References: <4B733721.3030503@am.sony.com>  <4B7338BF.1070505@am.sony.com>	 <1265929831.2737.340.camel@localhost.localdomain>	 <4B749A42.2080703@am.sony.com> <1265934415.2737.344.camel@localhost.localdomain>
In-Reply-To: <1265934415.2737.344.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 04:26 PM, Steven Rostedt wrote:
> On Thu, 2010-02-11 at 16:01 -0800, Tim Bird wrote:
>> On 02/11/2010 03:10 PM, Steven Rostedt wrote:
>>> On Wed, 2010-02-10 at 14:52 -0800, Tim Bird wrote:
>>>>  static struct tracer_opt trace_opts[] = {
>>>>  	/* Display overruns? (for self-debug purpose) */
>>>> @@ -53,6 +54,8 @@ static struct tracer_opt trace_opts[] = {
>>>>  	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
>>>>  	/* Display absolute time of an entry */
>>>>  	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
>>>> +	/* Display function name on exit, instead of just closing brace */
>>>> +	{ TRACER_OPT(funcgraph-exit, TRACE_GRAPH_PRINT_FUNC_EXIT) },
>>>>  	{ } /* Empty entry */
>>>
>>> I wonder if this should be enabled on start up of the function graph
>>> tracer if the threshold is set?
>>>
>>> Otherwise people will wonder WTF?
>>
>> Indeed.  I'm not sure exactly how to do this.
>>
>> Would it be better to set the option when current_tracer
>> is set with 'function_graph', and tracing_thresh is non-zero?
> 
> The above is the only one I would do. If tracing_thresh is non-zero when
> the function_graph tracer is set, on the start up code in the function
> tracer (graph_trace_init).
> 
> Just enable the option if trace_thresh is set. If you enable function
> graph tracer and have the trace_thresh set, then this type of tracing
> starts immediately. It also keeps the code nicely in the
> trace_function_graph.c file, and does not need to touch the setting of
> tracing_thresh.

OK.  Here's what I came up with.  Pretty straightforward.
Do you want me to integrate this into the previous patch and
re-send, or just submit this by itself.

My apologies for getting this out so late.  I'll be on
vacation with my family next week, so if you don't hear
from me, don't take it as a sign of disinterest. :-)

Index: linux-2.6.31.x86_64/kernel/trace/trace_functions_graph.c
===================================================================
--- linux-2.6.31.x86_64.orig/kernel/trace/trace_functions_graph.c	2010-02-10 14:07:47.000000000 -0800
+++ linux-2.6.31.x86_64/kernel/trace/trace_functions_graph.c	2010-02-12 16:13:53.925957633 -0800
@@ -298,6 +298,11 @@
 		return ret;
 	tracing_start_cmdline_record();

+	if (tracing_thresh)
+		tracer_flags.val |= TRACE_GRAPH_PRINT_FUNC_EXIT;
+	else
+		tracer_flags.val &= ~TRACE_GRAPH_PRINT_FUNC_EXIT;
+
 	return 0;
 }



=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

