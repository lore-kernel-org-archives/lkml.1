Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbZJ2Umj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbZJ2Umj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 16:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbZJ2Umj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 16:42:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670AbZJ2Umi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 16:42:38 -0400
Message-ID: <4AE9FE09.2030906@redhat.com>
Date: Thu, 29 Oct 2009 16:41:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Josh Stone <jistone@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu> <4AE9C919.4070003@redhat.com> <4AE9F6BF.8000501@redhat.com> <4AE9FA43.1040803@redhat.com>
In-Reply-To: <4AE9FA43.1040803@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Stone wrote:
> On 10/29/2009 01:10 PM, Masami Hiramatsu wrote:
>> Masami Hiramatsu wrote:
>>> Ingo Molnar wrote:
>>>> Another problem i noticed is that a vmlinux without DEBUG_INFO will fail
>>>> in this way:
>>>>
>>>>     aldebaran:~/linux/linux>    perf probe schedule
>>>>       Fatal: Failed to call dwarf_init(). Maybe, not a dwarf file.
>>>
>>> Ah, really? I think I broke need_dwarf logic somehow...
>>
>> Hmm, I've found that is for searching (implicitly) inlined symbols,
>> this means "the behavior is by (bad) design" :-(
>>
>> I think it should be search the symbol in Elf (or kallsyms) first,
>> and only if it fails, use Dwarf for searching the symbol again.
>>
>> Or, it may be enough that just trying to setup probe and if it fails
>> use Dwarf. This way doesn't require any vmlinux access.
>
> Just beware that functions can exist in the symbol table and as inlines
> at the same time.  For example, we've seen compat_sys_recvmsg get
> inlined into compat_sys_socketcall, while it's still compiled as a
> standalone function too.  So if you have the dwarf, you should still try
> to see if inlined versions exist.

Right, by default, perf-probe should see Dwarf since some static functions
may implicitly compiled as inline, and it is hard to request user checking
whether the symbol is inlined or not.

So, this means current design is not so bad, but practically, we'd better
provide an option which ignores inline functions. e.g. exported functions
will be always not-inlined.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

