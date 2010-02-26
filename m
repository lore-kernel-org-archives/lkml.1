Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702Ab0BZS1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:27:35 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:20054 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965631Ab0BZS1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:27:34 -0500
X-SpamScore: -38
X-BigFish: VPS-38(zz1432R14c3L98dN936eM148cM9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B881291.3040903@am.sony.com>
Date: Fri, 26 Feb 2010 10:27:29 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>,
       Steven Rostedt <srostedt@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: add tracing_thresh support to function_graph
 tracer (v3)
References: <4B87098B.4040308@am.sony.com> <20100226024601.GG5592@nowhere>
In-Reply-To: <20100226024601.GG5592@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2010 06:46 PM, Frederic Weisbecker wrote:
> On Thu, Feb 25, 2010 at 03:36:43PM -0800, Tim Bird wrote:
>> Add support for tracing_thresh to the function_graph tracer.  This
>> version of this feature isolates the checks into new entry and
>> return functions, to avoid adding more conditional code into the
>> main function_graph paths.
>>
>> Also, add support for specifying tracing_thresh on the kernel
>> command line.  When used like so: "tracing_thresh=200 ftrace=function_graph"
>> this can be used to analyse system startup.  It is important to disable
>> tracing soon after boot, in order to avoid losing the trace data.
>>
>> Note: the elimination of 'notrace' in the definition of '__init'
>> may be controversial.  This can be removed, or made conditional,
>> if it's a bit too scary, but it worked OK for me.  Tracing during
>> kernel startup still works, just with no visibility of routines
>> declared __init.
> 
> 
> __init functions are notrace otherwise ftrace would hot patch
> callsites of function that have disappeared.
> 
> That said, tracing __init functions is indeed interesting.
> Perhaps we can handle that by removing the __init functions
> from ftrace records each time we release init pages.

Thanks.  Given what Steven said about __init routines,
I'll have to think some more about this.  I'm OK with
just removing that piece of the patch for now.
> 
>> +static int __init set_tracing_thresh(char *str)
>> +{
>> +	unsigned long threshhold;
>> +	int ret;
>> +
>> +	if (!str)
>> +		return 0;
>> +	ret = strict_strtoul(str, 0, &threshhold);
>> +	if (ret < 0)
>> +		return 0;
>> +	tracing_thresh = threshhold * 1000;
>> +	return 1;
>> +}
>> +__setup("tracing_thresh=", set_tracing_thresh);
> 
> Looks like setting this, while the function graph tracer (normal
> mode) is running, will have no effect. That said it's perfectly
> fine as it would be pointless to change this value in the middle
> of the tracing.
> 
The command line is parsed before the tracer is activated, so
tracing_thresh is set when trace_graph_init() is called, which
results in the desired behaviour (that is, if you specify the
tracing_thresh on the command line, you get the duration
filtering on bootup).

...
> Ok, looks good to me.
> 
> Thanks.

Thanks for taking a look at it.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

