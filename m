Return-Path: <linux-kernel-owner+w=401wt.eu-S932500Ab0AFSQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0AFSQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458Ab0AFSQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:16:42 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:29752 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab0AFSQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:16:41 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R98dN936eMzz1202hz4fhzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B44D344.5010909@am.sony.com>
Date: Wed, 6 Jan 2010 10:15:32 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: Jiri Olsa <jolsa@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tracing: confusing output of function_graph when notrace function
 calls traceable function
References: <4B446972.9050901@cn.fujitsu.com>	 <20100106130806.GA7682@jolsa.lab.eng.brq.redhat.com> <1262790997.28171.2865.camel@gandalf.stny.rr.com>
In-Reply-To: <1262790997.28171.2865.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2010 18:15:33.0861 (UTC) FILETIME=[3CEDF150:01CA8EFC]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Steven Rostedt wrote:
>>On Wed, 2010-01-06 at 14:08 +0100, Jiri Olsa wrote:
>>> On Wed, Jan 06, 2010 at 06:44:02PM +0800, Lai Jiangshan wrote:
>>> == real graph ==:
>>>
>>> father_fun()
>>>   child_fun()
>>>   notrace_child_fun()
>>>     grandchild_fun1()
>>>     grandchild_fun2()
>>>
>>> ===function_graph shows===>
>>>
>>> father_fun()
>>>   child_fun()
>>>   grandchild_fun1()
>>>   grandchild_fun2()
>>>
>>> When the notrace function calls traceable function, function_graph will
>>> get wrong depth of functions, and show wrong graph.
>>>
>>> Is there any method to fix it?
>> I dont think so..
>>
>> AFAIK the depth computation is based on the traced functions, and there's
>> no other 'depth related' input apart from them.
> 
> Right.
> 
> 
> Honestly, if you think about it, the "father_fun()" does call those
> grandchild_fun() functions. Just indirectly. I don't find anything wrong
> with this.
> 
> You get the same issue if gcc decides to inline a function, since those
> inlined functions don't get traced either.

Well, there is at least one thing different that could be used to indicate
that we're "down" farther in the call nesting, and that is stack depth.
In the example above, grandchild_fun1() is going to have a lower stack position
than child_fun().  So you might be able to use 'sp' to distinguish between
children and lower descendents.

You could potentially use this as an indicator for increased
indentation, but I'm not sure how accurate it is.
This might be different from the inline case, where the compiler usually
does not build a stack frame for the "called" code.  But you also might
get false positives from variables declared inside in-function blocks
(or from other compiler oddities).

I would lean towards Steve's answer, that it doesn't matter too much.
Invisibility in the trace log, and the possible confusion it creates,
is the price you pay for 'notrace'.

Just my 2 cents.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

