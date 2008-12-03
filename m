Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbYLCPpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbYLCPpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYLCPoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:44:55 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:46878 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYLCPoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:44:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o0Gn6KGooZN74TgxlhvmGXfLgj//jECIl2PGnATjBkvPwm4GKj5tpmgO4txupMtvNT
         YZYrXMWD8JeupRkB3M9BdEbg9WJ+5wO3NGRwZcSWt0fNkz7l0paWTCAveSCnRet0NI4i
         /9xJQWgb85FyXCDMxpt/eb7M7puBfimBoRy0g=
Message-ID: <c62985530812030744p7c55bc69g251553f369c6fcf@mail.gmail.com>
Date: Wed, 3 Dec 2008 16:44:52 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration output
Cc: "Ingo Molnar" <mingo@elte.hu>, "Tim Bird" <tim.bird@am.sony.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812030821050.29045@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>
	 <20081203081906.GH21006@elte.hu>
	 <alpine.DEB.1.10.0812030649480.29045@gandalf.stny.rr.com>
	 <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>
	 <alpine.DEB.1.10.0812030821050.29045@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/3 Steven Rostedt <rostedt@goodmis.org>:
>
> On Wed, 3 Dec 2008, Fr?d?ric Weisbecker wrote:
>>
>>
>> I proposed a solution for ftrace_printk (which I planned to implement
>> this evening).
>> Since we are in a C-style output, that would be good  to put the ftrace_printk
>> as /* C comments */ inside just below the function that called it.
>> Like this:
>>
>> func_that_called_ftrace_printk {
>>     /* Message from ftrace_printk */
>> }
>>
>> This way we keep the idea of comment which comes along the role of
>> ftrace_printk and we know
>> which function called it, at which depth.....
>>
>> Do you like it this way?
>
> Yes definitely. I thought we already decided to do it that way ;-)


A proposition about this. I want to use __ftrace_printk, make it
generic for both function tracers and have a way to store the current
depth.
One solution: changing the print_entry to have the ip available for
function-tracer and depth available for return-function_tracer.

struct print_entry {
	struct trace_entry	ent;
        union {
	    unsigned long	ip;
            unsigned long       depth;
        } from;
	char			buf[];
};

We could make __ftrace_printk verify which tracer is running.

If normal tracer then
     trace_vprintk(__builtin_return_address(0), .....)
else if graph-tracer
     trace_vprintk(current->curr_ret_stack, ......)

This way we can even forget the ip argument of __trace_printk.
I prefer to ask before changing an exported symbol API....
