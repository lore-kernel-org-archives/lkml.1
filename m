Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbYIVGZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbYIVGZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 02:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYIVGYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 02:24:55 -0400
Received: from pih-relay06.plus.net ([212.159.14.19]:55365 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYIVGYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 02:24:54 -0400
Message-ID: <48D73A33.5010107@yahoo.com>
Date: Mon, 22 Sep 2008 07:24:51 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       astarikovskiy@suse.de
Subject: Re: Reading EeePC900 battery info causes stalls
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com> <48D50498.5050608@yahoo.com> <alpine.DEB.1.10.0809201037070.13540@gandalf.stny.rr.com> <48D52FE3.6060803@yahoo.com> <alpine.DEB.1.10.0809201739170.18130@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809201739170.18130@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 3a1af5fa2529b16b08096960d9e1fe6e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Sat, 20 Sep 2008, Sitsofe Wheeler wrote:
> 
>> Steven Rostedt wrote:
>>> OK, that is probably the known bug you are hitting. Simply disable the
>>> CONFIG_FTRACE_STARTUP_TEST and you should have the wakeup tracer. The bug is
>>> with the test, not the tracer, so it should not hurt you.
>> Thanks - this made the wakeup tracer appear a you said. I have put two wakeup
>> traces up:
>>
>> http://sucs.org/~sits/test/eeepc-debug/20080920/latency_trace.txt.gz
>> http://sucs.org/~sits/test/eeepc-debug/20080920/trace.txt.gz
>> (each file is around 6Mbytes uncompressed)
>>
>> Here's a small extract of latency_trace.txt:
>>
>>> # tracer: wakeup
>>> #
>>> wakeup latency trace v1.1.5 on 2.6.27-rc6skw-dirty
>>> --------------------------------------------------------------------
>>>  latency: 3232905 us, #65620/6180619, CPU#0 | (M:desktop VP:0, KP:0, SP:0
> 
> Peter, these times are crazy, mainly due to the cpu_clock. He probably 
> wants to use the sched_clock. Below is a patch to use it instead.
> 
> Sitsofe, I notice that the trace states "desktop". This means that you
> are running with CONFIG_PREEMPT_VOLUNTARY. You want 
> CONFIG_PREEMPT.
> 
> [...]
>> Is it intentional that the last event has a time earlier closer to that of the
>> first event?
>>
> 
> Change the config, and see what you get with this patch:
> 
> Note this is not compiled tested:

OK I've made the changes you suggested. Without preempt enabled the last 
event will have a stamp closer to the first event and the times are very 
high. With preempt enabled that beahviour has gone. Here are results 
with preempt enabled:

latency: 19657 us, #3268/3268, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0):
http://sucs.org/~sits/test/eeepc-debug/20080922/preempt/ath5k/latency_trace.txt 


latency: 104 us, #182/182, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0)
http://sucs.org/~sits/test/eeepc-debug/20080922/preempt/unplug/latency_trace.txt

latency: 95 us, #134/134, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0):
http://sucs.org/~sits/test/eeepc-debug/20080922/preempt/acpi/latency_trace.txt

latency: 91 us, #152/152, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0)
http://sucs.org/~sits/test/eeepc-debug/20080922/preempt/touchpad/latency_trace.txt

Are these the type of latencies to be expected with preemption on?

-- 
Sitsofe | http://sucs.org/~sits/
