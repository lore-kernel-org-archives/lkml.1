Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZKAOt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZKAOt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 09:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZKAOt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 09:49:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbZKAOtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 09:49:25 -0500
Message-ID: <4AED9FCD.6010202@redhat.com>
Date: Sun, 01 Nov 2009 09:48:45 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from crashing
 function graph tracer
References: <20091029205151.852744305@goodmis.org> <y0m4opfz5u6.fsf@fche.csb>
In-Reply-To: <y0m4opfz5u6.fsf@fche.csb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Steven Rostedt<rostedt@goodmis.org>  writes:
>
>> [...]  Jprobes and the function graph tracer use the same mechanism
>> to trace the exit of a function. Unfortunately, only one can be done
>> at a time.  The function graph tracer replaces the return address
>> with its own handler, but so does jprobes. The two are not
>> compatible. [...]
>
> What about kretprobes?  It too uses the same mechanism.

Exactly, kretprobe uses similar mechanism with func-graph tracer.

Fortunately, it doesn't cause any problem, because kretprobe doesn't
skip any function-return, and func-graph tracer(mcount) always intrudes
a function after kretprobe.

---
call func
	<-- kretprobe prehandler changes return address
	func()
	<-- func-graph prehandler changes return address
	...
	return
	--> func-graph trampoline sets ip to "kretprobe trampoline"
	--> kretprobe trampoline sets ip to "real return address"
(return address)
---

So that kretprobe handler doesn't conflict with function graph tracer.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

