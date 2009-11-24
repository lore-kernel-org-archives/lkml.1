Return-Path: <linux-kernel-owner+w=401wt.eu-S933438AbZKXQE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbZKXQE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbZKXQEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:04:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933349AbZKXQEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:04:55 -0500
Message-ID: <4B0C0469.2020903@redhat.com>
Date: Tue, 24 Nov 2009 11:06:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v5 00/10] kprobes: Kprobes jump optimization support
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091124020315.GA6221@nowhere> <20091124032008.GD6752@nowhere> <20091124075249.GC21991@elte.hu>
In-Reply-To: <20091124075249.GC21991@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
>> On Tue, Nov 24, 2009 at 03:03:19AM +0100, Frederic Weisbecker wrote:
>>> On Mon, Nov 23, 2009 at 06:21:16PM -0500, Masami Hiramatsu wrote:
>>>>   When the optimized-kprobe is hit before optimization, its handler
>>>>  changes IP(instruction pointer) to copied code and exits. So, the
>>>>  instructions which were copied to detour buffer are executed on the detour
>>>>  buffer.
>>>
>>>
>>>
>>> Hm, why is it playing such hybrid game there?
>>> If I understand well, we have executed int 3, executed the
>>> handler and we jump back to the detour buffer?
>>>
>>
>> I got it, I think. We have instructions to patch. And the above turn 
>> this area into dead code, safe to patch.
>>
>> But still, stop_machine() seem to make it not necessary anymore.
> 
> i think 'sending an IPI to all online CPUs' might be an adequate 
> sequence to make sure patching effects have propagated. I.e. an 
> smp_call_function() with a dummy function?

Hmm, I assume that you mean waiting for all int3 handler.

We have to separate below issues:
 - int3-based multi-bytes code replacement
 - multi-instruction replacement with int3-detour code

The former is implemented on patch 9/10 and 10/10. As you can see,
these patches are RFC status, because I'd like to wait for official
reply of safeness from processor architects.
And it may be able to use a dummy IPI for 2nd IPI because it
just for waiting int3 interrupts. But again, it is just estimated that
replacing with/recovering from int3 is automatically synchronized...

However, at least stop_machine() method is officially described
at "7.1.3 Handling Self- and Cross-Modifying Code" on the intel's
software developer's manual 3A . So currently we can use it.

For the latter issue, as I explained on previous reply, we need
to wait all running interrupts including hardware interrupts.
Thus I used synchronize_sched().

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

