Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbZHXGXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbZHXGXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZHXGXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:23:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57359 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZHXGXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:23:34 -0400
Message-ID: <4A923197.4040708@cn.fujitsu.com>
Date: Mon, 24 Aug 2009 14:22:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
References: <4A9214E3.2070807@cn.fujitsu.com> <1251093660.7538.119.camel@twins>
In-Reply-To: <1251093660.7538.119.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-08-24 at 12:19 +0800, Li Zefan wrote:
>> If the correspoding module is unloaded before ftrace_profile_disable()
>> is called, event->profile_disable() won't be called, which can
>> cause oops:
>>
>>   # insmod trace-events-sample.ko
>>   # perf record -f -a -e sample:foo_bar sleep 3 &
>>   # sleep 1
>>   # rmmod trace_events_sample
>>   # insmod trace-events-sample.ko
>>   OOPS!
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> 
> Hrmm, feel fragile, why don't we check if all a modules tracepoints are
> unused on unload?
> 

I don't think it's fragile. We are profiling via a module's
tracepoint, so we should pin the module, via module_get().
If event->profile_enable() has been calld, we should make
sure it's profile_disable() will be called.

