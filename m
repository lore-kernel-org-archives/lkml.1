Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZINDIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZINDIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZINDIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:08:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:21900 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZINDIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MiLM5+sbIHYTsaZtbuR8Lqpz3i0DIXjE+l3T90shlEtI++YLl246aM+8BaRY5CgDNE
         rkrck/8OvDtVN75yyRGXmYLCIHomeajWPgTkKN/RMwaMviMHKgotTVUO6MW57G6LrC/K
         7lFCFWHnXZoPz69Jx8nbuxf67V7WOXdr6Gf90=
Date: Mon, 14 Sep 2009 05:08:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH tracing/kprobes 4/7] tracing/kprobes: Add event
	profiling support
Message-ID: <20090914030802.GD14306@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <4AAAA550.9010203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAAA550.9010203@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 03:30:24PM -0400, Masami Hiramatsu wrote:
>> Note that the end-result must be u64 aligned for perf ring buffer.
>> And this is a bit tricky.
>> What is inserted in the perf ring buffer is:
>>
>> raw_trace + (u32)raw_trace_size
>>
>> So we must ensure that sizeof(raw_trace) + sizeof(u32)
>> is well u64 aligned.
>>
>> We don't insert the trace_size ourself though, this is done
>> from kernel/perf_counter.c
>>
>> But we need to handle the size of the size (sorry) in the final
>> alignment.
>> To sum-up: sizeof(raw_trace) doesn't need (shouldn't) to be u64
>> aligned but sizeof(raw_trace) + sizeof(u32) must be.
>>
>> Given this aligned size, we then substract it by sizeof(u32)
>> to have the needed size of the raw entry.
>>
>> This result gives you the size of char raw_data[], which
>> is also the same size passed in perf_tpcounter_event().
>>
>> See?
>
> Ah, I see. So the size to write to perf_tpcounter_event must be
> '(a multiple number of sizeof(u64)) - sizeof(u32)', right?


Exactly.
To simplify I guess the raw events just needs to be u32 aligned :)


> (Hmm, why would not perf_counter align data by itself? :)


Because that would require it to copy the data into a seperate
u64 aligned buffer.



>>
>> That's why we have this in trace/ftrace.h:
>>
>> __data_size = "the real entry data size"
>> __entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32), sizeof(u64));
>> __entry_size -= sizeof(u32);
>>
>> do {
>> 		char raw_data[__entry_size];
>> 		...
>> 		perf_tpcounter_event(event_call->id, __addr, __count, entry,
>> 			     __entry_size);
>> 		...
>> } while (0);
>
> Ok, I'll do that.


Thanks!

