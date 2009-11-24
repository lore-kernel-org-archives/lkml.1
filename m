Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbZKXRtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbZKXRtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933692AbZKXRtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:49:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688AbZKXRtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:49:21 -0500
Message-ID: <4B0C1BF8.9060408@redhat.com>
Date: Tue, 24 Nov 2009 12:46:32 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 07/10] kprobes/x86: Support kprobes jump	optimization
 on x86
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232211.22071.58974.stgit@dhcp-100-2-132.bos.redhat.com> <20091124162708.GA29995@redhat.com>
In-Reply-To: <20091124162708.GA29995@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
[...]
>> +/*
>> + * Cross-modifying kernel text with stop_machine().
>> + * This code originally comes from immediate value.
>> + * This does _not_ protect against NMI and MCE. However,
>> + * since kprobes can't probe NMI/MCE handler, it is OK for kprobes.
>> + */
>> +static atomic_t stop_machine_first;
>> +static int wrote_text;
>> +
>> +struct text_poke_param {
>> +	void *addr;
>> +	const void *opcode;
>> +	size_t len;
>> +};
>> +
>> +static int __kprobes stop_machine_multibyte_poke(void *data)
>> +{
>> +	struct text_poke_param *tpp = data;
>> +
>> +	if (atomic_dec_and_test(&stop_machine_first)) {
>> +		text_poke(tpp->addr, tpp->opcode, tpp->len);
>> +		smp_wmb();	/* Make sure other cpus see that this has run */
>> +		wrote_text = 1;
>> +	} else {
>> +		while (!wrote_text)
>> +			smp_rmb();
>> +		sync_core();
>> +	}
>> +
>> +	flush_icache_range((unsigned long)tpp->addr,
>> +			   (unsigned long)tpp->addr + tpp->len);
>> +	return 0;
>> +}
>> +
>> +static void *__kprobes __multibyte_poke(void *addr, const void *opcode,
>> +					size_t len)
>> +{
>> +	struct text_poke_param tpp;
>> +
>> +	tpp.addr = addr;
>> +	tpp.opcode = opcode;
>> +	tpp.len = len;
>> +	atomic_set(&stop_machine_first, 1);
>> +	wrote_text = 0;
>> +	stop_machine(stop_machine_multibyte_poke, (void *)&tpp, NULL);
>> +	return addr;
>> +}
>
> As you know, I'd like to have the jump label optimization for
> tracepoints, make use of this '__multibyte_poke()' interface. So perhaps
> it can be moved to arch/x86/kernel/alternative.c. This is where 'text_poke()'
> and friends currently live.

Hmm, maybe current text_poke needs to have singlebyte_poke() wrapper
for avoiding confusion.

> Also, with multiple users we don't want to trample over each others code
> patching. Thus, if each sub-system could register some type of
> 'is_reserved()' callback, and then we can call all these call backs from
> the '__multibyte_poke()' routine before we do any patching to make sure
> that we aren't trampling on each others code. After a successful
> patching, each sub-system can update its reserved set of code as
> appropriate. I can code a prototype here, if this makes sense.

Hmm, we have to implement it carefully, because here kprobes already
inserted int3 and optprobe rewrites the int3 again. If is_reserved()
returns 1 and multibyte_poke returns error, we can't optimize it anymore.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

